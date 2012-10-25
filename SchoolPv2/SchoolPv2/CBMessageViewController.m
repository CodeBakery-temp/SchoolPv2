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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"CBMessageCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBMessageCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBMessageCell"];
    CBMessage *message = [messages objectAtIndex:[indexPath row]];
    [[cell senderTextLabel] setText:[message sender]];
    [[cell messageTextField] setText:[message text]];
    //CBMessage *message = [messages objectAtIndex:[indexPath row]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

@end