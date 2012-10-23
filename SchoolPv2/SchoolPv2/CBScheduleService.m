#import "CBDatabaseService.h"
#import "CBScheduleService.h"
#import "CBUser.h"
#import "CBLecture.h"
#import "CBNote.h"
#import "CBMessage.h"

@implementation CBScheduleService {
    CBDatabaseService* db;
}

+ (CBScheduleService *)schedule
{
    // Singleton
    static CBScheduleService *schedule = nil;
    if (!schedule) {
        schedule = [[super allocWithZone:nil] init];
    }
    return schedule;
}

+ (id)createSchedule
{
    return [self schedule];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self schedule];
}

- (id)init
{
    return [self initSchedule];
}

- (id)initSchedule
{
    if(self = [super init])
    {
        db = [CBDatabaseService database];
        
        NSMutableDictionary *mondayDict = [NSMutableDictionary dictionaryWithObject:@"MONDAY" forKey:@"DAY"];
        NSMutableArray *mondayList = [[NSMutableArray alloc] init];
        [mondayDict setObject:mondayList forKey:@"LECTURES"];
        NSMutableDictionary *tuesdayDict = [NSMutableDictionary dictionaryWithObject:@"TUESDAY" forKey:@"DAY"];
        NSMutableArray *tuesdayList = [[NSMutableArray alloc] init];
        [tuesdayDict setObject:tuesdayList forKey:@"LECTURES"];
        NSMutableDictionary *wednesdayDict = [NSMutableDictionary dictionaryWithObject:@"WEDNESDAY" forKey:@"DAY"];
        NSMutableArray *wednesdayList = [[NSMutableArray alloc] init];
        [wednesdayDict setObject:wednesdayList forKey:@"LECTURES"];
        NSMutableDictionary *thursdayDict = [NSMutableDictionary dictionaryWithObject:@"THURSDAY" forKey:@"DAY"];
        NSMutableArray *thursdayList = [[NSMutableArray alloc] init];
        [thursdayDict setObject:thursdayList forKey:@"LECTURES"];
        NSMutableDictionary *fridayDict = [NSMutableDictionary dictionaryWithObject:@"FRIDAY" forKey:@"DAY"];
        NSMutableArray *fridayList = [[NSMutableArray alloc] init];
        [fridayDict setObject:fridayList forKey:@"LECTURES"];
        
        weekLectures = [[NSMutableArray alloc] initWithObjects:mondayDict, tuesdayDict, wednesdayDict, thursdayDict, fridayDict, nil];
        
        NSMutableDictionary *mondayNoteDict = [NSMutableDictionary dictionaryWithObject:@"MONDAY" forKey:@"DAY"];
        NSMutableArray *mondayNoteList = [[NSMutableArray alloc] init];
        [mondayNoteDict setObject:mondayNoteList forKey:@"NOTES"];
        NSMutableDictionary *tuesdayNoteDict = [NSMutableDictionary dictionaryWithObject:@"TUESDAY" forKey:@"DAY"];
        NSMutableArray *tuesdayNoteList = [[NSMutableArray alloc] init];
        [tuesdayNoteDict setObject:tuesdayNoteList forKey:@"NOTES"];
        NSMutableDictionary *wednesdayNoteDict = [NSMutableDictionary dictionaryWithObject:@"WEDNESDAY" forKey:@"DAY"];
        NSMutableArray *wednesdayNoteList = [[NSMutableArray alloc] init];
        [wednesdayNoteDict setObject:wednesdayNoteList forKey:@"NOTES"];
        NSMutableDictionary *thursdayNoteDict = [NSMutableDictionary dictionaryWithObject:@"THURSDAY" forKey:@"DAY"];
        NSMutableArray *thursdayNoteList = [[NSMutableArray alloc] init];
        [thursdayNoteDict setObject:thursdayNoteList forKey:@"NOTES"];
        NSMutableDictionary *fridayNoteDict = [NSMutableDictionary dictionaryWithObject:@"FRIDAY" forKey:@"DAY"];
        NSMutableArray *fridayNoteList = [[NSMutableArray alloc] init];
        [fridayNoteDict setObject:fridayNoteList forKey:@"NOTES"];
        
        weekNotes = [[NSMutableArray alloc] initWithObjects:mondayNoteDict, tuesdayNoteDict, wednesdayNoteDict, thursdayNoteDict, fridayNoteDict, nil];
    }
    return self;
}

