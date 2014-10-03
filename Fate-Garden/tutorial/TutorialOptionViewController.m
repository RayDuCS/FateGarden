//
//  TutorialOptionViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 3/9/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "TutorialOptionViewController.h"
#import "TutorialFateGameViewController.h"
#import "Theme.h"
#import "PetalInfo.h"
#import "UICustomFont.h"
#import "UICustomColor.h"
#import "UIViewCustomAnimation.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef enum
{
    TUTORIAL_OPTION_STATE_START = 1,
    TUTORIAL_OPTION_STATE_PICK_THEME = 2,
    TUTORIAL_OPTION_STATE_ADD_OPTION = 3,
    TUTORIAL_OPTION_STATE_EDIT_OPTION = 4,
    TUTORIAL_OPTION_STATE_DONE = 5
}TutorialOptionState;

@interface TutorialOptionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mask_imgView;
@property (weak, nonatomic) IBOutlet UITableView *opt_tableView;
@property (weak, nonatomic) IBOutlet UIButton *start_btn;
@property (weak, nonatomic) IBOutlet UIButton *go_btn;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@property (weak, nonatomic) IBOutlet UIImageView *bar_image_view;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;

@property (strong, nonatomic) PetalInfo *petalInfo_up;
@property (strong, nonatomic) PetalInfo *petalInfo_up_left;
@property (strong, nonatomic) PetalInfo *petalInfo_up_right;
@property (strong, nonatomic) PetalInfo *petalInfo_down;
@property (strong, nonatomic) PetalInfo *petalInfo_down_left;
@property (strong, nonatomic) PetalInfo *petalInfo_down_right;
@property (strong, nonatomic) PetalInfo *sample_petalInfo_up_left;
@property (strong, nonatomic) PetalInfo *sample_petalInfo_down_right;
@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) Theme *sample_theme;
@property (nonatomic) int idx;
@property (nonatomic) int numberOfPetals;
@property (nonatomic) TutorialOptionState state;

@property (strong, nonatomic) AVAudioPlayer *sePlayer;
@end

@implementation TutorialOptionViewController
@synthesize mask_imgView = _mask_imgView;
@synthesize opt_tableView = _opt_tableView;
@synthesize start_btn = _start_btn;
@synthesize petalInfo_up = _petalInfo_up;
@synthesize petalInfo_down = _petalInfo_down;
@synthesize petalInfo_up_left = _petalInfo_up_left;
@synthesize petalInfo_down_left = _petalInfo_down_left;
@synthesize petalInfo_down_right = _petalInfo_down_right;
@synthesize petalInfo_up_right = _petalInfo_up_right;
@synthesize sample_petalInfo_up_left = _sample_petalInfo_up_left;
@synthesize sample_petalInfo_down_right = _sample_petalInfo_down_right;
@synthesize theme = _theme;
@synthesize idx = _idx;
@synthesize numberOfPetals = _numberOfPetals;
@synthesize sample_theme = _sample_theme;
@synthesize sePlayer = _sePlayer;

