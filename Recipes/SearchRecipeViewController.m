//
//  SearchRecipeViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "SearchRecipeViewController.h"
#import "Recipes.h"
#import "RecipeViewCell.h"
#import "RecipeDetailViewController.h"



@interface SearchRecipeViewController ()

@end

@implementation SearchRecipeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //sets search parameter
    self.parameter = self.searchKeyword;
    
    

    
#pragma mark - SWReveal setup
    
    //Set the side bar button action. when it's tapped, it will show the sidebar
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
  
        [self reachabilityCheck];
        
   

    

    
    NSLog(@"Key word = %@", self.searchKeyword);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
