//
//  GameScene.m
//  BreakOut
//
//  Created by Pomme on 8/4/16.
//  Copyright (c) 2016 Yuanjie Xie. All rights reserved.
//
#import "GameScene.h"
#import "GameOver.h"
#import "GameWon.h"


static const CGFloat ktrackPixelsPerSecond = 1000;

static const uint32_t category_fence = 0x1 << 3;  // 0x00000000000000000000000000001000     as fence
static const uint32_t category_paddle = 0x1 << 2; // 0x00000000000000000000000000000100     as paddle
static const uint32_t category_block = 0x1 << 1;  // 0x00000000000000000000000000000010     as block/pokemons
static const uint32_t category_ball = 0x1 << 0;   // 0x00000000000000000000000000000001     as pokeball

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;


@end

@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    // fence
    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    
    // skphysicsContactDelegate
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *background = (SKSpriteNode *) [self childNodeWithName:@"Background"];
    background.lightingBitMask = 0x1;
    background.zPosition = 0;

    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    // text label welcome setup
    myLabel.text = @"Hello, Pokémon Trainer!";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.frame.size.height - 100.0);
    [self addChild:myLabel];
    
    // setup pokeball and posistion
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"pokeball"];
    ball1.name = @"Pokeball";
    ball1.position = CGPointMake(60, 30);
    // setup physicsBody of pokeball
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0.0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0.0;
    ball1.physicsBody.angularDamping = 0.0;
    ball1.physicsBody.allowsRotation = YES;
    ball1.physicsBody.mass = 1.0;
    ball1.physicsBody.velocity = CGVectorMake(200.0, 200.0); // initial velocity
    ball1.physicsBody.affectedByGravity = NO;
    ball1.physicsBody.categoryBitMask = category_ball; // new
    ball1.physicsBody.collisionBitMask = category_fence | category_ball | category_block | category_paddle; // New
    ball1.physicsBody.contactTestBitMask = category_fence | category_block; // new
    ball1.physicsBody.usesPreciseCollisionDetection = YES; // new
    ball1.zPosition =1;
    [self addChild:ball1];

    // add a light to the ball
    SKLightNode *light = [SKLightNode new];
    light.categoryBitMask = 0x1;
    light.falloff = 1;
    light.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    light.shadowColor = [[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light.zPosition = 1;
    [ball1 addChild:light];
    
    
    // setup layout of block/pokemons
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"pikachu"];
    CGFloat kBlockWidth = node.size.width;
    CGFloat kBlockHeight = node.size.height;
    CGFloat kBlockHorizSpace = 40.0f;
    int kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizSpace));
    
    // Top row of Blocks
    for (int i = 0; i < kBlocksPerRow; i++) {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"pikachu"];
        node.name = @"Block";
        node.position = CGPointMake(kBlockHorizSpace/2 + kBlockWidth/2 + i*(kBlockWidth) + i*kBlockHorizSpace, self.size.height - 100.0);
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = 0x0;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        [self addChild:node];
    }
    
    // Middle row of blocks of pikachu
    kBlocksPerRow = kBlocksPerRow - 1;
    for (int i = 0; i < kBlocksPerRow; i++) {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"pokemons83"];
        node.name = @"Block";
        node.position = CGPointMake(kBlockHorizSpace + kBlockWidth + i*(kBlockWidth)+i*kBlockHorizSpace, self.size.height - 100.0 - 1*kBlockHeight);
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        [self addChild:node];
    }
    
    // Third row
    kBlocksPerRow = kBlocksPerRow + 1;
    for (int i = 0; i < kBlocksPerRow; i++) {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"pokemons146"];
        node.name = @"Block";
        node.position = CGPointMake(kBlockHorizSpace/2 + kBlockWidth/2 + i*(kBlockWidth)+i*kBlockHorizSpace, self.size.height - 100.0 - 2.0 * kBlockHeight);
        node.zPosition = 1;
        node.lightingBitMask = 0x1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0.0;
        node.physicsBody.restitution = 1.0;
        node.physicsBody.linearDamping = 0.0;
        node.physicsBody.angularDamping = 0.0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = NO;
        [self addChild:node];
    }

    // setup paddle state
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.name = @"Paddle";
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
    paddle.physicsBody.dynamic = NO;
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 1.0;
    paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0); // initial velocity
    
    paddle.zPosition = 1;
    [self addChild:paddle];
}

