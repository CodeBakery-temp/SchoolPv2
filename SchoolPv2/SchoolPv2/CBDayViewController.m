#import "CBWeekLayerViewController.h"
#import "CBDayViewController.h"
#import "CBDayLectureViewController.h"
#import "CBDayNoteViewController.h"
#import "CBScheduleService.h"
#import "CBDatabaseService.h"
#import "CBUser.h"
#import "CBAdminSelectViewController.h"
#import "CBAdminCourseViewController.h"
#import "CBMessageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CBDayViewController ()
{
    CBDayLectureViewController *dayLectures;
    CBDayNoteViewController *dayNotes;
    CBScheduleService *schedule;
    NSDictionary *allUsersDict;
    CBUser *user;
    BOOL isAdmin;
}

@end

@implementation CBDayViewController

@synthesize delegate;
@synthesize alertView;

- (id)init
{
    self = [super init];
    if (self) {
        CBDatabaseService *db = [CBDatabaseService database];
        schedule = [CBScheduleService schedule];
        allUsersDict = [db getUsers];
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolP_user"];
        if (userName) {
            // If logged in, get CBUser object
            for (CBUser *admin in [allUsersDict objectForKey:@"ADMIN"]) {
                if ([[admin mailAddress]isEqualToString:userName]) {
                    user =admin;
                    isAdmin =TRUE;
                    break;
                }
            }
            if (!user) {
                for (CBUser *student in [allUsersDict objectForKey:@"STUDENT"]) {
                    if ([[student mailAddress]isEqualToString:userName]) {
                        user =student;
                        isAdmin =FALSE;
                        break;
                    }
                }
            }
            if (user) {
                [self fetchData];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isAdmin)
        _adminButton.hidden =FALSE;
    else
        _adminButton.hidden =TRUE;
    if (!userName) {
        alertView = [[UIAlertView alloc] init];
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        alertView.title = @"Login";
        [[self.alertView textFieldAtIndex:0] setDelegate:self];
        [alertView show];
    }
    else {
        [_dayLabel setText:[[schedule getDayLectures:0] objectForKey:@"DAY"]];
        dayLectures = [[CBDayLectureViewController alloc] init];
        dayNotes = [[CBDayNoteViewController alloc] init];
        [_lectureTable addSubview:dayLectures.view];
        [_noteTable addSubview:dayNotes.view];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@ %@", [[alertView textFieldAtIndex:0] text], [[alertView textFieldAtIndex:1] text]);
    for (CBUser *admin in [allUsersDict objectForKey:@"ADMIN"]) {
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:[admin mailAddress]]&&
            [[[alertView textFieldAtIndex:1] text] isEqualToString:[admin password]]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[admin mailAddress] forKey:@"SchoolP_user"];
            user =admin;
            isAdmin =TRUE;
            break;
        }
    }
    if (!user) {
        for (CBUser *student in [allUsersDict objectForKey:@"STUDENT"]) {
            if ([[[alertView textFieldAtIndex:0] text] isEqualToString:[student mailAddress]]&&
                [[[alertView textFieldAtIndex:1] text] isEqualToString:[student password]]) {
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:[student mailAddress] forKey:@"SchoolP_user"];
                user =student;
                isAdmin =FALSE;
                break;
            }
        }
    }
    if (!user) {
        [[alertView textFieldAtIndex:0] setText:@""];
        [[alertView textFieldAtIndex:1] setText:@""];
    }
    else {
        if (isAdmin)
            _adminButton.hidden =FALSE;
        else
            _adminButton.hidden =TRUE;
        [self fetchData];
    }
    return YES;
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
    CBMessageViewController *messageView = [[CBMessageViewController alloc] init];
    messageView.delegate = delegate;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:messageView];
    navController.navigationBar.tintColor = [UIColor blackColor];
    [delegate setRootViewController:navController];
    NSLog(@"Inbox");
}

- (IBAction)doSync:(id)sender {
    NSLog(@"Refresh");
    CABasicAnimation *halfTurn;
    halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn.fromValue = [NSNumber numberWithFloat:0];
    halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn.duration = 1.2;
    halfTurn.repeatCount = 1;
    [sender addAnimation:halfTurn forKey:@"180"];
    [self fetchData];
}

- (IBAction)toAdmin:(id)sender {
    NSLog(@"ADMIN VIEW");
    CBAdminSelectViewController *adminController = [[CBAdminSelectViewController alloc] init];
    adminController.delegate = delegate;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:adminController];
    navController.navigationBar.tintColor = [UIColor blackColor];
    [delegate setRootViewController:navController];
}

- (void)fetchData {
    NSLog(@"Fetch data");
    if (user&&schedule) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSWeekCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate:date];
        
        [schedule getLecturesOfWeek:user currentWeek:[components week]];
        [schedule getNotesOfWeekAndMessages:user currentWeek:[components week]];
        [schedule sortLecturesByVersionAndTime];
        NSLog(@"%d %d %d %d %d", [[[[schedule getWeekLectures] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:1] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:2] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:3] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:4] objectForKey:@"LECTURES"] count]);
    }
    else {
        NSLog(@"User or ScheduleService not initiated");
    }
}

@end
