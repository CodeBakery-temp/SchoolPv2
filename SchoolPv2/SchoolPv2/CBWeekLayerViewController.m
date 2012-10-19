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
    CBScheduleService *schedule;
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
        // TEST GET YOU
        /*userName = @"nordin.christoffer@gmail.com";
        CBDatabaseService *db = [CBDatabaseService database];
        NSMutableArray *users = [[db getUsers] objectForKey:@"STUDENT"];
        for(CBUser* u in users) {
            if ([[u mailAddress] isEqualToString:userName]) {
                user = u;
            }
        }
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSWeekCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate:date];
        
        schedule = [CBScheduleService schedule];
        [schedule getLecturesOfWeek:user currentWeek:[components week]];
        [schedule sortLecturesByVersionAndTime];
        //[schedule getNotesOfWeekAndMessages:user currentWeek:[components week]];
        NSLog(@"%d %d %d %d %d", [[[[schedule getWeekLectures] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:1] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:2] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:3] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:4] objectForKey:@"LECTURES"] count]);*/
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
