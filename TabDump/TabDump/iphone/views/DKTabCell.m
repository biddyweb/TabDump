//
//  DKTabCell.m
//  TabDump
//
//  Created by Daniel on 4/22/14.
//  Copyright (c) 2014 dkhamsing. All rights reserved.
//

#import "DKTabCell.h"

// Categories
#import "NSString+DK.h"
#import "UIColor+DK.h"
#import "UIColor+TD.h"
#import "UIImage+DK.h"
#import "UIView+DK.h"

// Defines
#import "DKTabDumpDefines.h"

// Models
#import "DKTab.h"


@interface DKTabCell ()
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *domainLabel;
@end


@implementation DKTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [[UILabel alloc] init];
        self.shareButton = [[UIButton alloc] init];
        self.domainLabel = [[UILabel alloc] init];
        
        [UIView dk_addSubviews:@[
                                 self.contentLabel,
                                 self.domainLabel,
                                 self.shareButton,
                                 ] onView:self.contentView];
        
        self.contentLabel.numberOfLines = 0;
        self.domainLabel.font = [UIFont fontWithName:kFontRegular size:11];
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setLink:(DKTab *)link {
    // setup
    _link = link;
    
    self.domainLabel.text = [link.urlString dk_domainForStringURL];
    
    NSString *tabText = link.strippedHTML;
    NSString *dateBlock = [NSString stringWithFormat:@"%@: ",link.tabDay];
    if (self.isCategory) {
        tabText = [tabText stringByReplacingOccurrencesOfString:link.tabNumber withString:@""];
        tabText = [tabText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tabText = [tabText stringByReplacingOccurrencesOfString:link.category withString:dateBlock];
    }
    self.contentLabel.text = tabText;
    
    // colors
    self.contentLabel.textColor = [UIColor blackColor];
    UIColor *dumpColor = [UIColor whiteColor];
    UIColor *categoryColor = dumpColor;
    if (link.colorForCategory == [UIColor whiteColor]) {
        dumpColor = [UIColor td_highlightColor];
        categoryColor = [UIColor grayColor];
    }
    if ([link brandColorIsDark]) {
        dumpColor = [UIColor td_highlightColor];
        categoryColor = [UIColor td_highlightColor];
    }
    
    NSNumber *categoryColors = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsSettingsCategoryColors];
    self.domainLabel.textColor = [UIColor dk_colorWithRed:210 green:210 blue:210];
    UIImage *shareImage = [UIImage dk_maskedImageNamed:@"tab-action" color:self.domainLabel.textColor];
    NSNumber *nightMode = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsSettingsNightMode];
    if ([nightMode isEqual:@1]) {
        self.backgroundColor = [UIColor blackColor];
        self.contentLabel.textColor = [UIColor whiteColor];
    }
    else {
        if ([categoryColors isEqual:@1]) {
            self.backgroundColor = [link colorForCategory];
            
            if ([link brandColorIsDark]) {
                self.contentLabel.textColor = [UIColor whiteColor];
                self.domainLabel.textColor = [UIColor whiteColor];
                shareImage = [UIImage dk_maskedImageNamed:@"tab-action" color:[UIColor whiteColor]];
            }
        }
        else {
            self.backgroundColor = [UIColor whiteColor];
            
            dumpColor = [UIColor td_highlightColor];
            categoryColor = [UIColor blackColor];
            self.contentLabel.textColor = [UIColor blackColor];
        }
    }
    
    // style
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:dumpColor} range:[self.contentLabel.text rangeOfString:dateBlock]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:dumpColor} range:[self.contentLabel.text rangeOfString:link.tabNumber]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:dumpColor} range:[self.contentLabel.text rangeOfString:link.tabNumber]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:categoryColor} range:[self.contentLabel.text rangeOfString:link.category]];
    [attributedString addAttributes:[link contentAttributes] range:[self.contentLabel.text rangeOfString:self.contentLabel.text]];
    self.contentLabel.text = @"";
    self.contentLabel.attributedText = attributedString;
    
    // frame
    CGRect frame = self.contentLabel.frame;
    frame.origin = CGPointMake(kCellPadding,kCellPadding);
    frame.size = [link sizeForStrippedHTML];
    self.contentLabel.frame = frame;
    
    frame.origin.y = self.contentLabel.dk_bottom -5;
    frame.size = CGSizeMake(50, 50);
    frame.origin.x = -3;
    self.shareButton.frame = frame;
    
    [self.shareButton setImage:shareImage forState:UIControlStateNormal];
    
    frame.size = CGSizeMake(200, 26);
    frame.origin.x = self.shareButton.dk_right -5;
    frame.origin.y = self.contentLabel.dk_bottom +7;
    self.domainLabel.frame = frame;
}


@end