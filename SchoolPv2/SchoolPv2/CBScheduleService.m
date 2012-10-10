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
    }
    return self;
}

/*********************************************************************
 METHOD : GET ALL USER'S LECTURE OBJECTS FROM USER-DATA AND CURRENT WEEK
 ACCEPTS: Student/Admin object, NSUInteger of current week
 RETURNS: NSArray with Lecture objects
 *********************************************************************/
-(NSArray*)getLecturesOfWeek:(CBUser*)user
                 currentWeek: (NSUInteger) currentWeek {
    NSArray* lectures = [db getLectures];
    NSMutableArray* userLectures = [NSMutableArray array];
    
    for(NSString* courseID in [user courses]) {
        for(id lecture in lectures) {
            if([courseID isEqualToString:[lecture courseID]]) {
                for(NSString* week in [lecture weeks]) {
                    if([week isEqualToString:[NSString stringWithFormat:@"%d", currentWeek]]) {
                        [userLectures addObject:lecture];
                    }
                }
            }
        }
    }
    return userLectures;
}

/*********************************************************************
 METHOD : GET ALL LECTURE OBJECTS SORTED IN MONDAY - FRIDAY
 ACCEPTS: NSArray with Lecture objects
 RETURNS: NSDictionary with Lecture objects sorted in KEYS MONDAY - FRIDAY
 *********************************************************************/
-(NSDictionary*)getLecturesPerDays:(NSArray *)lectures {
    NSDictionary* lecturesDays = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSMutableArray array], @"MONDAY",
                                  [NSMutableArray array], @"TUESDAY",
                                  [NSMutableArray array], @"WEDNESDAY",
                                  [NSMutableArray array], @"THURSDAY",
                                  [NSMutableArray array], @"FRIDAY",nil];
    for(NSArray* day in lecturesDays) {
        for(CBLecture* lecture in lectures) {
            for(NSString* weekDay in [lecture daysOfWeek]) {
                if(![weekDay caseInsensitiveCompare:[NSString stringWithFormat:@"%@", day]]) {
                    [[lecturesDays objectForKey:day] addObject:lecture];
                }
            }
        }
    }
    return lecturesDays;
}

/*********************************************************************
 METHOD : GET ALL LECTURE OBJECTS SORTED NEWEST VERSION IN MONDAY - FRIDAY
 ACCEPTS: NSDictionary with Lecture objects sorted in KEYS MONDAY - FRIDAY
 RETURNS: NSDictionary with Lecture objects sorted only newest version in KEYS MONDAY - FRIDAY
 *********************************************************************/
-(NSDictionary*)getLecturesWithVersion:(NSDictionary *)lectures {
    NSDictionary* lecturesDays = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSMutableArray array], @"MONDAY",
                                  [NSMutableArray array], @"TUESDAY",
                                  [NSMutableArray array], @"WEDNESDAY",
                                  [NSMutableArray array], @"THURSDAY",
                                  [NSMutableArray array], @"FRIDAY",nil];
    for (NSString* weekDay in lectures) {   // EACH WEEKDAY
        // CHECKS NUMBER OF DIFFERENT COURSES FOR EACH DAY
        int top = 0;
        for (CBLecture* lec in [lectures objectForKey:weekDay]){  // EACH LECTURE IN CURRENT DAY - CHECK ID COUNT
            if ([[lec courseID] intValue]>top) {
                top = [[lec courseID] intValue];
            }
        }
        //FINDS TOP VERSION OF EACH COURSE FOR THE DAY
        NSInteger COURSESNUM = top;
        for (NSInteger CURRENTCOURSE=1; CURRENTCOURSE<=COURSESNUM; CURRENTCOURSE++){
            // CHECKS DIFFERENT COURSES
            int versionTop = 0;
            CBLecture* lecture = [CBLecture alloc];
            for (CBLecture* lec in [lectures objectForKey:weekDay]){  // EACH LECTURE IN CURRENT DAY
                if([[lec courseID]isEqualToString:[NSString stringWithFormat:@"%d", CURRENTCOURSE]]
                   &&[[lec version] intValue]>versionTop) { // IS SPECIFIC COURSE AND VERSION IS HIGHER THAN PREVIOUS
                    versionTop = [[lec version] intValue];
                    lecture = [lecture initCourseWithName:[lec course]
                                                    grade:[lec grade]
                                                  teacher:[lec teacher]
                                                     room:[lec room]
                                                 courseID:[lec courseID]
                                                  version:[lec version]
                                                startTime:[lec startTime]
                                                 stopTime:[lec stopTime]
                                               lunchStart:[lec lunchStart]
                                                lunchStop:[lec lunchStop]
                                                     year:[lec year]
                                               daysOfWeek:[lec daysOfWeek]
                                                    weeks:[lec weeks]
                                                couchDBId:[lec couchDBId]
                                               couchDBRev:[lec couchDBRev]];
                }
            }
            if([lecture courseID]) {
                [[lecturesDays objectForKey:weekDay] addObject:lecture];
            }
            
        }
        
    }
    return lecturesDays;
}

