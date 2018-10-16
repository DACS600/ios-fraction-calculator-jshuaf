//
//  ViewController.h
//  FractionCalculatorApp
//
//  Created by jfang19 on 9/27/18.
//  Copyright © 2018 joshuafang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FractionCalculator.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property FractionCalculator* calculator;

@end

