//
//  EMAudioObject.m
//  EMAudioPlayer
//
//  Created by Eric McConkie on 8/24/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "EMAudioObject.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface EMAudioObject()
@property (nonatomic)BOOL canUpdate;
@property (nonatomic,retain)UIImage *artworkImage;
@end

@implementation EMAudioObject
- (id)init
{
    self = [super init];
    if (self) {
        self.canUpdate = YES;
        [self addObserver:self forKeyPath:@"urlToAlbumArt" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    self.canUpdate = NO;
    [self removeObserver:self forKeyPath:@"urlToAlbumArt" context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"urlToAlbumArt"]) {
        dispatch_queue_t queue = dispatch_queue_create("fetchAlbumArt",NULL);
        dispatch_queue_t main = dispatch_get_main_queue();
        
        dispatch_async(queue,^{
            NSData *dta = [NSData dataWithContentsOfURL:self.urlToAlbumArt];
            UIImage *img = [UIImage imageWithData:dta];
            [self setArtworkImage:img];
            [self updatePlayInfoCenter];
            dispatch_async(main,^{
                
            });
        });
    }
}

-(void)updatePlayInfoCenter
{
    if (!self.canUpdate)
        return;
    
    //artwork
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        if (self.artworkImage){
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:self.artworkImage ];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        }

        if (self.title)
            [songInfo setObject:self.title forKey:MPMediaItemPropertyTitle];
        if(self.artist)
            [songInfo setObject:self.artist forKey:MPMediaItemPropertyArtist];
        if(self.album)
            [songInfo setObject:self.album forKey:MPMediaItemPropertyAlbumTitle];
        
        //...extend as you wish...
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        
        
    }
}

@end
