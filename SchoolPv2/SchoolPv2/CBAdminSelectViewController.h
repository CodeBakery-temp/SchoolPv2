#import <UIKit/UIKit.h>

@interface CBAdminSelectViewController : UIViewController

@property (nonatomic, strong) id delegate;

- (IBAction)toCourses:(id)sender;
- (IBAction)toNotes:(id)sender;
- (IBAction)toMessages:(id)sender;

@end