- (NSArray *)getWeekLectures
{
    return weekLectures;
}

- (NSDictionary *)getDayLectures:(int)day
{
    if (day==0) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSWeekdayCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate:date];
        day =([components weekday]-1);
        if (day==0)
            day =7;
    }
    if (day>5)
        return [weekLectures objectAtIndex:4];
    else
        return [weekLectures objectAtIndex:(day-1)];
}

- (NSArray *)getWeekNotes
{
    return weekNotes;
}

- (NSDictionary *)getDayNotes:(int)day
{
    if (day==0) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSWeekdayCalendarUnit;
        NSDateComponents *components = [calendar components:units fromDate:date];
        day =[components weekday]-1;
        if (day==0)
            day =7;
    }
    if (day>5)
        return [weekNotes objectAtIndex:4];
    else
        return [weekNotes objectAtIndex:(day-1)];
}

- (NSArray *)getMessages
{
    return messages;
}

/*********************************************************************
 METHOD : GET ALL USER'S LECTURE OBJECTS BY USER-DATA AND CURRENT WEEK
 ACCEPTS: Student/Admin object, NSUInteger of current week
 RESULT : weekLectures has LECTURES sorts in MONDAY - FRIDAY
 *********************************************************************/
- (void)getLecturesOfWeek:(CBUser *)user currentWeek:(NSUInteger)currentWeek
{
    NSArray* lectures = [db getLectures];
    NSMutableArray* userLectures = [NSMutableArray array];
    // SORT OUT WEEK LECTURES
    for(NSString* courseID in [user courses]) {
        for(CBLecture* lecture in lectures) {
            if([courseID isEqualToString:[lecture courseID]]) {
                for(NSString* week in [lecture weeks]) {
                    if([week isEqualToString:[NSString stringWithFormat:@"%d", currentWeek]]) {
                        [userLectures addObject:lecture];
                    }
                }
            }
        }
    }
    for (int i=0; i<5; i++) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [[weekLectures objectAtIndex:i] setObject:list forKey:@"LECTURES"];
    }
    // SORT LECTURES TO DAYS
    for (int day=0; day<5; day++) {
        for (CBLecture* lecture in userLectures) {
            for (NSString* weekDay in [lecture daysOfWeek]) {
                if(![weekDay caseInsensitiveCompare:[[weekLectures objectAtIndex:day] objectForKey:@"DAY"]]) {
                    [[[weekLectures objectAtIndex:day] objectForKey:@"LECTURES"] addObject:lecture];
                }
            }
        }
    }
}

/*********************************************************************
 METHOD : SORT weekLectures by VERSION and TIME
 ACCEPTS: Student/Admin object, NSUInteger of current week
 RESULT : Stores LECTURES sorted in MONDAY-FRIDAY in NSArray weekLectures
 *********************************************************************/
- (void)sortLecturesByVersionAndTime
{
    NSMutableArray *mondayList = [[NSMutableArray alloc] init];
    NSMutableArray *tuesdayList = [[NSMutableArray alloc] init];
    NSMutableArray *wednesdayList = [[NSMutableArray alloc] init];
    NSMutableArray *thursdayList = [[NSMutableArray alloc] init];
    NSMutableArray *fridayList = [[NSMutableArray alloc] init];
    NSMutableArray *lecturesDays = [[NSMutableArray alloc]
                                    initWithObjects:mondayList, tuesdayList, wednesdayList, thursdayList, fridayList, nil];
    // SELECT BY VERSION
    for (int day=0; day<5; day++) {
        int top = 0;
        for (CBLecture* lec in [[weekLectures objectAtIndex:day] objectForKey:@"LECTURES"]) {
            if ([[lec courseID] intValue]>top) {
                top = [[lec courseID] intValue];
            }
        }
        NSInteger COURSENUM = top;
        for (NSInteger CURRENTCOURSE=1; CURRENTCOURSE<=COURSENUM; CURRENTCOURSE++) {
            int versionTop = 0;
            CBLecture *lecture = [CBLecture alloc];
            for (CBLecture *lec in [[weekLectures objectAtIndex:day] objectForKey:@"LECTURES"]) {
                if ([[lec courseID]isEqualToString:[NSString stringWithFormat:@"%d",CURRENTCOURSE]]
                    &&[[lec version] intValue]>versionTop) {
                    versionTop = [[lec version] intValue];
                    lecture = [lecture initCourseWithName:[lec course]                                                    
                                                  teacher:[lec teacher]
                                                     room:[lec room]
                                                 courseID:[lec courseID]
                                                  version:[lec version]
                                                startTime:[lec startTime]
                                                 stopTime:[lec stopTime]
                                                     year:[lec year]
                                               daysOfWeek:[lec daysOfWeek]
                                                    weeks:[lec weeks]
                                                couchDBId:[lec couchDBId]
                                               couchDBRev:[lec couchDBRev]];
                }
            }
            if ([lecture courseID]) {
                [[lecturesDays objectAtIndex:day] addObject:lecture];
            }
        }
    }
    for (int b =0; b<5; b++) {
        [[weekLectures objectAtIndex:b] removeObjectForKey:@"LECTURES"];
    }
    // SORT BY TIME
    for (int i=0; i<5; i++) {
        NSArray *list = [[lecturesDays objectAtIndex:i] sortedArrayUsingComparator:^(CBLecture* lec1, CBLecture* lec2) {
            int time1 = [self timeStringToTimeInt:[lec1 startTime]];
            int time2 = [self timeStringToTimeInt:[lec2 startTime]];
            return time1>time2;
        }];
        [[weekLectures objectAtIndex:i] setObject:list forKey:@"LECTURES"];
    }
}

