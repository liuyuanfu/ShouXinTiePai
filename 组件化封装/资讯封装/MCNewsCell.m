//
//  MCNewsCell.m
//  Project
//
//  Created by Nitch Zheng on 2019/12/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCNewsCell.h"
#import "HomeModel.h"
@interface MCNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icone;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@end
@implementation MCNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.icone.layer.cornerRadius = 5;
    self.icone.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updataWithModel:(HomeModel*)newsModel {
    [self.icone sd_setImageWithURL:[NSURL URLWithString:newsModel.lowSource] placeholderImage:[MCImageStore placeholderImageWithSize:CGSizeMake(118, 90)]];
    self.title.text = newsModel.title;
       
    if ([newsModel.createTime hasSuffix:@"000"]) {
        self.content.text = [MCDateStore compareCurrentTime:newsModel.createTime];
    } else {
        self.content.text = newsModel.createTime;
    }
}
@end
