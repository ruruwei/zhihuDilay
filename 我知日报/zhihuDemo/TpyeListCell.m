//
//  TpyeListCell.m
//  zhihuDemo
//
//  Created by ruru on 16/5/26.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "TpyeListCell.h"

@implementation TpyeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(id)initWithData:(NSMutableDictionary *)info tableView:(id)tableView{
    static NSString *cellIndentifier=@"cellIdenti";
    self=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (self==nil) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"TpyeListCell" owner:self options:nil]lastObject];
    }
    self.tpyeListLab.text=info[@"name"];
    return self;
}
@end
