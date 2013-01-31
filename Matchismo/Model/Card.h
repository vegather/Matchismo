//
//  Card.h
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *content;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = iSUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
