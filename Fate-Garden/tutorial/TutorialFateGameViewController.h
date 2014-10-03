//
//  TutorialFateGameViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 3/9/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeView.h"
#import "FateGameViewController.h"
@class Theme;

@interface TutorialFateGameViewController : UIViewController<ShakeViewDelegate>
- (void)loadWithTheme:(Theme *)theme
                  idx:(int)idx;
@end
