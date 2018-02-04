//
//  DistanceViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 04/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "DistanceViewController.h"

@interface DistanceViewController ()

@end

NSArray *_distanceUnitsArray;
NSArray *_toMetreMultipliers;
NSArray *_fromMetreMultipliers;
NSString *_distanceFromUnitSelected;
NSString *_distanceToUnitSelected;


@implementation DistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    // Create a flexible space to align buttons to the right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Create a cancel button to dismiss the keyboard
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    
    // Add buttons to the toolbar
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    
    // Set the toolbar as accessory view of an UITextField object
    inputField.inputAccessoryView = toolbar;
    
    fromUnit.delegate = self;
    toUnit.delegate = self;
    
    _distanceUnitsArray = @[
                    @"Millimetres",
                    @"Centimetre",
                    @"Metre",
                    @"Kilometre",
                    @"Inches",
                    @"Feet",
                    @"Yards",
                    @"Miles"
                    ];
    
    _toMetreMultipliers = @[
                         @0.001f,
                         @0.01f,
                         @1.0f,
                         @1000.0f,
                         @0.0254f,
                         @0.3048f,
                         @0.9144f,
                         @1609.34
                         ];
    
    _fromMetreMultipliers = @[
                           @1000,
                           @100,
                           @1.0f,
                           @0.001,
                           @39.3701,
                           @3.28083,
                           @1.09361,
                           @0.000621371
                           ];
    
}

- (IBAction)userDidPressConvert:(id)sender {
    
    if (_distanceFromUnitSelected == nil) {
        _distanceFromUnitSelected = [_distanceUnitsArray firstObject];
    }
    
    if (_distanceToUnitSelected == nil) {
        _distanceToUnitSelected = [_distanceUnitsArray firstObject];
    }
    
    float metreResult = [self convertToMetre:[inputField.text floatValue]];
    float finalResult = [self convertFromMetre:metreResult];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _distanceToUnitSelected];
    resultLabel.text = formattedResult;
}

- (float)convertToMetre:(float)inputValue {
    float toMetreMultiplier = [_toMetreMultipliers[[_distanceUnitsArray indexOfObject:_distanceFromUnitSelected]] floatValue];
    return inputValue * toMetreMultiplier;
}

-(float)convertFromMetre:(float)metreValue {
    float fromMetreMultiplier = [_fromMetreMultipliers[[_distanceUnitsArray indexOfObject:_distanceToUnitSelected]] floatValue];
    return metreValue * fromMetreMultiplier;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == fromUnit) {
        _distanceFromUnitSelected = [_distanceUnitsArray objectAtIndex:row];
    } else {
        _distanceToUnitSelected = [_distanceUnitsArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _distanceUnitsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _distanceUnitsArray[row];
}

- (void)dismissKeyboard {
    [inputField resignFirstResponder];
}

- (IBAction)dismissView:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

