//
//  RecipeDetailViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/10/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "RecipeDetails.h"
#import "WebViewController.h"
#import "IngredientsCell.h"
#import "Reachability.h"

static NSString * const IngredientsCellIdentifer = @"IngredientsCell";

@interface RecipeDetailViewController ()



@property (nonatomic ,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *attributesLabel;
@property (nonatomic, strong) IBOutlet UIImageView *recipePic;
@property (nonatomic, strong) IBOutlet UILabel *timeToCook;
@property (nonatomic, strong) IBOutlet UIButton *cookingInstructions;
@property (nonatomic ,strong) NSArray *recipeData;

@property (nonatomic, strong) IBOutlet UITableView *ingrdeientsTable;




@end

@implementation RecipeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //set background color
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.32 blue:0.25 alpha:1];
    
    
    //make sure UILabes, UiTableView are nil or hidden
    self.nameLabel.text = nil;
    self.attributesLabel.text = nil;
    self.timeToCook.text = nil;
    self.ingrdeientsTable.hidden = YES;
    self.timeToCook.hidden = YES;
    self.cookingInstructions.hidden = YES;
    
    if (self.recipeInfo) {
        
        [SVProgressHUD showWithStatus:@"Loading Recipe Info!" maskType:SVProgressHUDMaskTypeGradient];
        
        [self reachabilityCheck];

        
        
        
    }

}

#pragma mark - Networking Check
-(void)reachabilityCheck
{
    
   Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([reach isReachable]) {
        
        reach.reachableBlock = ^(Reachability *reachibility)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"REACHABLE! block");
                [self loadRecipeDetails];
            });
        };
        
    } else {
        
        reach.unreachableBlock = ^(Reachability * reachability)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"UNREACHABLE! block");
                
                [SVProgressHUD showErrorWithStatus:@"NO NETWORK CONNECTION!"];
                
                
            });
            
        };
    }
    
    
    [reach startNotifier];
    
    
    
}




- (void)loadRecipeDetails
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKMapping *mapping = [MappingProvder recipeDetailMapping];
    
 
    
    NSString *resourcePath = [NSString stringWithFormat:@"/v1/api/recipe/%@", self.recipeInfo.recipeId];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:resourcePath
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodeSet];
    
   

  
    
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.yummly.com/v1/api/recipe/%@?_app_id=%@&_app_key=%@&requirePictures=true", self.recipeInfo.recipeId
                                       ,Yummly_APP_ID , Yummly_API_kEY ]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
        
        
       self.recipeData = mappingResult.array;
        
        
        [self updateUI];
        
        
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
 
        
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        [SVProgressHUD showErrorWithStatus:@"Request Failed"];
    }];
    
    
    
    [operation start];
    



    
}

- (void)updateUI
{
    
    
    
    RecipeDetails *details = [self.recipeData objectAtIndex:0];
    
    //sets namelabe text
    //self.nameLabel.text = details.name;
    self.title = details.name;
    
    
    //sets up the timetocook label
    self.timeToCook.hidden = NO;
    self.timeToCook.clipsToBounds = YES;
    self.timeToCook.layer.cornerRadius = self.timeToCook.frame.size.width / 2.5;
    self.timeToCook.layer.borderWidth = 2;
    self.timeToCook.layer.borderColor = [UIColor whiteColor].CGColor;
    self.timeToCook.text = details.totalTime;
    
    //set up cook it button
    self.cookingInstructions.hidden = NO;
    self.cookingInstructions.layer.cornerRadius = self.cookingInstructions.frame.size.width / 2.5
    ;
    self.cookingInstructions.layer.borderWidth = 2;
    self.cookingInstructions.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //set the text for attribution label
    self.attributesLabel.text = details.attributionText;
    
    //sets up recipePic
    self.recipePic.layer.cornerRadius = self.recipePic.frame.size.width / 10;
    self.recipePic.clipsToBounds = YES;
    self.recipePic.layer.borderWidth = 3.0f;
    self.recipePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[details.images objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.recipePic.image = [UIImage imageWithData:urlData];
    
    //sets up tableview for ingreidents
    self.ingrdeientsTable.hidden = NO;
    self.ingrdeientsTable.layer.cornerRadius = 15;
    self.ingrdeientsTable.layer.borderWidth =2;
    
    
     [self.ingrdeientsTable reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  RecipeDetails *detail = [self.recipeData objectAtIndex:0];
    // Return the number of rows in the section.
    return detail.ingredientLines.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (IngredientsCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    IngredientsCell *cell = [self.ingrdeientsTable dequeueReusableCellWithIdentifier:IngredientsCellIdentifer forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(IngredientsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RecipeDetails *detail = [self.recipeData objectAtIndex:0];
    NSString *temp = [detail.ingredientLines objectAtIndex:indexPath.row];
    [cell adjustUILabelSize:temp];
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static IngredientsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.ingrdeientsTable dequeueReusableCellWithIdentifier:IngredientsCellIdentifer];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - Share
- (IBAction)shareRecipe:(id)sender {
    
    RecipeDetails *data = [self.recipeData objectAtIndex:0];
    
    NSString *recipeStr =[NSString stringWithFormat:@"Check out this recipe from %@, sent from Recipe Buddy for iPhone", data.sourceDisplayName];
    NSURL *url = [[NSURL alloc] initWithString:data.sourceRecipeUrl];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[recipeStr, url]
                                      applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    WebViewController *webView = segue.destinationViewController;
    // Pass the selected object to the new view controller.
    RecipeDetails *passedDetails = [self.recipeData objectAtIndex:0];

    
    
    webView.urlString = passedDetails.sourceRecipeUrl;
    webView.sourceString = passedDetails.sourceDisplayName;
}


@end