- (void)setOpt_tableView:(UITableView *)opt_tableView
{
    _opt_tableView = opt_tableView;
    self.opt_tableView.delegate = self;
    self.opt_tableView.dataSource = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadWithIdx:(int)idx
{
    self.idx = idx;
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
    float adjust_x = 0.0f;
    float adjust_y = 44.0f;
    
    [self.opt_tableView setFrame:CGRectMake(19, 128, 283, 310)];
    [self.bar_image_view setFrame:CGRectMake(50, 0, 220, 102)];
    
    [self.back_btn  setFrame:CGRectMake( 30 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.edit_btn  setFrame:CGRectMake( 85 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.go_btn    setFrame:CGRectMake(248 + adjust_x, 404 + adjust_y, 44, 60)];
    
    [self.mask_imgView setImage:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_2", nil)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self rearrange_icons];
    self.opt_tableView.backgroundColor = [UIColor clearColor];
    self.opt_tableView.backgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unknown.png"]];
    self.opt_tableView.backgroundColor = [UIColor clearColor];
    self.opt_tableView.separatorColor  = [UIColor clearColor];
    [self.opt_tableView setShowsVerticalScrollIndicator:NO];
    
    self.start_btn.titleLabel.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:20];
    self.start_btn.titleLabel.textColor = [UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE];
    [self.start_btn setTitleColor:[UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE] forState:UIControlStateNormal];
    
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
    NSDictionary *options = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                 self.petalInfo_up_left,
                                                                 self.petalInfo_down_right,
                                                                 self.petalInfo_up,
                                                                 self.petalInfo_down_left,
                                                                 self.petalInfo_up_right,
                                                                 self.petalInfo_down, nil]
                                                        forKeys:[NSArray arrayWithObjects:
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP_LEFT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN_RIGHT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN_LEFT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP_RIGHT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN],nil]];
    
    self.theme = [[Theme alloc] initWithTitle:@"" options:options count:2];
    
    
    self.sample_petalInfo_up_left = [[PetalInfo alloc] initWithPos:PETAL_UP_LEFT
                                                   desc_image:[UIImage imageNamed:@"petal_color_blue"]
                                                   desc_color:NSLocalizedString(@"option_dflt_option_color_blue", nil)
                                                       option:@""];
    self.sample_petalInfo_down_right = [[PetalInfo alloc] initWithPos:PETAL_DOWN_RIGHT
                                                    desc_image:[UIImage imageNamed:@"petal_color_purple"]
                                                    desc_color:NSLocalizedString(@"option_dflt_option_color_purple", nil)
                                                        option:@""];
    self.sample_petalInfo_up_left.option = NSLocalizedString(@"dflt_theme_tutorial_option_1", nil);
    self.sample_petalInfo_down_right.option = NSLocalizedString(@"dflt_theme_tutorial_option_2", nil);
    NSDictionary *sample_options = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                 self.sample_petalInfo_up_left,
                                                                 self.sample_petalInfo_down_right,
                                                                 self.petalInfo_up,
                                                                 self.petalInfo_down_left,
                                                                 self.petalInfo_up_right,
                                                                 self.petalInfo_down, nil]
                                                        forKeys:[NSArray arrayWithObjects:
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP_LEFT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN_RIGHT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN_LEFT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_UP_RIGHT],
                                                                 [NSString stringWithFormat:@"%d", PETAL_DOWN],nil]];
    
    
    self.sample_theme = [[Theme alloc] initWithTitle:NSLocalizedString(@"dflt_theme_tutorial_title", nil) options:sample_options count:2];
    
    self.start_btn.enabled = NO;
    self.state = TUTORIAL_OPTION_STATE_START;
    [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_2", nil)]];
    self.numberOfPetals = 2;
    [self.opt_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMask_imgView:nil];
    [self setOpt_tableView:nil];
    [self setStart_btn:nil];
    [self setSePlayer:nil];
    [self setBg_image_view:nil];
    [self setGo_btn:nil];
    [self setEdit_btn:nil];
    [self setShare_btn:nil];
    [self setBar_image_view:nil];
    [self setBack_btn:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TutOptToGameSeg"])
    {
        [segue.destinationViewController loadWithTheme:self.theme
                                                   idx:self.idx+1];
    }
}

- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;
    
    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (IBAction)startBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    [self performSegueWithIdentifier:@"TutOptToGameSeg" sender:sender];
}

/* Protocol Implementations */
/* Protocol UITextField */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self play_click_sound];
    
    int row = textField.tag - 10;
    if (row == 0) {
        /* title */
        if (!self.theme.title || [self.theme.title isEqualToString:@""])
            textField.text = @"";
    }
    else if (row <= self.numberOfPetals) {
        /* Petal options */
        PetalInfo *info = [self.theme.options objectForKey:[NSString stringWithFormat:@"%d", row]];
        if (!info.option || [info.option isEqualToString:@""])  textField.text = @"";
    }
    
    [self.view setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{   
    int row = textField.tag - 10;
    if (row == 0) {
        /* title */
        if (textField.text && ![textField.text isEqualToString:@""])
            self.theme.title = textField.text;
        else {
            self.theme.title = @"";
            textField.text = NSLocalizedString(@"option_dflt_title", nil);
        }
    }
    else if (row <= self.numberOfPetals) {
        /* Petal options */
        PetalInfo *info = [self.theme.options objectForKey:[NSString stringWithFormat:@"%d", row]];
        if (textField.text && ![textField.text isEqualToString:@""])
        {
            info.option = textField.text;
        } else {
            info.option = @"";
            
            textField.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"option_dflt_option_prefix", nil), info.desc_color, NSLocalizedString(@"option_dflt_option_postfix", nil)];
        }
    }
    
    [self.view setNeedsDisplay];
    [self next_state];
    textField.enabled = NO;
}

/* Protocol UITableView */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfPetals + 1 + 1 + 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIImage *)imageForRow:(int)row
{
    if (row == 0 || row == self.numberOfPetals + 1) return [UIImage imageNamed:@"unknown.png"];
    
    if (row <= self.numberOfPetals) {
        PetalInfo *info = [self.theme.options objectForKey:[NSString stringWithFormat:@"%d", row]];
        return info.desc_image;
    }
    
    return [UIImage imageNamed:@"flower_2_small.png"];
}

