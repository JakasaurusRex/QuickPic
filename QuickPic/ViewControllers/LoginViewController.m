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
        [self alerter:@"Username required":@"Please enter a username."];
    } else if([self.password.text isEqual:@""]) {
        [self alerter:@"Password required":@"Please enter a password."];
    } else if([self.username.text rangeOfString:@" "].location != NSNotFound){
        [self alerter:@"Invalid username":@"Please enter a valid username. Usernames cannot contain spaces."];
    } else if([self.password.text rangeOfString:@" "].location != NSNotFound) {
        [self alerter:@"Invalid password":@"Please enter a valid password. Password cannot contain spaces."];
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
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            if(error.code == 202) {
                [self alerter:@"Username taken":@"An account already exists with this username, please enter another valid username."];
            }
        } else {
            NSLog(@"User registered successfully");
            // manually segue to logged in view
            self.firstTime = 1;
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            if([self.username.text isEqual:@""]) {
                [self alerter:@"Username required":@"Please enter a username."];
            } else if([self.password.text isEqual:@""]) {
                [self alerter:@"Password required":@"Please enter a password."];
            } else {
                [self alerter:@"Invalid login information":@"Please enter valid login information or create an account by clicking signup with a username and password."];
            }
            
        } else {
            NSLog(@"User logged in successfully");
            self.firstTime = 0;
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


//Method to create an alert on the login screen.
- (void) alerter: (NSString *)title :(NSString *)text {
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //If this is the users first time (they just registered) send that information
    if(self.firstTime == 1) {
        UINavigationController *navigationController = [segue destinationViewController];
        HomeViewController *homeController = (HomeViewController*)navigationController.topViewController;
        homeController.firstTime = 1;
    }
}


@end
