//
//  TutorialFateGameViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 3/9/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "TutorialFateGameViewController.h"
#import "FateGameViewController.h"
#import "ShakeView.h"
#import "Petal.h"
#import "Theme.h"
#import "PetalInfo.h"
#import "UICustomFont.h"
#import "UICustomColor.h"
#import "UIViewCustomAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface TutorialFateGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mask_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *bar_imgView;
@property (weak, nonatomic) IBOutlet UIView *result_view;
@property (weak, nonatomic) IBOutlet UILabel *result_title_label;
@property (weak, nonatomic) IBOutlet UILabel *result_option_label;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_left_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_right_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_right_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_left_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *pistil_imgView;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@property (weak, nonatomic) IBOutlet UIImageView *bar_image_view;
@property (weak, nonatomic) IBOutlet UIButton *replay_btn;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *home_btn;

@property (strong, nonatomic) AVAudioPlayer *sePlayer;
@property (strong, nonatomic) Theme *theme;
@property (nonatomic) int idx;

@property (strong, nonatomic) ShakeView *shakeView;
@property (strong, atomic) NSArray *current_petals;
@property (strong, atomic) NSArray *discarded_petals;
@property (strong, atomic) NSArray *unused_petals;
@property (strong, atomic) NSArray *unused_discarded_petals;
@property (atomic) BOOL played;
@property (atomic) int petal_losts;
@property (atomic) int petal_animation_finished;
@property (atomic) GameState state;
@property (strong, nonatomic) NSTimer *endOfGameTimer;
@property (atomic) BarState barState;
@property (atomic) BarShakeStatus bar_shake_status;
@property (atomic) BarShakeState bar_shake_state;
@property (atomic) int bar_shake_iteration;

@end

@implementation TutorialFateGameViewController
@synthesize idx = _idx;
@synthesize theme = _theme;
@synthesize petal_down_imgView = _petal_down_imgView;
@synthesize petal_down_left_imgView = _petal_down_left_imgView;
@synthesize petal_down_right_imgView = _petal_down_right_imgView;
@synthesize petal_up_imgView = _petal_up_imgView;
@synthesize petal_up_left_imgView = _petal_up_left_imgView;
@synthesize petal_up_right_imgView = _petal_up_right_imgView;
@synthesize bar_imgView = _bar_imgView;
@synthesize result_option_label = _result_option_label;
@synthesize result_title_label = _result_title_label;
@synthesize result_view = _result_view;
@synthesize mask_imgView = _mask_imgView;
@synthesize shakeView = _shakeView;
@synthesize current_petals = _current_petals;
@synthesize discarded_petals = _discarded_petals;
@synthesize unused_petals = _unused_petals;
@synthesize unused_discarded_petals = _unused_discarded_petals;
@synthesize played = _played;
@synthesize petal_losts = _petal_losts;
@synthesize petal_animation_finished = _petal_animation_finished;
@synthesize state = _state;
@synthesize endOfGameTimer = _endOfGameTimer;
@synthesize barState = _barState;
@synthesize sePlayer = _sePlayer;
@synthesize bar_shake_state = _bar_shake_state;
@synthesize bar_shake_status = _bar_shake_status;
@synthesize bar_shake_iteration = _bar_shake_iteration;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadWithTheme:(Theme *)theme idx:(int)idx
{
    self.theme = theme;
    self.idx = idx;
}

- (BOOL)usefulPetal:(Petal *)petal
{
    for (id key in self.theme.options)
    {
        PetalInfo *info = [self.theme.options objectForKey:key];
        if (info.pos == petal.pos && info.option &&![info.option isEqualToString:@""])
            return TRUE;
    }
    
    return FALSE;
}

- (UIImage *)image_for_string:(NSString *)mask_name
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@_ip5.png", mask_name]];
    } else {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", mask_name]];
    }
}

