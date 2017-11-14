//
//  secondViewViewController.h
//  Mi Primera Tabla
//
//  Created by Vic on 9/27/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface secondViewViewController : UIViewController
@property NSDictionary *data;
@property (weak, nonatomic) IBOutlet UITextField *skin;
@property (weak, nonatomic) IBOutlet UITextField *hair;
@property (weak, nonatomic) IBOutlet UITextField *height;

@end
