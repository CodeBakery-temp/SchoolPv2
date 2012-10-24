#import "CBWeekLayerViewController.h"
#import "CBDatabaseService.h"
#import "CBScheduleService.h"
#import "CBWeekViewController.h"
#import "CBDayViewController.h"
#import "CBLecture.h"
#import "CBNote.h"
#import "CBUser.h"
#import "CBMessage.h"
#import "CBWeekViewCell.h"

@interface CBWeekLayerViewController ()
{
    CBWeekViewController *weekSchedule;
    CBUser *user;
}

@end

@implementation CBWeekLayerViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    weekSchedule = [[CBWeekViewController alloc] init];
    [_weekTable addSubview:weekSchedule.view];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||
        fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
        NSLog(@"DAY VIEW");
        CBDayViewController *dayController = [[CBDayViewController alloc] init];
        dayController.delegate = delegate;
        [delegate setRootViewController:dayController];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
