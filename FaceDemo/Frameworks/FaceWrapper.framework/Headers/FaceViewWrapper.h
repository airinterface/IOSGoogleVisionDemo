//
//  FaceViewWrapper.h
//  AppGeneration
//
//  Created by Yuri Fukuda on 3/13/18.
//  Copyright © 2018 EachScape. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FaceViewWrapper : UIView
- (UIView* ) createFaceView :(NSDictionary *)options;
- ( void ) destroy;
@end

