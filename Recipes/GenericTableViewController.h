//
//  GenericTableViewController.h
//  Recipes
//
//  Created by Tyler Miller on 7/31/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipes.h"

@interface GenericTableViewController : UITableViewController 

@property (nonatomic, strong) NSString *parameter;
@property (nonatomic, strong) NSMutableArray *recipes;
@property (nonatomic, strong) Recipes *selectedRecipe;
@property (nonatomic, assign) NSInteger startNumForYummly;
@property (nonatomic, strong) UIRefreshControl *refresh;


- (void)reloadData;
- (void)loadRecipes;
- (void)nextPage;
- (void)reachabilityCheck;
@end
