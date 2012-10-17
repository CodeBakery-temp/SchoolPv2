#import "CBDatabaseService.h"
#import "CBScheduleService.h"
#import "CBWeekViewController.h"
#import "CBDayViewController.h"
#import "CBLecture.h"
#import "CBNote.h"
#import "CBUser.h"
#import "CBMessage.h"
#import "CBWeekViewCell.h"

@implementation CBWeekViewController
{
    CBScheduleService *schedule;
    CBUser *user;
}
@synthesize delegate;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.separatorColor = [UIColor clearColor];
        
        NSLog(@"GET USER");
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
        [schedule sortLecturesByVersionAndTime];
        //[schedule getNotesOfWeekAndMessages:user currentWeek:[components week]];
        NSLog(@"%d %d %d %d %d", [[[[schedule getWeekLectures] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:1] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:2] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:3] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:4] objectForKey:@"LECTURES"] count]);
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CBWeekViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBWeekViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[schedule getWeekLectures] objectAtIndex:section] objectForKey:@"LECTURES"] count]+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.sectionFooterHeight =0;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBWeekViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBWeekViewCell"];
    if ([indexPath row]==0) {
        // DAY HEADER
        [[cell dayLabel] setText:[[[schedule getWeekLectures] objectAtIndex:[indexPath section]] objectForKey:@"DAY"]];
        [[cell courseLabel] setText:@""];
        [[cell startLabel] setText:@""];
        [[cell stopLabel] setText:@""];
        return cell;
    }
    else {
        // COURSE OBJECTS
        NSArray *lectures = [[[schedule getWeekLectures] objectAtIndex:[indexPath section]] objectForKey:@"LECTURES"];
        CBLecture *lec = [lectures objectAtIndex:([indexPath row]-1)];
        [[cell dayLabel] setText:@""];
        [[cell courseLabel] setText: [lec course]];
        [[cell startLabel] setText: [NSString stringWithFormat:@"%@ -", [lec startTime]]];
        [[cell stopLabel] setText: [NSString stringWithFormat:@"%@", [lec stopTime]]];
        return cell;
    }
    return nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||
        fromInterfaceOrientation==UIInterfaceOrientationLandscapeRight) {
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
