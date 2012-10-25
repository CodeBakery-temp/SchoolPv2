#import <Foundation/Foundation.h>

@class CBUser, CBLecture, CBNote, CBMessage;

@interface CBScheduleService : NSObject
{
    NSDictionary *storage;
    NSMutableArray *weekLectures;
    NSMutableArray *weekNotes;
    NSMutableArray *messages;
}

+(id)schedule;
+(id)createSchedule;
-(id)initSchedule;

- (int)getWeekDay;
- (NSArray*)getWeekLectures;
- (NSDictionary*)getDayLectures:(int)day;
- (NSArray*)getWeekNotes;
- (NSDictionary*)getDayNotes:(int)day;
- (NSArray*)getMessages;

- (void)getLecturesOfWeek:(NSDictionary*)user
              currentWeek:(NSUInteger)currentWeek;

- (void)sortLecturesByVersionAndTime;

- (void)getNotesOfWeekAndMessages: (NSDictionary*)user
                      currentWeek: (NSUInteger)currentWeek;

- (CBLecture*)createLecture:(NSDictionary*)dict;

- (CBLecture*)createLectureEvent:(NSDictionary*)dict;

- (void)createNote:(NSDictionary*)dict;

- (void)createMessage:(NSDictionary*)dict;

- (CBLecture*)updateLecture:(NSDictionary*)dict;

-(int)timeStringToTimeInt:(NSString *)stringNum;


- (NSString*)itemArchivepath;

- (BOOL)saveChanges;

@end
