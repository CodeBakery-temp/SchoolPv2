#import <UIKit/UIKit.h>

@interface CBAdminCreateMessageViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;

- (IBAction)mailTextFieldDo:(id)sender;

- (IBAction)clickBG:(id)sender;


@end
