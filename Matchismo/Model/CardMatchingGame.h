//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/31/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)count;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;

@end
