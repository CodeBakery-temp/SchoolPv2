#import "CBWeekLayerViewController.h"
#import "CBDayViewController.h"
#import "CBDayLectureViewController.h"
#import "CBDayNoteViewController.h"
#import "CBScheduleService.h"
#import "CBDatabaseService.h"
#import "CBUser.h"
#import "CBAdminSelectViewController.h"
#import "CBAdminCourseViewController.h"
#import "CBMessageLayerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CBDayViewController ()
{
    CBDayLectureViewController *dayLectures;
    CBDayNoteViewController *dayNotes;
    CBDatabaseService *db;
    CBScheduleService *schedule;
    NSMutableDictionary *user;
    NSDictionary *allUsersDict;
    int displayedDay;
    NSURL *scriptUrl;
    BOOL findUser;
}

@end

@implementation CBDayViewController

@synthesize delegate;
@synthesize alertView;
@synthesize refreshBlock;

- (id)init
{
    self = [super init];
    if (self) {
        scriptUrl = [NSURL URLWithString:@"http://zephyr.iriscouch.com"];
        schedule = [CBScheduleService schedule];
        displayedDay = [schedule getWeekDay];
        dayLectures = [[CBDayLectureViewController alloc] init];
        dayNotes = [[CBDayNoteViewController alloc] init];
        db = [CBDatabaseService database];
        
        user = [[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolP_user"];
        NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
        if (data != nil) {
            allUsersDict = [db getUsers];
            if (user) {
                // If logged in, get user
                for (CBUser *admin in [allUsersDict objectForKey:@"ADMIN"]) {
                    if ([[admin mailAddress]isEqualToString:[user objectForKey:@"MAIL"]]) {
                        NSMutableDictionary *tempUser = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                         [admin firstName], @"FORNAME",
                                                         [admin lastName], @"SURNAME",
                                                         [admin mailAddress], @"MAIL",
                                                         @"ADMIN", @"TYPE", nil];
                        [[NSUserDefaults standardUserDefaults] setObject:tempUser forKey:@"SchoolP_user"];
                        [[NSUserDefaults standardUserDefaults] setObject:[admin courses] forKey:@"SchoolP_userCourses"];
                        user = tempUser;
                        [user setObject:[admin courses] forKey:@"COURSES"];
                        findUser =TRUE;
                        break;
                    }
                }
                if (!findUser) {
                    for (CBUser *student in [allUsersDict objectForKey:@"STUDENT"]) {
                        if ([[student mailAddress]isEqualToString:[user objectForKey:@"MAIL"]]) {
                            NSMutableDictionary *tempUser = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                             [student firstName], @"FORNAME",
                                                             [student lastName], @"SURNAME",
                                                             [student mailAddress], @"MAIL",
                                                             @"STUDENT", @"TYPE", nil];
                            [[NSUserDefaults standardUserDefaults] setObject:tempUser forKey:@"SchoolP_user"];
                            [[NSUserDefaults standardUserDefaults] setObject:[student courses] forKey:@"SchoolP_userCourses"];
                            user = tempUser;
                            [user setObject:[student courses] forKey:@"COURSES"];
                            findUser =TRUE;
                            break;
                        }
                    }
                }
            }
        }
        else {
            if (user) {
                user = [[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolP_user"];
                [user setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolP_userCourses"] forKey:@"COURSES"];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data&&[[user objectForKey:@"TYPE"] isEqualToString:@"ADMIN"])
        _adminButton.hidden =FALSE;
    else
        _adminButton.hidden =TRUE;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolP_user"]) {
        alertView = [[UIAlertView alloc] init];
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        alertView.title = @"Login";
        [[self.alertView textFieldAtIndex:0] setDelegate:self];
        [alertView show];
    }
    [_dayLabel setText:[[schedule getDayLectures:0] objectForKey:@"DAY"]];
    [_lectureTable addSubview:dayLectures.view];
    [_noteTable addSubview:dayNotes.view];
    UIFont *crayonFont = [UIFont fontWithName:@"DK Crayon Crumble" size:20];
    _dayLabel.font = crayonFont;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (CBUser *admin in [allUsersDict objectForKey:@"ADMIN"]) {
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:[admin mailAddress]]&&
            [[[alertView textFieldAtIndex:1] text] isEqualToString:[admin password]]) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            NSMutableDictionary *tempUser = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             [admin firstName], @"FORNAME",
                                             [admin lastName], @"SURNAME",
                                             [admin mailAddress], @"MAIL",
                                             @"ADMIN", @"TYPE", nil];
            [[NSUserDefaults standardUserDefaults] setObject:tempUser forKey:@"SchoolP_user"];
            [[NSUserDefaults standardUserDefaults] setObject:[admin courses] forKey:@"SchoolP_userCourses"];
            user = tempUser;
            [user setObject:[admin courses] forKey:@"COURSES"];
            findUser =TRUE;
            break;
        }
    }
    if (!findUser) {
        for (CBUser *student in [allUsersDict objectForKey:@"STUDENT"]) {
            if ([[[alertView textFieldAtIndex:0] text] isEqualToString:[student mailAddress]]&&
                [[[alertView textFieldAtIndex:1] text] isEqualToString:[student password]]) {
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                NSMutableDictionary *tempUser = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 [student firstName], @"FORNAME",
                                                 [student lastName], @"SURNAME",
                                                 [student mailAddress], @"MAIL",
                                                 @"STUDENT", @"TYPE", nil];
                [[NSUserDefaults standardUserDefaults] setObject:tempUser forKey:@"SchoolP_user"];
                [[NSUserDefaults standardUserDefaults] setObject:[student courses] forKey:@"SchoolP_userCourses"];
                user = tempUser;
                [user setObject:[student courses] forKey:@"COURSES"];
                findUser =TRUE;
                break;
            }
        }
    }
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data&&user) {
        if ([[user objectForKey:@"TYPE"] isEqualToString:@"ADMIN"])
            _adminButton.hidden =FALSE;
        else
            _adminButton.hidden =TRUE;
    }
    else {
        [[alertView textFieldAtIndex:0] setText:@""];
        [[alertView textFieldAtIndex:1] setText:@""];
    }
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation==UIInterfaceOrientationPortrait||
        fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
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
        _noteView.hidden =FALSE;
    else
        _noteView.hidden =TRUE;
}

