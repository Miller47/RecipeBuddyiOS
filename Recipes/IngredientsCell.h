//
//  IngredientsCell.h
//  Recipes
//
//  Created by Tyler Miller on 7/22/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void)adjustUILabelSize:(NSString *)text;//Adjusts UILabel size based on content

@end
