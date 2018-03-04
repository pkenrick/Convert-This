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

@implementation GeneralViewController {

    NSString *_fromUnitSelected;
    NSString *_toUnitSelected;
    Boolean _fromUnitIsMulti;
    Boolean _toUnitIsMulti;
    NSDictionary *unitsDict;
    Boolean _convertButtonPressed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.converterType = [self.converterType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self getUnits:self.converterType];
    [self setUpView:self.converterType];
    
    [inputFieldMain addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputFieldFirst addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputFieldSecond addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

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
    inputFieldMain.inputAccessoryView = toolbar;
    inputFieldFirst.inputAccessoryView = toolbar;
    inputFieldSecond.inputAccessoryView = toolbar;
    // ===================================================
}

-(void)getUnits:(NSString *)converterType {
    
    if ([converterType isEqualToString:@"Weight"]) {
        unitsDict = [self loadUnitsFromFile:@"weightUnitsToKgs"];
    } else if ([converterType isEqualToString:@"Distance"]) {
        unitsDict = [self loadUnitsFromFile:@"distanceUnitsToMetres"];
    } else if ([converterType isEqualToString:@"Area"]) {
        unitsDict = [self loadUnitsFromFile:@"areaUnitsToSquareMetres"];
    } else if ([converterType isEqualToString:@"Volume"]) {
        unitsDict = [self loadUnitsFromFile:@"volumeUnitsToLitres"];      
    } else if ([converterType isEqualToString:@"Speed"]) {
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
    inputFieldMain.placeholder = [NSString stringWithFormat:@"Enter %@", [converterType lowercaseString]];
}

-(IBAction)userDidPressConvert:(id)sender {
    _convertButtonPressed = YES;
    
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (_fromUnitSelected == nil) {
        _fromUnitSelected = [sortedUnits firstObject];
    }
    if (_toUnitSelected == nil) {
        _toUnitSelected = [sortedUnits firstObject];
    }
    
    [self initiateConversion];
}

-(void)initiateConversion {
    
    float intermediateResult;
    if (_fromUnitIsMulti) {
        NSString *fromUnitFirst = unitsDict[_fromUnitSelected][@"units"][0];
        NSString *fromUnitSecond = unitsDict[_fromUnitSelected][@"units"][1];
        
        float intermediateResultFirst = [self convertToIntermediateUnit:[inputFieldFirst.text floatValue] fromUnit:fromUnitFirst];
        float intermediateResultSecond = [self convertToIntermediateUnit:[inputFieldSecond.text floatValue] fromUnit:fromUnitSecond];
        
        intermediateResult = intermediateResultFirst + intermediateResultSecond;
    } else {
        intermediateResult = [self convertToIntermediateUnit:[inputFieldMain.text floatValue] fromUnit:_fromUnitSelected];
    }

    if (_toUnitIsMulti) {
        NSString *toUnitFirst = unitsDict[_toUnitSelected][@"units"][0];
        NSString *toUnitSecond = unitsDict[_toUnitSelected][@"units"][1];

        // Calculate result for first unit of output
        float finalResultFirst = [self convertFromIntermediateUnit:intermediateResult toUnit:toUnitFirst];
        float finalResultFirstMod = fmod(finalResultFirst, 1.0);
        int finalResultFirstInt = (int)finalResultFirst;
        
        // Calculate result for second unit of output
        float intermediateResultSecond = [self convertToIntermediateUnit:finalResultFirstMod fromUnit:toUnitFirst];
        float finalResultSecond = [self convertFromIntermediateUnit:intermediateResultSecond toUnit:toUnitSecond];
        
        resultLabelFirst.text = [NSString stringWithFormat:@"%i\n%@", finalResultFirstInt, toUnitFirst];
        
        if (finalResultSecond == 0.0) {
            int finalResultSecondInt = (int)finalResultSecond;
            resultLabelSecond.text = [NSString stringWithFormat:@"%i\n%@", finalResultSecondInt, toUnitSecond];
        } else {
            resultLabelSecond.text = [self formatForDisplay:finalResultSecond unit:toUnitSecond];
        }
    } else {
        float finalResult = [self convertFromIntermediateUnit:intermediateResult toUnit:_toUnitSelected];
        [self formatForDisplay:finalResult unit:_toUnitSelected];
        resultLabelMain.text = [self formatForDisplay:finalResult unit:_toUnitSelected];
    }
}

-(float)convertToIntermediateUnit:(float)inputValue fromUnit:(NSString *)fromUnitName {
    float multiplier = [[unitsDict valueForKey:fromUnitName] floatValue];
    return inputValue * multiplier;
}

-(float)convertFromIntermediateUnit:(float)intermediateResult toUnit:(NSString *)toUnitName {
    float divisor = [[unitsDict valueForKey:toUnitName] floatValue];
    return intermediateResult / divisor;
}

-(NSString *)formatForDisplay:(float)result unit:(NSString *)toUnit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    if (result >= 1) { [formatter setMaximumFractionDigits:2]; }
    if (result < 1) { [formatter setMaximumFractionDigits:4]; }
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
    
    NSNumber *resultNumber = [NSNumber numberWithFloat:result];
    NSString *formattedResult;
    if (result < 0.00005) {
        formattedResult = [NSString stringWithFormat:@"< 0.00005\n%@", toUnit];
    } else {
        formattedResult = [NSString stringWithFormat:@"%@\n%@", [formatter stringFromNumber:resultNumber], toUnit];
    }
    return formattedResult;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if (pickerView == fromUnitPicker) {
        _fromUnitSelected  = [sortedUnits objectAtIndex:row];
        if ([unitsDict[_fromUnitSelected] isKindOfClass:[NSDictionary class]]) {
             _fromUnitIsMulti = YES;
        } else {
            _fromUnitIsMulti = NO;
        }
        [self setInputs];
    } else if (pickerView == toUnitPicker){
        _toUnitSelected = [sortedUnits objectAtIndex:row];
        if ([unitsDict[_toUnitSelected] isKindOfClass:[NSDictionary class]]) {
            _toUnitIsMulti = YES;
        } else {
            _toUnitIsMulti = NO;
        }
        [self setResultArea];
    }
    
    if (_convertButtonPressed) {
        [self initiateConversion];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return unitsDict.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSArray *sortedUnits = [[unitsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    return [sortedUnits objectAtIndex: row];
//}

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

- (void)setInputs {
    if (_fromUnitIsMulti) {
        NSString *firstUnit = unitsDict[_fromUnitSelected][@"units"][0];
        NSString *secondUnit = unitsDict[_fromUnitSelected][@"units"][1];
        inputFieldFirst.placeholder = [NSString stringWithFormat:@"Enter %@", firstUnit];
        inputFieldSecond.placeholder = [NSString stringWithFormat:@"Enter %@", secondUnit];
        inputFieldMain.hidden = true;
        inputFieldFirst.hidden = false;
        inputFieldSecond.hidden = false;
    } else {
        inputFieldMain.placeholder = [NSString stringWithFormat:@"Enter %@", _fromUnitSelected];
        inputFieldMain.hidden = false;
        inputFieldFirst.hidden = true;
        inputFieldSecond.hidden = true;
    }
}

- (void)setResultArea {
    if (_toUnitIsMulti) {
        resultLabelMain.hidden = true;
        resultLabelMain.text = @"";
        resultLabelFirst.hidden = false;
        resultLabelSecond.hidden = false;
    } else {
        resultLabelMain.hidden = false;
        resultLabelFirst.hidden = true;
        resultLabelSecond.hidden = true;
        resultLabelFirst.text = @"";
        resultLabelSecond.text = @"";
    }
}

- (void)textFieldDidChange:(id)sender {
    if(_convertButtonPressed) {
        [self initiateConversion];
    }
}

- (void)dismissKeyboard {
    [inputFieldMain resignFirstResponder];
    [inputFieldFirst resignFirstResponder];
    [inputFieldSecond resignFirstResponder];
}

- (IBAction)dismissView:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