/*********************************************************************
 METHOD : GET ALL LECTURE OBJECTS SORTED NEWEST VERSION IN MONDAY - FRIDAY
 ACCEPTS: NSArray with Lecture objects
 RETURNS: NSDictionary with Lecture objects sorted only newest version in KEYS MONDAY - FRIDAY
 *********************************************************************/
-(NSDictionary*)getLecturesPerDaysRefined:(NSArray*)lectures {
    NSDictionary* tempSort = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [NSMutableArray array], @"MONDAY",
                              [NSMutableArray array], @"TUESDAY",
                              [NSMutableArray array], @"WEDNESDAY",
                              [NSMutableArray array], @"THURSDAY",
                              [NSMutableArray array], @"FRIDAY",nil];
    NSDictionary* lecturesDays = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSMutableArray array], @"MONDAY",
                                  [NSMutableArray array], @"TUESDAY",
                                  [NSMutableArray array], @"WEDNESDAY",
                                  [NSMutableArray array], @"THURSDAY",
                                  [NSMutableArray array], @"FRIDAY",nil];
    for(NSArray* day in tempSort) {
        for(CBLecture* lecture in lectures) {
            for(NSString* weekDay in [lecture daysOfWeek]) {
                if(![weekDay caseInsensitiveCompare:[NSString stringWithFormat:@"%@", day]]) {
                    [[tempSort objectForKey:day] addObject:lecture];
                }
            }
        }
    }
    
    for (NSString* weekDay in tempSort) {    // EACH WEEKDAY
        // CHECKS NUMBER OF DIFFERENT COURSES FOR EACH DAY
        int top = 0;
        for (CBLecture* lec in [tempSort objectForKey:weekDay]){ // EACH LECTURE IN CURRENT DAY - CHECK ID COUNT
            if ([[lec courseID] intValue]>top) {
                top = [[lec courseID] intValue];
            }
        }
        //FINDS TOP VERSION OF EACH COURSE FOR THE DAY
        NSInteger COURSESNUM = top;
        for (NSInteger CURRENTCOURSE=1; CURRENTCOURSE<=COURSESNUM; CURRENTCOURSE++){
            // CHECKS DIFFERENT COURSES
            int versionTop = 0;
            CBLecture* lecture = [CBLecture alloc];
            for (CBLecture* lec in [tempSort objectForKey:weekDay]){  // EACH LECTURE IN CURRENT DAY
                if([[lec courseID]isEqualToString:[NSString stringWithFormat:@"%d", CURRENTCOURSE]]
                   &&[[lec version] intValue]>versionTop) { // IS SPECIFIC COURSE AND VERSION IS HIGHER THAN PREVIOUS
                    versionTop = [[lec version] intValue];
                    lecture = [lecture initCourseWithName:[lec course]
                                                    grade:[lec grade]
                                                  teacher:[lec teacher]
                                                     room:[lec room]
                                                 courseID:[lec courseID]
                                                  version:[lec version]
                                                startTime:[lec startTime]
                                                 stopTime:[lec stopTime]
                                               lunchStart:[lec lunchStart]
                                                lunchStop:[lec lunchStop]
                                                     year:[lec year]
                                               daysOfWeek:[lec daysOfWeek]
                                                    weeks:[lec weeks]
                                                couchDBId:[lec couchDBId]
                                               couchDBRev:[lec couchDBRev]];
                }
            }
            if([lecture courseID]) {
                [[lecturesDays objectForKey:weekDay] addObject:lecture];
            }
            
        }
        
    }
    return lecturesDays;
}

