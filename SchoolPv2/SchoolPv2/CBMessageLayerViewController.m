#import "CBMessageLayerViewController.h"
#import "CBMessageViewController.h"
#import "CBDayViewController.h"

@interface CBMessageLayerViewController ()
{
    CBMessageViewController *inbox;
}

@end

@implementation CBMessageLayerViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Messages"];
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
    inbox = [[CBMessageViewController alloc] init];
    [_messageTable addSubview:inbox.view];
}

- (void)exitAdmin:(id)sender
{
    CBDayViewController *dayController = [[CBDayViewController alloc] init];
    dayController.delegate = delegate;
    [delegate setRootViewController:dayController];
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
