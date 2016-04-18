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
    self.statusArry = [[NSMutableArray alloc]init];
    
    self.detailView.hidden = YES;
    
    
    //applying blurr to the background image
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    self.imageViewView.clipsToBounds = YES;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.imageViewView addSubview:blurEffectView];
    
    [self.imageViewView bringSubviewToFront:self.nameLabel];
    [self.imageViewView bringSubviewToFront:self.urlLabel];
    [self.imageViewView bringSubviewToFront:self.followersLabel];
    [self.imageViewView bringSubviewToFront:self.displayImg];
    [self.imageViewView bringSubviewToFront:self.followBtn];
    
    [self extractDataFromJson];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
}

-(void)extractDataFromJson{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"iOS-Android Data" ofType:@"json"];
    NSError *error = nil; // This so that we can access the error if something goes wrong
    NSData *JSONData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    // Load the file into an NSData object called JSONData
    // Retrieve local JSON file called iOS-Android Data.json
    
    id object = [NSJSONSerialization
                JSONObjectWithData:JSONData
                options:NSJSONReadingAllowFragments
                error:&error];
    
    if ([object isKindOfClass:[NSArray class]])
    {
        self.dataArray = (NSMutableArray*)object;
    }
    
    for (int list = 0; list < self.dataArray.count; list ++)
    {
        if([[self.dataArray objectAtIndex:list] valueForKey:@"type"])
        {
            [self.datalistArray addObject:[self.dataArray objectAtIndex:list]];
        }
    }
    
    for (int st = 0; st < self.dataArray.count; st++)
    {
        [self.statusArry addObject:@"0"];
    }
    
    [self.roposoTableVIew reloadData];
    
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = 10;
}

#pragma Mark - Table View delegate and Datasource methods

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
    
    
    NSString * url = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] objectForKey:@"si"]];
    [roposoCell.imageImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    roposoCell.imageImageView.clipsToBounds = YES;
    roposoCell.imageImageView.layer.cornerRadius = roposoCell.imageImageView.bounds.size.height/2;
    
    roposoCell.followButton.layer.cornerRadius = 10;
    
    roposoCell.titleLabel.text = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
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
    
    NSString * descString = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"description"]];
    
    CGSize descLength = [self sizeInitWithFontName:@"HelveticaNeue-Light" andDataString:descString andFontSize:12];
    
    roposoCell.descLabel.text = descString;
    roposoCell.descHeightConst.constant = descLength.height;
    
    if(roposoCell.descLabel.text.length == 0)
    {
        roposoCell.descHeightConst.constant = 0;
    }
    
    [roposoCell.followButton addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    roposoCell.followButton.tag = indexPath.row;
    if([[NSString stringWithFormat:@"%@",[self.statusArry objectAtIndex:indexPath.row]]isEqualToString:@"0"])
    {
        [roposoCell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }else{
        [roposoCell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
    
    return roposoCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * descString = [NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"description"]];

    CGSize descLength = [self sizeInitWithFontName:@"HelveticaNeue-Light" andDataString:descString andFontSize:12];

    if(descString.length == 0){
        return descLength.height +100;
    }
    return 150 + descLength.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * shilpaID = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"id"]];
    NSString * nargisID = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"id"]];
    self.followBtn.tag = indexPath.row;
    self.displayImg.clipsToBounds = YES;
    self.backgroundImg.clipsToBounds = YES;

    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:shilpaID]){
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"username"]];
        self.urlLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"handle"]];
        self.followersLabel.text = [NSString stringWithFormat:@"Followers : %@",[[self.dataArray objectAtIndex:0] valueForKey:@"followers"]];
        [self.displayImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"image"]]]];
        [self.backgroundImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"image"]]]];
        self.aboutLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:0] valueForKey:@"about"]];
        [self.aboutLabel sizeToFit];
        
        
        [self animateView];
    }
    if([[NSString stringWithFormat:@"%@",[[self.datalistArray objectAtIndex:indexPath.row] valueForKey:@"db"]]isEqualToString:nargisID]){
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"username"]];
        self.urlLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"handle"]];
        self.followersLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"followers"]];
        [self.displayImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"image"]]]];
        [self.backgroundImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"image"]]]];
        self.aboutLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:1] valueForKey:@"about"]];
        
        [self animateView];
    }
    
}

-(void)animateView
{
    self.detailView.hidden = NO;
    
    [self.detailView setTransform:CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.detailView setTransform:CGAffineTransformIdentity];
        }];
    });

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

- (CGSize)sizeInitWithFontName:(NSString*)fontName andDataString:(NSString*)dataString andFontSize:(float)fontSize
{
    CGSize size;
    UIFont *dataFont = [UIFont fontWithName:fontName size:fontSize];
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObject:dataFont forKey:NSFontAttributeName];
    NSMutableAttributedString *dataText = [[NSMutableAttributedString alloc] initWithString:dataString attributes:dataDictionary];
    
    CGRect dataFrame = [dataText boundingRectWithSize:(CGSize){304, MAXFLOAT}
                                              options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              context:nil];
    return size = dataFrame.size;
}


-(void)cancelBtnClicked
{
    self.detailView.hidden = YES;
}

@end
