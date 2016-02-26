//
//  VIEShowMainTableViewCell.m
//  Viediscovery
//
//  Created by Vie on 16/2/22.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIEShowMainTableViewCell.h"
#import "VIEShowMainCellModel.h"
#import <UIImageView+WebCache.h>
@interface VIEShowMainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weibotextLabel;

@end
@implementation VIEShowMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTopic:(VIEShowMainCellModel *)topic{
    _topic = topic;
    
    //设定用户头像以及默认头像
    [self.profile_image sd_setImageWithURL:[NSURL URLWithString:topic.profile_image_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
        //用户昵称
    self.nameLabel.text = topic.name;
    
    //微博创建时间
    self.timeLabel.text = topic.created_at;
    
    
    //微博内容
    self.weibotextLabel.text = topic.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    
    frame.origin.x = margin;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

@end
