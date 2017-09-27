//
//  ViewController.m
//  Mi Primera Tabla
//
//  Created by Walter Gonzalez Domenzain on 20/09/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import "Home.h"
#import "cellMainTable.h"
#import "secondViewViewController.h"

@interface Home ()
@property NSMutableArray *userNames;
@property NSMutableArray *userAges;
@property NSMutableArray *userDescriptions;
@property NSMutableArray *userImages;
@property (strong, nonatomic) IBOutlet UIImageView *tmpImage;
@property NSMutableArray *dataToSend;
@end

@implementation Home
/**********************************************************************************************/
#pragma mark - Initialization methods
/**********************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initController];
}
//-------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------
- (void)initController {
    self.userNames  = [[NSMutableArray alloc] initWithObjects: @"Tyrion Lannister", @"Daenerys Targaryen", @"Jon Snow", @"Arya Stark", @"Cersei Lannister", nil];
    
        self.userDescriptions  = [[NSMutableArray alloc] initWithObjects: @"Tyrion Lannister is a man", @"Daenerys Targaryen is a bad person", @"I hate Jon Snow", @"I love Arya Stark", @"I hate Cersei Lannister", nil];
    
    self.userAges  = [[NSMutableArray alloc] initWithObjects: @"38 años", @"22 años", @"25 años", @"16 años", @"42 años", nil];

    self.userImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"tyrion.jpg"], [UIImage imageNamed:@"daenerys.jpeg"], [UIImage imageNamed:@"jon.jpg"], [UIImage imageNamed:@"arya.jpg"], [UIImage imageNamed:@"cersei.jpg"], nil];
}

/**********************************************************************************************/
#pragma mark - Table source and delegate methods
/**********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userNames.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Initialize cells
    cellMainTable *cell = (cellMainTable *)[tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"cellMainTable" bundle:nil] forCellReuseIdentifier:@"cellMainTable"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    }
    //Fill cell with info from arrays
    cell.lblName.text       = self.userNames[indexPath.row];
    cell.lblAge.text        = self.userAges[indexPath.row];
    cell.imgUser.image      = self.userImages[indexPath.row];
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.dataToSend = [[NSMutableArray alloc]init];
    [self.dataToSend addObject:@{
                                        @"name" :  self.userNames[indexPath.row],
                                        @"age" : self.userAges[indexPath.row],
                                        @"image" :  self.userImages[indexPath.row],
                                        @"description": self.userDescriptions[indexPath.row]
                                        }];
    
    NSDictionary *objectToSend = self.dataToSend[0];
    [self performSegueWithIdentifier:@"secondView" sender:objectToSend];
    NSLog(@"Item selected");
}
/**********************************************************************************************/
#pragma mark - Action methods
/**********************************************************************************************/
- (IBAction)btnAddPressed:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add new item"
                                                                              message: @"Input Name Age and Image"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"age";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        UITextField * agefield = textfields[1];
        
        [self.userNames addObject:namefield.text];
        [self.userAges addObject:agefield.text];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
        //[self.userImages addObject:@"jon.jpg"];
        
        //[self.tblMain reloadData];
        
        NSLog(@"%@:%@",namefield.text,agefield.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // output image
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.tmpImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self.userImages addObject:chosenImage];
    [self.tblMain reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"secondView"])
    {
        secondViewViewController *controller = [segue destinationViewController];
        controller.data = sender;
        NSLog(@"Segueado!!!!!");

    }
}

@end
