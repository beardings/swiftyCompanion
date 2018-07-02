//
//  CustomTableViewCell.h
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/18/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *conteinerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setSkills:(NSArray *)skills;
- (void)setProjects:(NSArray *)projects;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *color;

@end
