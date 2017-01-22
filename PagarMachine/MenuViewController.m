//
//  MenuViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 21/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#define OPERATION_TITLE_KEY             @"title"
#define OPERATION_MENU_INDEX_KEY        @"menuIndex"
#define OPERATION_CODE_KEY              @"operationCode"
#define OPERATION_IS_COMBINED_KEY       @"isCombined"

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "SelectValueViewController.h"
#import "UIColor+Utils.h"
#import "NSArray+Utils.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *operations;
@property (strong, nonatomic) NSMutableArray *cellHeights;

@property (nonatomic) NSInteger numberOfItemsInMenu;
@property (nonatomic) NSInteger selectedMenuItem;

@end


@implementation MenuViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.operations = [NSArray loadPlistWithName:@"Operations"];
    self.numberOfItemsInMenu = [self.operations count];
    
    self.cellHeights = [NSMutableArray array];
    for (int i = 0; i < self.numberOfItemsInMenu; i++) {
        [self.cellHeights addObject:[NSNumber numberWithFloat:44.f]];
    }
    
    /// setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upButtonPressed:) name:@"upButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downButtonPressed:) name:@"downButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberButtonPressed:) name:@"numberButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmButtonPressed:) name:@"confirmButtonPressed" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedMenuItem = 0;
    [self.tableView reloadData];
}


#pragma mark - UITableView Delegate and Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfItemsInMenu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *menuTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"menuTableViewCell"];
    
    if (self.selectedMenuItem == indexPath.row) {
        [menuTableViewCell setBackgroundColor:[UIColor defaultColor:DefaultColorMenuItemSelectedBackground]];
    } else {
        [menuTableViewCell setBackgroundColor:[UIColor defaultColor:DefaultColorMenuItemDeselectedBackground]];
    }
    
    [menuTableViewCell.menuTitleLabel setText:[self.operations[indexPath.row] objectForKey:OPERATION_TITLE_KEY]];
    [menuTableViewCell.menuTitleLabel setNumberOfLines:0];
    [menuTableViewCell.menuTitleLabel sizeToFit];
    self.cellHeights[indexPath.row] = [NSNumber numberWithFloat:menuTableViewCell.menuTitleLabel.frame.size.height + 17];
    
    return menuTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.row] floatValue];
}


#pragma mark - NSNotification Selector Methods

- (void)upButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.selectedMenuItem > 0) {
            self.selectedMenuItem--;
            [self.tableView reloadData];
        }
    }
}

- (void)downButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.selectedMenuItem < [self.operations count] - 1) {
            self.selectedMenuItem++;
            [self.tableView reloadData];
        }
    }
}

- (void)numberButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        /// some number has been pressed
        if ([notification.object isKindOfClass:[UIButton class]]) {
            
            /// fetch text number from selected button
            UIButton *selectedButton = (UIButton *)notification.object;
            NSInteger number = [selectedButton.titleLabel.text integerValue];
            
            /// check if selected button corresponds to one of the menu options
            if (number > 0 && number <= [self.operations count]) {
                
                /// update selectedMenuItem
                self.selectedMenuItem = number - 1;
                [self.tableView reloadData];
            }
        }
    }
}

- (void)confirmButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        [self performSegueWithIdentifier:@"pushToSelectValue" sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToSelectValue"]) {
        SelectValueViewController *selectValueViewController = (SelectValueViewController *)[segue destinationViewController];
        NSInteger operationNumber = [[self.operations[self.selectedMenuItem] valueForKey:OPERATION_CODE_KEY] integerValue];
        selectValueViewController.selectedOperationNumber = operationNumber;
        selectValueViewController.isOperationCombined = [[self.operations[self.selectedMenuItem] valueForKey:OPERATION_IS_COMBINED_KEY] boolValue];
    }
}

@end
