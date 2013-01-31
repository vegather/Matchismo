//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "CardGameViewController.h"
#import "Card.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

//Label
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

//Deck
@property (strong, nonatomic) Deck *deck;

//Card Buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end


@implementation CardGameViewController

#pragma mark - Getter

- (Deck *)deck
{
    if (!_deck)
    {
        _deck = [[PlayingCardDeck alloc]init];
    }
    return _deck;
}

#pragma mark - Setters

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.content forState:UIControlStateSelected];
    }
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

#pragma mark - IBAction

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.flipCount++;
    
//    //If NOT selected
//    if (sender.isSelected == NO)
//    {
//        
//        sender.selected = YES;
//        PlayingCard *currentCard = [self.deckOfPlayingCards drawRandomCard];
//        [self.myCard setTitle:currentCard.content forState:UIControlStateSelected];
//        [self.deckOfPlayingCards addCard:currentCard atTop:YES];
//        self.flipCount++;
//    }
//    else
//    {
//        sender.selected = NO;
//    }
}

@end
