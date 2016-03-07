//
//  ViewController.h
//  Assessment
//
//  Created by DeepaChithari on 3/6/16.
//  Copyright © 2016 CodeForce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#include "AFNetworking.h"
#include "OpinionzAlertView.h"

@interface ViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_result;
    
}

@property(strong,nonatomic)IBOutlet UITextField *txtfield_Search;
//@property(strong, nonatomic)IBOutlet UILabel *lbl_Meaning;

-(IBAction)searchClicked:(id)sender;


@end

