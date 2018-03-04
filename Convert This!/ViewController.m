//
//  ViewController.m
//  Convert This!
//
//  Created by Paul Kenrick on 21/02/2018.
//  Copyright © 2018 Paul Kenrick. All rights reserved.
//

#import "ViewController.h"
@import GoogleMobileAds;

@interface ViewController () <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

UINavigationController *navigationController;

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.adUnitID = @"ca-app-pub-6253453252582106/3070482092";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"4c5fcbb920a15b4fa1928c8f18c25712" ];
    [self.bannerView loadRequest:request];
    self.bannerView.delegate = self;
}

- (void)didSelectConverter:(id)sender {
    
    UIButton *buttonPressed = (UIButton *)sender;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GeneralViewController *generalViewController = (GeneralViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"generalConverter"];
    generalViewController.converterType = buttonPressed.currentTitle;
    generalViewController.title = [NSString stringWithFormat:@"%@ Converter", buttonPressed.currentTitle];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:generalViewController];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    generalViewController.navigationItem.leftBarButtonItem = backButton;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)backBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///// Tells the delegate an ad request loaded an ad.
//- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//    NSLog(@"adViewDidReceiveAd");
//}
//
///// Tells the delegate an ad request failed.
//- (void)adView:(GADBannerView *)adView
//didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
//}
//
///// Tells the delegate that a full-screen view will be presented in response
///// to the user clicking on an ad.
//- (void)adViewWillPresentScreen:(GADBannerView *)adView {
//    NSLog(@"adViewWillPresentScreen");
//}
//
///// Tells the delegate that the full-screen view will be dismissed.
//- (void)adViewWillDismissScreen:(GADBannerView *)adView {
//    NSLog(@"adViewWillDismissScreen");
//}
//
///// Tells the delegate that the full-screen view has been dismissed.
//- (void)adViewDidDismissScreen:(GADBannerView *)adView {
//    NSLog(@"adViewDidDismissScreen");
//}
//
///// Tells the delegate that a user click will open another app (such as
///// the App Store), backgrounding the current app.
//- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
//    NSLog(@"adViewWillLeaveApplication");
//}

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
