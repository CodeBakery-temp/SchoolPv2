#import <UIKit/UIKit.h>

@interface CBMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *senderTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;

@end
