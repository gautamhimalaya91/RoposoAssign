//
//  ViewController.m
//  RoposoAssignment
//
//  Created by KartRocket iOSOne on 17/04/16.
//  Copyright © 2016 Assignment. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}

-(void)extractDataFromJson{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"iOS-Android Data" ofType:@"json"];
    
    NSError *error = nil; // This so that we can access the error if something goes wrong
    NSData *JSONData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    // Load the file into an NSData object called JSONData
    // Retrieve local JSON file called example.json
    
    self.dataArray =  [NSJSONSerialization
                       JSONObjectWithData:JSONData
                       options:NSJSONReadingAllowFragments
                       error:&error];
}

@end
