//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

//Label
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

//Card Buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

//The Game
@property (strong, nonatomic) CardMatchingGame *game;

@end


@implementation CardGameViewController
{}
#pragma mark - Getter

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count]
                                                 usingDeck:[[PlayingCardDeck alloc]init]];
    }
    return _game;
}

#pragma mark - Setters

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

#pragma mark - Method

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.content forState:UIControlStateSelected];
        [cardButton setTitle:card.content forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.isUnplayable;
        if (card.isUnplayable)
        {
            cardButton.alpha = 0.3;
        }
        else
        {
            cardButton.alpha = 1.0;
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - IBAction

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (sender.selected == NO)
    {
        self.flipCount++;
    }
    [self updateUI];
}

@end