/*********************************************************************
 METHOD : GET ALL USER'S NOTE OBJECTS BY USER-DATA AND CURRENT WEEK AND MESSAGES
 ACCEPTS: Student/Admin object, NSUInteger of current week
 RESULT : weekNotes has NOTES sorts in MONDAY - FRIDAY, messages is populated
 *********************************************************************/
- (void)getNotesOfWeekAndMessages:(CBUser *)user currentWeek:(NSUInteger)currentWeek
{
    NSDictionary *notifications = [db getNotifications];
    NSArray* notes = [notifications objectForKey:@"NOTES"];
    messages = [notifications objectForKey:@"MESSAGES"];
    NSMutableArray* userNotes = [NSMutableArray array];
    // SORT OUT WEEK NOTES
    for(NSString* courseID in [user courses]) {
        for(CBNote* note in notes) {
            if([courseID isEqualToString:[note courseID]]) {
                if([[note week] isEqualToString:[NSString stringWithFormat:@"%d", currentWeek]]) {
                    [userNotes addObject:note];
                }
            }
        }
    }
    // SORT NOTES TO DAYS
    for (int day=0; day<5; day++) {
        for (CBNote* note in userNotes) {
            if(![[note day] caseInsensitiveCompare:[[weekNotes objectAtIndex:day] objectForKey:@"DAY"]]) {
                [[[weekNotes objectAtIndex:day] objectForKey:@"NOTES"] addObject:note];
            }
        }
    }
    
}

/*********************************************************************
 METHOD : CREATE LECTURE TEMPLATE OBJECT
 ACCEPTS: CBLECTURE object
 RESULT:  Send LECTURE object to DATABASE
 *********************************************************************/
- (void)createLecture:(NSDictionary*)dict
{
    int objID = 1;
    NSArray* lectures = [db getLectures];
    for (CBLecture* lec in lectures) {
        if([[lec courseID] intValue]>objID) {
            objID = [[lec courseID] intValue];
        }
    }
    int idInt = objID;
    idInt +=1;
    objID = idInt;
    NSDictionary *lecture = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [dict objectForKey:@"COURSE"], @"course",
                          [dict objectForKey:@"TEACHER"], @"teacher",
                          [dict objectForKey:@"ROOM"], @"room",
                          [NSString stringWithFormat:@"%d", objID], @"courseID",
                          @"1", @"version",
                          [dict objectForKey:@"START"], @"startTime",
                          [dict objectForKey:@"STOP"], @"stopTime",
                          [dict objectForKey:@"YEAR"], @"year",
                          [dict objectForKey:@"DAYS"], @"daysOfWeek",
                          [dict objectForKey:@"WEEKS"], @"weeks",
                          nil];
    NSString* result = [db lectureToDataBase:lecture];
    NSLog(@"CREATE ID: %@ RESULT: %@", [lecture objectForKey:@"COURSEID"], result);
}

