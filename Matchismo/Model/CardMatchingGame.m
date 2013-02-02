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
@property (nonatomic) int gameDifficulty; //0 = Easy, 1 = Medium, 2 = Hard
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
- (id)initWithCardCount:(NSUInteger)count
           withDifficulty:(int)currentDifficulty
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        //Set the game mode
        self.gameDifficulty = currentDifficulty;
        
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

//- (void)flipCardAtIndex:(NSUInteger)index
//{
//    //Choses the card at a given index
//    Card *card = [self cardAtIndex:index];
//    
//    //If there is a card at the index, and it is playable
//    if (card && card.isUnplayable == NO)
//    {
//        //We only want to do things if card is GETTING flipped up
//        if (card.isFaceUp == NO)
//        {
//            //Loop through all our cards
//            for (Card *otherCard in self.cards)
//            {
//                //Check if there are other cards that are faced up
//                //and playable, in which case we might have a match
//                if (otherCard.isFaceUp && !otherCard.isUnplayable)
//                {
//                    //card compares itself to the otherCard and gives us
//                    //a score as a result of that
//                    int matchScore = [card match:@[otherCard]];
//                    //If we have a match
//                    if (matchScore != 0)
//                    {
//                        card.unPlayable = YES;
//                        otherCard.unPlayable = YES;
//                        int scoreThisMatch = matchScore * MATCH_BONUS;
//                        self.score += scoreThisMatch;
//                        self.messageFromMatch =[NSString
//                                stringWithFormat:@"Matched %@ and %@ for\r\n%d points.",
//                                        otherCard.content, card.content, scoreThisMatch];
//                    }
//                    //If the card didn't match
//                    else
//                    {
//                        otherCard.faceUp = NO;
//                        self.score -= MISMATCH_PENALTY;
//                        self.messageFromMatch =[NSString
//                                stringWithFormat:@"%@ and %@ don't match.\r\n%d points penalty!",
//                                        otherCard.content, card.content, MISMATCH_PENALTY];
//                    }
//                    //When we have a match we don't care about the other cards
//                    //More than two playable cards can't be selected anyways.
//                    break;
//                }
//                //If the otherCard is not faced up, we want to say that the user
//                //has only flipped one card
//                else if (otherCard.isFaceUp == NO)
//                {
//                    //Will probably start of with this message, but if one of the
//                    //otherCards are faced up and playable, one of other messages
//                    //will be used.
//                    self.messageFromMatch = [NSString
//                                               stringWithFormat:@"Flipped up %@", card.content];
//                }
//            }
//            //Flipping a card costs a point only if card is faced up
//            self.score -= FLIP_COST;
//        }
//        //If card is getting flipped back down
//        else
//        {
//            self.messageFromMatch = @"";
//        }
//        //The card will be flipped to the opposite of the
//        //state it's currently in
//        card.faceUp = !card.faceUp;
//    }
//}

