//
//  SettingsViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 3/23/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate <NSObject>
- (void)turn_on_music:(BOOL)on;
@required

@end

@interface SettingsViewController : UIViewController<UIAlertViewDelegate>

- (void)load_with_idx:(int)idx
             delegate:(id)delegate;

@end
