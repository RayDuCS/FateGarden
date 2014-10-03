//
//  OptionViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 1/17/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface OptionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>{
    GADBannerView *bannerView_;
}


typedef enum
{
    OPTION_TABLE_CELL_TAG_IMAGE     = 101,
    OPTION_TABLE_CELL_TAG_TEXT      = 102,
    OPTION_TABLE_CELL_TAG_ROW_TEXT  = 103,
    OPTION_TABLE_CELL_TAG_BTN       = 104,
}OptionTableCellTag;

- (void)load_with_numberOfPetals:(int)numberOfPetals
                    petalInfos:(NSDictionary *)infos
                        delegate:(id)delegate;

@end
