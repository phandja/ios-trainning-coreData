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
#import "DetailViewController.h"
#import "UINavigationController+Categoria.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSArray *dado;
@property (nonatomic, weak) IBOutlet UIImageView *imageSelect;
@property (nonatomic, weak) IBOutlet UITextField *cityName;
@property (nonatomic, strong) NSData *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"view Did Load --- ");    [self  setupInitialValues];
    // Do any additional setup after loading the view, typically from a nib.
}

// Printing data in the table View
- (void)setupInitialValues {
    self.dado = [self fetchEntries];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dado.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                  forIndexPath:indexPath];
    Place *p = self.dado[indexPath.row];
    cell.nameLabel.text = p.name;
    cell.cityImageView.image = [UIImage imageWithData:p.image];
    
    return cell;
}

// Fetching dada from de data base
- (NSArray *) fetchEntries {
    
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    //request.predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Sao Paulo"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[descriptor];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (Place *p in array) {
        //receber dados e printar no table view
        NSLog(@"%@",p.name);
    }
    return array;
}

// Putting data in the data base
- (void) newEntry: (NSString *) imageName {
    
    NSLog(@"Iniciando New Entry --- ");
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                 inManagedObjectContext:context];
    place.name = imageName;
    place.image = UIImagePNGRepresentation([UIImage imageNamed:@"curitiba"]);
    NSError *error = nil;
    
    if (![ context save:&error]) {
        NSLog(@"%@", error);
    }
    
    else {
        NSLog(@"Success!! -- ");
    }
    //[self fetchEntries];
    
}

- (IBAction)savecityt:(UIButton *)sender{
 
    NSLog(@"Metodo save --- ");
    [self newEntry:self.cityName.text];
}

- (IBAction)pickImage:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageSelect.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Removed because we add a segue to any cell, so we don't need this alert anymore
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Place *p = self.data[indexPath.row];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cidade"
                                                                             message:p.name
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *detailAction = [UIAlertAction actionWithTitle:@"Detalhes"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self performSegueWithIdentifier:@"CityDetailSegue" sender:nil];
                                                         }];
    [alertController addAction:detailAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CityDetailSegue"]) {
        DetailViewController *detailViewC = segue.destinationViewController;
        Place *p = self.data[self.tableView.indexPathForSelectedRow.row];
        detailViewC.place = p;
    }
}

@end