- (NSString *)textForRow:(int)row
{
    if (row == self.numberOfPetals + 1) return @"";
    
    if (row == 0) {
        /* Handling the title */
        if (self.theme.title && ![self.theme.title isEqualToString:@""]) {
            return self.theme.title;
        } else {
            return NSLocalizedString(@"option_dflt_title", nil);
        }
    }
    
    if (row <= self.numberOfPetals) {
        /* Handling the options */
        PetalInfo *info = [self.theme.options objectForKey:[NSString stringWithFormat:@"%d", row]];
        if (info.option && ![info.option isEqualToString:@""]) {
            return info.option;
        } else {
            return [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"option_dflt_option_prefix", nil), info.desc_color, NSLocalizedString(@"option_dflt_option_postfix", nil)];
        }
    }
    
    int theme_idx = row - self.numberOfPetals - 2;
    if (theme_idx > 0) return @"Empty";
    return self.sample_theme.title;
}


- (IBAction)addCellPressed:(id)sender
{
    if (self.state != TUTORIAL_OPTION_STATE_ADD_OPTION) return;
 
    [self play_click_sound];
    [self next_state];
    self.numberOfPetals++;
    
    [self.opt_tableView reloadData];
    [self.opt_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.numberOfPetals inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"barCell";
    
    if (indexPath.row == self.numberOfPetals + 1)
    {
        CellIdentifier = @"ropeCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unknown.png"]];
    }
    
    // Configure the cell...
    if ([CellIdentifier isEqualToString:@"ropeCell"])
    {
        UIButton *button = (UIButton *)[cell.contentView viewWithTag:OPTION_TABLE_CELL_TAG_BTN];
        [button addTarget:self action:@selector(addCellPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (self.state != TUTORIAL_OPTION_STATE_ADD_OPTION) button.enabled = NO;
        else button.enabled = YES;
        
        return cell;
    }
    
    int row = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unknown.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UITextField *textField;
    UITextField *row_textField = (UITextField *)[cell.contentView viewWithTag:OPTION_TABLE_CELL_TAG_ROW_TEXT];
    if ([row_textField.text isEqualToString:@"-1"]) {
        /* Initial Usage */
        textField = (UITextField *)[cell.contentView viewWithTag:OPTION_TABLE_CELL_TAG_TEXT];
        textField.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:17];
        textField.textColor = [UIColor whiteColor];
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    } else {
        textField = (UITextField *)[cell.contentView viewWithTag:[row_textField.text intValue] + 10];
    }
    
    textField.text = [self textForRow:row];
    textField.tag = row + 10;
    
    if (row > self.numberOfPetals) {
        textField.enabled = NO;
    } else {
        textField.enabled = YES;
        /* Hard code 3rd row is editable */
        if (row == 3) {
            textField.enabled = YES;
        } else {
            textField.enabled = NO;
        }
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:OPTION_TABLE_CELL_TAG_IMAGE];
    imageView.image = [self imageForRow:row];
    
    row_textField.text = [NSString stringWithFormat:@"%d", row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    /* hard code tutorial */
    if (self.state == TUTORIAL_OPTION_STATE_START && row <= 2) {
        [self play_click_sound];
        [self next_state];
    }
    
    if (self.state == TUTORIAL_OPTION_STATE_PICK_THEME && row == self.numberOfPetals + 2) {
        [self play_click_sound];
        [self next_state];
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

- (void)next_state
{
    switch (self.state) {
        case TUTORIAL_OPTION_STATE_START:
            self.state = TUTORIAL_OPTION_STATE_PICK_THEME;
            [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_3", nil)]];
            break;
        case TUTORIAL_OPTION_STATE_PICK_THEME:
            self.state = TUTORIAL_OPTION_STATE_ADD_OPTION;
            [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_4", nil)]];
            
            self.theme.title = self.sample_theme.title;
            self.theme.options = [self.sample_theme.options copy];
            self.theme.count = self.sample_theme.count;
            self.numberOfPetals = self.sample_theme.count;
            
            [self.opt_tableView reloadData];
            [self.opt_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
            break;
        case TUTORIAL_OPTION_STATE_ADD_OPTION:
            self.state = TUTORIAL_OPTION_STATE_EDIT_OPTION;
            [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_5", nil)]];
            break;
        case TUTORIAL_OPTION_STATE_EDIT_OPTION:
            self.state = TUTORIAL_OPTION_STATE_DONE;
            [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_6", nil)]];
            self.start_btn.enabled = YES;
            break;
        case TUTORIAL_OPTION_STATE_DONE:
            break;
    }
}

@end
