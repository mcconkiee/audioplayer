//
//  EMAudioUtility.m
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "EMAudioUtility.h"

@interface EMAudioUtility()

@end

@implementation EMAudioUtility

- (id)init
{
    self = [super init];
    if (self) {
        
        [self addObserver:self forKeyPath:@"audioUtilityState" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"audioUtilityState"]) {
        switch (self.audioUtilityState) {
            case AudioUtilityStateTypeFinished:
            {
                
            }
                break;
                
            case AudioUtilityStateTypePaused:
            {
                
            }
                break;
                
            case AudioUtilityStateTypePlaying:
            {
                
            }
                break;
                
            case AudioUtilityStateTypeStopped:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"audioUtilityState"];
}

-(void)play:(NSString*)pathToContentFile
{
    NSURL *url = [NSURL fileURLWithPath:pathToContentFile];    
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    //preprare the session, and allow for background
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    [player setNumberOfLoops:0];//playonce
    [player setDelegate:self];
    [self setAudioPlayer:player];
    
    
    BOOL prepared = [self.audioPlayer prepareToPlay];
    if (prepared) {
        if ([self.audioPlayer play]) {
            [self setAudioUtilityState:AudioUtilityStateTypePlaying];
        }
    }
    
}

-(void)scrubTo:(float)zeroToOne
{

    NSTimeInterval dur = self.audioPlayer.duration;
    double newSeekTime = (zeroToOne ) * dur;
    [self.audioPlayer setCurrentTime:(int)newSeekTime];
}

-(void)pause
{
    if (self.audioUtilityState == AudioUtilityStateTypePlaying) {
        [self setAudioUtilityState:AudioUtilityStateTypePaused];    
        [self.audioPlayer pause];
    }else
    {
        [self setAudioUtilityState:AudioUtilityStateTypePlaying];
        [self.audioPlayer play];
    }
    
    
}

-(void)stop
{
    [self.audioPlayer stop];
    [self setAudioUtilityState:AudioUtilityStateTypeStopped];    
}

#pragma mark -------------->>audio delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self setAudioUtilityState:AudioUtilityStateTypeFinished];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}
@end
