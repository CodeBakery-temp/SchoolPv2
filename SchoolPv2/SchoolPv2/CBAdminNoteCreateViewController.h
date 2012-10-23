#import <UIKit/UIKit.h>

@interface CBAdminNoteCreateViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *coursePickerView;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UITextField *weekTextField;
- (IBAction)dayTextFieldAction:(id)sender;
- (IBAction)weekTextFieldAction:(id)sender;


@end