/*********************************************************************
 METHOD : CREATE NOTE OBJECT
 ACCEPTS: CBNOTE object
 RESULT:  Send NOTE object to DATABASE
 *********************************************************************/
- (void)createNote:(NSDictionary *)dict
{
    NSDictionary *note = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [dict objectForKey:@"TEXT"], @"text",
                          [dict objectForKey:@"WEEK"], @"week",
                          [dict objectForKey:@"DAY"], @"day",
                          [dict objectForKey:@"COURSEID"], @"courseID",
                          @"note", @"type",
                          nil];
    NSString* result = [db noteToDataBase:note];
    NSLog(@"RESULT: %@", result);
}

/*********************************************************************
 METHOD : CREATE MESSAGE OBJECT
 ACCEPTS: CBMESSAGE object
 RESULT:  Send MESSAGE object to DATABASE
 *********************************************************************/
- (void)createMessage:(NSDictionary *)dict
{
    NSDictionary *message = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [dict objectForKey:@"SENDER"], @"sender",
                             [dict objectForKey:@"RECEIVER"], @"receiver",
                             [dict objectForKey:@"TEXT"], @"text",
                             @"message", @"type",
                             nil];
    NSString* result = [db messageToDataBase:message];
    NSLog(@"RESULT: %@", result);
}

/*********************************************************************
 METHOD : UPDATE LECTURE OBJECT TEMPLATE WITH VERSION 1
 ACCEPTS: CBLECTURE object
 RESULT: CBLECTURE template is updated in database
 *********************************************************************/
-(void)updateLectureTemplate:(CBLecture*)lecture
{
    /*if ([lecture couchDBId]&&[lecture couchDBRev]) {
        [db lectureToDataBase:lecture];
    }
    else {
        NSLog(@"Object is not previously registered in database.");
    }*/
}

/*********************************************************************
 METHOD : UPDATE LECTURE OBJECT - CREATE MODIFIED INSTANCE OR EDIT INSTANCE
 ACCEPTS: CBLECTURE object
 RESULT: Send CBLECTURE event to database
 *********************************************************************/
-(void)updateLectureEvent:(CBLecture*)lecture
{
    
}

/*-(void)updateLectureEvent:(NSString*)jsonPath {
 
 NSLog(@"%@ %@", [dict objectForKey:@"courseID"], [dict objectForKey:@"version"]);
 for(CBLecture* lec in lectures) {
 if([[lec courseID]isEqualToString:[dict objectForKey:@"courseID"]]&&[[lec version]isEqualToString:[dict objectForKey:@"version"]]) {
 if([[dict objectForKey:@"version"]isEqualToString:@"1"]) {
 // CREATE NEW EVENT
 // VERSION STAMP
 NSString* ver = @"1";
 for(CBLecture* lec in lectures) {
 if([[lec courseID]isEqualToString:[dict objectForKey:@"courseID"]]&&[[lec version]isGreaterThan:ver]) {
 ver = [lec version];
 }
 }
 int verInt = [ver intValue];
 verInt +=1;
 ver = [NSString stringWithFormat:@"%d", verInt];
 [dict setObject:[lec courseID] forKey:@"courseID"];
 [dict setObject:ver forKey:@"version"];
 NSLog(@"ID: %@ WITH VERSION: %@", [dict objectForKey:@"courseID"], [dict objectForKey:@"version"]);
 [db lectureToDataBase:dict];
 
 }
 else {
 // EDIT EXISTING EVENT
 [dict setObject:[lec couchDBId] forKey:@"_id"];
 [dict setObject:[lec couchDBRev] forKey:@"_rev"];
 [dict setObject:[lec courseID] forKey:@"courseID"];
 [dict setObject:[lec version] forKey:@"version"];
 [db lectureToDataBase:dict];
 }
 break;
 }
 }
 }*/

/*********************************************************************
 METHOD : CONVERT STRING TIME XX:XX to INT TIME XXXX
 ACCEPTS: NSString with time separated with comma
 RETURNS: int with time in digits
 *********************************************************************/
- (int)timeStringToTimeInt:(NSString *)stringNum
{
    NSArray *timeArray = [stringNum componentsSeparatedByString:@":"];
    NSString *time = [[timeArray objectAtIndex:0] stringByAppendingString:[timeArray objectAtIndex:1]];
    return [time intValue];
}

@end
