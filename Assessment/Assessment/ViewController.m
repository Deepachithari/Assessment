//
//  ViewController.m
//  Assessment
//
//  Created by DeepaChithari on 3/6/16.
//  Copyright © 2016 CodeForce. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.txtfield_Search.delegate = self;
    self.txtfield_Search.autocapitalizationType = UITextAutocapitalizationTypeWords;
    arr_result = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Search Button
-(IBAction)searchClicked:(id)sender
{
    if(self.txtfield_Search.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"empty"];
        [self getSearchResult];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"empty"];
        [self showFailedAlert];
    }
    
    [self.txtfield_Search resignFirstResponder];
    
    
}

#pragma mark- MBProgressHUD
-(void)showIndicator
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideIndicator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getSearchResult];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - API Call

-(void)getSearchResult
{
    [self showIndicator];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@", self.txtfield_Search.text]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self hideIndicator];
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseObject options: NSJSONReadingMutableContainers error:nil];
            NSLog(@"response:%@",JSON);
            
            NSMutableArray *temp_array = [JSON valueForKey:@"lfs"];
            
            if(temp_array.count == 0)
            {
                [self showFailedAlert];
            }
            
            else
            {
                NSMutableArray *temp_array1 = [temp_array objectAtIndex:0];
                
                arr_result = [temp_array1 valueForKey:@"lf"];
                
                // NSLog(@"array:%@",temp_array1);
                
                //NSLog(@"meaning:%@",str_meaning);
                //self.lbl_Meaning.text = [arr_result objectAtIndex:0];
                [self showSuccessAlert];
                
            }
            
            self.txtfield_Search.text = @"";
            
            [self hideIndicator];
            
        }
    }];
    [dataTask resume];
}

#pragma mark - AlertView

-(void)showSuccessAlert
{
    OpinionzAlertView *alertView = [[OpinionzAlertView alloc] initWithTitle:nil
                                                                    message:[arr_result objectAtIndex:0]
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil
                                                    usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                        
                                                        NSLog(@"Tapped button at index : %li", (long)buttonIndex);
                                                        NSLog(@"buttonTitle: %@", [alertView buttonTitleAtIndex:buttonIndex]);
                                                    }];
    
    alertView.iconType = OpinionzAlertIconSuccess;
    alertView.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
    
    [alertView show];
}
-(void)showFailedAlert
{
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"empty"] isEqualToString:@"yes"])
    {
        OpinionzAlertView *alertView = [[OpinionzAlertView alloc] initWithTitle:nil
                                                                        message:@"Please Type Acronym to Search"
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil
                                                        usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                            
                                                            NSLog(@"Tapped button at index : %li", (long)buttonIndex);
                                                            NSLog(@"buttonTitle: %@", [alertView buttonTitleAtIndex:buttonIndex]);
                                                        }];
        
        alertView.iconType = OpinionzAlertIconWarning;
        //alertView.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
        
        [alertView show];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"empty"];
        
    }
    
    else
    {
        OpinionzAlertView *alertView = [[OpinionzAlertView alloc] initWithTitle:nil
                                                                        message:@"Acronym Not Found"
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil
                                                        usingBlockWhenTapButton:^(OpinionzAlertView *alertView, NSInteger buttonIndex) {
                                                            
                                                            NSLog(@"Tapped button at index : %li", (long)buttonIndex);
                                                            NSLog(@"buttonTitle: %@", [alertView buttonTitleAtIndex:buttonIndex]);
                                                        }];
        
        alertView.iconType = OpinionzAlertIconWarning;
        //alertView.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
        
        [alertView show];
    }
}

#pragma mark - View Tapped
-(void)viewTapped
{
    
    [self.txtfield_Search resignFirstResponder];
}

@end
