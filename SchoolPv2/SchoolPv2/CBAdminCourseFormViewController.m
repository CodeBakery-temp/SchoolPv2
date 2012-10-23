#import "CBAdminCourseFormViewController.h"
#import "CBScheduleService.h"
#import "CBLecture.h"

@interface CBAdminCourseFormViewController ()
{
    CBScheduleService *scheduleService;
}

@end

@implementation CBAdminCourseFormViewController
{
    NSMutableDictionary *courseInfo;
    NSMutableArray *days;
    NSMutableArray *weeks;
    UITextField *activeField;
    
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

- (id)init
{
    self = [super init];
    if (self) {
        scheduleService = [CBScheduleService schedule];
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"TEMPLATE"];
        courseInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSMutableArray array], @"COURSE",
                      [NSMutableArray array], @"TEACHER",
                      [NSMutableArray array], @"ROOM",
                      [NSMutableArray array], @"DAYS",
                      [NSMutableArray array], @"WEEKS",
                      [NSMutableArray array], @"YEAR",
                      [NSMutableArray array], @"START",
                      [NSMutableArray array], @"STOP", nil];
    }
    return self;
}

- (id)initNewTemplate {
    self = [self init];
    if(self) {
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(createTemplate:)];
        cancelButton = [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                        target:self action:@selector(cancelTemplate:)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
    }
    return self;
}

- (id)initEditTemplate {
    self = [self init];
    if(self) {
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Event"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(createEvent:)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
    }
    return self;
}

- (id)initEditEvent {
    self = [self init];
    if(self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_lecture) {
        [_courseField setText:[_lecture course]];
        [_teacherField setText:[_lecture teacher]];
        [_roomField setText:[_lecture room]];
        [_courseField setText:[_lecture course]];
        NSString *dayString = [[NSString alloc] init];
        for (NSString *a in [_lecture daysOfWeek]) {
            dayString = [dayString stringByAppendingFormat:@"%@,", a];
        }
        [_dayField setText:dayString];
        NSString *weekString = [[NSString alloc] init];
        for (NSString *b in [_lecture weeks]) {
            weekString = [weekString stringByAppendingFormat:@"%@,", b];
        }
        [_weekField setText:weekString];
        [_yearField setText:[_lecture year]];
        [_startField setText:[_lecture startTime]];
        [_stopField setText:[_lecture stopTime]];
    }
}

- (void)setLecture:(CBLecture *)lec
{
    NSLog(@"Set template");
    _lecture = lec;
    NSString *t = [NSString stringWithFormat:@"%@.%@ %@", [_lecture courseID], [_lecture version], [_lecture course]];
    [[self navigationItem] setTitle:t];
}

- (void)createTemplate:(id)sender
{
    NSLog(@"CREATE");
    if (!([_teacherField.text isEqualToString:@""]) && !([_courseField.text isEqualToString:@""]) && !([_roomField.text isEqualToString:@""]) && !([_dayField.text isEqualToString:@""]) && !([_weekField.text isEqualToString:@""]) && !([_yearField.text isEqualToString:@""]) && !([_startField.text isEqualToString:@""]) && !([_stopField.text isEqualToString:@""]))
    {
        [courseInfo setValue:_teacherField.text forKey:@"TEACHER"];
        [courseInfo setValue:_courseField.text forKey:@"COURSE"];
        [courseInfo setValue:_roomField.text forKey:@"ROOM"];
        
        days = [[NSMutableArray alloc] init];
        days = [[[[_dayField.text stringByReplacingOccurrencesOfString:@" " withString:@""] capitalizedString] componentsSeparatedByString:@","] mutableCopy];
        
        [courseInfo setValue:days forKey:@"DAYS"];
        
        weeks = [[NSMutableArray alloc] init];
        weeks = [[[_weekField.text stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","] mutableCopy];
        [courseInfo setValue:weeks forKey:@"WEEKS"];
        
        [courseInfo setValue:_yearField.text forKey:@"YEAR"];
        [courseInfo setValue:_startField.text forKey:@"START"];
        [courseInfo setValue:_stopField.text forKey:@"STOP"];
        NSLog(@"all values \n %@", [courseInfo allValues]);
        
        [scheduleService createLecture:courseInfo];
        _yearField.text = @"";
        _startField.text = @"";
        _stopField.text = @"";
        _weekField.text = @"";
        _dayField.text = @"";
        _teacherField.text = @"";
        _courseField.text = @"";
        _roomField.text = @"";
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Failed" message:@"You need to fill out all the fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)createEvent:(id)sender
{
    NSLog(@"EVENT");
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTemplate:(id)sender
{
    NSLog(@"CANCEL");
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)courseExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)teacherExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)roomExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)dayExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)weekExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)yearExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)startExit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)stopExit:(id)sender
{
    [sender resignFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _superHejScroll.contentInset = contentInsets;
    _superHejScroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [_superHejScroll setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _superHejScroll.contentInset = contentInsets;
    _superHejScroll.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect bkgndRect = activeField.superview.frame;
//    bkgndRect.size.height += kbSize.height;
//    [activeField.superview setFrame:bkgndRect];
//    [_superHejScroll setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
//}

@end
