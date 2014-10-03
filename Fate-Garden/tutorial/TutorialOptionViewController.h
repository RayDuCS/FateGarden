//
//  TutorialOptionViewController.h
//  Fate-Garden
//
//  Created by Rui Du on 3/9/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    OPTION_TABLE_CELL_TAG_IMAGE     = 101,
    OPTION_TABLE_CELL_TAG_TEXT      = 102,
    OPTION_TABLE_CELL_TAG_ROW_TEXT  = 103,
    OPTION_TABLE_CELL_TAG_BTN       = 104,
}OptionTableCellTag;

@interface TutorialOptionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
- (void)loadWithIdx:(int)idx;
@end
