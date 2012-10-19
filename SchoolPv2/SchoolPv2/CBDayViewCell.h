//
//  CBDayViewCell.h
//  Scheduler
//
//  Created by Christoffer Nordin on 10/12/12.
//
//

#import <UIKit/UIKit.h>

@interface CBDayViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;

@end
