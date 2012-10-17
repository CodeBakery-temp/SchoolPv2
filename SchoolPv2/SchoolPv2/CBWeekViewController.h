#import <Foundation/Foundation.h>

@interface CBWeekViewController : UITableViewController
{
    NSString* userName;
}

@property (nonatomic, weak) id delegate;

@end
