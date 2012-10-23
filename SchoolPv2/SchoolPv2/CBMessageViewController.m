#import "CBMessageViewController.h"
#import "CBMessageCell.h"
#import "CBScheduleService.h"
#import "CBMessage.h"
#import "CBDayViewController.h"

@interface CBMessageViewController ()

@end

@implementation CBMessageViewController
{
    CBScheduleService *schedule;
    NSMutableArray *messages;
}
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        schedule = [CBScheduleService schedule];
        messages = [[NSMutableArray alloc] init];
        messages = [[schedule getMessages] mutableCopy];
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Messages"];
        UIBarButtonItem *buttonExit = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Exit"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(exitAdmin:)];
        [[self navigationItem] setLeftBarButtonItem:buttonExit];
        // Custom initialization
    }
    return self;
}

- (void)exitAdmin:(id)sender
{
    CBDayViewController *dayController = [[CBDayViewController alloc] init];
    dayController.delegate = delegate;
    [delegate setRootViewController:dayController];
//    CBDayViewController *lectureList = [[CBDayViewController alloc] init];
//    [[self navigationController] pushViewController:lectureList animated:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CBMessageCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBMessageCell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    
    CBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBMessageCell"];
    CBMessage *message = [messages objectAtIndex:[indexPath row]];
    [[cell senderTextLabel] setText:[message sender]];
    [[cell messageTextField] setText:[message text]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

@end

/*
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
}

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        schedule = [CBScheduleService schedule];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
*/