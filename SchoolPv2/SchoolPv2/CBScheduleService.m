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

- (int)getWeekDay
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date];
    int day =([components weekday]-1);
    if (day==0)
        day =7;
    return day;
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
    NSArray* allMessages = [notifications objectForKey:@"MESSAGES"];
    NSMutableArray* userNotes = [NSMutableArray array];
    messages = [[NSMutableArray alloc] init];
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
    for (CBMessage* message in allMessages) {
        for (NSString *rece in [message receiver]) {
            if ([rece isEqual:[user mailAddress]]) {
                [messages addObject:message];
            }
        }
    }
    
}

/*********************************************************************
 METHOD : CREATE LECTURE TEMPLATE OBJECT
 ACCEPTS: CBLECTURE object
 RESULT:  Send LECTURE object to DATABASE
 *********************************************************************/
- (CBLecture*)createLecture:(NSDictionary*)dict
{
    int objID = 1;
    NSArray* lectures = [db getLectures];
    for (CBLecture* lec in lectures) {
        if([[lec courseID] intValue]>objID) {
            objID = [[lec courseID] intValue];
        }
    }
    objID +=1;
    NSDictionary *lecture = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%d", objID], @"courseID",
                             @"1", @"version",
                             [dict objectForKey:@"COURSE"], @"course",
                             [dict objectForKey:@"TEACHER"], @"teacher",
                             [dict objectForKey:@"ROOM"], @"room",
                             [dict objectForKey:@"START"], @"startTime",
                             [dict objectForKey:@"STOP"], @"stopTime",
                             [dict objectForKey:@"YEAR"], @"year",
                             [dict objectForKey:@"DAYS"], @"daysOfWeek",
                             [dict objectForKey:@"WEEKS"], @"weeks",
                             nil];
    NSDictionary* result = [db lectureToDataBase:lecture];
    NSLog(@"RESULT: %@", result);
    if ([result objectForKey:@"ok"]) {
        NSLog(@"CREATE ID: %@", [lecture objectForKey:@"courseID"]);
        CBLecture *lec = [[CBLecture alloc] initCourseWithName:[dict objectForKey:@"COURSE"]
                                                       teacher:[dict objectForKey:@"TEACHER"]
                                                          room:[dict objectForKey:@"ROOM"]
                                                      courseID:[NSString stringWithFormat:@"%d", objID]
                                                       version:@"1"
                                                     startTime:[dict objectForKey:@"START"]
                                                      stopTime:[dict objectForKey:@"STOP"]
                                                          year:[dict objectForKey:@"YEAR"]
                                                    daysOfWeek:[dict objectForKey:@"DAYS"]
                                                         weeks:[dict objectForKey:@"WEEKS"]
                                                     couchDBId:[result objectForKey:@"id"]
                                                    couchDBRev:[result objectForKey:@"rev"]];
        return lec;
    }
    return nil;
}

/*********************************************************************
 METHOD : CREATE LECTURE EVENT OBJECT
 ACCEPTS: CBLECTURE object
 RESULT:  Send LECTURE object to DATABASE
 *********************************************************************/