/*********************************************************************
 METHOD : GET LECTURE OBJECTS FROM USER-DATA AND CALCULATED CURRENT DAY
 ACCEPTS: Student/Admin object and NSDictionary with Lecture objects sorted in KEYS MONDAY - FRIDAY
 RETURNS: NSSet with Lecture objects
 *********************************************************************/
-(NSSet*)getLecturesOfDay:(NSDictionary*)lectures {
    NSDate *date = [NSDate date];
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEEE"];
    
    NSSet* lecturesOfDay = [lectures objectForKey:[[weekDay stringFromDate:date] uppercaseString]];
    
    return lecturesOfDay;
}

/*********************************************************************
 METHOD : GET ALL USER'S NOTE OBJECTS FROM USER-DATA AND CURRENT WEEK
 ACCEPTS: Student/Admin object, NSArray of Note objects, NSUInteger of current week
 RETURNS: NSArray with Note objects
 *********************************************************************/
-(NSArray*)getNotesOfWeek:(CBUser*)user
              currentWeek:(NSUInteger)currentWeek {
    NSArray* notes = [[db getNotifications]objectForKey:@"NOTES"];
    NSMutableArray* userNotes = [NSMutableArray array];
    
    for(id course in [user courses]) {
        for(CBNote* note in notes) {
            if([[note courseID]isEqualToString:course]) {
                [userNotes addObject:note];
            }
        }
    }
    return userNotes;
}

/*********************************************************************
 METHOD : GET ALL NOTE OBJECTS SORTED IN MONDAY - FRIDAY
 ACCEPTS: NSArray with Note objects
 RETURNS: NSDictionary with Note objects sorted in KEYS MONDAY - FRIDAY
 *********************************************************************/
-(NSDictionary*)getNotesPerDays:(NSArray *)notes {
    NSDictionary* notesDays = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSMutableArray array], @"MONDAY",
                               [NSMutableArray array], @"TUESDAY",
                               [NSMutableArray array], @"WEDNESDAY",
                               [NSMutableArray array], @"THURSDAY",
                               [NSMutableArray array], @"FRIDAY",nil];
    for(NSArray* day in notesDays) {
        for(CBNote* note in notes) {
            if(![[note day]caseInsensitiveCompare:[NSString stringWithFormat:@"%@", day]]) {
                [[notesDays objectForKey:day] addObject:note];
            }
        }
    }
    return notesDays;
}

/*********************************************************************
 METHOD : GET NOTE OBJECTS FROM USER-DATA AND CALCULATED CURRENT DAY
 ACCEPTS: Student/Admin object and NSDictionary with Note objects sorted in KEYS MONDAY - FRIDAY
 RETURNS: NSSet with Note objects
 *********************************************************************/
-(NSSet*)getNotesOfDay:(NSDictionary*) notes {
    NSDate *date = [NSDate date];
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEEE"];
    
    NSSet* notesOfDay = [notes objectForKey:[[weekDay stringFromDate:date] uppercaseString]];
    
    return notesOfDay;
}

/*********************************************************************
 METHOD : GET ALL MESSAGE OBJECTS FROM USER-DATA
 ACCEPTS: NSDictionary with at least NSSet of Message objects
 RETURNS: NSArray with Message objects for User
 *********************************************************************/
