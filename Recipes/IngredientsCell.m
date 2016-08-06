//
//  IngredientsCell.m
//  Recipes
//
//  Created by Tyler Miller on 7/22/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "IngredientsCell.h"

@implementation IngredientsCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustUILabelSize:(NSString *)text
{
    self.titleLabel.text = text;
    
    CGSize constrainedSize = CGSizeMake(self.titleLabel.frame.size.width  , 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:13.0], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"textToShow" attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (requiredHeight.size.width > self.titleLabel.frame.size.width) {
        requiredHeight = CGRectMake(0,0, self.titleLabel.frame.size.width, requiredHeight.size.height);
    }
    CGRect newFrame = self.titleLabel.frame;
    newFrame.size.height = requiredHeight.size.height;
    self.titleLabel.frame = newFrame;
    
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//makes sure all letters for a given word are on the same line
 
}



@end
