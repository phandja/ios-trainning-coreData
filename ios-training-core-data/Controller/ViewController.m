//
//  ViewController.m
//  ios-training-core-data
//
//  Created by Treinamento Mobile on 10/27/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import "ViewController.h"
#import "Place.h"
#import "AppDelegate.h"
#import "PlaceTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self  setupInitialValues];
    
    // Do any additional setup after loading the view, typically from a nib.
}

// Printing data in the table View
- (void)setupInitialValues {
    
    self.data = [self fetchEntries];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                  forIndexPath:indexPath];
    
    Place *p = self.data[indexPath.row];
    cell.nameLabel.text = p.name;
    cell.cityImageView.image = [UIImage imageWithData:p.image];
    
    return cell;
}

// Fetching dada from de data base
- (NSArray *) fetchEntries
{
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Sao Paulo"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[descriptor];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    //for (Place *p in array) {
        
        //receber dados e printar no table view
        
        //NSLog(@"%@",p.name);
   // }
    return array;
}

// Putting data in the data base
- (void) newEntry
{
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                 inManagedObjectContext:context];
    
    place.name = @"Curitiba";
    place.image = UIImagePNGRepresentation([UIImage imageNamed:@"curitiba"]);
    
    NSError *error = nil;
    if (![ context save:&error]) {
        NSLog(@"%@", error);
    }
    
}

- (void) saveCity{
    
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //imageView.layer.cornerRadius = 15.0f;
    //imageView.layer.masksToBounds = YES;
    //imageView.image = [UIImage imageNamed:@"masp"];
}


@end
