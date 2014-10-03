//
//  FateGameViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 9/23/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import "FateGameViewController.h"
#import "ShakeView.h"
#import "Petal.h"
#import "Theme.h"
#import "PetalInfo.h"
#import "UICustomFont.h"
#import "UICustomColor.h"
#import "UIViewCustomAnimation.h"
#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SHK.h"
#import "SHKConfiguration.h"
#import "shareKitConfig.h"
#import "SHKFacebook.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#define GAME_URL @"https://itunes.apple.com/us/app/petal-decision-maker/id631865206?ls=1&mt=8"
@interface FateGameViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bar_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_right_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_right_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_down_left_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *petal_up_left_imgView;
@property (weak, nonatomic) IBOutlet UIView *result_view;
@property (weak, nonatomic) IBOutlet UILabel *result_title_label;
@property (weak, nonatomic) IBOutlet UILabel *result_option_label;
@property (weak, nonatomic) IBOutlet UIImageView *pistil_imgView;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *again_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIButton *home_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) ShakeView *shakeView;
@property (strong, atomic) NSArray *current_petals;
@property (strong, atomic) NSArray *discarded_petals;
@property (strong, atomic) NSArray *unused_petals;
@property (strong, atomic) NSArray *unused_discarded_petals;
@property (strong, nonatomic) AVAudioPlayer *sePlayer;
@property (atomic) BOOL played;
@property (atomic) int petal_losts;
@property (atomic) int petal_animation_finished;
@property (atomic) GameState state;
@property (strong, atomic) NSLock *petalLock;
@property (strong, nonatomic) NSTimer *endOfGameTimer;
@property (atomic) BarState barState;
@property (atomic) BarShakeStatus bar_shake_status;
@property (atomic) BarShakeState bar_shake_state;
@property (atomic) int bar_shake_iteration;

@property (strong, nonatomic) Theme *theme;

@end

@implementation FateGameViewController
@synthesize petal_down_imgView = _petal_down_imgView;
@synthesize petal_down_left_imgView = _petal_down_left_imgView;
@synthesize petal_down_right_imgView = _petal_down_right_imgView;
@synthesize petal_up_imgView = _petal_up_imgView;
@synthesize petal_up_left_imgView = _petal_up_left_imgView;
@synthesize petal_up_right_imgView = _petal_up_right_imgView;
@synthesize pistil_imgView = _pistil_imgView;
@synthesize shakeView = _shakeView;
@synthesize current_petals = _current_petals;
@synthesize discarded_petals = _discarded_petals;
@synthesize unused_petals = _unused_petals;
@synthesize unused_discarded_petals = _unused_discarded_petals;
@synthesize played = _played;
@synthesize petal_losts = _petal_losts;
@synthesize petal_animation_finished = _petal_animation_finished;
@synthesize state = _state;
@synthesize petalLock = _petalLock;
@synthesize endOfGameTimer = _endOfGameTimer;
@synthesize barState = _barState;
@synthesize theme = _theme;
@synthesize bar_imgView = _bar_imgView;
@synthesize result_option_label = _result_option_label;
@synthesize result_title_label = _result_title_label;
@synthesize result_view = _result_view;
@synthesize bar_shake_state = _bar_shake_state;
@synthesize bar_shake_status = _bar_shake_status;
@synthesize bar_shake_iteration = _bar_shake_iteration;
@synthesize delegate = _delegate;
@synthesize sePlayer = _sePlayer;

