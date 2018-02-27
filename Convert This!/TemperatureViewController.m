//
//  TemperatureViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 04/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "TemperatureViewController.h"
@import GoogleMobileAds;

@interface TemperatureViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSString *_tempFromUnitSelected;
NSString *_tempToUnitSelected;

NSDictionary *_temperatureUnitsToCelcius;

@implementation TemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/3249373666";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"4c5fcbb920a15b4fa1928c8f18c25712" ];
    [self.bannerView loadRequest:request];
    self.bannerView.delegate = self;
    
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
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"temperatureUnitsToCelcius" ofType:@"plist"];
    _temperatureUnitsToCelcius = [NSDictionary dictionaryWithContentsOfFile:plistCatPath];
    
//    for(NSString *key in [_temperatureUnitsToCelcius allKeys]) {
//        NSDictionary *unitDict = [_temperatureUnitsToCelcius objectForKey:key];
//        for(NSString *innerKey in [unitDict allKeys]) {
//            NSLog(@"%@: %f", key, [[unitDict objectForKey:innerKey] floatValue]);
//        }
//
//    }
}

- (IBAction)toggleSign:(id)sender {
    if (![inputField.text isEqualToString:@""]) {
        if ([inputField.text floatValue] > 0) {
            inputField.text = [NSString stringWithFormat:@"-%@",inputField.text];
        } else {
            inputField.text = [inputField.text substringFromIndex:1];
        }
    }
}

- (IBAction)userDidPressConvert:(id)sender {
    
    NSArray *sortedKeys = [[_temperatureUnitsToCelcius allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    if (_tempFromUnitSelected == nil) {
        _tempFromUnitSelected = [sortedKeys firstObject];
    }
    
    if (_tempToUnitSelected == nil) {
        _tempToUnitSelected = [sortedKeys firstObject];
    }
    
    float celciusResult = [self convertToCelcius:[inputField.text floatValue]];
    float finalResult = [self convertFromCelcius:celciusResult];

    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _tempToUnitSelected];
    resultLabel.text = formattedResult;
}

- (float)convertToCelcius:(float)inputValue {
    NSDictionary *requiredDict = [_temperatureUnitsToCelcius objectForKey:_tempFromUnitSelected];
    float celciusResult = (inputValue + [requiredDict[@"beforeConstant"] floatValue]) * [requiredDict[@"multiplier"] floatValue];
    return celciusResult;
}

- (float)convertFromCelcius:(float)celciusValue {
    NSDictionary *requiredDict = [_temperatureUnitsToCelcius objectForKey:_tempToUnitSelected];
    float finalResult = celciusValue / [requiredDict[@"multiplier"] floatValue] - [requiredDict[@"beforeConstant"] floatValue];
    return finalResult;
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
    NSArray *sortedKeys = [[_temperatureUnitsToCelcius allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if (pickerView == fromUnit) {
        _tempFromUnitSelected = [sortedKeys objectAtIndex:row];
    } else {
        _tempToUnitSelected = [sortedKeys objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_temperatureUnitsToCelcius allKeys].count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *sortedKeys = [[_temperatureUnitsToCelcius allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [sortedKeys objectAtIndex:row];
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
