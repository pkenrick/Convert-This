//
//  TemperatureViewController.h
//  Convert This!
//
//  Created by Paul Kenrick on 04/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDelegate> {

IBOutlet UIPickerView *fromUnit;
IBOutlet UIPickerView *toUnit;

IBOutlet UITextField *inputField;
IBOutlet UILabel *resultLabel;
}

-(IBAction)dismissView:(id)sender;
-(IBAction)toggleSign:(id)sender;
-(IBAction)userDidPressConvert:(id)sender;

@end
