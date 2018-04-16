//
//  UserProfileViewController.h
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/16/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) NSDictionary *json;

+ (UserProfileViewController *)initWithJson:(NSDictionary *)json;

@end
