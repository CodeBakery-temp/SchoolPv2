#import "CBDayLectureViewController.h"
#import "CBDayNoteViewController.h"
#import "CBScheduleService.h"
#import "CBDayViewCell.h"
#import "CBLecture.h"

@interface CBDayLectureViewController ()
{
    CBScheduleService *schedule;
    CBDayNoteViewController *noteTable;
    CBDayNoteViewController *dayNotes;
    NSDictionary *list;
    BOOL postit;
}

@end

@implementation CBDayLectureViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        schedule = [CBScheduleService schedule];
        
        list = [schedule getDayLectures];
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
    UINib *nib = [UINib nibWithNibName:@"CBDayViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CBDayViewCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize lectureView;
    NSLog(@"Postit: %d", postit);
    lectureView = CGSizeMake(320, (([[list objectForKey:@"LECTURES"] count])*70)+500);
    [self.tableView setContentSize:lectureView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[list objectForKey:@"LECTURES"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBDayViewCell"];
    CBLecture *lec = [[list objectForKey:@"LECTURES"] objectAtIndex:[indexPath row]];
    [[cell courseLabel] setText:[lec course]];
    [[cell teacherLabel] setText:[lec teacher]];
    [[cell roomLabel] setText:[lec room]];
    [[cell startLabel] setText: [lec startTime]];
    [[cell stopLabel] setText: [lec stopTime]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
