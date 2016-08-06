//
//  Recipes.h
//  Recipes
//
//  Created by Tyler Miller on 7/10/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipes : NSObject

@property (nonatomic, copy) NSString *recipeId;
@property (nonatomic, copy) NSString *recipeName;
@property (nonatomic, assign) int totalTimeInSeconds;
@property (nonatomic, strong) NSArray *smallImageUrls;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *sourceDisplayName;


@end
