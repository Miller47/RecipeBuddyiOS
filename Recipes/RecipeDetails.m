//
//  RecipeDetails.m
//  Recipes
//
//  Created by Tyler Miller on 7/15/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "RecipeDetails.h"

@implementation RecipeDetails

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ made of %@", self.name, self.ingredientLines];
}

@end
