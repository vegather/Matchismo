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

- (NSArray *)twoCardsThatMatchedFromThreeCards:(NSArray *)threeCards
{
    NSMutableArray *matchedCards = [[NSMutableArray alloc]init];
    
    if ([threeCards count] == 3)
    {
        PlayingCard *firstCard = threeCards[0];
        PlayingCard *secondCard = threeCards[1];
        PlayingCard *thirdCard = threeCards[2];
        //If some of the suits matched
        if ([firstCard.suit isEqualToString:secondCard.suit])
        {
            [matchedCards addObjectsFromArray:@[firstCard, secondCard]];
        }
        else if ([firstCard.suit isEqualToString:thirdCard.suit])
        {
            [matchedCards addObjectsFromArray:@[firstCard, thirdCard]];
        }
        else if ([secondCard.suit isEqualToString:thirdCard.suit])
        {
            [matchedCards addObjectsFromArray:@[secondCard, thirdCard]];
        }
        
        //If some rank matched, replace content of matchedCards and add cards
        //with rank that matched
        if (firstCard.rank == secondCard.rank)
        {
            [matchedCards removeAllObjects];
            [matchedCards addObjectsFromArray:@[firstCard, secondCard]];
        }
        else if (firstCard.rank == thirdCard.rank)
        {
            [matchedCards removeAllObjects];
            [matchedCards addObjectsFromArray:@[firstCard, thirdCard]];
        }
        else if (secondCard.rank == thirdCard.rank)
        {
            [matchedCards removeAllObjects];
            [matchedCards addObjectsFromArray:@[secondCard, thirdCard]];
        }
    }
    
    return [matchedCards copy];
}

- (int)match:(NSArray *)otherCards usingGameDifficulty:(int)gameDifficultyIndex
{
    int score = 0;
    
    //Match two cards
    if ([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit] && gameDifficultyIndex == 1)
        {
            //Medium difficulty
            score = 2;
        }
        else if (otherCard.rank == self.rank)
        {
            //Medium difficulty
            score = 4;
        }
    }
    //Match three cards
    else if ([otherCards count] == 2)
    {
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        
        if (gameDifficultyIndex == 0)
        {
            //If two suits matches
            if ([self.suit isEqualToString:firstCard.suit] ||
                [self.suit isEqualToString:secondCard.suit] ||
                [firstCard.suit isEqualToString:secondCard.suit])
            {
                //Easy difficulty
                score = 1;
            }
            //If two ranks matches
            if (self.rank == firstCard.rank ||
                self.rank == secondCard.rank ||
                firstCard.rank == secondCard.rank)
            {
                //Easy difficulty
                score = 2;
            }
        }
        else if (gameDifficultyIndex == 2)
        {
            //If all three suits matches
            if ([self.suit isEqualToString:firstCard.suit] &&
                [self.suit isEqualToString:secondCard.suit])
            {
                //Hard difficulty
                score = 4;
            }
            //If all three ranks matches
            else if (self.rank == firstCard.rank &&
                     self.rank == secondCard.rank)
            {
                //Hard difficulty
                score = 8;
            }
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
