#import "CBLecture.h"

@implementation CBLecture {
    NSMutableArray *lessonDays;
    NSMutableArray *lessonWeeks;
}

@synthesize couchDBId = _couchDBId;
@synthesize couchDBRev = _couchDBRev;

@synthesize course = _course;
@synthesize teacher = _teacher;
@synthesize room = _room;
@synthesize courseID = _courseID;
@synthesize version = _version;
@synthesize startTime = _startTime;
@synthesize stopTime = _stopTime;
@synthesize year = _year;

+(id) courseWithName:(NSString *)course
             teacher: (NSString*)teacher
                room: (NSString*)room
            courseID:(NSString *)courseID
             version:(NSString *)version
           startTime:(NSString *)startTime
            stopTime:(NSString *)stopTime
                year:(NSString *)year
          daysOfWeek:(NSArray *)daysOfWeek
               weeks:(NSArray *)weeks
           couchDBId: (NSString *) couchDBId
          couchDBRev: (NSString *) couchDBRev{
    return [[self alloc]initCourseWithName:course
                                   teacher:teacher
                                      room:room
                                  courseID:courseID
                                   version:version
                                 startTime:startTime
                                  stopTime:stopTime
                                      year:year
                                daysOfWeek:daysOfWeek
                                     weeks:weeks
                                 couchDBId:couchDBId
                                couchDBRev:couchDBRev];
}

-(id) initCourseWithName:(NSString *)course
                 teacher:(NSString*)teacher
                    room:(NSString*)room
                courseID:(NSString *)courseID
                 version:(NSString *)version
               startTime:(NSString *)startTime
                stopTime:(NSString *)stopTime
                    year:(NSString *)year
              daysOfWeek:(NSArray *)daysOfWeek
                   weeks:(NSArray *)weeks
               couchDBId:(NSString *) couchDBId
              couchDBRev:(NSString *) couchDBRev; {
    if(self = [super init]) {
        
        lessonDays = [NSMutableArray array];
        for (NSDictionary *object in daysOfWeek) {
            [lessonDays addObject:object];
        }
        lessonWeeks = [NSMutableArray array];
        for (NSDictionary *object in weeks) {
            [lessonWeeks addObject:object];
        }
        
        _course = course;
        _teacher = teacher;
        _room = room;
        _courseID = courseID;
        _version = version;
        _startTime = startTime;
        _stopTime = stopTime;
        _year = year;
        _couchDBId = couchDBId;
        _couchDBRev = couchDBRev;
    }
    return self;
}

-(NSDictionary*) asDictionary {
    
    if (self.couchDBId) {
        return [NSDictionary dictionaryWithObjectsAndKeys:self.course, @"course",
                self.teacher, @"teacher",
                self.room, @"room",
                self.courseID, @"courseID",
                self.version, @"version",
                self.startTime, @"startTime",
                self.stopTime, @"stopTime",
                self.year, @"year",
                self.couchDBId, @"_id",
                self.couchDBRev, @"_rev",
                lessonDays, @"lessondays",
                lessonWeeks, @"lessonWeeks",
                nil];
    }
    else {
        return [NSDictionary dictionaryWithObjectsAndKeys:self.course, @"course",
                self.teacher, @"teacher",
                self.room, @"room",
                self.courseID, @"courseID",
                self.version, @"version",
                self.startTime, @"startTime",
                self.stopTime, @"stopTime",
                self.year, @"year",
                lessonDays, @"lessondays",
                lessonWeeks, @"lessonWeeks",
                nil];
    }
}


-(NSMutableArray *)daysOfWeek {
    return lessonDays;
}

-(NSMutableArray *)weeks {
    return lessonWeeks;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\nCourse: %@, \nTeacher: %@, \nRoom: %@, \nCourseID: %@, \nVersion: %@, \nTime: %@-%@, \nYear: %@, \nDays: %@ \nWeeks: %@",
            self.course,
            self.teacher,
            self.room,
            self.courseID,
            self.version,
            self.startTime,
            self.stopTime,
            self.year,
            [lessonDays componentsJoinedByString:@", "], [lessonWeeks componentsJoinedByString:@", "]];
}

-(void)printLecture {
    NSLog(@"\nCourse: %@, \nTeacher: %@, \nRoom: %@, \nTime: %@-%@, \nYear: %@ \n\n",
          self.course,
          self.teacher,
          self.room,
          self.startTime,
          self.stopTime,
          self.year);
}

@end
