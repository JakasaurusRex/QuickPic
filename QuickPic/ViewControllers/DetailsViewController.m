//
//  DetailsViewController.m
//  QuickPic
//
//  Created by Jake Torres on 6/28/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.text = self.post.author[@"username"];
    self.caption.text = self.post[@"caption"];
    
    self.createdAt.text = self.post[@"updatedAt"];
    
    
    //turning PFFileObject that is the post image into data to be used to turn into an image
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil) {
            self.postImage.image = [UIImage imageWithData:data];
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error loading image");
        }
    }];
    // Do any additional setup after loading the view.
}





@end
