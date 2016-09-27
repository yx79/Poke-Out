//
//  GameWon.m
//  PokéOut
//
//  Created by Pomme on 8/11/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

#import "GameWon.h"
#import "GameStart.h"


@implementation GameWon

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