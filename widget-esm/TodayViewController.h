//
//  TodayViewController.h
//  widget-esm
//
//  Created by Yuuki Nishiyama on 2017/06/23.
//  Copyright © 2017 Yuuki NISHIYAMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *mainView;
- (IBAction)ChangedSlider:(id)sender;
- (IBAction)pushedFirstButton:(id)sender;

@end
