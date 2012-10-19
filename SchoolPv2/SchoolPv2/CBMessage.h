#import <CoreData/CoreData.h>

@interface CBMessage : NSManagedObject

@property (nonatomic, copy) NSString* sender;
// receiver
@property (nonatomic, copy) NSString* text;

+(id) messageWithSender: (NSString *)sender
               receiver: (NSArray *)receiver
                   text: (NSString *)text;

-(id) initMessageWithSender: (NSString *)sender
                   receiver: (NSArray *)receiver
                       text: (NSString *)text;

-(NSMutableArray *) receiver;

@end