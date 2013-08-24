//
//  ViewController.h
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAudioObject.h"

@interface EMAudioPlayerViewController : UIViewController
@property (nonatomic,strong) EMAudioObject *audioObject;

@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UISlider *sliderScrub;
@property (weak, nonatomic) IBOutlet UISlider *sliderVolume;

-(void)play;
-(void)stream;
-(void)pause;


@end
