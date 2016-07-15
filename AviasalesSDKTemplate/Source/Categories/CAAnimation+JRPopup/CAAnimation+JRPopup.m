//
// Created by Ilya Amelchenkov on 08.11.15.
// Copyright (c) 2015 aviasales. All rights reserved.
//


#import "CAAnimation+JRPopup.h"


@implementation CAAnimation (JRPopup)

+ (CAAnimation *)attachPopUpAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
            animationWithKeyPath:@"transform"];

    CATransform3D scale1 = CATransform3DMakeScale(0.25, 0.25, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.75, 0.75, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale5 = CATransform3DMakeScale(1.0, 1.0, 1);

    NSArray *frameValues = @[[NSValue valueWithCATransform3D:scale1],
            [NSValue valueWithCATransform3D:scale2],
            [NSValue valueWithCATransform3D:scale3],
            [NSValue valueWithCATransform3D:scale4],
            [NSValue valueWithCATransform3D:scale5]];
    [animation setValues:frameValues];

    NSArray *frameTimes = @[@0.1f,
            @0.4f,
            @0.5f,
            @0.6f,
            @1.0f];
    [animation setKeyTimes:frameTimes];

    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.265;

    return animation;
}

+ (CAAnimation *)detachPopUpAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
            animationWithKeyPath:@"transform"];

    CATransform3D scale5 = CATransform3DMakeScale(0.0, 0.0, 1);
    CATransform3D scale4 = CATransform3DMakeScale(0.75, 0.75, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);

    NSArray *frameValues = @[[NSValue valueWithCATransform3D:scale1],
            [NSValue valueWithCATransform3D:scale2],
            [NSValue valueWithCATransform3D:scale3],
            [NSValue valueWithCATransform3D:scale4],
            [NSValue valueWithCATransform3D:scale5]];
    [animation setValues:frameValues];

    NSArray *frameTimes = @[@0.1f,
            @0.4f,
            @0.7f,
            @0.8f,
            @1.0f];
    [animation setKeyTimes:frameTimes];

    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.duration = 0.225;

    return animation;
}

@end