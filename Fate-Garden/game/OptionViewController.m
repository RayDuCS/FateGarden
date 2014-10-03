//
//  OptionViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 1/17/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "OptionViewController.h"
#import "SettingsViewController.h"
#import "UICustomFont.h"
#import "UICustomColor.h"
#import "UIViewCustomAnimation.h"
#import "FateGameViewController.h"
#import "Theme.h"
#import "PetalInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SHK.h"
#import "SHKConfiguration.h"
#import "shareKitConfig.h"
#import "SHKFacebook.h"


#define GAME_URL @"https://itunes.apple.com/us/app/petal-decision-maker/id631865206?ls=1&mt=8"

@interface OptionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *start_btn;
@property (weak, nonatomic) IBOutlet UITableView *bar_table;
@property (weak, nonatomic) IBOutlet UIButton *back_btn;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIButton *go_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@property (weak, nonatomic) IBOutlet UIImageView *bar_image_view;
@property (weak, nonatomic) id delegate;

@property (nonatomic) int numberOfPetals;
@property (nonatomic) CGPoint center;

@property (strong, nonatomic) AVAudioPlayer *sePlayer;
@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) Theme *theme_duplicate;
@end

@implementation OptionViewController
@synthesize numberOfPetals = _numberOfPetals;
@synthesize center = _center;
@synthesize theme = _theme;
@synthesize sePlayer = _sePlayer;
@synthesize delegate = _delegate;
@synthesize theme_duplicate = _theme_duplicate;

- (void)setBar_table:(UITableView *)bar_table
{
    _bar_table = bar_table;
    self.bar_table.delegate = self;
    self.bar_table.dataSource = self;
}

- (void)load_with_numberOfPetals:(int)numberOfPetals
                      petalInfos:(NSDictionary *)infos
                        delegate:(id)delegate
{
    self.numberOfPetals = numberOfPetals;
    self.theme = [[Theme alloc] initWithTitle:@"" options:[infos copy] count:self.numberOfPetals];
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

- (void)generate_rate_us_alert
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL user_has_rated = [defaults boolForKey:@"user_has_rated"];
    if (user_has_rated) return;
    
    int play_attempt = [defaults integerForKey:@"play_attempt"];
    if (play_attempt >= 5) {
        play_attempt = 0;
        
        UIAlertView *alertView;
        alertView = [[UIAlertView alloc] initWithTitle:@""
                                               message:NSLocalizedString(@"rate_alert", nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"rate_alert_later", nil)
                                     otherButtonTitles:NSLocalizedString(@"rate_alert_go", nil), nil];
        [alertView show];
        
        [defaults setInteger:0 forKey:@"play_attempt"];
        [defaults synchronize];
    }
}

- (void)generate_reminder
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL user_has_seen = [defaults boolForKey:@"user_has_been_reminded"];
    if (user_has_seen) return;
    
    int play_attempt = [defaults integerForKey:@"play_attempt"];
    if (play_attempt > 0) {
        UIAlertView *alertView;
        alertView = [[UIAlertView alloc] initWithTitle:@""
                                               message:NSLocalizedString(@"instant_result_alert", nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"instant_result_alert_ok", nil)
                                     otherButtonTitles:nil];
        [alertView show];
        
        [defaults setBool:YES forKey:@"user_has_been_reminded"];
        [defaults synchronize];
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
    
    [self.bar_table setFrame:CGRectMake(19, 128, 283, 310)];
    [self.bar_image_view setFrame:CGRectMake(50, 0, 220, 102)];

    [self.back_btn  setFrame:CGRectMake( 30 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.edit_btn  setFrame:CGRectMake( 85 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.go_btn    setFrame:CGRectMake(248 + adjust_x, 404 + adjust_y, 44, 60)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!self.theme.options || self.numberOfPetals < 2 || self.numberOfPetals > 6) {
        [UIViewCustomAnimation showAlert:NSLocalizedString(@"error", nil)];
        [self backBtnPressed:nil];
        return;
    }
    
    [self rearrange_icons];
    
    self.bar_table.backgroundColor = [UIColor clearColor];    
    self.bar_table.backgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unknown.png"]];
    self.bar_table.backgroundColor = [UIColor clearColor];
    self.bar_table.separatorColor  = [UIColor clearColor];
    [self.bar_table setShowsVerticalScrollIndicator:NO];
    
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    for (Theme *theme in arr)
    {
        NSLog(@"Title: %@, Option: %@/%@", theme.title, [theme.options objectAtIndex:0], [theme.options objectAtIndex:1]);
    }
     */
    
    self.center = self.view.center;
    
    self.start_btn.titleLabel.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:20];
    self.start_btn.titleLabel.textColor = [UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE];
    [self.start_btn setTitleColor:[UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE] forState:UIControlStateNormal];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_iphone_5"]) {
        return;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self generate_reminder];
    [self generate_rate_us_alert];
    self.start_btn.titleLabel.font = [UICustomFont fontWithFontType:FONT_FANGZHENG_XINGHEI size:20];
    self.start_btn.titleLabel.textColor = [UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE];
    [self.bar_table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBar_table:nil];
    [self setStart_btn:nil];
    [self setBack_btn:nil];
    [self setEdit_btn:nil];
    [self setShare_btn:nil];
    [self setGo_btn:nil];
    [self setSePlayer:nil];
    [self setBg_image_view:nil];
    [self setBar_image_view:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fateGameSeg"]) {
        [segue.destinationViewController load_with_theme:self.theme_duplicate delegate:self.delegate];
    } else if ([segue.identifier isEqualToString:@"OptToSetSeg"]) {
        [segue.destinationViewController load_with_idx:1 delegate:self.delegate];
    }
}

