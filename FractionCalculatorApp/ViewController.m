//
//  ViewController.m
//  FractionCalculatorApp
//
//  Created by jfang19 on 9/27/18.
//  Copyright © 2018 joshuafang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplayLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *navigationControl;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;

@end

@implementation ViewController

-(void) viewWillAppear:(BOOL)animated {
  self.calculator = [[FractionCalculator alloc] init];
  self.calculator.isOn = TRUE;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.historyTableView.delegate = self;
  self.historyTableView.dataSource = self;
  self.historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  for (UIButton *subview in [self.buttonContainer subviews]) {
    subview.layer.cornerRadius = 0.5 * subview.bounds.size.width;
    subview.clipsToBounds = TRUE;
    int buttonTextASCII = [subview.titleLabel.text characterAtIndex:0];
    if (buttonTextASCII >= 48 && buttonTextASCII <= 57) {
      subview.layer.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.2].CGColor;
      subview.layer.borderWidth = 2.0;
    } else if ([subview.titleLabel.text isEqual:@"="]) {
      subview.layer.borderWidth = 0.0;
    } else {
      subview.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.08];
      subview.layer.borderWidth = 0.0;
    }
  }
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.view.bounds;
  UIColor *color1 = UIColor.blackColor;
  UIColor *color2 = [UIColor colorWithHue:0 saturation:0 brightness:0.23 alpha:1];
  gradient.colors = @[(id) color1, (id) color2];
  [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) updateDisplay {
  self.displayLabel.text = self.calculator.display;
  self.historyDisplayLabel.text = self.calculator.historyDisplay;
}

- (IBAction)numberButtonTapped:(UIButton *)sender {
  [self.calculator inputNumber: sender.titleLabel.text.intValue];
  [self updateDisplay];
}

- (IBAction)fractionBarButtonTapped:(id)sender {
  self.calculator.focusedNumerator = FALSE;
  [self updateDisplay];
}

- (IBAction)changeSignButtonTapped:(UIButton *)sender {
  [self.calculator changeSign];
  [self updateDisplay];
}

- (IBAction)reciprocalButtonTapped:(UIButton *)sender {
  [self.calculator reciprocate];
  [self updateDisplay];
}

- (IBAction)operationButtonTapped:(UIButton *)sender {
  if (self.calculator.focusedNumerator) return;

  if ([sender.titleLabel.text isEqual: @"+"]) {
    self.calculator.operation = Add;
  } else if ([sender.titleLabel.text isEqual: @"–"]) {
    self.calculator.operation = Subtract;
  } else if ([sender.titleLabel.text isEqual: @"×"]) {
    self.calculator.operation = Multiply;
  } else if ([sender.titleLabel.text isEqual: @"÷"]) {
    self.calculator.operation = Divide;
  }
  self.calculator.displayFirstFraction = FALSE;
  self.calculator.focusedNumerator = TRUE;
  [self updateDisplay];
}

- (IBAction)clearButtonTapped:(UIButton *)sender {
  [self.calculator reset];
  [self updateDisplay];
}

- (IBAction)solveButtonTapped:(UIButton *)sender {
  [self.calculator performOperation];
  [self updateDisplay];
  [self.historyTableView reloadData];
}

- (IBAction)arrowButtonTapped:(UIButton *)sender {
  [self.calculator backspace];
  [self updateDisplay];
}

- (IBAction)navigationControlTapped:(id)sender {
  if (self.navigationControl.selectedSegmentIndex == 0) {
    self.calculatorView.hidden = FALSE;
    self.historyTableView.hidden = TRUE;
  } else {
    self.calculatorView.hidden = TRUE;
    self.historyTableView.hidden = FALSE;
  }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyItem"];
  cell.textLabel.text = [self.calculator.history objectAtIndex:indexPath.row];
  return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!self.calculator.history.count) {
    return 0;
  } else {
    return self.calculator.history.count;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

@end
