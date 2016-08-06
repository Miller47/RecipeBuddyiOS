//
//  RecipeViewCell.m
//  Recipes
//
//  Created by Tyler Miller on 7/12/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "RecipeViewCell.h"

@implementation RecipeViewCell



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRound
{
    self.recipeImage.layer.cornerRadius = self.recipeImage.frame.size.width / 2;
    self.recipeImage.clipsToBounds = YES;
    self.recipeImage.layer.borderWidth = 3.0f;
    self.recipeImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
}

@end
