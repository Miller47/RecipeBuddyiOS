//
//  RecipeViewCell.h
//  Recipes
//
//  Created by Tyler Miller on 7/12/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *attlabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

- (void)setRound;
@end
