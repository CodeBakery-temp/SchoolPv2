#import <Foundation/Foundation.h>

@class CBUser, CBLecture, CBNote, CBMessage;

@interface CBDatabaseService : NSObject

+(id)database;
+(id)createDatabase;
-(id)initDatabase;

-(NSString*) lectureToDataBase: (CBLecture*)lecture;
-(NSString*) noteToDataBase: (CBNote*)note;
-(NSString*) messageToDataBase: (CBMessage*)note;

-(NSDictionary *) getUsers;
-(NSMutableArray *) getLectures;
-(NSDictionary *) getNotifications;


@end
