//
//  TemperatureViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 04/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "TemperatureViewController.h"

@interface TemperatureViewController ()

@end

NSArray *_tempUnitsArray;
NSString *_tempFromUnitSelected;
NSString *_tempToUnitSelected;

@implementation TemperatureViewController

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
    
    _tempUnitsArray = @[
                        @"Degrees Celcius",
                        @"Degrees Fahrenheit"
                        ];
}

- (IBAction)toggleSign:(id)sender {
    if ([inputField.text floatValue] > 1) {
        inputField.text = [NSString stringWithFormat:@"-%@",inputField.text];
    } else {
        inputField.text = [inputField.text substringFromIndex:1];
    }
//    inputField.text = [NSString stringWithFormat:@"%f", [inputField.text floatValue] * -1];
}

- (IBAction)userDidPressConvert:(id)sender {
    
    if (_tempFromUnitSelected == nil) {
        _tempFromUnitSelected = [_tempUnitsArray firstObject];
    }
    
    if (_tempToUnitSelected == nil) {
        _tempToUnitSelected = [_tempUnitsArray firstObject];
    }
    
    float finalResult = [self convert:[inputField.text floatValue]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _tempToUnitSelected];
    resultLabel.text = formattedResult;
}

- (float)convert:(float)inputValue {
    if ([_tempFromUnitSelected isEqualToString:@"Degrees Celcius"]) {
        if ([_tempToUnitSelected isEqualToString:@"Degrees Celcius"]) {
            return inputValue;
        } else {
            return inputValue * 1.8 + 32;
        }
    } else {
        if ([_tempToUnitSelected isEqualToString:@"Degrees Celcius"]) {
            return (inputValue - 32) / 1.8;
        } else {
            return inputValue;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == fromUnit) {
        _tempFromUnitSelected = [_tempUnitsArray objectAtIndex:row];
    } else {
        _tempToUnitSelected = [_tempUnitsArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _tempUnitsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _tempUnitsArray[row];
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
