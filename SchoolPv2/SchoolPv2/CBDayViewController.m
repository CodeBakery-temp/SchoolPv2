#import "CBDayViewController.h"
#import "CBWeekViewController.h"

@implementation CBDayViewController

@synthesize delegate;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        UIBarButtonItem *inboxButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(inbox:)];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        NSArray *buttons = [[NSArray alloc] initWithObjects:inboxButton, refreshButton, nil];
        [toolbar setItems:buttons];
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

/*- (void)viewDidLoad
 {
 [super viewDidLoad];
 UINib *nib = [UINib nibWithNibName:@"CBWeekViewCell" bundle:nil];
 [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBWeekViewCell"];
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 return [[[weekDays objectAtIndex:section] objectForKey:@"LECTURES"] count]+1;
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
 [[cell dayLabel] setText:[[weekDays objectAtIndex:[indexPath section]] objectForKey:@"DAY"]];
 [[cell courseLabel] setText:@""];
 [[cell startLabel] setText:@""];
 [[cell stopLabel] setText:@""];
 return cell;
 }
 else {
 // COURSE OBJECTS
 NSArray *lectures = [[weekDays objectAtIndex:[indexPath section]] objectForKey:@"LECTURES"];
 CBLecture *lec = [lectures objectAtIndex:([indexPath row]-1)];
 [[cell dayLabel] setText:@""];
 [[cell courseLabel] setText: [lec course]];
 [[cell startLabel] setText: [NSString stringWithFormat:@"%@ -", [lec startTime]]];
 [[cell stopLabel] setText: [NSString stringWithFormat:@"%@", [lec stopTime]]];
 return cell;
 }
 return nil;
 }*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation==UIInterfaceOrientationPortrait||
        fromInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
        CBWeekViewController *weekController = [[CBWeekViewController alloc] init];
        weekController.delegate = delegate;
        [delegate setRootViewController:weekController];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
