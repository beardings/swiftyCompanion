//
//  SkillsTableViewCell.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 30.06.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "SkillsTableViewCell.h"

@interface SkillsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *placeholderLvlView;
@property (weak, nonatomic) IBOutlet UIView *lvlVIew;

@end

@implementation SkillsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - Custom methods

- (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (CGFloat)newWidthRow:(NSString *)string
{    
    NSArray *dataArr = [string componentsSeparatedByString:@"."];
    
    NSString *digit = [NSString stringWithFormat:@"0.%@",[[dataArr objectAtIndex:1] substringToIndex:2]];
    
    CGFloat newWidth = self.placeholderLvlView.frame.size.width * [digit doubleValue];
    
    return newWidth;
}

- (void)hideLvlView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = CGRectMake(0, 0, 0, 7);
        
        _lvlVIew.frame = frame;
    });
}

- (void)animateShowLvlView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = CGRectMake(0, 0, [self newWidthRow:_lvlStr], 7);
        
        [UIView animateWithDuration:0.6 animations:^{
            _lvlVIew.frame = frame;
        }];
    });
}

- (void)setTitleSkill
{
    NSArray *dataArr = [_lvlStr componentsSeparatedByString:@"."];
    
    NSString *secondPart = [[dataArr objectAtIndex:1] substringToIndex:2];
    
    _titleLbl.text = [NSString stringWithFormat:@"%@ - Level : %@ - %@%%", _titleLbl.text, [dataArr objectAtIndex:0], secondPart];
}

#pragma mark - Properties

- (void)setTitleLbl:(UILabel *)titleLbl
{
    if (!_titleLbl)
        _titleLbl = titleLbl;
}

- (void)setPlaceholderLvlView:(UIView *)placeholderLvlView
{
    if (!_placeholderLvlView)
        _placeholderLvlView = placeholderLvlView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _placeholderLvlView.layer.cornerRadius = 3.5f;
    });
    
}

- (void)setLvlVIew:(UIView *)lvlVIew
{
    if (!_lvlVIew)
        _lvlVIew = lvlVIew;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _lvlVIew.layer.cornerRadius = 3.5f;
        if (_color)
            _lvlVIew.backgroundColor = [self colorWithHexString:_color];
    });
}

@end
