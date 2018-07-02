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

@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;


@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UIView *hederPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *loginTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *walletTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *correctionTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UILabel *walletLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *correctionLbl;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UILabel *coalitionNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coalitionBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *coalitionImageView;


@property (weak, nonatomic) IBOutlet UIView *placeholderLvlView;
@property (weak, nonatomic) IBOutlet UIView *lvlView;
@property (weak, nonatomic) IBOutlet UILabel *lvlLbl;

@property (nonatomic) NSArray *titleArr;

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSDictionary *coalitionData;
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) NSArray *projects;

@property (nonatomic) NSString *lvlStr;

@end

@implementation UserProfileViewController

+ (UserProfileViewController *)initWithJson:(NSDictionary *)json coalition:(NSDictionary *)coalitionData
{
    UserProfileViewController *controller = [UserProfileViewController new];
    
    if (controller)
    {
        [controller setJson:json];
        [controller setCoalitionData:coalitionData];
    }
        
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
    
    self.tableView.backgroundColor = [self colorWithHexString:@"FAFAFA"];
    
    _titleArr = [NSArray arrayWithObjects:@"Skills", @"Projects", nil];
    
    [self tuneImageView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _placeholderLvlView.layer.cornerRadius = 4.f;
        _lvlView.layer.cornerRadius = 4.f;
        _hederPlaceholder.layer.cornerRadius = 4.f;
    });
    
    [self setSkillsAndLvlStr];
    [self setLvlLbl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect frame = CGRectMake(0, 0, [self newWidthRow:_lvlStr], 8);
    
    [UIView animateWithDuration:0.6 animations:^{
        _lvlView.frame = frame;
    }];
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

- (void)parsProjects:(NSArray *)projects
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < projects.count; i++)
    {
        if (![projects[i][@"final_mark"] isEqual:[NSNull null]])
            [array addObject:projects[i]];
    }
    
    _projects = array;
}

- (BOOL)isValid:(id<NSObject>)obj {
    if (obj != nil && ![obj isKindOfClass:[NSNull class]])
        return YES;
    else
        return NO;
}

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

- (void)tuneImageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
        self.imageView.layer.borderWidth = 3;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.clipsToBounds = YES;
    });

}

- (CGFloat)newWidthRow:(NSString *)string
{
    
    NSArray *dataArr = [string componentsSeparatedByString:@"."];
    
    NSString *digit = [NSString stringWithFormat:@"0.%@",[[dataArr objectAtIndex:1] substringToIndex:2]];
    
    CGFloat newWidth = self.placeholderLvlView.frame.size.width * [digit doubleValue];
    
    return newWidth;
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
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    [cell setSkills:_skills];
    [cell setProjects:_projects];
    cell.indexPath = indexPath;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
        cell.color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    return cell;
}

#pragma mark - Properties

- (void)setHeaderBgImageView:(UIImageView *)headerBgImageView
{
    _headerBgImageView = headerBgImageView;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"name"][0]])
    {
        NSString *name = [_coalitionData valueForKey:@"name"][0];
        
        if ([name isEqualToString:@"The Union"])
            _headerBgImageView.image = [UIImage imageNamed:@"the_union_new"];
        else if ([name isEqualToString:@"The Hive"])
            _headerBgImageView.image = [UIImage imageNamed:@"the_hive_new"];
        else if ([name isEqualToString:@"The Empire"])
            _headerBgImageView.image = [UIImage imageNamed:@"the_empire_new"];
        else if ([name isEqualToString:@"The Alliance"])
            _headerBgImageView.image = [UIImage imageNamed:@"the_alliance_new"];
    }
}

- (void)setLvlLbl
{
    if (!_lvlStr)
        return;
    
    NSArray *dataArr = [_lvlStr componentsSeparatedByString:@"."];
    
    NSString *secondPart = [[dataArr objectAtIndex:1] substringToIndex:2];
    
    _lvlLbl.text = [NSString stringWithFormat:@"Level : %@ - %@%%", [dataArr objectAtIndex:0], secondPart];
}


- (void)setSkillsAndLvlStr
{
    NSArray *dataArr;
    NSArray *projects;
    
    if ([self isValid:[_json valueForKey:@"cursus_users"]])
        dataArr = _json[@"cursus_users"];
    
    if (dataArr && [self isValid:[[dataArr firstObject] valueForKey:@"skills"]])
          _skills = [dataArr firstObject][@"skills"];
    
    if (dataArr && [self isValid:[[dataArr firstObject] valueForKey:@"level"]])
        _lvlStr = [NSString stringWithFormat:@"%f", [[dataArr firstObject][@"level"] doubleValue]];
    
    if ([self isValid:[_json valueForKey:@"projects_users"]])
        projects = _json[@"projects_users"];
    
    [self parsProjects:projects];
    
}

- (void)setFullNameLbl:(UILabel *)fullNameLbl
{
    if (!_fullNameLbl)
        _fullNameLbl = fullNameLbl;
    
    _fullNameLbl.numberOfLines = 1;
    _fullNameLbl.minimumScaleFactor = 0.5;
    _fullNameLbl.adjustsFontSizeToFitWidth = YES;
    
    if (_json && [self isValid:[_json valueForKey:@"displayname"]])
        self.fullNameLbl.text = _json[@"displayname"];
}

- (void)setImageView:(UIImageView *)imageView
{
    if (_imageView == nil)
        _imageView = imageView;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_json[@"image_url"]]];
    self.imageView.image = [UIImage imageWithData: imageData];
}

