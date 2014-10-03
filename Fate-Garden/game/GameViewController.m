//
//  GameViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 8/2/12.
//  Copyright (c) 2012 Rui Du. All rights reserved.
//

#import "GameViewController.h"
#import "UIViewCustomAnimation.h"
#import "OptionViewController.h"
#import "SettingsViewController.h"
#import "TutorialGameViewController.h"
#import "Theme.h"
#import "PetalInfo.h"
#import "SHK.h"
#import "SHKConfiguration.h"
#import "shareKitConfig.h"
#import "SHKFacebook.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#define WELCOME_DURATION 3
#define GAME_URL @"https://itunes.apple.com/us/app/petal-decision-maker/id631865206?ls=1&mt=8"

@interface GameViewController ()

@property (strong, nonatomic) UIImageView *welcomeView;
@property (strong, nonatomic) NSArray *btnArray;
@property (weak, nonatomic) IBOutlet UIButton *flowerBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *flowerBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *flowerBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *flowerBtn_5;
@property (weak, nonatomic) IBOutlet UIButton *flowerBtn_6;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;

@property (strong, nonatomic) PetalInfo *petalInfo_up;
@property (strong, nonatomic) PetalInfo *petalInfo_up_left;
@property (strong, nonatomic) PetalInfo *petalInfo_up_right;
@property (strong, nonatomic) PetalInfo *petalInfo_down;
@property (strong, nonatomic) PetalInfo *petalInfo_down_left;
@property (strong, nonatomic) PetalInfo *petalInfo_down_right;
@property (strong, nonatomic) AVAudioPlayer *sePlayer;

@property (nonatomic) int numberOfPetals;
@property (nonatomic) BOOL is_first_time_launch;

@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation GameViewController
@synthesize welcomeView = _welcomeView;
@synthesize flowerBtn_2 = _flowerBtn_2;
@synthesize flowerBtn_3 = _flowerBtn_3;
@synthesize flowerBtn_4 = _flowerBtn_4;
@synthesize flowerBtn_5 = _flowerBtn_5;
@synthesize flowerBtn_6 = _flowerBtn_6;
@synthesize btnArray = _btnArray;
@synthesize numberOfPetals = _numberOfPetals;
@synthesize petalInfo_up = _petalInfo_up;
@synthesize petalInfo_down = _petalInfo_down;
@synthesize petalInfo_up_left = _petalInfo_up_left;
@synthesize petalInfo_down_left = _petalInfo_down_left;
@synthesize petalInfo_down_right = _petalInfo_down_right;
@synthesize petalInfo_up_right = _petalInfo_up_right;
@synthesize sePlayer = _sePlayer;
@synthesize is_first_time_launch = _is_first_time_launch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDictionary *)generate_petalInfo
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                [self.petalInfo_up_left copy],
                                                [self.petalInfo_down_right copy],
                                                [self.petalInfo_up copy],
                                                [self.petalInfo_down_left copy],
                                                [self.petalInfo_up_right copy],
                                                [self.petalInfo_down copy], nil]
                                       forKeys:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:@"%d", PETAL_UP_LEFT],
                                                [NSString stringWithFormat:@"%d", PETAL_DOWN_RIGHT],
                                                [NSString stringWithFormat:@"%d", PETAL_UP],
                                                [NSString stringWithFormat:@"%d", PETAL_DOWN_LEFT],
                                                [NSString stringWithFormat:@"%d", PETAL_UP_RIGHT],
                                                [NSString stringWithFormat:@"%d", PETAL_DOWN],nil]];
}

- (NSArray *)initializeThemes_2
{
    self.petalInfo_up_left.option = NSLocalizedString(@"dflt_theme_1_option_1", nil);
    self.petalInfo_down_right.option = NSLocalizedString(@"dflt_theme_1_option_2", nil);
    NSDictionary *options = [self generate_petalInfo];
    Theme *theme2 = [[Theme alloc] initWithTitle:NSLocalizedString(@"dflt_theme_1_title", nil) options:[options copy] count:2];
    
    self.petalInfo_up_left.option = NSLocalizedString(@"dflt_theme_2_option_1", nil);
    self.petalInfo_down_right.option = NSLocalizedString(@"dflt_theme_2_option_2", nil);
    self.petalInfo_up.option = NSLocalizedString(@"dflt_theme_2_option_3", nil);
    options = [self generate_petalInfo];
    Theme *theme3 = [[Theme alloc] initWithTitle:NSLocalizedString(@"dflt_theme_2_title", nil) options:[options copy] count:3];
    
    self.petalInfo_up_left.option = @"1";
    self.petalInfo_down_right.option = @"2";
    self.petalInfo_up.option = @"3";
    self.petalInfo_down_left.option = @"4";
    self.petalInfo_up_right.option = @"5";
    self.petalInfo_down.option = @"6";
    options = [self generate_petalInfo];
    Theme *theme4 = [[Theme alloc] initWithTitle:NSLocalizedString(@"dflt_theme_3_title", nil) options:[options copy] count:6];
    

    
    NSArray *themesArray = [NSArray arrayWithObjects:theme2, theme3, theme4, nil];
    return [themesArray copy];
}

