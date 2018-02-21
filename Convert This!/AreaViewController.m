//
//  AreaViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 04/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "AreaViewController.h"
@import GoogleMobileAds;

@interface AreaViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSArray *_areaUnitsArray;
NSArray *_toSquareMetreMultipliers;
NSArray *_fromSquareMetreMultipliers;
NSString *_areaFromUnitSelected;
NSString *_areaToUnitSelected;

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/5492393625";
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
    
    _areaUnitsArray = @[
                    @"Square Millimetres",
                    @"Square Centimetres",
                    @"Square Metres",
                    @"Hectares",
                    @"Square Kilometres",
                    @"Square Inches",
                    @"Square Feet",
                    @"Acres",
                    @"Square Miles"
                    ];
    
    _toSquareMetreMultipliers = @[
                         @0.000001f,
                         @0.0001f,
                         @1.0f,
                         @10000.0f,
                         @1000000.0f,
                         @0.00064516f,
                         @0.092903f,
                         @4046.86f,
                         @2590000.0f
                         ];
    
    _fromSquareMetreMultipliers = @[
                           @1000000.0f,
                           @10000.0f,
                           @1.0f,
                           @0.0001f,
                           @0.000001f,
                           @1550.0031f,
                           @10.7639151f,
                           @0.00024711f,
                           @0.000000386102f
                           ];
    
}

- (IBAction)userDidPressConvert:(id)sender {
    
    if (_areaFromUnitSelected == nil) {
        _areaFromUnitSelected = [_areaUnitsArray firstObject];
    }
    
    if (_areaToUnitSelected == nil) {
        _areaToUnitSelected = [_areaUnitsArray firstObject];
    }
    
    float metreResult = [self convertToMetre:[inputField.text floatValue]];
    float finalResult = [self convertFromMetre:metreResult];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    if (finalResult >= 1) { [formatter setMaximumFractionDigits:2]; }
    if (finalResult < 1) { [formatter setMaximumFractionDigits:4]; }
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *finalResultNumber = [NSNumber numberWithFloat:finalResult];
    NSString *formattedResult;
    if (finalResult < 0.00005) {
        formattedResult = [NSString stringWithFormat:@"< 0.00005\n%@", _areaToUnitSelected];
    } else {
        formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:finalResultNumber], _areaToUnitSelected];
    }
    resultLabel.text = formattedResult;
}

- (float)convertToMetre:(float)inputValue {
    float toSquareMetreMultiplier = [_toSquareMetreMultipliers[[_areaUnitsArray indexOfObject:_areaFromUnitSelected]] floatValue];
    return inputValue * toSquareMetreMultiplier;
}

-(float)convertFromMetre:(float)kgValue {
    float fromSquareMetreMultiplier = [_fromSquareMetreMultipliers[[_areaUnitsArray indexOfObject:_areaToUnitSelected]] floatValue];
    return kgValue * fromSquareMetreMultiplier;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == fromUnit) {
        _areaFromUnitSelected = [_areaUnitsArray objectAtIndex:row];
    } else {
        _areaToUnitSelected = [_areaUnitsArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _areaUnitsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _areaUnitsArray[row];
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
