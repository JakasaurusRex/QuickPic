//
//  PostViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/27/22.
//

#import "PostViewController.h"
#import "Post.h"
#import <Parse/Parse.h>

@interface PostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property int picked;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.delegate = self;
    [self pictureRecognizerGesture];
    PFUser *user = [PFUser currentUser];
    if(user[@"email"] == nil) {
        [self alertWithTitle:@"Email not added" message:@"It is required to put in your email before continuing. Please go to the settings page found on the profile to customize your profile page and add your email."];
    }
}

- (void) pictureRecognizerGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage)];
    [self.postImage addGestureRecognizer:gesture];
    [self.postImage setUserInteractionEnabled:YES];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    NSLog(@"Post canceled");
}
- (IBAction)shareButton:(id)sender {
    if(![UIImagePNGRepresentation(self.postImage.image) isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"image_placeholder"])]) {
        if([self.textView.text isEqualToString:@"Write a caption..."]) {
            self.textView.text = @"";
        }
        UIImage *resizedImage = [self resizeImage:self.postImage.image withSize:CGSizeMake(300, 300)];
        [Post postUserImage:resizedImage withCaption:self.textView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error == nil) {
                NSLog(@"User made post");
            } else {
                NSLog(@"Error posting");
                return;
            }
        }];
        PFUser *user = [PFUser currentUser];
        int counter = [user[@"postCount"] intValue];
        user[@"postCount"] =  @(counter+1);
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error == nil) {
                NSLog(@"Post count increased");
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                NSLog(@"Error increasing post count");
                return;
            }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No image selected"
                                                                                   message:@"Please select an image to post."
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
}

-(void) didTapImage {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera ???? available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];

}

- (IBAction)libraryButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.postImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
  [textView setText:@""];
  //other awesome stuff here...
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) alertWithTitle: (NSString *)title message:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:text
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                        [self dismissViewControllerAnimated:true completion:nil];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
