//
//  CustomTableViewCell.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/18/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "SkillsTableViewCell.h"

@interface CustomTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@property (nonatomic, strong) NSArray *skills;

@property (nonatomic, strong) NSMutableArray *projectsArray;

@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _conteinerView.layer.cornerRadius = 4;

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

#pragma mark - Properties

- (void)setTableVIew:(UITableView *)tableVIew
{
    if (!_tableVIew)
        _tableVIew = tableVIew;
    
    _tableVIew.layer.cornerRadius = 4;
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _tableVIew.separatorColor = [self colorWithHexString:@"FAFAFA"];
    });
}

- (void)setSkills:(NSArray *)skills
{
    if (!_skills)
        _skills = skills;
   
}

#pragma mark - TableView DataSourse, Delegate

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SkillsTableViewCell class]]) {
        [(SkillsTableViewCell *)cell hideLvlView];
    }
}

 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SkillsTableViewCell class]]) {
        [(SkillsTableViewCell *)cell animateShowLvlView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _indexPath.row == 0 ? _skills.count : _projectsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillsCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SkillsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SkillsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SkillsCell"];
    }

    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.color = _color;
    cell.titleLbl.text = _skills[indexPath.row][@"name"];
    [cell setLvlStr:[NSString stringWithFormat:@"%f", [_skills[indexPath.row][@"level"] doubleValue]]];
    [cell setTitleSkill];
    
    return cell;
}

@end
