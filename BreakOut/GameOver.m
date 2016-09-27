//
//  GameOver.m
//  PokéOut
//
//  Created by Pomme on 8/4/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"
#import "GameStart.h"

@implementation GameOver
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(touches) {
        SKView *skView = (SKView *)self.view;
        // Congifgure game scene
        GameStart *scene = [GameStart nodeWithFileNamed:@"GameStart"];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        // Present the scene
        [skView presentScene: scene];
    }
    
}

@end
