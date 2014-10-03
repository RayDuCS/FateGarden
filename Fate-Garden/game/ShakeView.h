//
//  ShakeView.h
//  Fate-Garden
//
//  Created by Rui Du on 9/23/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShakeViewDelegate <NSObject>

@required
- (void)shakeEventDetectedWithDuration:(float)duration;

@end

@interface ShakeView : UIView

@property (weak, nonatomic) id delegate;

@end
