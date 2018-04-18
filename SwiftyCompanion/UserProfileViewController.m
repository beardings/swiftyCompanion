//
//  UserProfileViewController.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 4/16/18.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CustomTableViewCell.h"

@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSArray *titleArr;

@property (nonatomic, strong) NSDictionary *json;

@end

@implementation UserProfileViewController

+ (UserProfileViewController *)initWithJson:(NSDictionary *)json
{
    UserProfileViewController *controller = [UserProfileViewController new];
    
    if (controller)
        [controller setJson:json];
        
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate  = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    _titleArr = [NSArray arrayWithObjects:@"Skills", @"Projects", nil];
    
    [self tuneImageView];
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

- (void)tuneImageView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
        self.imageView.layer.borderWidth = 3;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.clipsToBounds = YES;
    });

}

#pragma mark - TableView DataSourse, Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
    cell.titleLabel.text =_titleArr[indexPath.row];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;

    return cell;
}

- (void)setImageView:(UIImageView *)imageView
{
    if (_imageView == nil)
        _imageView = imageView;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_json[@"image_url"]]];
    self.imageView.image = [UIImage imageWithData: imageData];
}

//[0]    (null)    @"patroning" : @"0 elements"
//[1]    (null)    @"location" : @"e1r9p12"
//[2]    (null)    @"url" : @"https://api.intra.42.fr/v2/users/mponomar"
//[3]    (null)    @"expertises_users" : @"0 elements"
//[4]    (null)    @"pool_year" : @"2016"
//[5]    (null)    @"last_name" : @"Ponomarov"
//[6]    (null)    @"displayname" : @"Mykola Ponomarov"
//[7]    (null)    @"staff?" : (no summary)
//[8]    (null)    @"correction_point" : (long)2
//[9]    (null)    @"cursus_users" : @"2 elements"
//[10]    (null)    @"achievements" : @"16 elements"
//[11]    (null)    @"partnerships" : @"0 elements"
//[12]    (null)    @"id" : (long)22452
//[13]    (null)    @"projects_users" : @"82 elements"
//[14]    (null)    @"email" : @"mponomar@student.unit.ua"
//[15]    (null)    @"groups" : @"0 elements"
//[16]    (null)    @"phone" : @"+380636408293"
//[17]    (null)    @"login" : @"mponomar"
//[18]    (null)    @"pool_month" : @"september"
//[19]    (null)    @"titles" : @"1 element"
//[20]    (null)    @"titles_users" : @"1 element"
//[21]    (null)    @"patroned" : @"0 elements"
//[22]    (null)    @"campus" : @"1 element"
//[23]    (null)    @"languages_users" : @"2 elements"
//[24]    (null)    @"wallet" : (long)55
//[25]    (null)    @"first_name" : @"Mykola"
//[26]    (null)    @"campus_users" : @"1 element"
//[27]    (null)    @"image_url" : @"https://cdn.intra.42.fr/users/mponomar.jpg"

@end