- (void)load_with_theme:(Theme *)theme
               delegate:(id)delegate
{
    self.theme = theme;
    self.delegate = delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (BOOL)is_iphone_5
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)rearrange_icons
{
    if (![self is_iphone_5]) {
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
    [self.again_btn setFrame:CGRectMake(141 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.home_btn  setFrame:CGRectMake(248 + adjust_x, 404 + adjust_y, 44, 60)];
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
    
    
    // 122/110/74/147 -- 160/254
    /*
    [self.petal_up_imgView removeFromSuperview];
    self.holder_up_view = [[UIView alloc] initWithFrame:CGRectMake(13, 107, 293, 293)];
    [self.holder_up_view addSubview:self.petal_up_imgView];
    [self.view addSubview:self.holder_up_view];
     */
    
    if (!self.theme || self.theme.count < 2) {
        [UIViewCustomAnimation showAlert:NSLocalizedString(@"error", nil)];
        [self backToMenu:nil];
        return;
    }
   
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
    
    self.petalLock = [[NSLock alloc] init];
    self.result_view.alpha = 0;
    
    self.result_title_label.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    self.result_option_label.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:48];
    //self.result_title_label.textColor = [UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE];
    self.result_title_label.textColor = [UIColor whiteColor];
    self.result_option_label.textColor = [UIColor whiteColor];
    
    self.barState = BARSTATE_MID_LEFT;
    self.bar_shake_status = BAR_SHAKE_STATUS_STOP;
    self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_LEFT;
    self.bar_shake_iteration = 0;
    
    NSLog(@"title=%@", self.theme.title);
    for (id key in self.theme.options)
    {
        PetalInfo *info = [self.theme.options objectForKey:key];
        NSLog(@"option=%@", info.option);
    }
    
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    bannerView_.adUnitID = @"a1514da16c9bbe3";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    GADRequest *request = [GADRequest request];
    //request.testing = YES; // test mode
    [bannerView_ loadRequest:request];
    
    
    if (![self is_iphone_5]) {
        bannerView_.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPetal_up_right_imgView:nil];
    [self setPetal_down_right_imgView:nil];
    [self setPetal_up_imgView:nil];
    [self setPetal_down_imgView:nil];
    [self setPetal_down_left_imgView:nil];
    [self setPetal_up_left_imgView:nil];
    [self.shakeView resignFirstResponder];
    [self setPistil_imgView:nil];
    [self setResult_view:nil];
    [self setResult_title_label:nil];
    [self setResult_option_label:nil];
    [self setBar_imgView:nil];
    [self setBack_btn:nil];
    [self setEdit_btn:nil];
    [self setAgain_btn:nil];
    [self setShare_btn:nil];
    [self setHome_btn:nil];
    [self setSePlayer:nil];
    [self setBg_image_view:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GameToSetSeg"]) {
        [segue.destinationViewController load_with_idx:2 delegate:self.delegate];
    }
}

/* IBOutlet */
- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;
    
    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (IBAction)backToMenu:(UIButton *)sender
{
    [self play_click_sound];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)homeBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    UIViewController *vc = self.presentingViewController;
    vc = vc.presentingViewController;
    [vc dismissModalViewControllerAnimated:YES];

}

- (IBAction)restartPressed:(UIButton *)sender
{
    NSLog(@"restarting...");
    [self play_click_sound];
    if (![self is_iphone_5]) {
        bannerView_.alpha = 0;
    }
    
    //[self.petalLock lock];
    self.state = GAMESTATE_RESETING;
    
    /* Involved Petals */
    NSMutableArray *petals_in_discard = [self.discarded_petals mutableCopy];
    NSMutableArray *petals_remains = [self.current_petals mutableCopy];
    
    for (Petal *petal in petals_in_discard)
    {
        [petals_remains addObject:petal];
    }
    
    [petals_in_discard removeAllObjects];
    
    for (Petal *petal in petals_remains)
    {
        [petal reset];
    }
    
    self.current_petals = [petals_remains copy];
    self.discarded_petals = [petals_in_discard copy];
    
    /* Not Involved Petals */
    NSMutableArray *u_petals_in_discard = [self.unused_discarded_petals mutableCopy];
    NSMutableArray *u_petals_remains = [self.unused_petals mutableCopy];
    
    for (Petal *petal in u_petals_in_discard)
    {
        [u_petals_remains addObject:petal];
    }
    
    [u_petals_in_discard removeAllObjects];
    
    for (Petal *petal in u_petals_remains)
    {
        [petal reset];
    }
    
    self.unused_discarded_petals = [u_petals_in_discard copy];
    self.unused_petals = [u_petals_remains copy];
    
    self.state = GAMESTATE_IDLE;
    self.result_view.alpha = 0;
    [self.endOfGameTimer invalidate];
    //[self.petalLock unlock];
}

- (IBAction)editBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    [self performSegueWithIdentifier:@"GameToSetSeg" sender:sender];
}

- (IBAction)sharedBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    NSURL *url = [NSURL URLWithString:GAME_URL];
    SHKItem *item = [SHKItem URL:url title:@"Petal decision maker just helped me out! Come on and try it!" contentType:SHKURLContentTypeWebpage];
    
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    [SHK setRootViewController:self];
    [actionSheet showInView:self.view];
}

