//
//  RecipeDetails.h
//  Recipes
//
//  Created by Tyler Miller on 7/15/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeDetails : NSObject

@property (nonatomic, strong) NSArray *ingredientLines;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *totalTime;
@property (nonatomic, copy) NSString *attributionText;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *sourceRecipeUrl;
@property (nonatomic, copy) NSString *sourceDisplayName;

@end
