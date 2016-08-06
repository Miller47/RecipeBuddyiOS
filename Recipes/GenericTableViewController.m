//
//  GenericTableViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/31/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "GenericTableViewController.h"
#import "Recipes.h"
#import "RecipeViewCell.h"
#import "RecipeDetailViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"




@interface GenericTableViewController () <SWRevealViewControllerDelegate>


@property (nonatomic, strong) Reachability * reach;


@end

@implementation GenericTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.startNumForYummly = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.32 blue:0.25 alpha:1];
    
    
    
    
    __weak typeof(self) weakSelf = self;
    
    
    
    // setup infinite scroll
    [self.tableView addInfiniteScrollWithHandler:^(UIScrollView* scrollView) {
        //
        // fetch your data here, can be async operation,
        // just make sure to call finishInfiniteScroll in the end
        //
        
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        
        [strongSelf nextPage];
        
        
        // finish infinite scroll animation
        [scrollView finishInfiniteScroll];
    }];
    
    
    
    
    
    [SVProgressHUD showWithStatus:@"Loading Recipes!" maskType:SVProgressHUDMaskTypeGradient];
    
    
    
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    
    
    
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];//stop user from slecting tableview cells
    
    // Initialize the refresh control.
        
    _refresh = [[UIRefreshControl alloc] init];
    
    _refresh.backgroundColor = [UIColor colorWithRed:0.87 green:0.54 blue:0.46 alpha:1];//Bug in iOS 8 makes color bleed through to tableview
    _refresh.tintColor = [UIColor whiteColor];
    [self setRefreshTitle];
    
    [_refresh addTarget:self
                            action:@selector(reachabilityCheck)
                  forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = _refresh;
    
    
    
    
    
    
    
    
}

#pragma Mark-Workaround for UIRefreshControl cell overlapping

-(void)viewDidAppear:(BOOL)animated {
    _refresh.backgroundColor = [UIColor colorWithRed:0.87 green:0.54 blue:0.46 alpha:1];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    _refresh.backgroundColor = nil;
}










#pragma mark - Networking Check
-(void)reachabilityCheck
{
    
    _reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self) weakSelf = self;
    
    __strong typeof(weakSelf) strongSelf = weakSelf;
    
    if ([_reach isReachable]) {
        
        _reach.reachableBlock = ^(Reachability *reachibility)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"REACHABLE! block");
                [strongSelf loadRecipes];
                strongSelf.tableView.backgroundView = nil;
                //[strongSelf.refresh endRefreshing];
                
                
            });
        };
        
    } else {
        
        _reach.unreachableBlock = ^(Reachability * reachability)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"UNREACHABLE! block");
                
                [SVProgressHUD showErrorWithStatus:@"NO NETWORK CONNECTION!"];
                
                [strongSelf.recipes removeAllObjects];
                [strongSelf.tableView reloadData];
                //Display a message when the table is empty
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, strongSelf.view.bounds.size.width, strongSelf.view.bounds.size.height)];
                
                messageLabel.text = @"No data is currently available. Please pull to refresh.";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                [messageLabel sizeToFit];
                
                strongSelf.tableView.backgroundView = messageLabel;
                strongSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                [strongSelf.refresh endRefreshing];
                
                
            });
            
        };
    }
    
    
    [_reach startNotifier];
    
    
    
}


- (void)loadRecipes
{
    
    
    
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKMapping *mapping = [MappingProvder recipeMapping];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/v1/api/recipes"
                                                                                           keyPath:@"matches"
                                                                                       statusCodes:statusCodeSet];
    
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.yummly.com/v1/api/recipes?_app_id=%@&_app_key=%@&q=%@&maxResult=20&start=%ld&requirePictures=true",Yummly_APP_ID , Yummly_API_kEY, self.parameter, (long)self.startNumForYummly]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray *tempArray = mappingResult.array;
        
        
        
        if (self.recipes == nil) {
            
            
            self.recipes = [[NSMutableArray alloc] initWithArray:tempArray];
            
        } else {
            [self.recipes addObjectsFromArray:tempArray];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        // Enable Activity Indicator Spinner
        [AFNetworkActivityIndicatorManager sharedManager].enabled = NO;
        
        NSLog(@"Data: %@", self.recipes.description);
        
        // As this block of code is run in a background thread, we need to ensure the GUI
        // update is executed in the main thread
        
        if ([_refresh isRefreshing]) {
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        
        
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        [SVProgressHUD showErrorWithStatus:@"Request Failed"];
    }];
    
    
    
    [operation start];
    
}

-(void)setRefreshTitle {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    NSString *title = [NSString stringWithFormat:@"Last Update: %@", [formatter stringFromDate:[NSDate date]]];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                          attributes:attrsDictionary];
   _refresh.attributedTitle = attributedTitle;
    
}

- (void)reloadData
{
    
    
    //End the refreshing
    if (_refresh) {
        
        [self setRefreshTitle];
        
        
        [_refresh endRefreshing];
        
        
        // Reload table data
        //[self.tableView reloadData];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pagination
- (void)nextPage
{
    
    
    _startNumForYummly += 20;
    
    [self loadRecipes];
    
    
    //[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
//        if (self.recipes) {
//    
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    
//            return 1;
//        } else {
    
    
    
    
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return self.recipes.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"cell";
    RecipeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer forIndexPath:indexPath];
    
    
    
    Recipes *recipe = [self.recipes objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    cell.titlelabel.text = recipe.recipeName;
    
    //Converts seconds to minutes
    int duration = recipe.totalTimeInSeconds;
    int min = duration / 60;
    int sec = duration % 60;
    
    NSString *time = [NSString stringWithFormat:@"Time to cook %d:%02d Minutes", min, sec];
    
    cell.timelabel.text = time;
    
    cell.attlabel.textColor = [UIColor lightGrayColor];
    
    cell.attlabel.text = recipe.sourceDisplayName;
    
    //NSLog(@"att name: %@", recipe.attribution.description);
    
    NSString *url = [NSString stringWithFormat:@"%@", [recipe.smallImageUrls objectAtIndex:0]];
    
    NSURL *imageUrl = [NSURL URLWithString:url];
    
    [cell setRound];
    
    //sets imageview for tablewviewcell Via a AFNetworking method which is done asynchronously to keep loading smooth
    [cell.recipeImage setImageWithURL:imageUrl];
    
    
    
    return cell;
}



//- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) {
//        self.tableView.scrollEnabled = YES;
//        _sidebarMenuOpen = NO;
//
//    } else {
//        self.tableView.scrollEnabled = NO;
//        _sidebarMenuOpen = YES;
//
//    }
//}
//
//- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
//{
//    if(position == FrontViewPositionRight) {
//        self.tableView.scrollEnabled = YES;
//        _sidebarMenuOpen = NO;
//
//    } else {
//        self.tableView.scrollEnabled = NO;
//        _sidebarMenuOpen = YES;
//
//    }
//}
//




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    RecipeDetailViewController *recipeDetails = segue.destinationViewController;
    
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedRecipe = [self.recipes objectAtIndex:indexPath.row];
    recipeDetails.recipeInfo = self.selectedRecipe;
    
    
    
}


@end



