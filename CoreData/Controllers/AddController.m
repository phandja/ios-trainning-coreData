//
//  AddController.m
//  CoreData
//
//  Created by Treinamento Mobile on 10/27/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import "AddController.h"

@interface AddController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UIImageView *cityImage;
@property (nonatomic, strong) NSManagedObjectContext *context;


@end

@implementation AddController

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
    // Do any additional setup after loading the view.
    
    self.title = @"Adicionar Cidade";
    [self setInitialValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)cancelButtonTap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPhoto:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.cityImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - CoreDataActions
-(IBAction)addEntry:(id)sender {
    Place *place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:self.context];
    
    place.name = self.nameField.text;
    place.image = UIImagePNGRepresentation(self.cityImage.image);
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"%@", error);
    }else{
        NSLog(@"%@ adcionado com sucesso!", place.name);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
