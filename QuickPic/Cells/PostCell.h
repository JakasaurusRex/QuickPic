//
//  PostCell.h
//  QuickPic
//
//  Created by Jake Torres on 6/28/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end

NS_ASSUME_NONNULL_END
