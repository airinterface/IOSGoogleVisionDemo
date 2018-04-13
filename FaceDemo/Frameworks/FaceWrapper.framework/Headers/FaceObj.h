//
//  FaceObj.h
//  FaceWrapper
//
//  Created by yuri on 4/2/18.
//  Copyright © 2018 Yuri Fukuda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceObj : NSObject

@property( nonatomic, readwrite ) NSMutableDictionary* faceData;
@property( nonatomic, readwrite ) NSUInteger id;

- ( NSDictionary* ) getData;


@end
