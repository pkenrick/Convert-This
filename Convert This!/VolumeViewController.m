//
//  VolumeViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 05/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "VolumeViewController.h"

@interface VolumeViewController ()

@end

NSArray *_volumeUnitsArray;
NSArray *_toLitreMultipliers;
NSArray *_fromLitreMultipliers;
NSString *_volumeFromUnitSelected;
NSString *_volumeToUnitSelected;

@implementation VolumeViewController

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
    
    _volumeUnitsArray = @[
                          @"Cubic Millimetres",
                          @"Cubic Centimetres",
                          @"Cubic Metres",
                          @"Cubic Inches",
                          @"Cubic Feet",
                          @"Millilitres",
                          @"Litres",
                          @"Teaspoons",
                          @"Tablespoons",
                          @"Cups",
                          @"Pints",
                          @"Gallons"
                          ];
    
    _toLitreMultipliers = @[
                            @0.000001f,
                            @0.001f,
                            @1000.0f,
                            @0.0163871f,
                            @28.3168f,
                            @0.001f,
                            @1.0f,
                            @0.00591939f,
                            @0.0177582f,
                            @0.236588f,
                            @0.568261f,
                            @4.54609
                            ];
    
    _fromLitreMultipliers = @[
                              @1000000,
                              @1000,
                              @0.001,
                              @61.02361,
                              @0.03531472,
                              @1000,
                              @1.0f,
                              @168.936326,
                              @56.312014,
                              @4.226757,
                              @1.759755,
                              @0.219969
                              ];
    
}

- (IBAction)userDidPressConvert:(id)sender {
    
    if (_volumeFromUnitSelected == nil) {
        _volumeFromUnitSelected = [_volumeUnitsArray firstObject];
    }
    
    if (_volumeFromUnitSelected == nil) {
        _volumeFromUnitSelected = [_volumeUnitsArray firstObject];
    }
    
    float litreResult = [self convertToLitre:[inputField.text floatValue]];
    float finalResult = [self convertFromLitre:litreResult];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    if (finalResult >= 1) { [formatter setMaximumFractionDigits:2]; }
    if (finalResult < 1) { [formatter setMaximumFractionDigits:4]; }
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult;
    if (finalResult < 0.00005) {
        formattedResult = [NSString stringWithFormat:@"< 0.00005\n%@", _volumeToUnitSelected];
    } else {
        formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _volumeToUnitSelected];
    }
    resultLabel.text = formattedResult;
}

- (float)convertToLitre:(float)inputValue {
    float toLitreMultiplier = [_toLitreMultipliers[[_volumeUnitsArray indexOfObject:_volumeFromUnitSelected]] floatValue];
    return inputValue * toLitreMultiplier;
}

-(float)convertFromLitre:(float)metreValue {
    float fromLitreMultiplier = [_fromLitreMultipliers[[_volumeUnitsArray indexOfObject:_volumeToUnitSelected]] floatValue];
    return metreValue * fromLitreMultiplier;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == fromUnit) {
        _volumeFromUnitSelected = [_volumeUnitsArray objectAtIndex:row];
    } else {
        _volumeToUnitSelected = [_volumeUnitsArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _volumeUnitsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _volumeUnitsArray[row];
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


