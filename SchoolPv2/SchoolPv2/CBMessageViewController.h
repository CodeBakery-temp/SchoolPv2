#import <UIKit/UIKit.h>

@interface CBMessageViewController : UITableViewController

@property (nonatomic, strong) id delegate;

- (void)exitAdmin:(id)sender;

@end
