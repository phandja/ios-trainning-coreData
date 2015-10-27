//
//  DetailViewController.m
//  ios-training-core-data
//
//  Created by Treinamento Mobile on 10/27/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@property (nonatomic, weak) UIImageView *cityimage;
@property (nonatomic, weak) UILabel *citylabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.cityimage.image=[UIImage imageNamed:self.city.imageName];
    //self.citylabel.text= [self.citylabel.text stringByAppendingString:self.city.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