/* Outlet Handlings */

- (BOOL)validateTheme
{
    if (self.theme.count < 2) {
        [UIViewCustomAnimation showAlert:NSLocalizedString(@"error", nil)];
        [self backBtnPressed:nil];
        return FALSE;
    }
    
    if (!self.theme.title || [self.theme.title isEqualToString:@""]) {
        /*
         [UIViewCustomAnimation showAlert:@"请输入问题"];
         [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
         atScrollPosition:UITableViewScrollPositionTop
         animated:YES];
         return FALSE;
         */
        self.theme.title = NSLocalizedString(@"option_dflt_title", nil);
    }
        
    int row=1;
    int filled_option_cnt = 0, empty_option_idx = -1;
    for (id key in self.theme.options)
    {
        PetalInfo *info = [self.theme.options objectForKey:key];
        if (!info.option || [info.option isEqualToString:@""]) {
            if (empty_option_idx == -1) empty_option_idx = row;
            /*
            [UIViewCustomAnimation showAlert:[NSString stringWithFormat:@"请输入选项 %d", row]];
            [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];            
            return FALSE;
             */
        } else {
            filled_option_cnt++;
        }
        
        row++;
    }
    
    if (filled_option_cnt == 0) {
        BOOL success;
        [self setTheme_duplicate:nil];
        self.theme_duplicate = [self.theme copy];
        success = [self.theme_duplicate fillOptions:self.numberOfPetals];
        return success;
        
        //return [self.theme fillOptions:self.numberOfPetals];
    }
    
    if (filled_option_cnt < 2) {
        [UIViewCustomAnimation showAlert:@"Customize two choices at least, or leave all as default"];
        if (empty_option_idx == -1) empty_option_idx = 0;
        [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:empty_option_idx inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        return FALSE;
    }
    
    
    [self setTheme_duplicate:nil];
    self.theme_duplicate = [self.theme copy];
    return TRUE;
}

- (void)initializeThemes
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *saved_themes_2 = [[NSArray alloc] init];
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
}

- (void)play_click_sound
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music_is_off"]) return;

    self.sePlayer = [UIViewCustomAnimation audioPlayerAtPath:[[NSBundle mainBundle] pathForResource:@"knock_wood" ofType:@"mp3"] volumn:1];
    [self.sePlayer play];
}

- (void)writeToDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    if (!data) {
        [self initializeThemes];
        data = [defaults objectForKey:@"themes"];
    }
    
    NSDictionary *all_saved_themes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (all_saved_themes.count != 5) {
        [self initializeThemes];
        
        data = [defaults objectForKey:@"themes"];
        all_saved_themes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    //NSArray *saved_themes = [all_saved_themes objectForKey:[NSString stringWithFormat:@"%d", self.numberOfPetals]];
    NSArray *saved_themes = [all_saved_themes objectForKey:@"2"];
    NSMutableArray *saved_themes_mutable = [[NSMutableArray alloc] init];
    [saved_themes_mutable addObject:self.theme];
    
    int idx = 0;
    Theme *current_saved_theme;
    while (saved_themes.count > idx && saved_themes_mutable.count < 5)
    {
        current_saved_theme = [saved_themes objectAtIndex:idx];
        if (![current_saved_theme isEqualToTheme:self.theme]) {
            [saved_themes_mutable addObject:current_saved_theme];
        }
        
        idx++;
        if (saved_themes.count > idx)
            current_saved_theme = [saved_themes objectAtIndex:idx];
        else break;
    }
    
    NSMutableDictionary *updated_dictionary = [all_saved_themes mutableCopy];
    [updated_dictionary setObject:[saved_themes_mutable copy] forKey:@"2"];
    //[updated_dictionary setObject:[saved_themes_mutable copy] forKey:[NSString stringWithFormat:@"%d", self.numberOfPetals]];
    
    NSData *updated_data = [NSKeyedArchiver archivedDataWithRootObject:[updated_dictionary copy]];
    [defaults setObject:updated_data forKey:@"themes"];
    [defaults synchronize];
}

