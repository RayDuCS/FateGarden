//
//  ShakeView.m
//  Fate-Garden
//
//  Created by Rui Du on 9/23/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import "ShakeView.h"

@interface ShakeView()

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSTimer *timer;
@property (atomic) BOOL shaked;

@end

@implementation ShakeView
@synthesize delegate = _delegate;
@synthesize startDate = _startDate;
@synthesize timer = _timer;
@synthesize shaked = _shaked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)timerTriggered
{
    if (self.shaked) return;
    
    self.shaked = YES;
    [self.delegate shakeEventDetectedWithDuration:1.75];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //if (event.subtype == UIEventSubtypeMotionShake)
    {
        self.shaked = NO;
        self.startDate = [NSDate date];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.75
                                                      target:self
                                                    selector:@selector(timerTriggered)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    
    if ( [super respondsToSelector:@selector(motionBegan:withEvent:)] )
        [super motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //if (event.subtype == UIEventSubtypeMotionShake)
    if (!self.shaked)
    {
        self.shaked = YES;
        [self.timer invalidate];
        [self.delegate shakeEventDetectedWithDuration:-[self.startDate timeIntervalSinceNow]];
        //NSLog(@"%f", [self.startDate timeIntervalSinceNow]);
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
