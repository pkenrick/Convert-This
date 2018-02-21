//
//  WeightViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 30/01/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "WeightViewController.h"
@import GoogleMobileAds;


@interface WeightViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSArray *_unitsArray;
NSArray *_toKgMultipliers;
NSArray *_fromKgMultipliers;
NSString *_fromUnitSelected;
NSString *_toUnitSelected;

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/6319633400";
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
    
    _unitsArray = @[
                    @"Milligrams",
                    @"Grams",
                    @"Kilograms",
                    @"Tonnes",
                    @"Ounces",
                    @"Pounds",
                    @"Stone"
                    ];
    
    _toKgMultipliers = @[
                         @0.000001f,
                         @0.001f,
                         @1.0f,
                         @1000.0f,
                         @0.0283495f,
                         @0.453592f,
                         @6.35029f
                         ];
    
    _fromKgMultipliers = @[
                           @1000000,
                           @1000,
                           @1,
                           @0.001,
                           @35.2739907,
                           @2.2046244,
                           @0.1574731
                           ];

}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

- (IBAction)userDidPressConvert:(id)sender {
    
    if (_fromUnitSelected == nil) {
        _fromUnitSelected = [_unitsArray firstObject];
    }
    
    if (_toUnitSelected == nil) {
        _toUnitSelected = [_unitsArray firstObject];
    }
    
    float kgResult = [self convertToKg:[inputField.text floatValue]];
    float finalResult = [self convertFromKg:kgResult];
    
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

- (float)convertToKg:(float)inputValue {
    float toKgMultiplier = [_toKgMultipliers[[_unitsArray indexOfObject:_fromUnitSelected]] floatValue];
    return inputValue * toKgMultiplier;
}

-(float)convertFromKg:(float)kgValue {
    float fromKgMultiplier = [_fromKgMultipliers[[_unitsArray indexOfObject:_toUnitSelected]] floatValue];
    return kgValue * fromKgMultiplier;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == fromUnit) {
        _fromUnitSelected = [_unitsArray objectAtIndex:row];
    } else {
        _toUnitSelected = [_unitsArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _unitsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _unitsArray[row];
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