- (void)rearrange_icons
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return;
    }
    
    [self.bg_image_view setImage:[UIImage imageNamed:@"game_bg_ip5.png"]];
    [self.bar_imgView setFrame:CGRectMake(50, 0, 220, 102)];
    [self.pistil_imgView setFrame:CGRectMake(131, 222, 51, 66)];
    [self.petal_up_imgView setFrame:CGRectMake(123, 125, 74, 147)];
    [self.petal_up_left_imgView setFrame:CGRectMake(44, 188, 129, 92)];
    [self.petal_up_right_imgView setFrame:CGRectMake(153, 171, 115, 101)];
    [self.petal_down_imgView setFrame:CGRectMake(124, 241, 80, 124)];
    [self.petal_down_left_imgView setFrame:CGRectMake(51, 243, 108, 76)];
    [self.petal_down_right_imgView setFrame:CGRectMake(155, 239, 127, 72)];
    
    float adjust_x = 0.0f;
    float adjust_y = 44.0f;
    
    [self.back_btn  setFrame:CGRectMake( 30 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.edit_btn  setFrame:CGRectMake( 85 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.replay_btn setFrame:CGRectMake(141 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.home_btn  setFrame:CGRectMake(248 + adjust_x, 404 + adjust_y, 44, 60)];
    
    [self.mask_imgView setImage:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_7", nil)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self rearrange_icons];
    
    self.shakeView = [[ShakeView alloc] init];
    self.shakeView.delegate = self;
    [self.view addSubview:self.shakeView];
    [self.shakeView becomeFirstResponder];
    
    self.played = NO;
    
    Petal *petal_up = [[Petal alloc] initWithInitFrame:CGRectMake(123, 125, 74, 147)
                                             destFrame:CGRectMake(160, 0, 74, 147)
                                                  view:self.petal_up_imgView
                                                   pos:PETAL_UP];
    Petal *petal_up_left = [[Petal alloc] initWithInitFrame:CGRectMake(44, 188, 128, 92)
                                                  destFrame:CGRectMake(0, 200, 128, 92)
                                                       view:self.petal_up_left_imgView
                                                        pos:PETAL_UP_LEFT];
    Petal *petal_up_right = [[Petal alloc] initWithInitFrame:CGRectMake(153, 171, 115, 101)
                                                   destFrame:CGRectMake(320, 160, 115, 101)
                                                        view:self.petal_up_right_imgView
                                                         pos:PETAL_UP_RIGHT];
    Petal *petal_down = [[Petal alloc] initWithInitFrame:CGRectMake(124, 241, 80, 124)
                                               destFrame:CGRectMake(160, 480, 80, 124)
                                                    view:self.petal_down_imgView
                                                     pos:PETAL_DOWN];
    Petal *petal_down_left = [[Petal alloc] initWithInitFrame:CGRectMake(51, 243, 108, 76)
                                                    destFrame:CGRectMake(0, 280, 108, 76)
                                                         view:self.petal_down_left_imgView
                                                          pos:PETAL_DOWN_LEFT];
    Petal *petal_down_right = [[Petal alloc] initWithInitFrame:CGRectMake(155, 239, 127, 72)
                                                     destFrame:CGRectMake(320, 260, 127, 72)
                                                          view:self.petal_down_right_imgView
                                                           pos:PETAL_DOWN_RIGHT];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *unusedMutableArray = [[NSMutableArray alloc] init];
    
    if ([self usefulPetal:petal_up]) {
        [mutableArray addObject:petal_up];
    } else {
        [unusedMutableArray addObject:petal_up];
    }
    
    if ([self usefulPetal:petal_up_left]) {
        [mutableArray addObject:petal_up_left];
    } else {
        [unusedMutableArray addObject:petal_up_left];
    }
    
    if ([self usefulPetal:petal_up_right]) {
        [mutableArray addObject:petal_up_right];
    } else {
        [unusedMutableArray addObject:petal_up_right];
    }
    
    if ([self usefulPetal:petal_down]) {
        [mutableArray addObject:petal_down];
    } else {
        [unusedMutableArray addObject:petal_down];
    }
    
    if ([self usefulPetal:petal_down_left]) {
        [mutableArray addObject:petal_down_left];
    } else {
        [unusedMutableArray addObject:petal_down_left];
    }
    
    if ([self usefulPetal:petal_down_right]) {
        [mutableArray addObject:petal_down_right];
    } else {
        [unusedMutableArray addObject:petal_down_right];
    }
    
    self.current_petals = [mutableArray copy];
    self.unused_petals = [unusedMutableArray copy];
    
    self.discarded_petals = [[NSArray alloc] init];
    self.unused_discarded_petals = [[NSArray alloc] init];
    self.state = GAMESTATE_IDLE;
    
    self.result_view.alpha = 0;
    
    self.result_title_label.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    self.result_option_label.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:48];
    self.result_title_label.textColor = [UIColor whiteColor];
    self.result_option_label.textColor = [UIColor whiteColor];
    
    self.barState = BARSTATE_MID_LEFT;
    self.bar_shake_status = BAR_SHAKE_STATUS_STOP;
    self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_LEFT;
    self.bar_shake_iteration = 0;
    
    [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_7", nil)]];
    self.homeBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMask_imgView:nil];
    [self setBar_imgView:nil];
    [self setResult_view:nil];
    [self setResult_title_label:nil];
    [self setResult_option_label:nil];
    [self setPetal_up_imgView:nil];
    [self setPetal_up_left_imgView:nil];
    [self setPetal_up_right_imgView:nil];
    [self setPetal_down_right_imgView:nil];
    [self setPetal_down_left_imgView:nil];
    [self setPetal_down_imgView:nil];
    [self setHomeBtn:nil];
    [self setSePlayer:nil];
    [self setTheme:nil];
    [self setBg_image_view:nil];
    [self setReplay_btn:nil];
    [self setEdit_btn:nil];
    [self setShare_btn:nil];
    [self setBack_btn:nil];
    [self setBar_image_view:nil];
    [self setPistil_imgView:nil];
    [self setHome_btn:nil];
    [super viewDidUnload];
}

- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;

    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (IBAction)homeBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    UIViewController *vc = self.presentingViewController;
    
    for (int i=0; i<self.idx; i++)
    {
        vc = vc.presentingViewController;
    }
    
    [vc dismissModalViewControllerAnimated:YES];

}

- (int)getLostPetalsForDuration:(float)duration
{
    //return 1;
    
    if (duration < 0.5) return 1;
    if (duration < 0.8) return 2;
    if (duration < 1.25) return 3;
    if (duration < 1.75) return 4;
    
    return 5;
}

- (UIImage *)imageForBarState:(BarState)barState
{
    switch (barState) {
        case BARSTATE_MID_LEFT:
        case BARSTATE_MID_RIGHT:
        case BARSTATE_MID_LEFT_2:
        case BARSTATE_MID_RIGHT_2:
        case BARSTATE_MID_LEFT_BACK:
        case BARSTATE_MID_RIGHT_BACK:
            return [UIImage imageNamed:@"bar_shake.png"];
            
        case BARSTATE_LEFT_LOWER_LEFT:
        case BARSTATE_LEFT_LOWER_RIGHT:
            return [UIImage imageNamed:@"bar_left_1.png"];
            
        case BARSTATE_LEFT_UPPER:
            return [UIImage imageNamed:@"bar_left_2.png"];
            
        case BARSTATE_RIGHT_LOWER_LEFT:
        case BARSTATE_RIGHT_LOWER_RIGHT:
            return [UIImage imageNamed:@"bar_right_1.png"];
            
        case BARSTATE_RIGHT_UPPER:
            return [UIImage imageNamed:@"bar_right_2.png"];
    }
    
    return nil;
}

- (BarState)nextStateForState:(BarState)barState
{
    switch (barState) {
        case BARSTATE_MID_LEFT:
            return BARSTATE_MID_LEFT_2;
            
        case BARSTATE_MID_LEFT_2:
            return BARSTATE_LEFT_LOWER_LEFT;
            
        case BARSTATE_LEFT_LOWER_LEFT:
            return BARSTATE_LEFT_UPPER;
            
        case BARSTATE_LEFT_UPPER:
            return BARSTATE_LEFT_LOWER_RIGHT;
            
        case BARSTATE_LEFT_LOWER_RIGHT:
            return BARSTATE_MID_LEFT_BACK;
            
        case BARSTATE_MID_LEFT_BACK:
            return BARSTATE_MID_RIGHT;
            
        case BARSTATE_MID_RIGHT:
            return BARSTATE_MID_RIGHT_2;
            
        case BARSTATE_MID_RIGHT_2:
            return BARSTATE_RIGHT_LOWER_RIGHT;
            
        case BARSTATE_RIGHT_LOWER_RIGHT:
            return BARSTATE_RIGHT_UPPER;
            
        case BARSTATE_RIGHT_UPPER:
            return BARSTATE_RIGHT_LOWER_LEFT;
            
        case BARSTATE_RIGHT_LOWER_LEFT:
            return BARSTATE_MID_RIGHT_BACK;
            
        case BARSTATE_MID_RIGHT_BACK:
            return BARSTATE_MID_LEFT;
    }
}

- (CGRect)frameForState:(BarState)barState
{
    switch (barState) {
        case BARSTATE_MID_LEFT:
        case BARSTATE_MID_RIGHT:
            return CGRectMake(50, 0, 220, 103);
            
        case BARSTATE_MID_LEFT_2:
        case BARSTATE_MID_LEFT_BACK:
            return CGRectMake(48, 0, 220, 103);
            //return CGRectMake(50, 0, 220, 103);
            
        case BARSTATE_LEFT_LOWER_LEFT:
        case BARSTATE_LEFT_LOWER_RIGHT:
            return CGRectMake(45, 0, 218, 107);
            //return CGRectMake(49, 0, 218, 107);
            
        case BARSTATE_LEFT_UPPER:
            return CGRectMake(40, 0, 216, 115);
            //return CGRectMake(46, 0, 216, 115);
            
        case BARSTATE_MID_RIGHT_2:
        case BARSTATE_MID_RIGHT_BACK:
            return CGRectMake(52, 0, 220, 103);
            //return CGRectMake(50, 0, 220, 103);
            
        case BARSTATE_RIGHT_LOWER_LEFT:
        case BARSTATE_RIGHT_LOWER_RIGHT:
            return CGRectMake(57, 0, 221, 107);
            //return CGRectMake(53, 0, 221, 107);
            
        case BARSTATE_RIGHT_UPPER:
            return CGRectMake(60, 0, 222, 112);
            //return CGRectMake(54, 0, 222, 112);
            
    }
}

- (void)animate_shaking_bar
{
    CGPoint endPoint;
    CGPoint endOrigin;
    CGFloat width = self.bar_imgView.frame.size.width;
    CGFloat height = self.bar_imgView.frame.size.height;
    CGFloat shake_width = 20.0f;
    CGFloat shake_height = 0.0f;
    
    switch (self.bar_shake_state) {
        case BAR_SHAKE_STATE_BTM_TO_LEFT:
            /* Start of iteration, do check here */
            if (self.bar_shake_status == BAR_SHAKE_STATUS_START) {
                /* Fall below */
            } else if (self.bar_shake_status == BAR_SHAKE_STATUS_STOP) {
                /* Stopped by others */
                self.bar_shake_iteration = 0;
                return;
            } else if (self.bar_shake_status == BAR_SHAKE_STATUS_RESTART) {
                /* Restart */
                self.bar_shake_status = BAR_SHAKE_STATUS_START;
                self.bar_shake_iteration = BAR_SHAKE_ITERATION;
            }
            
            self.bar_shake_iteration--;
            if (self.bar_shake_iteration < 0) {
                /* Normal stop */
                self.bar_shake_iteration = 0;
                self.bar_shake_status = BAR_SHAKE_STATUS_STOP;
                return;
            }
            
            NSLog(@"iter=%d", self.bar_shake_iteration);
            
            self.bar_shake_state = BAR_SHAKE_STATE_LEFT_TO_BTM;
            endPoint  = CGPointMake(50.0f - shake_width + width/2.0f, 0.0f - shake_height + height/2.0f);
            endOrigin = CGPointMake(50.0f - shake_width, 0.0f - shake_height);
            break;
        case BAR_SHAKE_STATE_LEFT_TO_BTM:
            self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_RIGHT;
            endPoint  = CGPointMake(50.0f + width/2.0f, 0 + height/2.0f);
            endOrigin = CGPointMake(50.0f, 0.0f);
            break;
        case BAR_SHAKE_STATE_BTM_TO_RIGHT:
            self.bar_shake_state = BAR_SHAKE_STATE_RIGHT_TO_BTM;
            endPoint  = CGPointMake(50.0f + shake_width + width/2.0f, 0.0f - shake_height + height/2.0f);
            endOrigin = CGPointMake(50.0f + shake_width, 0.0f - shake_height);
            break;
        case BAR_SHAKE_STATE_RIGHT_TO_BTM:
            self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_LEFT;
            endPoint  = CGPointMake(50 + width/2.0f, 0 + height/2.0f);
            endOrigin = CGPointMake(50.0f, 0.0f);
            break;
    }
    
    
    CGRect imageFrame = self.bar_imgView.frame;
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = self.bar_imgView.frame.origin;
    //NSLog(@"origin = %f/%f endpoint = %f/%f layer = %f/%f size = %f/%f", viewOrigin.x, viewOrigin.y, endPoint.x, endPoint.y, self.bar_imgView.layer.position.x, self.bar_imgView.layer.position.y, width, height);
    
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    self.bar_imgView.frame = imageFrame;
    self.bar_imgView.layer.position = viewOrigin;
    
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationLinear;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = YES;
    //Setting Endpoint of the animation
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGPathAddLineToPoint(curvedPath, NULL, endPoint.x, endPoint.y);
    /*
     if (viewOrigin.y > endPoint.y) {
     CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
     } else {
     CGPathAddCurveToPoint(curvedPath, NULL, viewOrigin.x, endPoint.y, viewOrigin.x, endPoint.y, endPoint.x, endPoint.y);
     }
     */
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    [group setAnimations:[NSArray arrayWithObjects:pathAnimation, nil]];
    group.duration = 0.4f;
    group.delegate = self;
    [group setValue:self.bar_imgView forKey:@"imageViewBeingAnimated"];
    
    [self.bar_imgView.layer addAnimation:group forKey:@"savingAnimation"];
    self.bar_imgView.frame = CGRectMake(endOrigin.x, endOrigin.y, width, height);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self animate_shaking_bar];
}

