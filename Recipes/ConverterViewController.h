//
//  ConverterViewController.h
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConverterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSArray *unitsOfMeasure;
@property (strong, nonatomic) NSArray *measurementValues;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
