#import "CBCourseFormViewController.h"
#import "CBScheduleService.h"

@interface CBCourseFormViewController ()

@end

@implementation CBCourseFormViewController
{
    NSMutableDictionary *courseInfo;
    NSMutableArray *days;
    NSMutableArray *weeks;
    UITextField *activeField;
}
//@synthesize teacherField = _teacherField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        courseInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSMutableArray array], @"COURSE",
                      [NSMutableArray array], @"TEACHER",
                      [NSMutableArray array], @"ROOM",
                      [NSMutableArray array], @"DAYS",
                      [NSMutableArray array], @"WEEKS",
                      [NSMutableArray array], @"YEAR",
                      [NSMutableArray array], @"START",
                      [NSMutableArray array], @"STOP", nil];
        
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Add course"];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(doneWithCourse:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(cancelWithCourse:)];
        [item setRightBarButtonItem:doneButton];
        [item setLeftBarButtonItem:cancelButton];

        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)courseExit:(id)sender
{
    [sender resignFirstResponder];
    //NSLog(@"didEndOnExit");
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

- (IBAction)cancelWithCourse:(id)sender
{
    
}

-(IBAction)doneWithCourse:(id)sender
{
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
        
        CBScheduleService *scheduleService = [CBScheduleService schedule];
        [scheduleService createLecture:courseInfo];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Failed" message:@"You need to fill out all the fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
