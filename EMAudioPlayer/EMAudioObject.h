//
//  EMAudioObject.h
//  EMAudioPlayer
//
//  Created by Eric McConkie on 8/24/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMAudioObject : NSObject
@property (nonatomic,copy)NSURL *urlToFile;//remote or local
@property (nonatomic,copy)NSURL *urlToAlbumArt;//remote or local
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *artist;
@property (nonatomic,copy)NSString *album;


/*
 populate the now playing lockscreen with properties of this object

 */
-(void)updatePlayInfoCenter;

@end
