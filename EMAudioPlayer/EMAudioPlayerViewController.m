//
//  ViewController.m
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "EMAudioPlayerViewController.h"
#import "EMAudioUtility.h"
#import <AVFoundation/AVFoundation.h>


@interface EMAudioPlayerViewController ()
@property (nonatomic,retain)EMAudioUtility *audioUtil;
@property (nonatomic,retain)NSTimer *timer;
@end

@implementation EMAudioPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    EMAudioUtility *audioUtility = [[EMAudioUtility alloc] init];
    self.audioUtil = audioUtility;
    
    [self addObserver:self forKeyPath:@"audioUtil.audioUtilityState" options:NSKeyValueObservingOptionNew context:nil];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
    
    
    
    [self.sliderScrub addTarget:self action:@selector(onScrubComplete:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.sliderVolume setValue:0.5];
    [self.sliderScrub setValue:self.audioUtil.audioPlayer.currentTime];
    
}


#pragma mark -------------->>background events as media controller
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"event : %@",event);
    if(event.type == UIEventTypeRemoteControl)
    {
        int subtype = event.subtype;
        switch (subtype) {
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"play %@ ",self);
                [self.audioUtil pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"Pause");
                [self.audioUtil pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next");
                
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Prev");
                
                break;
            default:
                NSLog(@"not attended %@ ",event);
                break;
                
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

//end remote events

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"audioUtil.audioUtilityState"];
}


-(void)startScrubPositionTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"audioUtil.audioUtilityState"]) {
        switch (self.audioUtil.audioUtilityState) {
            case AudioUtilityStateTypeFinished:
            {
                [self.timer invalidate];
            }
                break;
            case AudioUtilityStateTypeStopped:
            {
                [self.timer invalidate];
            }
                break;
                
            case AudioUtilityStateTypePlaying:
            {
                [self startScrubPositionTimer];
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -------------->>timer
-(void)onTimer:(NSTimer*)timer
{
    float perc =  0.0;
    switch (self.audioUtil.audioPlayerType) {
        case AudioPlayerTypeLocalPlayback:
        {
            if(!self.audioUtil.audioPlayer.isPlaying)
                return;
            
            float dur = self.audioUtil.audioPlayer.duration;
            perc = self.audioUtil.audioPlayer.currentTime/dur;
        }
            break;
        case AudioPlayerTypeRemoteStream:
        {
            CMTime tme = self.audioUtil.playerItem.duration;
            double dur = CMTimeGetSeconds(tme);
            double curTime = CMTimeGetSeconds(self.audioUtil.playerItem.currentTime);
            perc = curTime / dur;
        }
            break;
        default:
            break;
    }
    
    [self.sliderScrub setValue:perc];
}


#pragma mark -------------->>actions
-(void)play{
    [self.audioUtil play:self.audioObject.urlToFile];
    [self.audioObject updatePlayInfoCenter];
    [self onVolume:self.sliderVolume];
    
}

-(void)stream{
    [self.audioUtil stream:self.audioObject.urlToFile];
    [self onVolume:self.sliderVolume];
    
}

-(void)pause{
    [self.audioUtil pause];
}



- (IBAction)onPlay:(id)sender {
    
    [self play];
}
- (IBAction)onPause:(id)sender {
    [self pause];
}
-(void)onScrubComplete:(UISlider*)slider
{
    [self startScrubPositionTimer];
}

- (IBAction)onScrub:(UISlider*)sender {
    [self.timer invalidate];
    float at = sender.value;
    [self.audioUtil scrubTo:at];

}
- (IBAction)onVolume:(UISlider*)sender {
    [self.audioUtil.audioPlayer setVolume:sender.value];
}




@end
