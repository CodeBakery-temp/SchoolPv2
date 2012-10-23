//
//  CBMessageCell.h
//  SchoolPv2
//
//  Created by Student vid Yrkeshögskola C3L on 10/23/12.
//
//

#import <UIKit/UIKit.h>

@interface CBMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *senderTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;

@end