// touch began to move paddle
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    const CGRect touchRegion = CGRectMake(0, 0, self.size.width, self.size.height * 0.3);
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        if (CGRectContainsPoint(touchRegion, p)) {
            self.motivatingTouch = touch;
        }
    }
    [self trackPaddlesToMotivatingTouches];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self trackPaddlesToMotivatingTouches];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:self.motivatingTouch]) {
        self.motivatingTouch = nil;
    }
}

// track the movement of paddle
-(void)trackPaddlesToMotivatingTouches {
    SKNode *node = [self childNodeWithName:@"Paddle"];
    UITouch *touch = self.motivatingTouch;
    if (!touch)
        return;
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos - node.position.x) / ktrackPixelsPerSecond;
    [node runAction:[SKAction moveToX:xPos duration:duration]];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static const int kMaxSpeed = 1500;
    static const int kMinSpeed = 400;
    
    // Adjust the linear damping if the ball starts moving a little too fast or slow
    SKNode *ball1 = [self childNodeWithName:@"Pokeball"];
    float dx = ball1.physicsBody.velocity.dx;
    float dy = ball1.physicsBody.velocity.dy;
    float speed = sqrtf(dx*dx + dy*dy);
    if (speed > kMaxSpeed) {
        ball1.physicsBody.linearDamping += 0.1f;
    }
    else if (speed < kMinSpeed) {
        ball1.physicsBody.linearDamping -= 0.1f;
    }
    else {
        ball1.physicsBody.linearDamping = 0.0f;
    }
    if (ABS(dx) < 100.0) {
        ball1.physicsBody.velocity = CGVectorMake(200.0, dy);
    }
    if (ABS(dy) < 100.0) {
        ball1.physicsBody.velocity = CGVectorMake(dx, 200.0);
    }
    NSLog(@"dx: %f \ndy: %f", dx, dy);
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if (([nameA containsString:@"Fence"]&&[nameB containsString:@"Pokeball"]) || ([nameA containsString:@"Pokeball"] && [nameB containsString:@"Fence"])) {
        if (contact.contactPoint.y < 10) {
            SKView *skView = (SKView *)self.view;
            [self removeFromParent];
            
            // create and configure the scene
            GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
            scene.scaleMode = SKSceneScaleModeAspectFit;
            
            // Present the scene
            [skView presentScene:scene];
        }
    }
    //NSLog(@"what collide? %@ %@", nameA, nameB);
    
    
    if (([nameA containsString:@"Pokeball"] && [nameB containsString:@"Block"]) || ([nameA containsString:@"Block"] && [nameB containsString:@"Pokeball"])) {
        // figure out which block is dispearing
        SKNode *block;
        if ([nameA containsString:@"Block"]) {
            block = contact.bodyA.node;
        }
        else {
            block = contact.bodyB.node;
        }
        SKAction *removeBlock = [SKAction removeFromParent];
        
        SKAction *checkGameWin = [SKAction runBlock:^{
            // Game win when all block dispeared
            BOOL anyBlocksRemaining = ([self childNodeWithName:@"Block"] != nil);
            if (!anyBlocksRemaining) {
                SKView *skView = (SKView *)self.view;
                [self removeFromParent];
                
                GameWon *scene = [GameWon nodeWithFileNamed:@"GameWon"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                [skView presentScene:scene];
            }
        
        }];
        
        [block runAction:removeBlock];
        [block runAction:checkGameWin];
    }
}


@end
