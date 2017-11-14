//
//  WebServices.h
//  Tarea 5 - Zapateria
//
//  Created by Vic on 11/13/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "personModel.h"

@interface WebServices : NSObject<NSURLSessionDelegate>

+ (void)getPeople:(void (^)(NSMutableArray<personModel> *people)) handler;
+ (void)getPerson:(NSString*)personID completion: (void (^)(NSMutableArray<personModel> *people)) handler;

@end
