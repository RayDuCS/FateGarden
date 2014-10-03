//
//  GameViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 8/2/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SettingsViewController.h"

@interface GameViewController : UIViewController<AVAudioPlayerDelegate, SettingsDelegate>
- (void)turn_on_music:(BOOL)on;
@end
