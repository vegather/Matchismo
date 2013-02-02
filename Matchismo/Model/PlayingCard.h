//
//  PlayingCard.h
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

- (NSString *)content;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
+ (NSArray *)twoCardsThatMatchedFromThisCard:(PlayingCard *)firstCard
                                    thisCard:(PlayingCard *)secondCard
                                 andThisCard:(PlayingCard *)thirdCard;

@end
