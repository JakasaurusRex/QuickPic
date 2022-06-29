//
//  LoginViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}
- (IBAction)signupButton:(id)sender {
    if([self.username.text isEqual:@""]) {
        [self alertWithTitle:@"Username required"message:@"Please enter a username."];
    } else if([self.password.text isEqual:@""]) {
        [self alertWithTitle:@"Password required"message:@"Please enter a password."];
    } else if([self.username.text rangeOfString:@" "].location != NSNotFound){
        [self alertWithTitle:@"Invalid username"message:@"Please enter a valid username. Usernames cannot contain spaces."];
    } else if([self.password.text rangeOfString:@" "].location != NSNotFound) {
        [self alertWithTitle:@"Invalid password"message:@"Please enter a valid password. Password cannot contain spaces."];
    } else {
        [self registerUser];
    }
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    newUser[@"profilePic"] = [self getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    newUser[@"firstTime"] = @(true);
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            if(error.code == 202) {
                [self alertWithTitle:@"Username taken"message:@"An account already exists with this username, please enter another valid username."];
            }
        } else {
            NSLog(@"User registered successfully");
            // manually segue to logged in view
            self.firstTime = YES;
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    if([self.username.text isEqual:@""]) {
        [self alertWithTitle:@"Username required"message:@"Please enter a username."];
        return;
    } else if([self.password.text isEqual:@""]) {
        [self alertWithTitle:@"Password required"message:@"Please enter a password."];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self alertWithTitle:@"Invalid login information" message: error.localizedDescription];
            return;
        } else {
            NSLog(@"User logged in successfully");
            user[@"firstTime"] = @(false);
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}
- (IBAction)forgotPass:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset password"
                                                                               message:@"Please enter the email you added on your profile:"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    [alert addAction:cancelAction];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textFields = alert.textFields;
        UITextField *text = textFields[0];
        [self resetPassword:text.text];
        [self pause];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) resetPassword: (NSString *)email {
    NSString *emailLower = [email lowercaseString];
    emailLower = [emailLower stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [PFUser requestPasswordResetForEmailInBackground:emailLower block:^(BOOL succeeded, NSError * _Nullable error) {
        if(error == nil) {
            [self alertWithTitle:@"Success" message:@"Success! Check your email for further instructions. Please allow up to 5 minutes to receive your email."];
        } else {
            [self alertWithTitle:@"Error!" message:@"Could not complete request."];
        }
        [self unpause];
    }];
}

-(void) pause {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.hidesWhenStopped = true;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleMedium];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
}

-(void) unpause{
    [self.activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
}


//Method to create an alert on the login screen.
- (void) alertWithTitle: (NSString *)title message:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:text
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //If this is the users first time (they just registered) send that information
    if(self.firstTime == YES) {
        UITabBarController *tabBarController = [segue destinationViewController];
        UINavigationController *navController = (UINavigationController *)tabBarController.selectedViewController;
        HomeViewController *homeController = (HomeViewController*)navController.topViewController;
        homeController.firstTime = YES;
    }
}


@end