-(NSArray*)getUserMessages:(CBUser*)user {
    NSArray* messages = [[db getNotifications]objectForKey:@"MESSAGES"];
    NSMutableArray* inbox = [NSMutableArray array];
    
    for(CBMessage* message in messages) {
        for(NSString* email in [message receiver]) {
            if([[user mailAddress]isEqualToString:email]) {
                [inbox addObject:message];
            }
        }
    }
    return inbox;
}

/*********************************************************************
 METHOD : CREATE LECTURE TEMPLATE OBJECT - SUPPLY WITH JSON
 ACCEPTS: NSString PATH to JSON DATA
 RETURNS: NONE
 *********************************************************************/
-(void)createLecture:(NSString *)jsonPath {
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
    NSArray* lectures = [db getLectures];
    int objID = 1;
    for(CBLecture* lec in lectures) {
        if([[lec courseID] intValue]>objID) {
            objID = [[lec courseID] intValue];
        }
    }
    int idInt = objID;
    idInt +=1;
    objID = idInt;
    [dict setObject:[NSString stringWithFormat:@"%d", objID] forKey:@"courseID"];
    [dict setObject:@"1" forKey:@"version"];
    NSLog(@"CREATE ID: %@", [dict objectForKey:@"courseID"]);
    [db lectureToDataBase:dict];
}

/*********************************************************************
 METHOD : CREATE NOTE OBJECT - SUPPLY WITH JSON
 ACCEPTS: NSString PATH to JSON DATA
 RETURNS: NONE
 *********************************************************************/
-(void)createNote:(NSString *)jsonPath {
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
    [dict setObject:@"note" forKey:@"type"];
    [db notificationToDataBase:dict];
}

/*********************************************************************
 METHOD : CREATE MESSAGE OBJECT - SUPPLY WITH JSON
 ACCEPTS: NSString PATH to JSON DATA
 RETURNS: NONE
 *********************************************************************/
-(void)createMessage:(NSString *)jsonPath {
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
    [dict setObject:@"message" forKey:@"type"];
    [db notificationToDataBase:dict];
}

-(void)updateLectureTemplate:(CBLecture*)lecture
{
}

-(void)updateLectureEvent:(CBLecture*)lecture
{}

/*********************************************************************
 METHOD : UPDATE LECTURE OBJECT TEMPLATE WITH VERSION 1 - SUPPLY WITH JSON
 ACCEPTS: NSString with number of ID, NSArray with Lecture objects, NSString PATH to JSON DATA
 RETURNS: NONE
 *********************************************************************/
/*-(void)updateLectureTemplate:(NSString*)jsonPath {
 NSArray* lectures = [db getLectures];
 NSData *data = [NSData dataWithContentsOfFile:jsonPath];
 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
 options:NSJSONReadingMutableContainers
 error:NULL];
 
 for(CBLecture* lec in lectures) {
 if([[lec courseID]isEqualToString:[dict objectForKey:@"courseID"]]&&[[lec version]isEqualToString:@"1"]) {
 [dict setObject:[lec couchDBId] forKey:@"_id"];
 [dict setObject:[lec couchDBRev] forKey:@"_rev"];
 [dict setObject:[lec courseID] forKey:@"courseID"];
 [dict setObject:@"1" forKey:@"version"];
 [db lectureToDataBase:dict];
 
 break;
 }
 }
 }*/

/*********************************************************************
 METHOD : UPDATE LECTURE OBJECT - CREATE MODIFIED INSTANCE OR EDIT INSTANCE - SUPPLY WITH JSON
 ACCEPTS: NSString with number of ID, NSString with number of version, NSArray with Lecture objects, NSString PATH to JSON DATA
 RETURNS: NONE
 *********************************************************************/
/*-(void)updateLectureEvent:(NSString*)jsonPath {
 NSArray* lectures = [db getLectures];
 NSData *data = [NSData dataWithContentsOfFile:jsonPath];
 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
 options:NSJSONReadingMutableContainers
 error:NULL];
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

@end
