//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/31/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *messageFromMatch;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@end

@implementation CardMatchingGame
{}
#pragma mark - Initializers

//Don't want init because it will create an invalid game,
//with no deck with no cards...
- (id)init
{
    return nil;
}

//Initializer that draws a random card from a deck and puts it in
//internal stack of cards.
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        //Loops though every card
        for (int i = 0; i < count; i++)
        {
            //draws a random card
            Card *card = [deck drawRandomCard];
            //There are only 52 cards in a Deck, so if count is 1000,
            //card will be nil, and we don't want to add it.
            if (card)
            {
                self.cards[i] = card;
            }
            //In fact we don't want to even exist if count > 52. self = nil
            else
            {
                self = nil;
                //And of course we don't want to continue going though the
                //cards after this. We are nil, end of discussion.
                break;
            }
        }
    }
    return self;
}

#pragma mark - Accessor Methods

//Lazily instantiates the NSMutableArray cards.
- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

#pragma mark - Point Defenitions
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

#pragma mark - Public Instance Methods

- (void)flipCardAtIndex:(NSUInteger)index
{
    //Choses the card at a given index
    Card *card = [self cardAtIndex:index];
    
    //If there is a card at the index, and it is playable
    if (card && card.isUnplayable == NO)
    {
        //We only want to do things if it is NOT? faced up
        if (card.isFaceUp == NO)
        {
            //Loop through all our cards
            for (Card *otherCard in self.cards)
            {
                //Check if there are other cards that are faced up
                //and playable, in which case we might have a match
                if (otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    //card compares itself to the otherCard and gives us
                    //a score as a result of that
                    int matchScore = [card match:@[otherCard]];
                    //If we have a match
                    if (matchScore != 0)
                    {
                        card.unPlayable = YES;
                        otherCard.unPlayable = YES;
                        int scoreThisMatch = matchScore * MATCH_BONUS;
                        self.score += scoreThisMatch;
                        self.messageFromMatch =[NSString
                                stringWithFormat:@"Matched %@ & %@ for %d points", card.content, otherCard.content, scoreThisMatch];
                    }
                    //If the card didn't match
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.messageFromMatch =[NSString
                                stringWithFormat:@"%@ & %@ don't match. %d points penalty!",
                                        card.content, otherCard.content, MISMATCH_PENALTY];
                    }
                    //When we have a match we don't care about the other cards
                    //More than two playable cards can't be selected anyways.
                    break;
                }
                //If the otherCard is not faced up, we want to say that the user
                //has only flipped one card
                else if (otherCard.isFaceUp == NO)
                {
                    //Will probably start of with this message, but if one of the
                    //otherCards are faced up and playable, one of other messages
                    //will be used.
                    self.messageFromMatch = [NSString
                                               stringWithFormat:@"Flipped up %@", card.content];
                }
            }
            //Flipping a card costs a point only if card is faced up
            self.score -= FLIP_COST;
        }
        //The card will be flipped to the opposite of the
        //state it's currently in
        card.faceUp = !card.faceUp;
    }
}

//Get the card at the following index, if index is out of cards
//array bounds, cardAtIndex: will return nil
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
