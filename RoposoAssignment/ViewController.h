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

@end

