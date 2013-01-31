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

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore != 0)
                    {
                        card.unPlayable = YES;
                        otherCard.unPlayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
                
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
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