- (IBAction)toInbox:(id)sender {
    CBMessageLayerViewController *messageView = [[CBMessageLayerViewController alloc] init];
    messageView.delegate = delegate;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:messageView];
    navController.navigationBar.tintColor = [UIColor blackColor];
    navController.navigationBar.alpha =0.8f;
    navController.navigationBar.translucent = YES;
    [delegate setRootViewController:navController];
}

- (IBAction)doSync:(id)sender {
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data != nil) {
        CABasicAnimation *halfTurn;
        halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        halfTurn.fromValue = [NSNumber numberWithFloat:0];
        halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/-180)];
        halfTurn.duration = 1.2;
        halfTurn.repeatCount = 1;
        [sender addAnimation:halfTurn forKey:@"180"];
        [self requestData];
    }
    else
        NSLog(@"No internet!");
}

- (IBAction)toAdmin:(id)sender {
    CBAdminSelectViewController *adminController = [[CBAdminSelectViewController alloc] init];
    adminController.delegate = delegate;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:adminController];
    navController.navigationBar.tintColor = [UIColor blackColor];
    [delegate setRootViewController:navController];
}

- (IBAction)handleSwipe:(UIGestureRecognizer*)sender {
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    if (direction==UISwipeGestureRecognizerDirectionLeft) {
        if (displayedDay<5) {
            displayedDay +=1;
        }
    }
    else if (direction==UISwipeGestureRecognizerDirectionRight) {
        if (displayedDay>1) {
            displayedDay -=1;
        }
    }
    [_dayLabel setText:[[schedule getDayLectures:displayedDay] objectForKey:@"DAY"]];
    [dayLectures refreshTable:displayedDay];
    [dayNotes refreshTable:displayedDay];
}

- (void)requestData {
    if (user&&schedule) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSWeekCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate:date];
        
        [schedule getLecturesOfWeek:user currentWeek:[components week]];
        [schedule getNotesOfWeekAndMessages:user currentWeek:[components week]];
        [schedule sortLecturesByVersionAndTime];
        /*NSLog(@"LECT: %d %d %d %d %d",
              [[[[schedule getWeekLectures] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:1] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:2] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:3] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekLectures] objectAtIndex:4] objectForKey:@"LECTURES"] count]);
        NSLog(@"NOTE: %d %d %d %d %d",
              [[[[schedule getWeekNotes] objectAtIndex:0] objectForKey:@"LECTURES"] count],
              [[[[schedule getWeekNotes] objectAtIndex:1] objectForKey:@"NOTES"] count],
              [[[[schedule getWeekNotes] objectAtIndex:2] objectForKey:@"NOTES"] count],
              [[[[schedule getWeekNotes] objectAtIndex:3] objectForKey:@"NOTES"] count],
              [[[[schedule getWeekNotes] objectAtIndex:4] objectForKey:@"NOTES"] count]);*/
        [_dayLabel setText:[[schedule getDayLectures:displayedDay] objectForKey:@"DAY"]];
        [dayLectures refreshTable:displayedDay];
        [dayNotes refreshTable:displayedDay];
        BOOL save = [schedule saveChanges];
        if (save)
            NSLog(@"SAVED");
        else
            NSLog(@"SAVE FAILED");
    }
    else {
        NSLog(@"User or ScheduleService not initiated");
    }
}


@end
