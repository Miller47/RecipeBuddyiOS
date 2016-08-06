//
//  SideBarViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "SearchRecipeViewController.h"


@interface SideBarViewController () <SWRevealViewControllerDelegate>


@property (nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *key;


@end

@implementation SideBarViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.54 blue:0.46 alpha:1];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //sets up array for sidemenu
    _menuItems = @[@"popular",  @"meat", @"poultry", @"desserts", @"salads", @"drinks", @"converter"];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section
    return [self.menuItems count];
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doSearch];
    
    
    return YES;
}

- (void)doSearch
{
    
    
    NSString *search = [[NSString alloc] initWithString:self.searchField.text];
    
    //URL Encodes the search string
    _key = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", _key);
    
    [self.searchField resignFirstResponder];
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    NSLog(@"Segue triggerd");
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    //destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
   
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc pushFrontViewController:nc animated:YES];
        };
        
        if ([segue.identifier isEqualToString:@"search"]) {
            
            SearchRecipeViewController *searchView = segue.destinationViewController;
            
            searchView.searchKeyword = _key;
        }

       
    }
    
}


@end
