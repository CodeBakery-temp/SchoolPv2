//
//  CBAdminCreateMessageViewController.h
//  SchoolPv2
//
//  Created by Student vid Yrkeshögskola C3L on 10/23/12.
//
//

#import <UIKit/UIKit.h>

@interface CBAdminCreateMessageViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;

- (IBAction)mailTextFieldDo:(id)sender;

- (IBAction)clickBG:(id)sender;


@end
