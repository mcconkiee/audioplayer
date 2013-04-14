//
//  ViewController.m
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "ViewController.h"
#import "EMAudioUtility.h"

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface ViewController ()
@property (nonatomic,retain)EMAudioUtility *audioUtil;
@property (nonatomic,retain)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    EMAudioUtility *audioUtility = [[EMAudioUtility alloc] init];
    self.audioUtil = audioUtility;
    
    [self addObserver:self forKeyPath:@"audioUtil.audioUtilityState" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self.sliderScrub addTarget:self action:@selector(onScrubComplete:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.sliderVolume setValue:0.5];
    [self.sliderScrub setValue:self.audioUtil.audioPlayer.currentTime];
    
}

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
    if(!self.audioUtil.audioPlayer.isPlaying)
        return;
    
    float dur = self.audioUtil.audioPlayer.duration;
    float perc = self.audioUtil.audioPlayer.currentTime/dur;
    [self.sliderScrub setValue:perc];
}


#pragma mark -------------->>actions
- (IBAction)onPlay:(id)sender {
    
    NSString *sample = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"];
    [self.audioUtil play:sample];
    [self onVolume:self.sliderVolume];
    
    //artwork
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        
        UIImage *artwork = [UIImage imageNamed:@"artwork.jpg"];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:artwork ];
        
        [songInfo setObject:@"Audio Title" forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
        
    }
}
- (IBAction)onPause:(id)sender {
    [self.audioUtil pause];
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
