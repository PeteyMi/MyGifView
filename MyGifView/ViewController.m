//
//  ViewController.m
//  MyGifView
//
//  Created by Petey Mi on 8/3/15.
//  Copyright © 2015 Petey Mi. All rights reserved.
//

#import "ViewController.h"
#import "MyGifView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
    NSData* data = [NSData dataWithContentsOfURL:fileUrl];
//    MyGifView* gifView = [[MyGifView alloc] initWithFrame:CGRectMake(100, 100, 200, 200) url:fileUrl];
//    MyGifView* gifView = [[MyGifView alloc] initWithFrame:CGRectMake(100, 100, 200, 200) data:data];
    MyGifView* gifView = [[MyGifView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    gifView.data = data;
    [self.view addSubview:gifView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
