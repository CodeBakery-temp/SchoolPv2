#import <Foundation/Foundation.h>

@class CBUser, CBLecture, CBNote, CBMessage;

@interface CBDatabaseService : NSObject

+(id)database;
+(id)createDatabase;
-(id)initDatabase;

-(NSDictionary*) lectureToDataBase: (NSDictionary*)lecture;
-(NSDictionary*) noteToDataBase: (NSDictionary*)note;
-(NSDictionary*) messageToDataBase: (NSDictionary*)note;

-(NSDictionary *) getUsers;
-(NSMutableArray *) getLectures;
-(NSDictionary *) getNotifications;


@end
