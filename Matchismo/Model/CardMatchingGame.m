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
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
{
    
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    Card *myCard = [[Card alloc]init];
    
    return myCard;
}

@end
