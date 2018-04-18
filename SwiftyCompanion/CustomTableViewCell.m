//
//  CustomTableViewCell.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/18/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()


@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _conteinerView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
