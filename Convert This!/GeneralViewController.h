//
//  GeneralViewController.h
//  Convert This!
//
//  Created by Paul Kenrick on 02/03/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDelegate> {
    IBOutlet UIPickerView *fromUnitPicker;
    IBOutlet UIPickerView *toUnitPicker;
    
    IBOutlet UITextField *inputField;
    IBOutlet UILabel *resultLabel;
}

-(IBAction)dismissView:(id)sender;
-(IBAction)userDidPressConvert:(id)sender;

@property (weak, nonatomic) NSString *converterType;

@end


