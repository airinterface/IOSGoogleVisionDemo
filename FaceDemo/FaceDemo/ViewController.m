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
@property (weak, nonatomic) IBOutlet UIView *capturedView;
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
                          @"onMissing"      :^( NSInteger id, NSArray<FaceObj*>* faceObjList ) {
                            [self onFaceDetectorMissing: id faces:faceObjList ];
                          },
                          @"onDone"         :^() {
                            [self onFaceDetectorDone ];
                          }

                          };
  self.faceWrapper  = [[ FaceViewWrapper alloc] init];
  UIView* view = [self.faceWrapper createFaceView : option];
  view.frame = self.view.bounds;
  [self.mainView addSubview: view ];

  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleSingleTap:)];
  [self.mainView addGestureRecognizer:singleFingerTap];
  
  self.capturedView.layer.borderWidth = 10;
  self.capturedView.layer.borderColor = UIColor.cyanColor.CGColor;
  self.capturedView.layer.cornerRadius = 40;
  // Do any additional setup after loading the view, typically from a nib.
}



//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  
  UIWindow * mainWindow = [UIApplication sharedApplication].windows.firstObject;
  //UIImage * res = [self captureImageFromUIView:mainWindow];
  [self.faceWrapper captureImage: ^(UIImage* myImage) {
    //self.capturedView.backgroundColor = [UIColor colorWithPatternImage: myImage];
    dispatch_async(dispatch_get_main_queue(), ^{
          CALayer* caputuredLayer = self.capturedView.layer;
          caputuredLayer.contentsGravity = kCAGravityResizeAspect;
          caputuredLayer.contents = ( __bridge id )[ myImage CGImage ];
          [ caputuredLayer setNeedsDisplay ];
          //[ caputuredLayer displayIfNeeded];
    });


  } errorCallback: ^(NSString* message){
    NSLog(message);
  }];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void) onFaceDetectorNew: (FaceObj* ) faceObj {
  if( faceObj != NULL ) {
    NSDictionary* faceData = [ faceObj getData ];
    NSLog(@"[face]New!!!!! %lu", (unsigned long) [ faceData objectForKey: @"smilingProbability"] );
  }
}

- (void) onFaceDetectorUpdate: (FaceObj* ) faceObj {
  if( faceObj != NULL ) {
    NSDictionary* faceData   = [ faceObj getData ];
    NSNumber* _number        = [ faceData objectForKey: @"smilingProbability"];
    NSLog(@"[face]update---  %.2f", [ _number floatValue ] );
  }
}

- (void) onFaceDetectorMissing: ( NSInteger ) id
          faces: ( NSArray<FaceObj*>* ) faceObjList {
  if( faceObjList != NULL ) {
    NSLog(@"[face]Missing!!!!! %1d, %lu", id, (unsigned long) [ faceObjList count] );
  }
}

- (void) onFaceDetectorDone{
  NSLog(@"[face]Done!!!!!");
}


-(UIImage* ) newCGImageFromLayer:(CALayer*)layer
                           frame:(CGRect)frame
{
  int x = frame.origin.x;
  int y = frame.origin.y;
  int width = frame.size.width;
  int height = frame.size.height;
  
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (context == NULL)
  {
    NSLog(@"Failed to create context.");
    return NULL;
  }
  
  CGContextTranslateCTM(context, -x, -y);
  
  [layer renderInContext:context];
  
  CGImageRef value = CGBitmapContextCreateImage(context);
  
  UIGraphicsEndImageContext();
  return [[UIImage alloc] initWithCGImage:value];
}

- ( UIImage * ) captureImageFromUIView:(UIView *) view {
  return [self newCGImageFromLayer:view.layer
                             frame:view.frame];
  /*CALayer *rootLayer = [self.placeHolder layer];
   UIGraphicsBeginImageContextWithOptions(self.placeHolder.bounds.size, NO, 0.0);
   CGContextRef ctx = UIGraphicsGetCurrentContext();
   [rootLayer renderInContext:ctx];
   UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return res;*/
}

@end
