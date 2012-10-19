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
- (NSDictionary*)getDayLectures;
- (NSArray*)getWeekNotes;
- (NSDictionary*)getDayNotes;
- (NSArray*)getMessages;

- (void)getLecturesOfWeek:(CBUser*)user
              currentWeek:(NSUInteger)currentWeek;

- (void)sortLecturesByVersionAndTime;

- (void)getNotesOfWeekAndMessages: (CBUser*)user
                      currentWeek: (NSUInteger)currentWeek;

- (void)createLecture:(NSDictionary*)dict;

- (void)createNote:(NSDictionary*)dict;

- (void)createMessage:(NSDictionary*)dict;


//-(void)updateLectureTemplate:(CBLecture*)lecture;

//-(void)updateLectureEvent:(CBLecture*)lecture;

-(int)timeStringToTimeInt:(NSString *)stringNum;

@end
