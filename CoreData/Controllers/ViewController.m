//
//  ViewController.m
//  CoreData
//
//  Created by Treinamento Mobile on 10/27/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *placeTableView;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ViewController
- (id)init {
    if ( self = [super init] ) {
        [self setInitialValues];
    }
    return self;
}

- (void)setInitialValues {
    self.context = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Cidades";
    
    [self setInitialValues];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadData];
    [self.placeTableView reloadData];
}

# pragma mark - UITableViewImplementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                  forIndexPath:indexPath];
    
    if (self.places.count > 0) {
        Place *place = self.places[indexPath.row];
        cell.placeName.text = place.name;
        
        cell.placeImage.image = [UIImage imageWithData:place.image];
        cell.placeImage.layer.cornerRadius = cell.placeImage.frame.size.height / 2;
        cell.placeImage.layer.masksToBounds = YES;
        
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Place *place = self.places[indexPath.row];
    [self.context deleteObject:place];
    
    NSError *error = nil;
    [self.context save:&error];
    [self loadData];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

# pragma mark - CoreData
- (void)loadData {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        //    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", @"São Paulo"];
        request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
        
        self.places = [self.context executeFetchRequest:request error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    
    });
}

#pragma mark - Navigation
    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        Place *place = self.places[self.tableView.indexPathForSelectedRow.row];
        detailVC.place = place;
    }
}
@end
