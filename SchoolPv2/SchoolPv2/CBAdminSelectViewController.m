#import "CBAdminSelectViewController.h"
#import "CBAdminCourseViewController.h"
#import "CBDayViewController.h"
#import "CBAdminNoteCreateViewController.h"
#import "CBAdminCreateMessageViewController.h"

@interface CBAdminSelectViewController ()

@end

@implementation CBAdminSelectViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Admin"];
        UIBarButtonItem *buttonExit = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Exit"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(exitAdmin:)];
        [[self navigationItem] setLeftBarButtonItem:buttonExit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)exitAdmin:(id)sender
{
    CBDayViewController *dayController = [[CBDayViewController alloc] init];
    dayController.delegate = delegate;
    [delegate setRootViewController:dayController];
}

- (IBAction)toCourses:(id)sender
{
    CBAdminCourseViewController *lectureList = [[CBAdminCourseViewController alloc] init];
    [[self navigationController] pushViewController:lectureList animated:YES];
}

- (IBAction)toNotes:(id)sender
{
    CBAdminNoteCreateViewController *noteCreate = [[CBAdminNoteCreateViewController alloc]init];
    [[self navigationController] pushViewController:noteCreate animated:YES];
}

- (IBAction)toMessages:(id)sender
{
    CBAdminCreateMessageViewController *messageCreate = [[CBAdminCreateMessageViewController alloc]init];
    [[self navigationController] pushViewController:messageCreate animated:YES];
}
@end
