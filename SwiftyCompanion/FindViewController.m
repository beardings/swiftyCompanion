//
//  ViewController.m
//  SwiftyCompanion
//
//  Created by Mykola Ponomarov on 14.04.2018.
//  Copyright © 2018 Mykola Ponomarov. All rights reserved.
//

#import "FindViewController.h"
#import "UserProfileViewController.h"

@interface FindViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *appUID;
@property (nonatomic, strong) NSString *secKey;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDictionary *json;

- (IBAction)searchPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, assign) BOOL isKeyboard;

@end

@implementation FindViewController
{
    CGRect _originalViewFrame;
    NSInteger kOFFSET_FOR_KEYBOARD;
    CGFloat keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kOFFSET_FOR_KEYBOARD = 0;
    keyboardHeight = 0;
    _originalViewFrame = self.view.frame;
    
    self.appUID = @"cb0a4b2cf538142a0248fb6fcc260f5a61678d9fabcf7c3be15a25c8f29c834f";
    self.secKey = @"611af97543ad0d533c5de46af81b752390a57a3944d2c96fc4967c17812d70c0";
    
    self.textField.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.indicator setHidden:YES];
    self.indicator.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.isKeyboard = YES;
    
    if (notification)
    {
        NSDictionary *info = [notification userInfo];
        
        CGRect rect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat yOffset = CGRectGetMaxY(self.errorLbl.frame);
        
        CGFloat diff = screenSize.height - CGRectGetHeight(rect);
        
        kOFFSET_FOR_KEYBOARD = yOffset - diff;
        
        if (kOFFSET_FOR_KEYBOARD < 0) 
            kOFFSET_FOR_KEYBOARD = 0;
    }
    
    if (self.view.frame.origin.y >= 0)
        [self setViewMovedUp:YES];
    
    else if (self.view.frame.origin.y < 0)
        [self setViewMovedUp:NO];

}

- (void)keyboardWillHide
{
    self.isKeyboard = NO;
    
    if (self.view.frame.origin.y >= 0)
        [self setViewMovedUp:YES];
    
    else if (self.view.frame.origin.y < 0)
        [self setViewMovedUp:NO];
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.34f];
        
    CGRect rect = self.view.frame;
    if (movedUp)
        rect.origin.y -= (kOFFSET_FOR_KEYBOARD + 30);

    else
        rect.origin.y += (kOFFSET_FOR_KEYBOARD + 30);
        
    self.view.frame = rect;
        
    [UIView commitAnimations];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self setErrorText:@""];
}

#pragma mark - API Method

- (void)getResultWithSrringURL:(NSString *)stringURL
{
    NSString *post = [NSString stringWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@",_appUID,_secKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:stringURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                
                                if (error)
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.indicator stopAnimating];
                                        [self setErrorText:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
                                    });
                                    
                                    return ;
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    NSError *jsonError;
                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:NSJSONReadingMutableContainers
                                                                                           error:&jsonError];
                                    if (!jsonError && json)
                                    {
                                        _token = json[@"access_token"];
                                        
                                        NSLog(@"%@", _token);
                                        
                                        if (_textField.text.length != 0)
                                            [self getUserData:@"https://api.intra.42.fr/v2/users" loginUser:self.textField.text];
                                        else
                                        {
                                            [self.indicator stopAnimating];
                                            [self setErrorText:@"Please, enter login"];
                                        }
                                    }
                                    
                                });
                            }];
    
    [task resume];
}

- (void)getUserData:(NSString *)stringURL loginUser:(NSString *)login
{
    NSString *get = [NSString stringWithFormat:@"%@/%@?access_token=%@", stringURL, login, _token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:get]];
    
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                        
                                        if (error)
                                        {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.indicator stopAnimating];
                                                [self setErrorText:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
                                            });
                                            
                                            return ;
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            NSError *jsonError;
                                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:NSJSONReadingMutableContainers
                                                                                                   error:&jsonError];
                                            
                                            if (json.count > 0 && !jsonError)
                                            {
                                                _json = json;
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [self dismissKeyboard];
                                                    
                                                    UserProfileViewController *userProfile = [UserProfileViewController initWithJson:json];

                                                    [self.indicator stopAnimating];

                                                    [self.navigationController pushViewController:userProfile animated:YES];
                                        
                                                });

                                            }
                                            else
                                            {
                                                [self.indicator stopAnimating];
                                                [self setErrorText:@"Please enter a valid email"];
                                            }
                                            
                                        });
                                    }];
    
     [task resume];
}

#pragma mark - Actions

- (IBAction)searchPressed:(id)sender
{
    if (self.indicator.animating == NO)
    {
        [self setErrorText:@""];
        
        if (_token)
        {
            if (_textField.text.length != 0)
            {
                [self.indicator setHidden:NO];
                [self.indicator startAnimating];
                [self getUserData:@"https://api.intra.42.fr/v2/users" loginUser:self.textField.text];
            }
            else
                [self setErrorText:@"Please, enter login"];
                
        }
        else
        {
            [self.indicator setHidden:NO];
            [self.indicator startAnimating];
            [self getResultWithSrringURL:@"https://api.intra.42.fr/oauth/token"];
        }
    }
    
}

#pragma mark - Action methods

- (void)setErrorText:(NSString *)text
{
     self.errorLbl.text = text;
}

@end