- (void) setPlaceholderLvlVIew:(UIView *)placeholderLvlView
{
    if (!_placeholderLvlView)
        _placeholderLvlView = placeholderLvlView;
    
}

- (void)setLvlView:(UIView *)lvlView
{
    if (!_lvlView)
        _lvlView = lvlView;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _lvlView.backgroundColor = [self colorWithHexString:color];
    }
}

- (UIImageView *) tintImageView: (UIImageView *)imageView withColor: (UIColor*) color{
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:color];
    return imageView;
}

- (void)setCoalitionNameLbl:(UILabel *)coalitionNameLbl
{
    if(!_coalitionNameLbl)
        _coalitionNameLbl = coalitionNameLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"name"][0]])
    {
        [_coalitionNameLbl setHidden:NO];
        _coalitionNameLbl.text = [_coalitionData valueForKey:@"name"][0];
    }
}

- (void)setCoalitionImageView:(UIImageView *)coalitionImageView
{
    if (!_coalitionImageView)
        _coalitionImageView = coalitionImageView;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"name"][0]])
    {
        NSString *name = [_coalitionData valueForKey:@"name"][0];
        
        if ([name isEqualToString:@"The Union"])
            _coalitionImageView.image = [UIImage imageNamed:@"logoUnion"];
        else if ([name isEqualToString:@"The Hive"])
            _coalitionImageView.image = [UIImage imageNamed:@"logoHive"];
        else if ([name isEqualToString:@"The Empire"])
            _coalitionImageView.image = [UIImage imageNamed:@"logoEmpire"];
        else if ([name isEqualToString:@"The Alliance"])
            _coalitionImageView.image = [UIImage imageNamed:@"logoAlliance"];
    }
}

- (void)setCoalitionBgImage:(UIImageView *)coalitionBgImage
{
    if (!_coalitionBgImage)
        _coalitionBgImage = coalitionBgImage;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [self tintImageView:_coalitionBgImage withColor:[self colorWithHexString:color]];
    }
}

#pragma mark - Headers titles properties

- (void)setLoginTitleLbl:(UILabel *)loginTitleLbl {
    
    if (!_loginTitleLbl)
        _loginTitleLbl = loginTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _loginTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setWalletTitleLbl:(UILabel *)walletTitleLbl
{
    if (!_walletTitleLbl)
        _walletTitleLbl = walletTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _walletTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setPhoneTitleLbl:(UILabel *)phoneTitleLbl
{
    if (!_phoneTitleLbl)
        _phoneTitleLbl = phoneTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _phoneTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setEmailTitleLbl:(UILabel *)emailTitleLbl
{
    if (!_emailTitleLbl)
        _emailTitleLbl = emailTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _emailTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setLocationTitleLbl:(UILabel *)locationTitleLbl
{
    
    if (!_locationTitleLbl)
        _locationTitleLbl = locationTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _locationTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setCorrectionTitleLbl:(UILabel *)correctionTitleLbl
{
    
    if (!_correctionTitleLbl)
        _correctionTitleLbl = correctionTitleLbl;
    
    if (_coalitionData && _coalitionData.count > 0 && [self isValid:[_coalitionData valueForKey:@"color"][0]])
    {
        [_coalitionBgImage setHidden:NO];
        NSString *color = [[_coalitionData valueForKey:@"color"][0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _correctionTitleLbl.textColor = [self colorWithHexString:color];
    }
}

- (void)setLoginLbl:(UILabel *)loginLbl
{
    if (!_loginLbl)
        _loginLbl = loginLbl;
    
    if (_json && [self isValid:[_json valueForKey:@"login"]])
        _loginLbl.text =  _json[@"login"];
}

- (void)setWalletLbl:(UILabel *)walletLbl
{
    if (!_walletLbl)
        _walletLbl = walletLbl;
    
    if (_json && [self isValid:[_json valueForKey:@"wallet"]])
        _walletLbl.text = [NSString stringWithFormat:@"%lu₳", [_json[@"wallet"] longValue]];
}

- (void)setPhoneLbl:(UILabel *)phoneLbl
{
    if (!_phoneLbl)
        _phoneLbl = phoneLbl;
    
    _phoneLbl.numberOfLines = 1;
    _phoneLbl.minimumScaleFactor = 0.5;
    _phoneLbl.adjustsFontSizeToFitWidth = YES;
    
    if (_json && [self isValid:[_json valueForKey:@"phone"]])
        _phoneLbl.text =  _json[@"phone"];
}

- (void)setEmailLbl:(UILabel *)emailLbl
{
    if (!_emailLbl)
        _emailLbl = emailLbl;
    
    _emailLbl.numberOfLines = 1;
    _emailLbl.minimumScaleFactor = 0.5;
    _emailLbl.adjustsFontSizeToFitWidth = YES;
    
    if (_json && [self isValid:[_json valueForKey:@"email"]])
        _emailLbl.text =  _json[@"email"];
}

- (void)setLocationLbl:(UILabel *)locationLbl
{
    if (!_locationLbl)
        _locationLbl = locationLbl;
    
    if (_json && [self isValid:[_json valueForKey:@"location"]])
        _locationLbl.text =  _json[@"location"];
}

- (void)setCorrectionLbl:(UILabel *)correctionLbl
{
    if (!_correctionLbl)
        _correctionLbl = correctionLbl;
    
    if (_json && [self isValid:[_json valueForKey:@"correction_point"]])
    {
        NSString *correction = [NSString stringWithFormat:@"%lu", [_json[@"correction_point"] longValue]];
        _correctionLbl.text =  correction;
    }
}

@end
