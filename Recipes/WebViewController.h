//
//  WebViewController.h
//  Recipes
//
//  Created by Tyler Miller on 7/20/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>


@property (nonatomic, strong) IBOutlet UIWebView *recipeWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, weak) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


- (void)loadRequestFromString:(NSString*)urlString;
- (void)updateButtons;

@end
