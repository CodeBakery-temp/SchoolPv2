#import "CBWeekLayerViewController.h"
#import "CBDayViewController.h"
#import "CBDayLectureViewController.h"
#import "CBDayNoteViewController.h"
#import "CBScheduleService.h"
#import "CBDatabaseService.h"
#import "CBUser.h"

@interface CBDayViewController ()
{
    CBDayLectureViewController *dayLectures;
    CBDayNoteViewController *dayNotes;
    CBScheduleService *schedule;
    CBUser *user;
}

@end

@implementation CBDayViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // TEST GET YOU
        userName = @"nordin.christoffer@gmail.com";
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
        [schedule getNotesOfWeekAndMessages:user currentWeek:[components week]];
        [schedule sortLecturesByVersionAndTime];
        NSLog(@"%d %d %d %d %d", [[[[schedule getWeekLectures] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:1] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:2] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:3] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:4] objectForKey:@"LECTURES"] count]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_dayLabel setText:[[schedule getDayLectures] objectForKey:@"DAY"]];
    dayLectures = [[CBDayLectureViewController alloc] init];
    dayNotes = [[CBDayNoteViewController alloc] init];
    [_lectureTable addSubview:dayLectures.view];
    [_noteTable addSubview:dayNotes.view];
    
    UIFont *crayonFont = [UIFont fontWithName:@"DK Crayon Crumble" size:30];
//    UIFont *handwritingFont = [UIFont fontWithName:@"Brasserie" size:30];
    _dayLabel.font = crayonFont;
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation==UIInterfaceOrientationPortrait||
        fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"WEEK VIEW");
        CBWeekLayerViewController *weekController = [[CBWeekLayerViewController alloc] init];
        weekController.delegate = delegate;
        [delegate setRootViewController:weekController];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)showNotes:(id)sender {
    if (_noteView.hidden)
        _noteView.hidden =NO;
    else
        _noteView.hidden =YES;
}

- (IBAction)toInbox:(id)sender {
    NSLog(@"Inbox");
}

- (IBAction)doSync:(id)sender {
    NSLog(@"Sync");
}

@end
