//
//  WebViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/20/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "WebViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface WebViewController ()

@property (nonatomic) NSURL *url;

@end

@implementation WebViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.sourceString;

    
    self.toolBar.backgroundColor = [UIColor colorWithRed:0.7 green:0.32 blue:0.25 alpha:1];
    
    self.recipeWebView.delegate = self;
    
     [SVProgressHUD showWithStatus:@"Loading Recipe Instructions!" maskType:SVProgressHUDMaskTypeGradient];
    
    [self reachabilityCheck];
    
  
    
}

#pragma mark - Networking Check
-(void)reachabilityCheck
{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([reach isReachable]) {
        
        reach.reachableBlock = ^(Reachability *reachibility)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"REACHABLE! block");
                [self loadRequestFromString:self.urlString];
            });
        };
        
    } else {
        
        reach.unreachableBlock = ^(Reachability * reachability)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"UNREACHABLE! block");
                
                [SVProgressHUD showErrorWithStatus:@"NO NETWORK CONNECTION!"];
                
                
            });
            
        };
    }
    
    
    [reach startNotifier];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView related methods
- (void)loadRequestFromString:(NSString*)urlString
{
    _url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    self.recipeWebView.scalesPageToFit = YES;
    
    
    [self.recipeWebView loadRequest:request];
}

- (void)updateButtons
{
    self.forward.enabled = self.recipeWebView.canGoForward;
    self.back.enabled = self.recipeWebView.canGoBack;
    self.stop.enabled = self.recipeWebView.loading;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
    [self updateButtons];
}



@end
