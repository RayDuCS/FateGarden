//
//  TutorialGameViewController.m
//  Fate-Garden
//
//  Created by Rui Du on 3/9/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import "TutorialGameViewController.h"
#import "TutorialOptionViewController.h"

@interface TutorialGameViewController ()
@property (nonatomic) int idx;
@property (weak, nonatomic) IBOutlet UIImageView *mask_imgView;
@property (weak, nonatomic) IBOutlet UIButton *flower_btn_2;
@property (weak, nonatomic) IBOutlet UIButton *flower_btn_3;
@property (weak, nonatomic) IBOutlet UIButton *flower_btn_4;
@property (weak, nonatomic) IBOutlet UIButton *flower_btn_5;
@property (weak, nonatomic) IBOutlet UIButton *flower_btn_6;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image_view;
@end

@implementation TutorialGameViewController
@synthesize idx = _idx;
@synthesize mask_imgView = _mask_imgView;

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
                                               delay:1.5
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^() {
                                              self.mask_imgView.alpha = 1;
                                          }
                                          completion:^(BOOL finished) {
                                              self.flower_btn_3.enabled = NO;
                                              self.flower_btn_4.enabled = NO;
                                              self.flower_btn_5.enabled = NO;
                                              self.flower_btn_6.enabled = NO;
                                          }];
                     }];
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
    
    [self.bg_image_view setImage:[UIImage imageNamed:@"main_bg_ip5.png"]];
    float adjust_x = 0.0f;
    float adjust_y = 44.0f;
    [self.flower_btn_2 setFrame:CGRectMake(116 + adjust_x, 218 + adjust_y, 76, 60)];
    [self.flower_btn_3 setFrame:CGRectMake( 45 + adjust_x, 148 + adjust_y, 75, 68)];
    [self.flower_btn_4 setFrame:CGRectMake(203 + adjust_x, 283 + adjust_y, 82, 80)];
    [self.flower_btn_5 setFrame:CGRectMake(207 + adjust_x, 117 + adjust_y, 74, 75)];
    [self.flower_btn_6 setFrame:CGRectMake( 37 + adjust_x, 277 + adjust_y, 78, 74)];
    
    [self.edit_btn  setFrame:CGRectMake( 85 + adjust_x, 404 + adjust_y, 44, 60)];
    [self.share_btn setFrame:CGRectMake(196 + adjust_x, 404 + adjust_y, 44, 60)];
 
    [self.mask_imgView setImage:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_1", nil)]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self rearrange_icons];
    [self animate_mask_with_image:[self image_for_string:NSLocalizedString(@"tutorial_mask_png_1", nil)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TutMenuToOptSeg"]) {
        [segue.destinationViewController loadWithIdx:self.idx+1];
    }
}

- (IBAction)flowerBtnPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"TutMenuToOptSeg" sender:sender];
}

- (void)viewDidUnload {
    [self setMask_imgView:nil];
    [self setFlower_btn_5:nil];
    [self setFlower_btn_3:nil];
    [self setFlower_btn_6:nil];
    [self setFlower_btn_4:nil];
    [self setFlower_btn_2:nil];
    [self setEdit_btn:nil];
    [self setShare_btn:nil];
    [self setBg_image_view:nil];
    [super viewDidUnload];
}
@end
