//
//  MappingProvder.h
//  Recipes
//
//  Created by Tyler Miller on 7/8/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvder : NSObject

+ (RKMapping *)recipeMapping;


+ (RKMapping *)recipeDetailMapping;



@end
