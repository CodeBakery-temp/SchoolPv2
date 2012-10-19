#import <UIKit/UIKit.h>

@interface CBDayViewController : UIViewController
{
    NSString* userName;
}

@property (nonatomic, weak) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (weak, nonatomic) IBOutlet UIButton *inboxButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UIScrollView *lectureView;
@property (weak, nonatomic) IBOutlet UIView *noteView;
@property (weak, nonatomic) IBOutlet UITableView *lectureTable;
@property (weak, nonatomic) IBOutlet UITableView *noteTable;

- (IBAction)showNotes:(id)sender;
- (IBAction)toInbox:(id)sender;
- (IBAction)doSync:(id)sender;

@end
