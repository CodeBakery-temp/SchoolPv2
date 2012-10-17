#import "CBDatabaseService.h"
#import "CBLecture.h"
#import "CBNote.h"
#import "CBUser.h"
#import "CBMessage.h"

NSString *const usersDB = @"http://zephyr.iriscouch.com/schoolp-users/";
NSString *const lecturesDB = @"http://zephyr.iriscouch.com/schoolp-schedules/";
NSString *const notificationsDB = @"http://zephyr.iriscouch.com/schoolp-notifications/";
NSString *const getAll = @"_all_docs?include_docs=true";

@implementation CBDatabaseService
{
    NSMutableDictionary *users;
    NSMutableDictionary *notifications;
    NSMutableArray *lectures;
}

+ (CBDatabaseService *)database
{
    // Singleton
    static CBDatabaseService *database = nil;
    if (!database) {
        database = [[super allocWithZone:nil] init];
    }
    return database;
}

+(id)createDatabase
{
    return [self database];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self database];
}

-(id)init
{
    return [self initDatabase];
}
-(id)initDatabase
{
    if(self = [super init])
    {
        users = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 [NSMutableArray array], @"ADMIN",
                 [NSMutableArray array], @"STUDENT", nil];
        notifications = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSMutableArray array], @"NOTES",
                         [NSMutableArray array], @"MESSAGES", nil];
        lectures = [NSMutableArray array];
    }
    return self;
}

/*********************************************************************
 METHOD : POST LECTURE OBJECT TO LECTURE DATABASE
 ACCEPTS: Lecture object as NSDictionary
 RETURNS: Result NSString
 *********************************************************************/
-(NSString*) lectureToDataBase:(CBLecture *)lecture
{
    NSData *tempData;
    if([NSJSONSerialization isValidJSONObject:lecture]) {
        tempData = [NSJSONSerialization dataWithJSONObject:lecture
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    }
    //REQUEST
    NSString *urlString = [NSString stringWithString: lecturesDB];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:tempData];
    [request setHTTPBody:postBody];
    
    //RESPONSE
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return result;
}

/*********************************************************************
 METHOD : POST NOTE OR MESSAGE OBJECT TO NOTIFICATION DATABASE
 ACCEPTS: Note or Message object as NSDictionary
 RETURNS: Result NSString
 *********************************************************************/
-(NSString*) noteToDataBase:(CBNote *)note
{
    NSData *tempData;
    if([NSJSONSerialization isValidJSONObject:note]) {
        tempData = [NSJSONSerialization dataWithJSONObject:note
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    }
    //REQUEST
    NSString *urlString = [NSString stringWithString: notificationsDB];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:tempData];
    [request setHTTPBody:postBody];
    
    //RESPONSE
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return result;
}

/*********************************************************************
 METHOD : POST NOTE OR MESSAGE OBJECT TO NOTIFICATION DATABASE
 ACCEPTS: Note or Message object as NSDictionary
 RETURNS: Result NSString
 *********************************************************************/
-(NSString*) messageToDataBase:(CBMessage *)message
{
    NSData *tempData;
    if([NSJSONSerialization isValidJSONObject:message]) {
        tempData = [NSJSONSerialization dataWithJSONObject:message
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    }
    //REQUEST
    NSString *urlString = [NSString stringWithString: notificationsDB];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:tempData];
    [request setHTTPBody:postBody];
    
    //RESPONSE
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return result;
}

/*********************************************************************
 METHOD : GET ALL USER OBJECTS FROM USERS DATABASE
 ACCEPTS: NONE
 RETURNS: NSDictionary with lists of Student and Admin objects
 *********************************************************************/
-(NSDictionary*)getUsers
{
    //REQUEST
    [[users objectForKey:@"ADMIN"] removeAllObjects];
    [[users objectForKey:@"STUDENT"] removeAllObjects];
    NSString* urlString = [NSString stringWithFormat:@"%@%@", usersDB, getAll];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSString* contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL
                                                     error:&error];
    if(!data) {
        NSLog(@"FAILED: %@", [error localizedDescription]);
        return nil;
    }
    else {
        NSMutableDictionary *usersDic = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:NULL];
        
        usersDic = [usersDic objectForKey:@"rows"]; // Step into 'rows'
        for (NSDictionary *object in usersDic) {    // Step into JSON array (single index)
            NSDictionary* dict = [object objectForKey:@"doc"]; // Step into 'doc' (current object key/values)
            
            CBUser* usr = [CBUser userWithName:[dict objectForKey:@"firstName"]
                                      lastName:[dict objectForKey:@"lastName"]
                                      password:[dict objectForKey:@"password"]
                                   mailAddress:[dict objectForKey:@"mailAddress"]
                                   phoneNumber:[dict objectForKey:@"phoneNumber"]
                                         admin:[dict objectForKey:@"admin"]
                                       courses:[dict objectForKey:@"courses"]];
            
            if([[dict objectForKey:@"admin"]isEqualToString:@"0"]) {
                [[users objectForKey:@"STUDENT"] addObject:usr];
            }
            else {
                [[users objectForKey:@"ADMIN"] addObject:usr];
            }
        }
        return users;
    }
}

