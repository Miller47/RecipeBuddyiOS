//
//  ConverterViewController.m
//  Recipes
//
//  Created by Tyler Miller on 7/9/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "ConverterViewController.h"


@interface ConverterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UITextField *userValue;

@end

@implementation ConverterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //sets view background color
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.32 blue:0.25 alpha:1];
    
    
    #pragma mark - SWReveal setup
    
    //Set the side bar button action. when it's tapped, it will show the sidebar
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Set up arrays for picker
    _unitsOfMeasure = @[@"Teaspoons to Tablespoons",@"Tablespoons to Cups", @"Cups to Pints", @"Pints to Quarts", @"Quarts to Gallons"];
    _measurementValues = @[@"0.33333333334", @"0.0625", @"0.5", @"0.5", @"0.25"];
    
  
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vanishKeyboard:)];
    

    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _unitsOfMeasure.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    UILabel *pickerLabel = [[UILabel alloc] init];
//    pickerLabel.text = _unitsOfMeasure[row];
//    pickerLabel.textColor = [UIColor greenColor];
//    
//    return _unitsOfMeasure[row];
//}

//Sets up label for picker control, then set textcolor
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = [[UILabel alloc] init];
    pickerLabel.text = _unitsOfMeasure[row];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = [UIColor whiteColor];
    
    return pickerLabel;
}

#pragma mark - Fraction coverter
- (NSString *)fraction:(float)input {
    
    NSArray * array = [[NSArray alloc] initWithObjects: @"",@"",@"1/8",@"",@"1/4",@"",@"3/8",@"",@"1/2",@"",@"5/8",@"",@"3/4",@"",@"3/4",@"",@"7/8",@"",nil];
    
    NSInteger fractions = lroundf((input - (int)input)/((float)1/(float)16));
    if(fractions == 0 || fractions == 16) {
        return [NSString stringWithFormat:@"%ld",lroundf(input)];
    } else {
        if([[array objectAtIndex:fractions] isEqualToString:@""]) {
            return [NSString stringWithFormat:@"%d %ld/16",(int)input,(long)fractions];
        } else {
            return [NSString stringWithFormat:@"%d %@",(int)input,[array objectAtIndex:fractions]];
        }
    }
    
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    float rate = [_measurementValues[row] floatValue];
    float value = [_userValue.text floatValue];
    float result = rate * value;
    
    
    NSString *temp = [self fraction:result];
    
    NSString *resultString = [[NSString alloc] init];
   
    
    
    
    switch (row) {
        case 0:
            NSLog(@"It worked.0");
            resultString = [NSString stringWithFormat:@"%@ Tablespoons", temp];
            _result.text = resultString;
            break;
        case 1:
            NSLog(@"It worked.1");
            resultString = [NSString stringWithFormat:@"%@ Cups", temp];
            _result.text = resultString;
            break;
        case 2:
            NSLog(@"It worked.2");
            resultString = [NSString stringWithFormat:@"%@ Pints", temp];
            _result.text = resultString;
            break;
        case 3:
            NSLog(@"It worked.3");
            resultString = [NSString stringWithFormat:@"%@ Quarts", temp];
            _result.text = resultString;
            break;
        case 4:
            NSLog(@"It worked.4");
            resultString = [NSString stringWithFormat:@"%@ Gallons", temp];
            _result.text = resultString;
            break;
//        case 5:
//            NSLog(@"It worked.5");
//            _result.text = resultString;
//            break;
//        case 6:
//            NSLog(@"It worked.6");
//            _result.text = resultString;
//            break;
        default:
            NSLog(@"It did not work.NIL");
            break;
    }
}

#pragma mark - Tap Gesture/Dismiss Keyboard
- (void)vanishKeyboard:(UIGestureRecognizer *)gest
{
    [self.view endEditing:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
