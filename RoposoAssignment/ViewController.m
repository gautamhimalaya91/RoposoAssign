//
//  ViewController.m
//  RoposoAssignment
//
//  Created by KartRocket iOSOne on 17/04/16.
//  Copyright © 2016 Assignment. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"

#define REUSE_ROPOSO @"RoposoCell"


@interface RoposoCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView * imageImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * authorLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UIButton * followButton;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * descHeightConst;
@end

@implementation RoposoCell

@end


@interface ViewController ()

@end

@implementation ViewController
@synthesize dataArray,datalistArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    self.datalistArray = [[NSMutableArray alloc]init];
    self.storyIDArray = [[NSMutableArray alloc]init];
    self.statusArry = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.detailViewTopConst.constant = self.view.bounds.size.height;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self extractDataFromJson];
}

-(void)extractDataFromJson{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"iOS-Android Data" ofType:@"json"];
    NSError *error = nil; // This so that we can access the error if something goes wrong
    NSData *JSONData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    // Load the file into an NSData object called JSONData
    // Retrieve local JSON file called example.json
    
    id object = [NSJSONSerialization
                JSONObjectWithData:JSONData
                options:NSJSONReadingAllowFragments
                error:&error];
    
    if ([object isKindOfClass:[NSArray class]])
    {
        self.dataArray = (NSMutableArray*)object;
    }
    
    for (int test = 0; test<self.dataArray.count; test++) {
        if([[self.dataArray objectAtIndex:test] valueForKey:@"type"]){
            [self.datalistArray addObject:[self.dataArray objectAtIndex:test]];
        }
    }
    
    [self.roposoTableVIew reloadData];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoposoCell * roposoCell = (RoposoCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ROPOSO forIndexPath:indexPath];
    
    roposoCell.imageImageView.clipsToBounds = YES;
    roposoCell.imageImageView.layer.cornerRadius = roposoCell.imageImageView.bounds.size.height/2;
    roposoCell.followButton.layer.cornerRadius = 10;
    roposoCell.titleLabel.text = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    roposoCell.imageImageView.backgroundColor = [UIColor blackColor];
   // NSString * url = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] objectForKey:@"si"]];
   // roposoCell.imageImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    NSString * shilpaStoryId = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] objectForKey:@"id"]];
    NSString * nargisStoryId = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] objectForKey:@"id"]];
    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:shilpaStoryId])
    {
        roposoCell.authorLabel.text = [NSString stringWithFormat:@"Author of the story : %@",[[self.dataArray objectAtIndex:0] valueForKey:@"username"]];
    }
    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:nargisStoryId])
    {
        roposoCell.authorLabel.text = [NSString stringWithFormat:@"Author of the story : %@",[[self.dataArray objectAtIndex:1] valueForKey:@"username"]];
    }
    roposoCell.descLabel.text = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"description"]];
    if(roposoCell.descLabel.text.length > 20){
        roposoCell.descHeightConst.constant = 70;
    }else{
        [roposoCell.descLabel sizeToFit];
    }
    [roposoCell.followButton addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    roposoCell.followButton.tag = indexPath.row;
    if([[NSString stringWithFormat:@"%@",[self.statusArry objectAtIndex:indexPath.row]]isEqualToString:@"0"])
    {
        [roposoCell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }else{
        [roposoCell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
        //[roposoCell.imageImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    return roposoCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoposoCell * roposoCell = (RoposoCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString * shilpaID = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"id"]];
    NSString * nargisID = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"id"]];
    self.followBtn.tag = indexPath.row;
//    if([roposoCell.followButton.titleLabel.text isEqualToString:@"Follow"]){
//        [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
//    }else{
//        [self.followBtn setTitle:@"Followed" forState:UIControlStateNormal];
//    }

    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:shilpaID]){
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"username"]];
        self.urlLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"handle"]];
        self.followersLabel.text = [NSString stringWithFormat:@"Followers : %@",[[self.dataArray objectAtIndex:0] valueForKey:@"followers"]];
//        self.createdOnLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"createdOn"]];
        self.aboutLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"about"]];
        [self.aboutLabel sizeToFit];
        
        
        [self animateView];
    }
    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:nargisID]){
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"username"]];
        self.urlLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"handle"]];
        self.followersLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"followers"]];
//        self.createdOnLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"createdOn"]];
        self.aboutLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"about"]];
        
        [self animateView];
    }
    
}

-(void)animateView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.detailView setFrame:CGRectMake(0, self.view.frame.origin.y+64,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void)followButtonClicked:(UIButton *)sender{
    
    if( [[NSString stringWithFormat:@"%@",[self.statusArry objectAtIndex:sender.tag]]isEqualToString:@"0"]){
        [self.statusArry replaceObjectAtIndex:sender.tag withObject:@"1"];
        [self.followBtn setTitle:@"Followed" forState:UIControlStateNormal];
        [self.roposoTableVIew reloadData];
    }else{
        [self.statusArry replaceObjectAtIndex:sender.tag withObject:@"0"];
        [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
        [self.roposoTableVIew reloadData];
    }

}


-(void)cancelBtnClicked{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.detailView setFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
@end