- (void)initializeThemes
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    if (!data) {
        NSArray *saved_themes_2 = [self initializeThemes_2];        
        NSArray *saved_themes_3 = [[NSArray alloc] init];
        NSArray *saved_themes_4 = [[NSArray alloc] init];
        NSArray *saved_themes_5 = [[NSArray alloc] init];
        NSArray *saved_themes_6 = [[NSArray alloc] init];
        
        NSArray *themes_array = [NSArray arrayWithObjects:saved_themes_2, saved_themes_3, saved_themes_4, saved_themes_5, saved_themes_6, nil];
        NSArray *themes_keys = [NSArray arrayWithObjects:@"2", @"3", @"4", @"5", @"6", nil];
        NSDictionary *saved_themes = [NSDictionary dictionaryWithObjects:themes_array
                                                                 forKeys:themes_keys];
        
        NSData *themes_data = [NSKeyedArchiver archivedDataWithRootObject:saved_themes];
        [defaults setObject:themes_data forKey:@"themes"];
        [defaults synchronize];
                
        self.petalInfo_up.option = @"";
        self.petalInfo_up_left.option = @"";
        self.petalInfo_up_right.option = @"";
        self.petalInfo_down.option = @"";
        self.petalInfo_down_left.option = @"";
        self.petalInfo_down_right.option = @"";
    }
}

- (void)first_time_launch
{   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"not_first_time_launch"]) {
        return;
    }
    
    /* First time run initialization */
    [defaults setBool:YES forKey:@"not_first_time_launch"];
    [defaults setInteger:0 forKey:@"play_attempt"];
    [defaults setBool:NO forKey:@"user_has_rated"];
    [defaults setBool:NO forKey:@"user_has_been_reminded"];
    CGRect screen_bound = [[UIScreen mainScreen] bounds];
    BOOL is_ip5 = (screen_bound.size.height > 480);
    [defaults setBool:is_ip5 forKey:@"is_iphone_5"];
    [defaults synchronize];
    
    self.is_first_time_launch = YES;
}

