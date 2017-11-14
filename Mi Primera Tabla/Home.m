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
@import Firebase;
@import GoogleSignIn;

@interface Home ()
@property NSMutableArray *snikerNames;
@property NSMutableArray *snikerPrice;
@property NSMutableArray *snikerDescription;
@property NSMutableArray *snikerImages;
@property (strong, nonatomic) IBOutlet UIImageView *tmpImage;
@property NSMutableArray *dataToSend;
@property (strong, nonatomic) NSMutableArray *people;
@end

int indexPerson = 0;

@implementation Home
/**********************************************************************************************/
#pragma mark - Initialization methods
/**********************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initController];
    _people = [[NSMutableArray alloc] init];
    [self getPeople];
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
    if([_people count] > 0){
        personModel *person = [_people objectAtIndex:indexPerson];
        NSString *name = person.name;
        cell.lblName.text       = person.name;
        cell.lblId.text = [NSString stringWithFormat:@"%d",indexPerson];
        //cell.imgUser.image      = self.snikerImages[indexPath.row];
        indexPerson++;
    }
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    personModel *person = [_people objectAtIndex:indexPath.row];
    self.dataToSend = [[NSMutableArray alloc]init];
    [self.dataToSend addObject:@{
                                        @"height" :  person.height,
                                        @"skin" : person.skin_color,
                                        @"hair": person.hair_color
                                        }];
    
    NSDictionary *objectToSend = self.dataToSend[0];
    [self performSegueWithIdentifier:@"secondView" sender:objectToSend];
    // Log event, when a product is selected
    [FIRAnalytics logEventWithName:@"Product_selected"
                        parameters:@{
                                     @"name": self.snikerNames[indexPath.row],
                                     @"price": self.snikerPrice[indexPath.row],
                                     }];
    NSLog(@"Item selected");
}
/**********************************************************************************************/
#pragma mark - Action methods
/**********************************************************************************************/
- (IBAction)btnAddPressed:(id)sender {
    
    [self getPeople];
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

//********************************************************************************************
#pragma mark                            Data methods
//********************************************************************************************
- (void)getPeople{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPeople:^(NSMutableArray<personModel> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            personModel *person = [people objectAtIndex:indexPerson];
            NSString *name = person.name;
            
            NSLog(@"print name : %@", name);
            //self.lblName.text = name;
            //self.lblName.adjustsFontSizeToFitWidth = YES;
            
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tblMain reloadData];
    }];
}
- (void)getPerson{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPerson:@"1" completion:^(NSMutableArray<personModel> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            personModel *person = [people objectAtIndex:indexPerson];
            NSString *name = person.name;
            
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

//********************************************************************************************
#pragma mark                            Action methods
//********************************************************************************************
- (IBAction)btnUpdatePressed:(id)sender {
    [self getPeople];
}


@end
