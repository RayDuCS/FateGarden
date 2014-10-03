//
//  FateGameViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 9/23/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakeView.h"
#import "GADBannerView.h"

@class Theme;

#define BAR_SHAKE_ITERATION 2

typedef enum
{
    GAMESTATE_IDLE = 1,
    GAMESTATE_RESETING = 2,
    GAMESTATE_SHAKING = 3,
}GameState;

typedef enum
{
    BARSTATE_MID_LEFT = 1,
    BARSTATE_LEFT_LOWER_LEFT = 2,
    BARSTATE_LEFT_UPPER = 3,
    BARSTATE_LEFT_LOWER_RIGHT = 4,
    BARSTATE_MID_RIGHT = 5,
    BARSTATE_RIGHT_LOWER_RIGHT = 6,
    BARSTATE_RIGHT_UPPER = 7,
    BARSTATE_RIGHT_LOWER_LEFT = 8,
    BARSTATE_MID_LEFT_2 = 9,
    BARSTATE_MID_LEFT_BACK = 10,
    BARSTATE_MID_RIGHT_2 = 11,
    BARSTATE_MID_RIGHT_BACK = 12
}BarState;

typedef enum
{
    BAR_SHAKE_STATE_BTM_TO_LEFT  = 1,
    BAR_SHAKE_STATE_LEFT_TO_BTM  = 2,
    BAR_SHAKE_STATE_BTM_TO_RIGHT = 3,
    BAR_SHAKE_STATE_RIGHT_TO_BTM = 4,
}BarShakeState;

typedef enum
{
    BAR_SHAKE_STATUS_START   = 1,
    BAR_SHAKE_STATUS_STOP    = 2,  // stop the bar after current iteration
    BAR_SHAKE_STATUS_RESTART = 3,  // the bar should finish current iteration, then startover (reset iter counter)
}BarShakeStatus;

@interface FateGameViewController : UIViewController<ShakeViewDelegate, UIAlertViewDelegate>{
    GADBannerView *bannerView_;
}

- (void)load_with_theme:(Theme *)theme
               delegate:(id)delegate;

@end
