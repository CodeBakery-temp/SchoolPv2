#import <UIKit/UIKit.h>

@interface CBCourseFormViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *courseField;
@property (weak, nonatomic) IBOutlet UITextField *teacherField;
@property (weak, nonatomic) IBOutlet UITextField *roomField;
@property (weak, nonatomic) IBOutlet UITextField *dayField;
@property (weak, nonatomic) IBOutlet UITextField *weekField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *stopField;

@property (strong, nonatomic) IBOutlet UIScrollView *superHejScroll;

- (IBAction)courseExit:(id)sender;
- (IBAction)teacherExit:(id)sender;
- (IBAction)roomExit:(id)sender;
- (IBAction)dayExit:(id)sender;
- (IBAction)weekExit:(id)sender;
- (IBAction)yearExit:(id)sender;
- (IBAction)startExit:(id)sender;
- (IBAction)stopExit:(id)sender;

//- (IBAction)cancelButton:(id)sender;
//- (IBAction)saveButton:(id)sender;

@end
