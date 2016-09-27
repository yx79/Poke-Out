//
//  GameStart.m
//  PokéOut
//
//  Created by Pomme on 8/5/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

#import "GameStart.h"

@implementation GameStart

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(touches) {
        SKView *skView = (SKView *)self.view;
        // Congifgure game scene
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        // Present the scene
        [skView presentScene: scene];
    }
    
}

@end
