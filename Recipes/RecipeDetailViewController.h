//
//  RecipeDetailViewController.h
//  Recipes
//
//  Created by Tyler Miller on 7/10/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipes.h"

@interface RecipeDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) Recipes *recipeInfo;

@end
