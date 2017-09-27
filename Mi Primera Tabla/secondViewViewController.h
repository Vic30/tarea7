//
//  secondViewViewController.h
//  Mi Primera Tabla
//
//  Created by Vic on 9/27/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface secondViewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property NSDictionary *data;
@property (weak, nonatomic) IBOutlet UITextField *textdesc;
@property (weak, nonatomic) IBOutlet UITextField *age;
@end
