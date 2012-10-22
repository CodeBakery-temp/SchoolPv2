#import "CBAdminSelectViewController.h"
#import "CBAdminCourseViewController.h"
#import "CBDayViewController.h"

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
    NSLog(@"DAY VIEW");
    CBDayViewController *dayController = [[CBDayViewController alloc] init];
    dayController.delegate = delegate;
    [delegate setRootViewController:dayController];
}

- (IBAction)toCourses:(id)sender
{
    NSLog(@"LECTURES");
    CBAdminCourseViewController *lectureList = [[CBAdminCourseViewController alloc] init];
    [[self navigationController] pushViewController:lectureList animated:YES];
}

- (IBAction)toNotes:(id)sender
{
    NSLog(@"NOTES");
}

- (IBAction)toMessages:(id)sender
{
    NSLog(@"MESSAGES");
}
@end