/* Protocol */
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
    NSLog(@"Shake bar %d", self.bar_shake_status);
    
    if (self.bar_shake_status == BAR_SHAKE_STATUS_STOP) {
        self.bar_shake_status = BAR_SHAKE_STATUS_START;
        self.bar_shake_iteration = BAR_SHAKE_ITERATION;
    } else {
        self.bar_shake_status = BAR_SHAKE_STATUS_RESTART;
        return;
    }
    /*
    self.barState = [self nextStateForState:self.barState];
    [UIView animateWithDuration:0.05
                          delay:0.01
                        options:UIViewAnimationOptionCurveLinear
                     animations:^() {
                         self.bar_imgView.frame = [self frameForState:self.barState];
                         //self.bar_imgView.frame = CGRectInset(self.bar_imgView.frame, 1, 1);
                         self.bar_imgView.image = [self imageForBarState:self.barState];
                     }
                     completion:^(BOOL finished) {
                         //self.bar_imgView.frame = CGRectInset(self.bar_imgView.frame, -1, -1);
                         if (self.barState == BARSTATE_MID_LEFT) {
                             [self shakeBarIteration:iteration - 1];
                         } else {
                             [self shakeBarIteration:iteration];
                         }
                     }];
     */
    self.bar_shake_state = BAR_SHAKE_STATE_BTM_TO_LEFT;
    [self animate_shaking_bar];
}

- (void)shakeEventDetectedWithDuration:(float)duration
{
    NSLog(@"shaked!!");
    if (self.current_petals.count <= 1) return;
    if (self.state == GAMESTATE_RESETING) return;
    
    self.state = GAMESTATE_SHAKING;
    self.petal_losts = [self getLostPetalsForDuration:duration];
    
    /* Check if instant result is turned on */
    BOOL instant_result_is_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"instant_result"];
    if (instant_result_is_on) {
        self.petal_losts = 5;
    }
    
    [self shakeRemainingPetalsWithLosts:self.petal_losts];
}

- (NSArray *)generateSomeNonRepeatedNumbers:(int)amount
                                    inRange:(int)uplimit
{
    //NSLog(@"Generate number %d/%d", amount, uplimit);
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
    //NSLog(@"Now shaking...");
    
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

/* increate the counter for alert */
- (void)increase_rate_us_alert
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL user_has_rated = [defaults boolForKey:@"user_has_rated"];
    if (user_has_rated) return;
    
    int play_attempt = [defaults integerForKey:@"play_attempt"];
    [defaults setInteger:play_attempt+1 forKey:@"play_attempt"];
    [defaults synchronize];
}

- (void)shrink_option_label
{
    UIFont *font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:40];
    CGSize constraint_size_unlimited = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGSize one_line_size = [[NSString stringWithFormat:@"ABCDEFGHIJ"] sizeWithFont:font
                                                                 constrainedToSize:constraint_size_unlimited
                                                                     lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize constraint_size = CGSizeMake(one_line_size.width, CGFLOAT_MAX);
    CGSize label_size = [self.result_option_label.text sizeWithFont:font
                                                  constrainedToSize:constraint_size
                                                      lineBreakMode:UILineBreakModeWordWrap];
    CGSize one_char_size = [[NSString stringWithFormat:@"O"] sizeWithFont:font
                                                        constrainedToSize:constraint_size
                                                            lineBreakMode:UILineBreakModeWordWrap];
    if (label_size.height > one_char_size.height) {
        [self.result_option_label setFont:[UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:27]];
    }
    
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
        if (![self is_iphone_5]) {
            bannerView_.frame = CGRectMake(0, 380 - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height);
        }
    } else {
        loc_board = 240;
        self.result_view.frame = CGRectMake(160 - 29, 315 - 15, 29 * 2, 15 * 2);
    }
    
    self.result_option_label.alpha = 0;
    self.result_title_label.alpha = 0;
    self.result_option_label.textColor = [petal get_petal_color];
    [self shrink_option_label];
    
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
                         if (loc_board < 100) {
                             /* Displayed on btm */ 
                             bannerView_.alpha = 1;
                         }
                     }];
    
    /* Stop the bar shaking*/
    self.bar_shake_status = BAR_SHAKE_STATUS_STOP;

    [self increase_rate_us_alert];
}

@end