/*********************************************************************
 METHOD : GET ALL LECTURE OBJECTS FROM LECTURE DATABASE
 ACCEPTS: NONE
 RETURNS: NSMutableArray list with Lecture objects
 *********************************************************************/
-(NSMutableArray*)getLectures
{
    //REQUEST
    [lectures removeAllObjects];
    NSString* urlString = [NSString stringWithFormat:@"%@%@", lecturesDB, getAll];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSString* contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL
                                                     error:&error];
    if(!data) {
        NSLog(@"FAILED: %@", [error localizedDescription]);
        return nil;
    }
    else {
        NSMutableDictionary *usersDic = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:NULL];
        
        usersDic = [usersDic objectForKey:@"rows"]; // Step into 'rows'
        for (NSDictionary *object in usersDic) {    // Step into JSON array (single index)
            NSDictionary* dict = [object objectForKey:@"doc"]; // Step into 'doc' (current object key/values)
            CBLecture* lecture = [CBLecture courseWithName:[dict objectForKey:@"course"]
                                                     grade:[dict objectForKey:@"grade"]
                                                   teacher:[dict objectForKey:@"teacher"]
                                                      room:[dict objectForKey:@"room"]
                                                  courseID:[dict objectForKey:@"courseID"]
                                                   version:[dict objectForKey:@"version"]
                                                 startTime:[dict objectForKey:@"startTime"]
                                                  stopTime:[dict objectForKey:@"stopTime"]
                                                lunchStart:[dict objectForKey:@"lunchStart"]
                                                 lunchStop:[dict objectForKey:@"lunchStop"]
                                                      year:[dict objectForKey:@"year"]
                                                daysOfWeek:[dict objectForKey:@"daysOfWeek"]
                                                     weeks:[dict objectForKey:@"weeks"]
                                                 couchDBId:[dict objectForKey:@"_id"]
                                                couchDBRev:[dict objectForKey:@"_rev"]];
            [lectures addObject:lecture];
        }
        return lectures;
    }
}
/*********************************************************************
 METHOD : GET ALL NOTE AND MESSAGE OBJECTS FROM NOTIFICATION DATABASE
 ACCEPTS: NONE
 RETURNS: NSDictionary with lists of Note and Message objects
 *********************************************************************/
-(NSDictionary*)getNotifications
{
    //REQUEST
    [[notifications objectForKey:@"NOTES"] removeAllObjects];
    [[notifications objectForKey:@"MESSAGES"] removeAllObjects];
    NSString* urlString = [NSString stringWithFormat:@"%@%@", notificationsDB, getAll];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSString* contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL
                                                     error:&error];
    if(!data) {
        NSLog(@"FAILED: %@", [error localizedDescription]);
        return nil;
    }
    else {
        NSMutableDictionary *noticesDic = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                           error:NULL];
        
        noticesDic = [noticesDic objectForKey:@"rows"]; // Step into 'rows'
        for (NSDictionary *object in noticesDic) {    // Step into JSON array (single index)
            NSDictionary* dict = [object objectForKey:@"doc"]; // Step into 'doc' (current object key/values)
            if([[dict objectForKey:@"type"]isEqualToString:@"note"]) {
                CBNote* note = [CBNote noteWithText:[dict objectForKey:@"text"]
                                               week:[dict objectForKey:@"week"]
                                                day:[dict objectForKey:@"day"]
                                           courseID:[dict objectForKey:@"courseID"]];
                [[notifications objectForKey:@"NOTES"] addObject:note];
            }
            else if ([[dict objectForKey:@"type"]isEqualToString:@"message"]){
                CBMessage* message = [CBMessage messageWithSender:[dict objectForKey:@"sender"]
                                                         receiver:[dict objectForKey:@"receiver"]
                                                             text:[dict objectForKey:@"text"]];
                [[notifications objectForKey:@"MESSAGES"] addObject:message];
            }
        }
        return notifications;
    }
}

@end

