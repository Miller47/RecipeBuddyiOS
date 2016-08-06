//
//  MappingProvder.m
//  Recipes
//
//  Created by Tyler Miller on 7/8/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "MappingProvder.h"
#import "Recipes.h"
#import "RecipeDetails.h"


@implementation MappingProvder



+ (RKMapping *)recipeMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Recipes class]];
       
    [mapping addAttributeMappingsFromDictionary:@{
                                                  
                                                  @"recipeName": @"recipeName",
                                                  @"id" : @"recipeId",
                                                  @"totalTimeInSeconds" : @"totalTimeInSeconds",
                                                  @"imageUrlsBySize.90" : @"smallImageUrls",
                                                  @"sourceDisplayName" : @"sourceDisplayName"
                                                  }];
    return mapping;
    
}

+ (RKMapping *)recipeDetailMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RecipeDetails class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  
                                                  @"attribution.text" : @"attributionText",
                                                  @"images.imageUrlsBySize.360" : @"images",
                                                  @"source.sourceRecipeUrl" : @"sourceRecipeUrl",
                                                  @"source.sourceDisplayName" : @"sourceDisplayName"
                                                  }];
    
    
    
    [mapping addAttributeMappingsFromArray:@[@"ingredientLines",
                                             @"name",
                                             @"totalTime"
                                            
                                             ]];
    
   
    
   
    return mapping;
    
}



@end
