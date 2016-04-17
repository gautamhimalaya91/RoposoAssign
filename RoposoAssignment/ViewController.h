//
//  ViewController.h
//  RoposoAssignment
//
//  Created by KartRocket iOSOne on 17/04/16.
//  Copyright © 2016 Assignment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * datalistArray;
@property(nonatomic,weak)IBOutlet UITableView * roposoTableVIew;
@property(nonatomic,strong)NSMutableArray * statusArry;
@property(nonatomic,strong)NSMutableDictionary * followDict;
@property(nonatomic,strong)NSMutableArray * storyIDArray;


@property(nonatomic,weak)IBOutlet UIImageView * backgroundImg;
@property(nonatomic,weak)IBOutlet UIImageView * displayImg;
@property(nonatomic,weak)IBOutlet UILabel * nameLabel;
@property(nonatomic,weak)IBOutlet UILabel * urlLabel;
@property(nonatomic,weak)IBOutlet UILabel * followersLabel;
@property(nonatomic,weak)IBOutlet UILabel * createdOnLabel;
@property(nonatomic,weak)IBOutlet UILabel * aboutLabel;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * detailViewTopConst;
@property(nonatomic,weak)IBOutlet UIView * detailView;
@property(nonatomic,weak)IBOutlet UIButton * cancelBtn;
@property(nonatomic,weak)IBOutlet UIButton * followBtn;
@end

