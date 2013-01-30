//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Vegard Solheim Thériault on 1/30/13.
//  Copyright (c) 2013 Vegard Solheim Thériault. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

@end