- (void)rearrange_icons
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return;
    }
    
    [self.bg_image_view setImage:[UIImage imageNamed:@"main_bg_ip5.png"]];
    float adjust_x = 0.0f;
    float adjust_y = 44.0f;
    [self.flowerBtn_2 setFrame:CGRectMake(116 + adjust_x, 218 + adjust_y, 76, 60)];
    [self.flowerBtn_3 setFrame:CGRectMake( 45 + adjust_x, 148 + adjust_y, 75, 68)];
    [self.flowerBtn_4 setFrame:CGRectMake(203 + adjust_x, 283 + adjust_y, 82, 80)];
    [self.flowerBtn_5 setFrame:CGRectMake(207 + adjust_x, 117 + adjust_y, 74, 75)];
    [self.flowerBtn_6 setFrame:CGRectMake( 37 + adjust_x, 277 + adjust_y, 78, 74)];
    
    [self.edit_btn  setFrame:CGRectMake( 85 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.is_first_time_launch = NO;
    [self first_time_launch];
    [self launch_background_music];
    [self rearrange_icons];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [UIViewCustomAnimation heartbeatAnimationForView:self.flowerBtn_2
                                            duration:1
                                              repeat:0];
    [UIViewCustomAnimation heartbeatAnimationForView:self.flowerBtn_3
                                            duration:1
                                              repeat:0];
    [UIViewCustomAnimation heartbeatAnimationForView:self.flowerBtn_4
                                            duration:1
                                              repeat:0];
    [UIViewCustomAnimation heartbeatAnimationForView:self.flowerBtn_5
                                            duration:1
                                              repeat:0];
    [UIViewCustomAnimation heartbeatAnimationForView:self.flowerBtn_6
                                            duration:1
                                              repeat:0];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [mutableArray addObject:self.flowerBtn_2];
    [mutableArray addObject:self.flowerBtn_3];
    [mutableArray addObject:self.flowerBtn_4];
    [mutableArray addObject:self.flowerBtn_5];
    [mutableArray addObject:self.flowerBtn_6];
    self.btnArray = [mutableArray copy];
    self.numberOfPetals = 6;
    
    self.petalInfo_up = [[PetalInfo alloc] initWithPos:PETAL_UP
                                            desc_image:[UIImage imageNamed:@"petal_color_yellow"]
                                            desc_color:NSLocalizedString(@"option_dflt_option_color_yellow", nil)
                                                option:@""];
    self.petalInfo_up_left = [[PetalInfo alloc] initWithPos:PETAL_UP_LEFT
                                                 desc_image:[UIImage imageNamed:@"petal_color_blue"]
                                                 desc_color:NSLocalizedString(@"option_dflt_option_color_blue", nil)
                                                     option:@""];
    self.petalInfo_up_right = [[PetalInfo alloc] initWithPos:PETAL_UP_RIGHT
                                                  desc_image:[UIImage imageNamed:@"petal_color_red"]
                                                  desc_color:NSLocalizedString(@"option_dflt_option_color_red", nil)
                                                      option:@""];
    self.petalInfo_down = [[PetalInfo alloc] initWithPos:PETAL_DOWN
                                              desc_image:[UIImage imageNamed:@"petal_color_orange"]
                                              desc_color:NSLocalizedString(@"option_dflt_option_color_orange", nil)
                                                  option:@""];
    self.petalInfo_down_left = [[PetalInfo alloc] initWithPos:PETAL_DOWN_LEFT
                                                   desc_image:[UIImage imageNamed:@"petal_color_pink"]
                                                   desc_color:NSLocalizedString(@"option_dflt_option_color_pink", nil)
                                                       option:@""];
    self.petalInfo_down_right = [[PetalInfo alloc] initWithPos:PETAL_DOWN_RIGHT
                                                    desc_image:[UIImage imageNamed:@"petal_color_purple"]
                                                    desc_color:NSLocalizedString(@"option_dflt_option_color_purple", nil)
                                                        option:@""];
    [self initializeThemes];
    
    NSLog(@"language=%@", NSLocalizedString(@"TEST", nil));
}

- (void)appear
{
    self.welcomeView.frame = self.view.frame;
    self.welcomeView.alpha = 0;
    //[UIView animateWithDuration:WELCOME_DURATION animations:^{ self.welcomeView.alpha = 0; }];
}

- (void)launch_background_music
{
    int music_idx = arc4random() % 3 + 1;
    NSString *music_str = [NSString stringWithFormat:@"bg_%d", music_idx];
    NSError *error;
    
    [self setPlayer:nil];
    NSString *bg_path = [[NSBundle mainBundle] pathForResource:music_str ofType:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bg_path] error:&error];
    [self.player prepareToPlay];

    self.player.numberOfLoops = 2;
    self.player.delegate = self;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) {
        [self.player play];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self appear];
    
    self.petalInfo_up.option = @"";
    self.petalInfo_up_left.option = @"";
    self.petalInfo_up_right.option = @"";
    self.petalInfo_down.option = @"";
    self.petalInfo_down_left.option = @"";
    self.petalInfo_down_right.option = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.is_first_time_launch) {
        [self performSegueWithIdentifier:@"MenuToTutSeg" sender:nil];
        self.is_first_time_launch = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.player stop];
    //[self setPlayer:nil];
}

- (void)viewDidUnload
{
    [self setFlowerBtn_2:nil];
    [self setFlowerBtn_3:nil];
    [self setFlowerBtn_4:nil];
    [self setFlowerBtn_5:nil];
    [self setFlowerBtn_6:nil];
    [self setEdit_btn:nil];
    [self setShare_btn:nil];
    [self setSePlayer:nil];
    [self setBg_image_view:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"optionSeg"]) {
        NSDictionary *infos = [self generate_petalInfo];
        [segue.destinationViewController load_with_numberOfPetals:self.numberOfPetals petalInfos:infos delegate:self];
    } else if ([segue.identifier isEqualToString:@"MenuToSetSeg"]) {
        [segue.destinationViewController load_with_idx:0 delegate:self];
    } else if ([segue.identifier isEqualToString:@"MenuToTutSeg"]) {
        [segue.destinationViewController loadWithIdx:0];
    }
}

/* IBOutlet */
- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;
    
    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (IBAction)flowerBtnPressed:(UIButton *)sender
{
    int i = 0;
    for (UIButton *btn in self.btnArray)
    {
        if (btn == sender) {
            self.numberOfPetals = i + 2;
            break;
        }
        
        i++;
    }
    
    [self performSegueWithIdentifier:@"optionSeg" sender:sender];
}

- (IBAction)editBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    [self performSegueWithIdentifier:@"MenuToSetSeg" sender:sender];
}

- (IBAction)shareBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    //DefaultSHKConfigurator *configurator =  [[shareKitConfig alloc] init];
    //[SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    //DefaultSHKConfigurator * configurator = [[shareKitConfig alloc] init];
    //[SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    NSURL *url = [NSURL URLWithString:GAME_URL];
    SHKItem *item = [SHKItem URL:url title:@"Petal decision maker just helped me out! Come on and try it!" contentType:SHKURLContentTypeWebpage];
    //item.text = [NSString stringWithFormat:@"Petal decision maker just helped me out! Come on and try it!   "];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    [SHK setRootViewController:self];
    [actionSheet showInView:self.view];
}

/* Protocols */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self launch_background_music];
}


- (void)turn_on_music:(BOOL)on
{
    if (on) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

@end
