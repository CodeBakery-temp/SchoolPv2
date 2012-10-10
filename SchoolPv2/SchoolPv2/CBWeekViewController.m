
#import "CBDatabaseService.h"
#import "CBScheduleService.h"
#import "CBWeekViewController.h"
#import "CBDayViewController.h"
#import "CBLecture.h"
#import "CBNote.h"
#import "CBUser.h"
#import "CBMessage.h"

@implementation CBWeekViewController
{
    CBUser *user;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        userName = @"nordin.christoffer@gmail.com";
        CBDatabaseService *db = [CBDatabaseService database];
        NSMutableArray *users = [[db getUsers] objectForKey:@"STUDENT"];
        for(CBUser* u in users) {
            if ([[u mailAddress] isEqualToString:userName]) {
                user = u;
            }
        }
        CBScheduleService *schedule = [CBScheduleService schedule];
        NSDictionary *lecturesDays = [schedule getLecturesPerDays:[schedule getLecturesOfWeek:user currentWeek:41]];
        
        NSMutableArray *mondayList = [lecturesDays objectForKey:@"MONDAY"];
        NSLog(@"%d", [mondayList count]);
        NSMutableDictionary *mondayDict = [NSMutableDictionary dictionaryWithObject:mondayList forKey:@"LECTURES"];
        [mondayDict setObject:@"MONDAY" forKey:@"DAY"];
        NSMutableArray *tuesdayList = [lecturesDays objectForKey:@"TUESDAY"];
        NSLog(@"%d", [tuesdayList count]);
        NSMutableDictionary *tuesdayDict = [NSMutableDictionary dictionaryWithObject:tuesdayList forKey:@"LECTURES"];
        [tuesdayDict setObject:@"TUESDAY" forKey:@"DAY"];
        NSMutableArray *wednesdayList = [lecturesDays objectForKey:@"WEDNESDAY"];
        NSLog(@"%d", [wednesdayList count]);
        NSMutableDictionary *wednesdayDict = [NSMutableDictionary dictionaryWithObject:wednesdayList forKey:@"LECTURES"];
        [wednesdayDict setObject:@"WEDNESDAY" forKey:@"DAY"];
        NSMutableArray *thursdayList = [lecturesDays objectForKey:@"THURSDAY"];
        NSLog(@"%d", [thursdayList count]);
        NSMutableDictionary *thursdayDict = [NSMutableDictionary dictionaryWithObject:thursdayList forKey:@"LECTURES"];
        [thursdayDict setObject:@"THURSDAY" forKey:@"DAY"];
        NSMutableArray *fridayList = [lecturesDays objectForKey:@"FRIDAY"];
        NSLog(@"%d", [fridayList count]);
        NSMutableDictionary *fridayDict = [NSMutableDictionary dictionaryWithObject:fridayList forKey:@"LECTURES"];
        [fridayDict setObject:@"FRIDAY" forKey:@"DAY"];
        
        weekDays = [[NSMutableArray alloc] initWithObjects:mondayDict, tuesdayDict, wednesdayDict, thursdayDict, fridayDict, nil];
        
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Scheduler"];
        UIBarButtonItem *inboxButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(toInbox:)];
        [item setRightBarButtonItem:inboxButton];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
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
    UITableViewCell *cell;
    if ([indexPath row]==0) {
        // DAY HEADER
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [[cell textLabel] setText:[[weekDays objectAtIndex:[indexPath section]] objectForKey:@"DAY"]];
    }
    else {
        // COURSE OBJECTS
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        NSArray *lectures = [[weekDays objectAtIndex:[indexPath section]] objectForKey:@"LECTURES"];
        CBLecture *lec = [lectures objectAtIndex:([indexPath row]-1)];
        [[cell textLabel] setText: [lec course]];
        [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@ - %@", [lec startTime], [lec stopTime]]];
    }
    return cell;
    
    /*static NSString *cellId = @"CNFriendListCell";
     NSArray *array = [[[[CNFriendManager manager] allFriends] objectAtIndex:[indexPath section]] objectForKey:@"list"];
     CNFriend *entry = [array objectAtIndex:[indexPath row]];
     
     if(([indexPath section]==0)||[[[CNFriendManager manager] allFriends] count]>0) {
     CNFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
     [[cell nameLabel] setText:[entry name]];
     [[cell idLabel] setText:[NSString stringWithFormat:@"ID: %@",[entry phone]]];
     [cell setController:self];
     [cell setIndexPath:indexPath];
     if([indexPath section]==0)
     cell.showLabel.hidden =YES;
     if([[entry show]isEqualToString:@"YES"])
     [[cell showLabel] setImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateNormal];
     else
     [[cell showLabel] setImage:[UIImage imageNamed:@"button_off.png"] forState:UIControlStateNormal];
     return cell;*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBDayViewController *dayController = [[CBDayViewController alloc] init];
    
    //NSArray *array = [[[[CNFriendManager manager] allFriends] objectAtIndex:[indexPath section]] objectForKey:@"list"];
    //CNFriend *f = [array objectAtIndex:[indexPath row]];
    //[addFriendController setPerson:f];
    
    [[self navigationController] pushViewController:dayController animated:YES];
}

@end
