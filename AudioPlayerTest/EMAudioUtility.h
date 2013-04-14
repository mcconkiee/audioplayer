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

@interface EMAudioUtility : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,retain)AVAudioPlayer *audioPlayer;
@property (nonatomic)AudioUtilityStateType audioUtilityState;

-(void)play:(NSString*)pathToContentFile;
-(void)scrubTo:(float)zeroToOne;
-(void)pause;
-(void)stop;
@end
