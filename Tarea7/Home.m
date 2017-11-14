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
@property NSMutableArray *snikerNames;
@property NSMutableArray *snikerPrice;
@property NSMutableArray *snikerDescription;
@property NSMutableArray *snikerImages;
@property (strong, nonatomic) IBOutlet UIImageView *tmpImage;
@property NSMutableArray *dataToSend;
@end

@implementation Home
/**********************************************************************************************/
#pragma mark - Initialization methods
/**********************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initController];
}
//-------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------
- (void)initController {
    self.snikerNames  = [[NSMutableArray alloc] initWithObjects: @"Roshe run", @"Air max", @"Air force", @"Canvas", @"Runner", @"Roshe one", nil];
    
        self.snikerDescription  = [[NSMutableArray alloc] initWithObjects: @"Lorem impsum DIolor", @"Lorem impsum DIolor", @"Lorem impsum DIolor", @"Lorem impsum DIolor", @"Lorem impsum DIolor", @"Lorem impsum DIolor", nil];
    
    self.snikerPrice  = [[NSMutableArray alloc] initWithObjects: @"1500", @"2300", @"2200", @"1800", @"2100", @"2200", nil];

    self.snikerImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"nike.jpg"], [UIImage imageNamed:@"nike2.jpg"], [UIImage imageNamed:@"nike3.jpg"], [UIImage imageNamed:@"nike4.jpg"], [UIImage imageNamed:@"nike5.jpg"],[UIImage imageNamed:@"nike6.jpg"], nil];
}

/**********************************************************************************************/
#pragma mark - Table source and delegate methods
/**********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.snikerNames.count;
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
    cell.lblName.text       = self.snikerNames[indexPath.row];
    cell.lblAge.text        = self.snikerPrice[indexPath.row];
    cell.imgUser.image      = self.snikerImages[indexPath.row];
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.dataToSend = [[NSMutableArray alloc]init];
    [self.dataToSend addObject:@{
                                        @"name" :  self.snikerNames[indexPath.row],
                                        @"price" : self.snikerPrice[indexPath.row],
                                        @"image" :  self.snikerImages[indexPath.row],
                                        @"description": self.snikerDescription[indexPath.row]
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
        
        [self.snikerNames addObject:namefield.text];
        [self.snikerPrice addObject:agefield.text];
        
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

    [self.snikerImages addObject:chosenImage];
    [self.tblMain reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"secondView"])
    {
        secondViewViewController *controller = [segue destinationViewController];
        controller.data = sender;

    }
}

@end
