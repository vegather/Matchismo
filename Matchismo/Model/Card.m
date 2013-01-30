//
//  Card.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(Card *)card
{
    int score = 0;
    
    if ([card.contents isEqualToString:self.contents])
    {
        score = 1;
    }
    
    return score;
}

@end
