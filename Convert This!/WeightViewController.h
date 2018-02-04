//
//  WeightViewController.h
//  Convert This!
//
//  Created by Paul Kenrick on 30/01/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDelegate> {
    IBOutlet UIPickerView *fromUnit;
    IBOutlet UIPickerView *toUnit;
    
    IBOutlet UIPickerView *fromPickerCover;
    IBOutlet UIPickerView *toPickerCover;
        
    IBOutlet UITextField *inputField;
    IBOutlet UILabel *resultLabel;
}

-(IBAction)dismissView:(id)sender;
-(IBAction)userDidPressConvert:(id)sender;

@end
