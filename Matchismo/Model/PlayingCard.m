//
//  PlayingCard.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit;

#pragma mark - Accessor Methods

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    if (_suit)
    {
        return _suit;
    }
    else
    {
        return @"?";
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

#pragma mark - Instance Methods

- (NSString *)content
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit])
        {
            score = 1;
        }
        else if (otherCard.rank == self.rank)
        {
            score = 2;
        }
    }
    else if ([otherCards count] == 2)
    {
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        
        //If two suits matches
        if ([self.suit isEqualToString:firstCard.suit] ||
            [self.suit isEqualToString:secondCard.suit])
        {
            //Two suits matched
        }
        //If two ranks mathc
        else if (self.rank == firstCard.rank ||
                 self.rank == secondCard.rank)
        {
            //Two ranks matched
        }
        //If all three suits match
        else if ([self.suit isEqualToString:firstCard.suit] &&
                 [self.suit isEqualToString:secondCard.suit])
        {
            //Three suits matched
        }
        //If three ranks mathc
        else if (self.rank == firstCard.rank &&
                 self.rank == secondCard.rank)
        {
            //Three ranks matched
        }
    }
    return score;
}


#pragma mark - Class Methods

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}



@end
