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

@interface CardGameViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

//Labels
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageFromComparisonLabel;

//Segmented Control
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyChanger;
@property (nonatomic) int currentDifficulty;

//Buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UIButton *startOverButton;

//The Game
@property (strong, nonatomic) CardMatchingGame *game;

@end


@implementation CardGameViewController
{}

- (void)viewDidLoad
{
    self.startOverButton.enabled = NO;
    self.startOverButton.alpha = 0.3;
    self.messageFromComparisonLabel.text = @"Match 2 out of 2 cards.";
}

#pragma mark - Getter

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count]
                                              withDifficulty:self.currentDifficulty
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
        
        UIImage *cardBackImage = [UIImage imageNamed:@"cardbacksmall.png"];
        [cardButton setBackgroundImage:cardBackImage forState:UIControlStateHighlighted];
        if (card.faceUp == NO)
        {
            [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
        }
        else
        {
            [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.messageFromComparisonLabel.text = self.game.messageFromMatch;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)startOver
{
    self.game = [self.game initWithCardCount:[self.cardButtons count]
                                withDifficulty:self.currentDifficulty
                                   usingDeck:[[PlayingCardDeck alloc]init]];
    [self.game resetScoreAndMessage];
    self.flipCount = 0;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    [self updateUI];
    self.difficultyChanger.enabled = YES;
    self.difficultyChanger.alpha = 1.0;
    self.startOverButton.enabled = NO;
    self.startOverButton.alpha = 0.3;
    if (self.difficultyChanger.selectedSegmentIndex == 0)
    {
        self.messageFromComparisonLabel.text = @"Match 2 out of 2 cards.";
    }
    else if (self.difficultyChanger.selectedSegmentIndex == 1)
    {
        self.messageFromComparisonLabel.text = @"Match 3 out of 3 cards.";
    }
}

#pragma mark - IBAction

- (IBAction)flipCard:(UIButton *)sender
{
    self.startOverButton.enabled = YES;
    self.startOverButton.alpha = 1.0;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    if (sender.selected == NO)
    {
        self.flipCount++;
    }
    [self updateUI];
    self.difficultyChanger.enabled = NO;
    self.difficultyChanger.alpha = 0.3;
}

- (IBAction)startOverButtonPressed
{
    UIActionSheet *mySheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure you want to start over? This will end your current game."
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Start Over"
                                               otherButtonTitles:nil];
    [mySheet showInView:self.view];
}

- (IBAction)difficultyChanged:(UISegmentedControl *)sender
{
    self.currentDifficulty = sender.selectedSegmentIndex;
    [self startOver];
}

- (IBAction)setImageWhenHighlighted:(UIButton *)sender
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardbacksmall.png"];
    [sender setBackgroundImage:cardBackImage forState:UIControlStateNormal];
}

#pragma mark - Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self startOver];
    }
}
@end
