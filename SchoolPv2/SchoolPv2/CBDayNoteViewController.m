#import "CBDayNoteViewController.h"
#import "CBScheduleService.h"
#import "CBDayNoteCell.h"
#import "CBNote.h"

@interface CBDayNoteViewController ()
{
    CBScheduleService *schedule;
    NSMutableDictionary *list;
}

@end

@implementation CBDayNoteViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        //schedule = [CBScheduleService schedule];
        //list = [schedule getDayNotes];
        
        list = [[NSMutableDictionary alloc] init];
        [list setObject:@"THURSDAY" forKey:@"DAY"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<1; i++) {
            CBNote *note = [[CBNote alloc] initNoteWithText:@"Läs kapitel 24 tills i morgon. Bonus: gör övningarna till kapittlet" week:@"42" day:@"Thursday" courseID:@"3"];
            [array addObject:note];
        }
        [list setObject:array forKey:@"NOTES"];
        NSLog(@"NOTES: %d", [[list objectForKey:@"NOTES"] count]);
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
    
    UINib *nib = [UINib nibWithNibName:@"CBDayNoteCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBDayNoteCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize noteView = CGSizeMake(320, (([[list objectForKey:@"NOTES"] count])*10));
    [self.tableView setContentSize:noteView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[list objectForKey:@"NOTES"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBDayNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBDayNoteCell"];
    CBNote *note = [[list objectForKey:@"NOTES"] objectAtIndex:[indexPath row]];
    [[cell noteLabel] setText:[note text]];
    
    UIFont *handwritingFont = [UIFont fontWithName:@"Schoolbell" size:15];
    cell.noteLabel.font = handwritingFont;
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

@end
