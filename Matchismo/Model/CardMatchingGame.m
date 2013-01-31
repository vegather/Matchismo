//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/31/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@end

@implementation CardMatchingGame
{}
#pragma mark - Initializers

- (id)init
{
    return nil;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                self.cards[i] = card;
            }
            else
            {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

#pragma mark - Accessor Methods

- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

#pragma mark - Public Instance Methods

- (void)flipCardAtIndex:(NSUInteger)index
{
    
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    if (index < [self.cards count])
    {
        return self.cards[index];
    }
    else
    {
        return nil;
    }
}

@end
