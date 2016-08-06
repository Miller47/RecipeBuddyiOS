//
//  SideBarViewController.h
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchField;


@end
