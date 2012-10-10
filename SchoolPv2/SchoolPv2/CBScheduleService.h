#import <Foundation/Foundation.h>

@class CBUser, CBLecture;

@interface CBScheduleService : NSObject

+(id)schedule;
+(id)createSchedule;
-(id)initSchedule;

-(NSArray*)getLecturesOfWeek: (CBUser*)user
                 currentWeek: (NSUInteger)currentWeek;

-(NSDictionary*)getLecturesPerDays:(NSArray *)lectures;

-(NSDictionary*)getLecturesWithVersion:(NSDictionary*)lectures;

-(NSDictionary*)getLecturesPerDaysRefined:(NSArray*)lectures;

-(NSSet*)getLecturesOfDay:(NSDictionary*)lectures;

-(NSArray*)getNotesOfWeek: (CBUser*)user
              currentWeek: (NSUInteger)currentWeek;

-(NSDictionary*)getNotesPerDays:(NSArray *)notes;

-(NSSet*)getNotesOfDay:(NSDictionary*)notes;

-(NSArray*)getUserMessages:(CBUser*)user;

-(void)createLecture:(NSString *)jsonPath;

-(void)createNote:(NSString *)jsonPath;

-(void)createMessage:(NSString *)jsonPath;

//-(void)updateLectureTemplate:(CBLecture*)lecture;

//-(void)updateLectureEvent:(CBLecture*)lecture;

@end
