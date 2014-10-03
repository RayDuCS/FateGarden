//
//  Theme.h
//  Fate-Garden
//
//  Created by Xiaoxuan Zhang on 1/18/13.
//  Copyright (c) 2013 Rui Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject<NSCoding, NSCopying>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDictionary *options;
@property (nonatomic) int count;

- (Theme *)initWithTitle:(NSString *)title
                 options:(NSDictionary *)options
                   count:(int)count;
- (BOOL)isEqualToTheme:(Theme *)theme;
- (BOOL)fillOptions:(int)numberOfPetals;
@end