- (void)shake_bar
{   
    if (self.bar_shake_status == BAR_SHAKE_STATUS_STOP) {
        self.bar_shake_status = BAR_SHAKE_STATUS_START;
        self.bar_shake_iteration = BAR_SHAKE_ITERATION;
    } else {
        self.bar_shake_status = BAR_SHAKE_STATUS_RESTART;
        return;
    }
    
    self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_LEFT;
    [self animate_shaking_bar];
}

- (void)shakeEventDetectedWithDuration:(float)duration
{
    if (self.current_petals.count <= 1) return;
    if (self.state == GAMESTATE_RESETING) return;
    
    self.state = GAMESTATE_SHAKING;
    self.petal_losts = [self getLostPetalsForDuration:duration];
    [self shakeRemainingPetalsWithLosts:self.petal_losts];
}

- (NSArray *)generateSomeNonRepeatedNumbers:(int)amount
                                    inRange:(int)uplimit
{
    if (amount > uplimit) return nil;
    
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int num;
    while ([uniqueNumbers count] < amount) {
        num = arc4random() % uplimit;
        if (![uniqueNumbers containsObject:[NSNumber numberWithInt:num]]) {
            [uniqueNumbers addObject:[NSNumber numberWithInt:num]];
        }
    }
    
    return [uniqueNumbers copy];
}