- (void)flipCardAtIndex:(NSUInteger)index
{
    //Choses the card at a given index
    Card *card = [self cardAtIndex:index];
    
    //If there is a card at the index, and it is playable
    if (card && card.isUnplayable == NO)
    {
        //We only want to do things if card is GETTING flipped up
        if (card.isFaceUp == NO)
        {
            NSMutableArray *indexesOfCardsToMatch = [[NSMutableArray alloc]init];
            //Loop through all our cards
            for (int i = 0; i < [self.cards count]; i++)//Card *currentCard in self.cards)
            {
                Card *currentCard = self.cards[i];
                //Check if there are other cards that are faced up
                //and playable, in which case we might have a match
                if (currentCard.isFaceUp && !currentCard.isUnplayable)
                {
                    [indexesOfCardsToMatch addObject:[NSNumber numberWithInt:i]];
                }
            }
            if (self.gameDifficulty == 0)
            {
                //Easy (2 out of 3)
                if ([indexesOfCardsToMatch count] == 0 || [indexesOfCardsToMatch count] == 1)
                {
                    self.messageFromMatch = [NSString stringWithFormat:@"Flipped up %@", card.content];
                }
                else if ([indexesOfCardsToMatch count] == 2)
                {
                    int indexOfFirstOtherCard = [indexesOfCardsToMatch[0]intValue];
                    int indexOfSecondOtherCard = [indexesOfCardsToMatch[1]intValue];
                    Card *firstOtherCard = [self.cards objectAtIndex:indexOfFirstOtherCard];
                    Card *secondOtherCard = [self.cards objectAtIndex:indexOfSecondOtherCard];
                    //card compares itself to the otherCard and gives us
                    //a score as a result of that
                    int matchScore = [card match:@[firstOtherCard, secondOtherCard] usingGameDifficulty:self.gameDifficulty];
                    //If we have a match
                    if (matchScore != 0)
                    {
                        card.unPlayable = YES;
                        firstOtherCard.unPlayable = YES;
                        secondOtherCard.unPlayable = YES;
                        int scoreThisMatch = matchScore * MATCH_BONUS;
                        self.score += scoreThisMatch;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"Matched %@ and %@ for\r\n%d points.",
                                                firstOtherCard.content, card.content, scoreThisMatch];
                    }
                    //If the two cards didn't match
                    else
                    {
                        firstOtherCard.faceUp = NO;
                        secondOtherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"%@, %@ and %@ don't match.\r\n%d points penalty!",
                                                secondOtherCard.content, firstOtherCard.content, card.content, MISMATCH_PENALTY];
                    }
                }
            }
            else if (self.gameDifficulty == 1)
            {
                //Medium (2 out of 2)
                if ([indexesOfCardsToMatch count] == 0)
                {
                    self.messageFromMatch = [NSString stringWithFormat:@"Flipped up %@", card.content];
                }
                else if ([indexesOfCardsToMatch count] == 1)
                {
                    int indexOfOtherCard = [[indexesOfCardsToMatch lastObject]intValue];
                    Card *otherCard = [self.cards objectAtIndex:indexOfOtherCard];
                    //card compares itself to the otherCard and gives us
                    //a score as a result of that
                    int matchScore = [card match:@[otherCard] usingGameDifficulty:self.gameDifficulty];
                    //If we have a match
                    if (matchScore != 0)
                    {
                        card.unPlayable = YES;
                        otherCard.unPlayable = YES;
                        int scoreThisMatch = matchScore * MATCH_BONUS;
                        self.score += scoreThisMatch;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"Matched %@ and %@ for\r\n%d points.",
                                                otherCard.content, card.content, scoreThisMatch];
                    }
                    //If the two cards didn't match
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"%@ and %@ don't match.\r\n%d points penalty!",
                                                otherCard.content, card.content, MISMATCH_PENALTY];
                    }
                }
            }
            else if (self.gameDifficulty == 2)
            {
                //Hard (3 out of 3)
                if ([indexesOfCardsToMatch count] == 0 || [indexesOfCardsToMatch count] == 1)
                {
                    self.messageFromMatch = [NSString stringWithFormat:@"Flipped up %@", card.content];
                }
                else if ([indexesOfCardsToMatch count] == 2)
                {
                    int indexOfOtherCard = [[indexesOfCardsToMatch lastObject]intValue];
                    Card *otherCard = [self.cards objectAtIndex:indexOfOtherCard];
                    //card compares itself to the otherCard and gives us
                    //a score as a result of that
                    int matchScore = [card match:@[otherCard] usingGameDifficulty:self.gameDifficulty];
                    //If we have a match
                    if (matchScore != 0)
                    {
                        card.unPlayable = YES;
                        otherCard.unPlayable = YES;
                        int scoreThisMatch = matchScore * MATCH_BONUS;
                        self.score += scoreThisMatch;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"Matched %@ and %@ for\r\n%d points.",
                                                otherCard.content, card.content, scoreThisMatch];
                    }
                    //If the two cards didn't match
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.messageFromMatch =[NSString
                                                stringWithFormat:@"%@ and %@ don't match.\r\n%d points penalty!",
                                                otherCard.content, card.content, MISMATCH_PENALTY];
                    }
                }
            }
            //Flipping a card costs a point only if card is faced up
            self.score -= FLIP_COST;
        }
        //If card is getting flipped back down
        else
        {
            self.messageFromMatch = @"";
        }
        //The card will be flipped to the opposite of the
        //state it's currently in
        card.faceUp = !card.faceUp;
    }
}

- (void)resetScoreAndMessage
{
    self.score = 0;
    self.messageFromMatch = @"";
}

#pragma mark - Private Methods

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
