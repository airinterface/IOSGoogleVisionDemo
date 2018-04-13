//
//  ViewController.m
//  FaceDemo
//
//  Created by yuri on 3/30/18.
//  Copyright © 2018 AirInterface. All rights reserved.
//

#import "ViewController.h"
#import <FaceWrapper/FaceWrapper.h>

@interface ViewController ()
@property (retain, readwrite, nonatomic) FaceViewWrapper *faceWrapper;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@end

@implementation ViewController



- (void)viewDidLoad {
  [super viewDidLoad];
  NSDictionary* option = @{
                          @"cameraType"    : @"front",
                          @"debugEnabled"  : @YES,
                          @"singleFace"    : @NO,
                          @"onUpdate"      : ^( FaceObj* faceObj ) {
                            [self onFaceDetectorUpdate:faceObj ];
                            },
                          @"onNew"      : ^( FaceObj* faceObj ) {
                            [self onFaceDetectorNew:faceObj ];
                          },
                          @"onMissing"      :^( NSArray<FaceObj*>* faceObjList ) {
                            [self onFaceDetectorMissing:faceObjList ];
                          },
                          @"onDone"         :^() {
                            [self onFaceDetectorDone ];
                          }

                          };
  self.faceWrapper  = [[ FaceViewWrapper alloc] init];
  UIView* view = [self.faceWrapper createFaceView : option];
  view.frame = self.view.bounds;
  [self.mainView addSubview: view ];

  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void) onFaceDetectorNew: (FaceObj* ) faceObj {
  if( faceObj != NULL ) {
    NSDictionary* faceData = [ faceObj getData ];
    NSLog(@"[face]New!!!!! %lu", (unsigned long) [ faceData objectForKey: @"smileProbability"] );
  }
}

- (void) onFaceDetectorUpdate: (FaceObj* ) faceObj {
  if( faceObj != NULL ) {
    NSDictionary* faceData = [ faceObj getData ];
    NSLog(@"[face]update!!!!! %lu", (unsigned long) [ faceData objectForKey: @"smileProbability"] );
  }
}

- (void) onFaceDetectorMissing: ( NSArray<FaceObj*>* ) faceObjList {
  if( faceObjList != NULL ) {
    NSLog(@"[face]Missing!!!!! %lu", (unsigned long) [ faceObjList count] );
  }
}

- (void) onFaceDetectorDone{
  NSLog(@"[face]Done!!!!!");
}


@end
