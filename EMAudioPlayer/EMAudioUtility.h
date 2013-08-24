//
//  EMAudioUtility.h
//  AudioPlayerTest
//
//  Created by Eric McConkie on 4/13/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef enum {
    AudioUtilityStateTypeStopped,
    AudioUtilityStateTypePlaying,
    AudioUtilityStateTypePaused,
    AudioUtilityStateTypeFinished
}AudioUtilityStateType;


typedef enum {
    AudioPlayerTypeUndefined,
    AudioPlayerTypeLocalPlayback,
    AudioPlayerTypeRemoteStream
}AudioPlayerType;

@interface EMAudioUtility : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,retain)AVAudioPlayer *audioPlayer;
@property (nonatomic,retain)AVPlayer *httpPlayer;
@property (nonatomic,retain)AVPlayerItem *playerItem;
@property (nonatomic)AudioUtilityStateType audioUtilityState;
@property (nonatomic)AudioPlayerType audioPlayerType;
-(void)play:(NSURL*)pathToContentFile;
-(void)stream:(NSURL*)url;
-(void)scrubTo:(float)zeroToOne;
-(void)pause;//will toggle play<->pause
-(void)stop;
@end
