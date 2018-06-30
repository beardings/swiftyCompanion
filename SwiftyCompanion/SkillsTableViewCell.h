//
//  SkillsTableViewCell.h
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 30.06.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *color;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

- (void)setLvlStr:(NSString *)lvlStr;
- (void)setTitleSkill;

- (void)animateShowLvlView;
- (void)hideLvlView;

@end
