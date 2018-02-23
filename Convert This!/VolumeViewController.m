//
//  VolumeViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 05/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "VolumeViewController.h"
@import GoogleMobileAds;

@interface VolumeViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

NSString *_volumeFromUnitSelected;
NSString *_volumeToUnitSelected;

NSDictionary *_volumeUnitsToCubicMetres;

@implementation VolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/2483086909";
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
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"volumeUnitsToCubicMetres" ofType:@"plist"];
    _volumeUnitsToCubicMetres = [NSDictionary dictionaryWithContentsOfFile:plistCatPath];
    
//    for(NSString *key in [_volumeUnitsToCubicMetres allKeys]) {
//        NSLog(@"%@: %f", key, [[_volumeUnitsToCubicMetres objectForKey:key] floatValue]);
//    }
}

- (IBAction)userDidPressConvert:(id)sender {
    
    NSArray *sortedKeys = [[_volumeUnitsToCubicMetres allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (_volumeFromUnitSelected == nil) {
        _volumeFromUnitSelected = [sortedKeys firstObject];
    }
    
    if (_volumeFromUnitSelected == nil) {
        _volumeFromUnitSelected = [sortedKeys firstObject];
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
    float multiplier = [[_volumeUnitsToCubicMetres valueForKey:_volumeFromUnitSelected] floatValue];
    return inputValue * multiplier;
}

-(float)convertFromLitre:(float)metreValue {
    float divisor = [[_volumeUnitsToCubicMetres valueForKey:_volumeToUnitSelected] floatValue];
    return metreValue / divisor;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *sortedKeys = [[_volumeUnitsToCubicMetres allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if (pickerView == fromUnit) {
        _volumeFromUnitSelected = [sortedKeys objectAtIndex:row];
    } else {
        _volumeToUnitSelected = [sortedKeys objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _volumeUnitsToCubicMetres.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *sortedKeys = [[_volumeUnitsToCubicMetres allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys[row];
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


