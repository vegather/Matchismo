//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/31/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

//Designated Initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)resetScoreAndMessage;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *messageFromMatch;

@end
