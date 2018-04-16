//
//  UserProfileViewController.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/16/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *mutArr;

@end

@implementation UserProfileViewController

+ (UserProfileViewController *)initWithJson:(NSDictionary *)json
{
    UserProfileViewController *controller = [UserProfileViewController new];
    
    if (controller)
        [controller setParameters];
    
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate  = self;
    
    self.tableView.dataSource = self;
    
    _mutArr = [[NSMutableArray alloc] init];
    
    [_mutArr addObjectsFromArray:[NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom method

- (void)setParameters
{
    
}

#pragma mark - TableView DataSourse, Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mutArr count];;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [_mutArr objectAtIndex:indexPath.row];
    return cell;
}



@end
