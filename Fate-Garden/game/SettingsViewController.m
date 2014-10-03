//
//  SettingsViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 3/23/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "SettingsViewController.h"
#import "TutorialGameViewController.h"
#import "UIViewCustomAnimation.h"
#import "UICustomFont.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#define GAME_URL @"https://itunes.apple.com/us/app/petal-decision-maker/id631865206?ls=1&mt=8"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *tutorial_btn;
@property (weak, nonatomic) IBOutlet UIButton *rate_us_btn;
@property (weak, nonatomic) IBOutlet UISwitch *switch_music;
@property (weak, nonatomic) IBOutlet UISwitch *switch_instant_result;
@property (weak, nonatomic) IBOutlet UILabel *label_music;
@property (weak, nonatomic) IBOutlet UILabel *label_instant_result;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@property (weak, nonatomic) IBOutlet UIImageView *bar_image_view;
@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) AVAudioPlayer *sePlayer;
@property (nonatomic) int idx;
@end

@implementation SettingsViewController
@synthesize back_btn = _back_btn;
@synthesize tutorial_btn = _tutorial_btn;
@synthesize delegate = _delegate;
@synthesize sePlayer = _sePlayer;

@synthesize idx = _idx;

- (void)load_with_idx:(int)idx delegate:(id)delegate
{
    self.idx = idx;
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

- (void)rearrange_icons
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return;
    }
    
    [self.bg_image_view setImage:[UIImage imageNamed:@"game_bg_ip5.png"]];
    [self.bar_image_view setFrame:CGRectMake(50, 0, 220, 102)];
    float adjust_x = 0.0f;
    float adjust_y = 44.0f;
    
    [self.back_btn  setFrame:CGRectMake( 30 + adjust_x, 404 + adjust_y, 44, 60)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self rearrange_icons];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL instant_result_is_on = [defaults boolForKey:@"instant_result"];
    BOOL music_is_off = [defaults boolForKey:@"music_is_off"];
    
    [self.switch_instant_result setOn:instant_result_is_on];
    [self.switch_music setOn:!music_is_off];
    
    self.label_music.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    self.label_music.text = NSLocalizedString(@"sound", nil);
    self.label_instant_result.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    self.label_instant_result.text = NSLocalizedString(@"instant_result", nil);
    self.tutorial_btn.titleLabel.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    [self.tutorial_btn setTitle:NSLocalizedString(@"tutorial", nil) forState:UIControlStateNormal];
    self.rate_us_btn.titleLabel.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:22];
    [self.rate_us_btn setTitle:NSLocalizedString(@"rate", nil) forState:UIControlStateNormal];
    
    [defaults setBool:YES forKey:@"user_has_been_reminded"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBack_btn:nil];
    [self setTutorial_btn:nil];
    [self setSePlayer:nil];
    [self setSwitch_music:nil];
    [self setSwitch_instant_result:nil];
    [self setLabel_music:nil];
    [self setLabel_instant_result:nil];
    [self setRate_us_btn:nil];
    [self setBg_image_view:nil];
    [self setBar_image_view:nil];
    [super viewDidUnload];
}

/* Seg */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SetToTutSeg"]) {
        [segue.destinationViewController loadWithIdx:self.idx+1];
    }
}

/* IBOutlet */
- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;

    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (IBAction)tutorial_btn_pressed:(UIButton *)sender
{
    [self play_click_sound];
    
    /* Generate an alert */
    UIAlertView *alertView;
    
    alertView = [[UIAlertView alloc] initWithTitle:@""
                                               message:NSLocalizedString(@"tutorial_alert", nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"tutorial_alert_no", nil)
                                     otherButtonTitles:NSLocalizedString(@"tutorial_alert_yes", nil), nil];
    [alertView show];
}

- (IBAction)back_btn_pressed:(UIButton *)sender
{
    [self play_click_sound];
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)rate_us_btn_pressed:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"user_has_rated"];
    [defaults synchronize];
    
    NSString *urlString = GAME_URL;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)switch_music_toggled:(UISwitch *)sender
{
    [self play_click_sound];
    
    BOOL music_is_off = ![self.switch_music isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:music_is_off forKey:@"music_is_off"];
    [defaults synchronize];
    
    [self.delegate turn_on_music:!music_is_off];
}

- (IBAction)switch_instant_result_toggled:(UISwitch *)sender
{
    [self play_click_sound];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"played_instant_result_msg"]) {
        /* Generate an alert */
        UIAlertView *alertView;
        
        alertView = [[UIAlertView alloc] initWithTitle:@""
                                               message:NSLocalizedString(@"instant_result_settings_alert", nil)
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [alertView show];
        
        [defaults setBool:YES forKey:@"played_instant_result_msg"];
    }
    
    [defaults setBool:[self.switch_instant_result isOn] forKey:@"instant_result"];
    [defaults synchronize];
}

/* Protocol */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:NSLocalizedString(@"tutorial_alert_yes", nil)]) {
        [self performSegueWithIdentifier:@"SetToTutSeg" sender:nil];
    }
}

@end