- (IBAction)startBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    
    if (![self validateTheme]) return;
    
    [self writeToDefaults];
    [self performSegueWithIdentifier:@"fateGameSeg" sender:sender];
}

- (IBAction)backBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    [self performSegueWithIdentifier:@"OptToSetSeg" sender:sender];
}

- (IBAction)shareBtnPressed:(UIButton *)sender
{
    [self play_click_sound];
    
    NSURL *url = [NSURL URLWithString:GAME_URL];
    SHKItem *item = [SHKItem URL:url title:@"Petal decision maker just helped me out! Come on and try it!" contentType:SHKURLContentTypeWebpage];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    [SHK setRootViewController:self];
    [actionSheet showInView:self.view];
}

/* Protocol Implementations */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:NSLocalizedString(@"rate_alert_go", nil)]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"user_has_rated"];
        [defaults synchronize];
        
        
        NSString *urlString = GAME_URL;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* Play the knock sound */
    [self play_click_sound];
    
    [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-10
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
    
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
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.center = CGPointMake(self.center.x, 120);
                     }
                     completion:^(BOOL finished){}];
    
    [self.view setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.center = self.center;
                     }
                     completion:^(BOOL finished){}];
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    NSDictionary *all_saved_themes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *saved_themes = [all_saved_themes objectForKey:@"2"];
    //NSArray *saved_themes = [all_saved_themes objectForKey:[NSString stringWithFormat:@"%d", self.numberOfPetals]];
    
    int theme_idx = row - self.numberOfPetals - 2;
    if (saved_themes.count < theme_idx + 1) return [UIImage imageNamed:@"flower_2_small.png"];
    
    Theme *theme = [saved_themes objectAtIndex:theme_idx];    
    return [UIImage imageNamed:[NSString stringWithFormat:@"flower_%d_small.png", theme.count]];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    NSDictionary *all_saved_themes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *saved_themes = [all_saved_themes objectForKey:@"2"];
    //NSArray *saved_themes = [all_saved_themes objectForKey:[NSString stringWithFormat:@"%d", self.numberOfPetals]];
    
    int theme_idx = row - self.numberOfPetals - 2;
    if (saved_themes.count < theme_idx + 1) return @"Empty";
    
    Theme *theme = [saved_themes objectAtIndex:theme_idx];
    return theme.title;
}

- (IBAction)addCellPressed:(id)sender
{
    [self play_click_sound];
    self.numberOfPetals++;
    self.theme.count++;
    /*
    NSArray *nextOptions = [self.delegate petalInfoCopyOfAmount:self.numberOfPetals];
    int idx = 0;
    for (PetalInfo *other in self.theme.options)
    {
        PetalInfo *info = [nextOptions objectAtIndex:idx];
        info.option = other.option;
        idx++;
    }
    
    self.theme.options = [nextOptions copy]; 
    */
    [self.bar_table reloadData];
    [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.numberOfPetals inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
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
        if (self.numberOfPetals >= 6) button.enabled = NO;
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
        //textField.textColor = [UICustomColor colorWithType:UI_CUSTOM_COLOR_CADE_BLUE];
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
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:OPTION_TABLE_CELL_TAG_IMAGE];
    imageView.image = [self imageForRow:row];
    
    row_textField.text = [NSString stringWithFormat:@"%d", row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row != self.numberOfPetals + 1) {
        [self play_click_sound];
    }
    
    if (row <= self.numberOfPetals + 1) return;
    
    NSLog(@"tapped");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"themes"];
    NSDictionary *all_saved_themes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //NSArray *saved_themes = [all_saved_themes objectForKey:[NSString stringWithFormat:@"%d", self.numberOfPetals]];
    NSArray *saved_themes = [all_saved_themes objectForKey:@"2"];
    
    int theme_idx = row - self.numberOfPetals - 2;
    if (saved_themes.count < theme_idx + 1) return;
    
    Theme *theme = [saved_themes objectAtIndex:theme_idx];
    self.theme.title = theme.title;
    self.theme.options = [theme.options copy];
    self.theme.count = theme.count;
    self.numberOfPetals = self.theme.count;
    
    [self.bar_table reloadData];
    [self.bar_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
}

@end
