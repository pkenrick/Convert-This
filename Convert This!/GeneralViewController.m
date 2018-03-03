//
//  GeneralViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 02/03/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "GeneralViewController.h"
@import GoogleMobileAds;


@interface GeneralViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSString *_fromUnitSelected;
NSString *_toUnitSelected;
NSDictionary *unitsDict;


@implementation GeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.converterType = [self.converterType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self getUnits:self.converterType];
    [self setUpView:self.converterType];
    
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/3070482092";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"4c5fcbb920a15b4fa1928c8f18c25712" ];
    [self.bannerView loadRequest:request];
    self.bannerView.delegate = self;
    
    // ===== Setting up 'Done' button on keyboard ========
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
    // ===================================================
}

-(void)getUnits:(NSString *)converterType {
    NSLog(@"%@", converterType);
    
    if ([converterType isEqualToString:@"Speed"]) {
        unitsDict = [self loadUnitsFromFile:@"speedUnitsToKilometrePerHour"];
    } else if ([converterType isEqualToString:@"Data"]) {
        unitsDict = [self loadUnitsFromFile:@"dataUnitsToKilobytes"];
    } else if ([converterType isEqualToString:@"Fuel"]) {
        unitsDict = [self loadUnitsFromFile:@"fuelUnitsToLitresPerKm"];
    } else if ([converterType isEqualToString:@"Power"]) {
        unitsDict = [self loadUnitsFromFile:@"powerUnitsToKilowatts"];
    } else if ([converterType isEqualToString:@"Time"]) {
        unitsDict = [self loadUnitsFromFile:@"timeUnitsToHours"];
    } else if ([converterType isEqualToString:@"Pressure"]) {
        unitsDict = [self loadUnitsFromFile:@"pressureUnitsToBar"];
    }
}

-(NSDictionary *)loadUnitsFromFile:(NSString *)fileName {
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *unitsDict = [NSDictionary dictionaryWithContentsOfFile:plistCatPath];
    return unitsDict;
}

-(void)setUpView:(NSString *)converterType {
    inputField.placeholder = [NSString stringWithFormat:@"Enter %@", [converterType lowercaseString]];
}

-(IBAction)userDidPressConvert:(id)sender {
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (_fromUnitSelected == nil) {
        _fromUnitSelected = [sortedUnits firstObject];
    }
    
    if (_toUnitSelected == nil) {
        _toUnitSelected = [sortedUnits firstObject];
    }
    
    float intermediateResult = [self convertToIntermediateUnit:[inputField.text floatValue]];
    float finalResult = [self convertFromIntermediateUnit:intermediateResult];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    if (finalResult >= 1) { [formatter setMaximumFractionDigits:2]; }
    if (finalResult < 1) { [formatter setMaximumFractionDigits:4]; }
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult;
    if (finalResult < 0.00005) {
        formattedResult = [NSString stringWithFormat:@"< 0.00005\n%@", _toUnitSelected];
    } else {
        formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _toUnitSelected];
    }
    resultLabel.text = formattedResult;
}

-(float)convertToIntermediateUnit:(float)inputValue {
    float multiplier = [[unitsDict valueForKey:_fromUnitSelected] floatValue];
    return inputValue * multiplier;
}

-(float)convertFromIntermediateUnit:(float)intermediateResult {
    float divisor = [[unitsDict valueForKey:_toUnitSelected] floatValue];
    return intermediateResult / divisor;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if (pickerView == fromUnitPicker) {
        _fromUnitSelected  = [sortedUnits objectAtIndex:row];
    } else if (pickerView == toUnitPicker){
        _toUnitSelected = [sortedUnits objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return unitsDict.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [sortedUnits objectAtIndex: row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerTextLabel = (UILabel*)view;
    if (!pickerTextLabel){
        pickerTextLabel = [[UILabel alloc] init];
        [pickerTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [pickerTextLabel setTextAlignment:NSTextAlignmentCenter];
    }
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    pickerTextLabel.text = [sortedUnits objectAtIndex: row];
    return pickerTextLabel;
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

@end