- (CBLecture*)createLectureEvent:(NSDictionary*)dict
{
    int objVer = 1;
    NSArray* lectures = [db getLectures];
    for (CBLecture* lec in lectures) {
        if([[lec courseID] isEqualToString:[dict objectForKey:@"COURSEID"]]&&[[lec version] intValue]>objVer) {
            objVer = [[lec version] intValue];
        }
    }
    objVer +=1;
    NSDictionary *lecture = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [dict objectForKey:@"COURSE"], @"course",
                             [dict objectForKey:@"TEACHER"], @"teacher",
                             [dict objectForKey:@"ROOM"], @"room",
                             [dict objectForKey:@"COURSEID"], @"courseID",
                             [NSString stringWithFormat:@"%d", objVer], @"version",
                             [dict objectForKey:@"START"], @"startTime",
                             [dict objectForKey:@"STOP"], @"stopTime",
                             [dict objectForKey:@"YEAR"], @"year",
                             [dict objectForKey:@"DAYS"], @"daysOfWeek",
                             [dict objectForKey:@"WEEKS"], @"weeks",
                             [dict objectForKey:@"COUCHID"], @"_id",
                             [dict objectForKey:@"COUCHREV"], @"_rev",
                             nil];
    NSDictionary* result = [db lectureToDataBase:lecture];
    NSLog(@"RESULT: %@", result);
    if ([result objectForKey:@"ok"]) {
        NSLog(@"CREATE ID: %@.%@", [lecture objectForKey:@"courseID"], [lecture objectForKey:@"version"]);
        CBLecture *lec = [[CBLecture alloc] initCourseWithName:[dict objectForKey:@"COURSE"]
                                                       teacher:[dict objectForKey:@"TEACHER"]
                                                          room:[dict objectForKey:@"ROOM"]
                                                      courseID:[dict objectForKey:@"COURSEID"]
                                                       version:[NSString stringWithFormat:@"%d", objVer]
                                                     startTime:[dict objectForKey:@"START"]
                                                      stopTime:[dict objectForKey:@"STOP"]
                                                          year:[dict objectForKey:@"YEAR"]
                                                    daysOfWeek:[dict objectForKey:@"DAYS"]
                                                         weeks:[dict objectForKey:@"WEEKS"]
                                                     couchDBId:[result objectForKey:@"id"]
                                                    couchDBRev:[result objectForKey:@"rev"]];
        return lec;
    }
    return nil;
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
    NSDictionary* result = [db noteToDataBase:note];
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
    NSDictionary* result = [db messageToDataBase:message];
    NSLog(@"RESULT: %@", result);
}

/*********************************************************************
 METHOD : UPDATE LECTURE OBJECT
 ACCEPTS: CBLECTURE object
 RESULT: CBLECTURE updated in database
 *********************************************************************/
-(CBLecture*)updateLecture:(NSDictionary*)dict
{
    if ([dict objectForKey:@"COURSEID"]&&[dict objectForKey:@"VERSION"]) {
        NSDictionary *lecture = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [dict objectForKey:@"COURSE"], @"course",
                                 [dict objectForKey:@"TEACHER"], @"teacher",
                                 [dict objectForKey:@"ROOM"], @"room",
                                 [dict objectForKey:@"COURSEID"], @"courseID",
                                 [dict objectForKey:@"VERSION"], @"version",
                                 [dict objectForKey:@"START"], @"startTime",
                                 [dict objectForKey:@"STOP"], @"stopTime",
                                 [dict objectForKey:@"YEAR"], @"year",
                                 [dict objectForKey:@"DAYS"], @"daysOfWeek",
                                 [dict objectForKey:@"WEEKS"], @"weeks",
                                 [dict objectForKey:@"COUCHID"], @"_id",
                                 [dict objectForKey:@"COUCHREV"], @"_rev",
                                 nil];
        NSLog(@"DICT: %@ LECTURE: %@", dict, lecture);
        NSDictionary* result = [db lectureToDataBase:lecture];
        NSLog(@"RESULT: %@", result);
        if ([result objectForKey:@"ok"]) {
            NSLog(@"UPDATE ID: %@.%@", [lecture objectForKey:@"courseID"], [lecture objectForKey:@"version"]);
            CBLecture *lec = [[CBLecture alloc] initCourseWithName:[dict objectForKey:@"COURSE"]
                                                           teacher:[dict objectForKey:@"TEACHER"]
                                                              room:[dict objectForKey:@"ROOM"]
                                                          courseID:[dict objectForKey:@"COURSEID"]
                                                           version:[dict objectForKey:@"VERSION"]
                                                         startTime:[dict objectForKey:@"START"]
                                                          stopTime:[dict objectForKey:@"STOP"]
                                                              year:[dict objectForKey:@"YEAR"]
                                                        daysOfWeek:[dict objectForKey:@"DAYS"]
                                                             weeks:[dict objectForKey:@"WEEKS"]
                                                         couchDBId:[result objectForKey:@"id"]
                                                        couchDBRev:[result objectForKey:@"rev"]];
            return lec;
        }
    }
    else {
        NSLog(@"Object is not previously registered in database.");
    }
    return nil;
}

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
