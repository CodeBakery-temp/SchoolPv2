#import <Foundation/Foundation.h>

@interface CBDatabaseService : NSObject

+(id)database;
+(id)createDatabase;
-(id)initDatabase;

-(NSString*) lectureToDataBase: (NSDictionary *) dictionary;
-(NSString*) notificationToDataBase: (NSDictionary *) dictionary;

-(NSDictionary *) getUsers;
-(NSMutableArray *) getLectures;
-(NSDictionary *) getNotifications;


@end