- (NSMutableArray *)shakeRemainingPetalsWithLosts:(int)losts
                                       targetPool:(NSArray *)pool
                                     keepsAtLeast:(int)low_bound
{
    int pool_cnt = pool.count;
    if (pool_cnt - losts < low_bound) losts = pool_cnt - low_bound;
    if (losts <= 0) return nil;
    
    NSArray *petal_drops = [self generateSomeNonRepeatedNumbers:losts inRange:pool_cnt];
    if (!petal_drops) return nil;
    
    int idx = 0;
    if (self.state == GAMESTATE_RESETING) return nil;
    NSLog(@"Now shaking...");
    
    /* Shake petals */
    NSMutableArray *petals_to_be_removed = [[NSMutableArray alloc] init];
    for (idx = 0; idx < pool_cnt; idx++)
    {
        Petal *petal = [pool objectAtIndex:idx];
        if ([petal_drops containsObject:[NSNumber numberWithInt:idx]]) {
            [petals_to_be_removed addObject:petal];
        }
    }
    
    /* Shake bar */
    [self shake_bar];
    return petals_to_be_removed;
    
    
}

- (void)shakeRemainingPetalsWithLosts:(int)losts
{
    int num_of_remaining = losts;
    NSMutableArray *removed_petals;
    if (self.unused_petals.count > 0) {
        /* Shake unused first */
        //[self.petalLock lock];
        removed_petals = [self shakeRemainingPetalsWithLosts:losts targetPool:self.unused_petals keepsAtLeast:0];
        if (removed_petals) {
            NSMutableArray *petalArr = [self.unused_petals mutableCopy];
            for (Petal *petal in removed_petals)
            {
                [petalArr removeObject:petal];
                [petal shake];
                
                /* add this petal to free pool */
                NSMutableArray *petalPool = [self.unused_discarded_petals mutableCopy];
                [petalPool addObject:petal];
                self.unused_discarded_petals = [petalPool copy];
            }
            
            self.unused_petals = [petalArr copy];
            num_of_remaining = losts - removed_petals.count;
            [removed_petals removeAllObjects];
        }
        
        
        //[self.petalLock unlock];
        
    }
    
    //[self.petalLock lock];
    removed_petals = [self shakeRemainingPetalsWithLosts:num_of_remaining
                                              targetPool:self.current_petals
                                            keepsAtLeast:1];
    if (removed_petals) {
        NSMutableArray *petalArr = [self.current_petals mutableCopy];
        for (Petal *petal in removed_petals)
        {
            [petalArr removeObject:petal];
            [petal shake];
            
            /* add this petal to free pool */
            NSMutableArray *petalPool = [self.discarded_petals mutableCopy];
            [petalPool addObject:petal];
            self.discarded_petals = [petalPool copy];
        }
        
        self.current_petals = [petalArr copy];
        [removed_petals removeAllObjects];
    }
    
    //[self.petalLock unlock];
    
    if (self.current_petals.count <= 1) {
        self.endOfGameTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                               target:self
                                                             selector:@selector(animateEndOfGame)
                                                             userInfo:nil
                                                              repeats:NO];
    }
}

