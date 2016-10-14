//
//  NotificationSound.h
//  TestGeTui
//
//  Created by ys on 16/3/30.
//  Copyright © 2016年 ys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface NotificationSound : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
    SystemSoundID sound1;
}
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放

@end
