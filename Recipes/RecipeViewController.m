//
//  RecipeViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "RecipeViewController.h"
#import "Recipes.h"
#import "RecipeViewCell.h"
#import "RecipeDetailViewController.h"




@interface RecipeViewController () 



@end

@implementation RecipeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    //sets search parameter
    self.parameter = @"";
    
    
    
    


    
#pragma mark - SWReveal setup
    
    //Set the side bar button action. when it's tapped, it will show the sidebar
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
       
   
    
           
            [self reachabilityCheck];
    
            
            
     
}






@end
