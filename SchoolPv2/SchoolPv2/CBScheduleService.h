#import <Foundation/Foundation.h>

@class CBUser, CBLecture, CBNote, CBMessage;

@interface CBScheduleService : NSObject
{
    NSMutableArray *weekLectures;
    NSMutableArray *weekNotes;
    NSMutableArray *messages;
}

+(id)schedule;
+(id)createSchedule;
-(id)initSchedule;

- (NSArray*)getWeekLectures;
- (NSDictionary*)getDayLectures:(int)day;
- (NSArray*)getWeekNotes;
- (NSDictionary*)getDayNotes:(int)day;
- (NSArray*)getMessages;

- (void)getLecturesOfWeek:(CBUser*)user
              currentWeek:(NSUInteger)currentWeek;

- (void)sortLecturesByVersionAndTime;

- (void)getNotesOfWeekAndMessages: (CBUser*)user
                      currentWeek: (NSUInteger)currentWeek;

- (CBLecture*)createLecture:(NSDictionary*)dict;

- (CBLecture*)createLectureEvent:(NSDictionary*)dict;

- (void)createNote:(NSDictionary*)dict;

- (void)createMessage:(NSDictionary*)dict;

- (CBLecture*)updateLecture:(NSDictionary*)dict;

-(int)timeStringToTimeInt:(NSString *)stringNum;

@end
