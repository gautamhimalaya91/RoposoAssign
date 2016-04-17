//
//  ViewController.m
//  RoposoAssignment
//
//  Created by KartRocket iOSOne on 17/04/16.
//  Copyright © 2016 Assignment. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"

#define REUSE_ROPOSO @"RoposoCell"


@interface RoposoCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView * imageImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * authorLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@end

@implementation RoposoCell

@end


@interface ViewController ()

@end

@implementation ViewController
@synthesize dataArray,datalistArray;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.roposoTableVIew reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoposoCell * roposoCell = (RoposoCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ROPOSO forIndexPath:indexPath];
    [roposoCell.imageImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:(indexPath.row + 2)] valueForKey:@"si"]]]];
    return roposoCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
