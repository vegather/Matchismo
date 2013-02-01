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

@interface CardGameViewController () <UIAlertViewDelegate>

//Labels
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageFromComparisonLabel;

//Segmented Control
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyChanger;

//Buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

//The Game
@property (strong, nonatomic) CardMatchingGame *game;

@end


@implementation CardGameViewController
{}

- (void)viewDidLoad
{
    self.difficultyChanger.enabled = NO;
    self.difficultyChanger.alpha = 0.3;
}

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

#pragma mark - Methods

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
    self.messageFromComparisonLabel.text = self.game.messageFromMatch;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)reDealGame
{
    self.game = [self.game initWithCardCount:[self.cardButtons count]
                                   usingDeck:[[PlayingCardDeck alloc]init]];
    [self.game resetScoreAndMessage];
    self.flipCount = 0;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    [self updateUI];
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

- (IBAction)dealButtonPressed
{
    UIAlertView *reDealAlert = [[UIAlertView alloc]initWithTitle:nil
                                                         message:@"Are you sure you want to draw? This will end your current game."
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Deal", nil];
    [reDealAlert show];
}

#pragma mark - Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self reDealGame];
    }
}

@end
