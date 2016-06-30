//
//  myTableCell.m
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "myTableCell.h"

@implementation myTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTitle.numberOfLines=0;
    self.contentTitle.lineBreakMode=NSLineBreakByWordWrapping;
    // Initialization code
}
-(id)initWithData:(NSMutableDictionary *)info tableView:(id)tableView{
    static NSString *cellIdentifier=@"cellIdentifier";
    self=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self==nil) {
        self=[[[NSBundle mainBundle]loadNibNamed:@"myTableCell" owner:self options:nil]lastObject];
    }
    self.contentTitle.text=[info objectForKey:@"title"];
    NSString *url=[info objectForKey:@"images"][0];
    [Common loadImage:self.contentimages url:url];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