- (void)animate_mask_with_image:(UIImage *)image
{
    [UIView animateWithDuration:0.5
                          delay:0.01
                        options:UIViewAnimationOptionCurveLinear
                     animations:^() {
                         self.mask_imgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.mask_imgView setImage:image];
                         [UIView animateWithDuration:0.5
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^() {
                                              self.mask_imgView.alpha = 1;
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

- (void)animateEndOfGame
{
    Petal *petal = [self.current_petals objectAtIndex:0];
    NSString *option = @"";
    CGFloat loc_board;
    
    self.result_view.alpha = 1;
    for (id key in self.theme.options)
    {
        PetalInfo *info = [self.theme.options objectForKey:key];
        if (info.pos == petal.pos) option = info.option;
    }
    
    self.result_title_label.text = self.theme.title;
    self.result_option_label.text = option;
    if (petal.pos == PETAL_DOWN || petal.pos == PETAL_DOWN_LEFT || petal.pos == PETAL_DOWN_RIGHT) {
        self.result_view.frame = CGRectMake(160 - 29, 155 - 15, 29 * 2, 15 * 2);
        loc_board = 80;
    } else {
        loc_board = 240;
        self.result_view.frame = CGRectMake(160 - 29, 315 - 15, 29 * 2, 15 * 2);
    }
    
    self.result_option_label.alpha = 0;
    self.result_title_label.alpha = 0;
    self.result_option_label.textColor = [petal get_petal_color];
    
    [UIView animateWithDuration:0.5f
                          delay:0.01f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^() {
                         self.result_view.frame = CGRectMake(15, loc_board, 290, 150);
                     }
                     completion:^(BOOL finished) {
                         
                         self.result_option_label.alpha = 1;
                         self.result_title_label.alpha = 1;
                         self.result_title_label.frame = CGRectMake(8, 7, 271, 47);
                         self.result_option_label.frame = CGRectMake(8, 56, 271, 82);
                         
                         [UIView animateWithDuration:1.0f
                                          animations:^() {
                                              self.result_view.frame = CGRectMake(15, loc_board, 290, 149);
                                          }
                                          completion:^(BOOL finished) {
                                              /* Delay for 1 sec to animate */
                                              [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_8", nil)]];
                                              self.homeBtn.enabled = YES;
                                          }];
                         
                     }];
    
    /* Stop the bar shaking*/
    self.bar_shake_status = BAR_SHAKE_STATUS_STOP;
}


@end
