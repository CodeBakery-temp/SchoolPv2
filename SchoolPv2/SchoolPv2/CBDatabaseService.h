#import <Foundation/Foundation.h>

@class CBUser, CBLecture, CBNote, CBMessage;

@interface CBDatabaseService : NSObject

+(id)database;
+(id)createDatabase;
-(id)initDatabase;

-(NSString*) lectureToDataBase: (NSDictionary*)lecture;
-(NSString*) noteToDataBase: (NSDictionary*)note;
-(NSString*) messageToDataBase: (NSDictionary*)note;

-(NSDictionary *) getUsers;
-(NSMutableArray *) getLectures;
-(NSDictionary *) getNotifications;


@end
