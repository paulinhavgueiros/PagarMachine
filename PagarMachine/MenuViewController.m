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

/*!
 * @brief the table view used to represent the card machine menu
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 * @brief an array of menu operations, each of which containing a dictionary of properties
 */
@property (strong, nonatomic) NSArray *operations;

/*!
 * @brief an array of cell heights of the menu table view
 */
@property (strong, nonatomic) NSMutableArray *cellHeights;

/*!
 * @brief the number of menu items
 */
@property (nonatomic) NSInteger numberOfItemsInMenu;

/*!
 * @brief the current selected menu
 */
@property (nonatomic) NSInteger selectedMenuItem;

@end


@implementation MenuViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

/*!
 * @discussion Method that sets up the user interface and performs any necessary view initialization
 */
- (void)setup {
    /// set menu table view delegate and data source to current view controller
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    /// initialize menu operations array
    self.operations = [NSArray loadPlistWithName:@"Operations"];
    
    /// define number of items in menu
    self.numberOfItemsInMenu = [self.operations count];
    
    /// initialize array of cell heights with default value
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
    
    /// reset selected menu item to the first item every time the user returns to the main screen
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
    
    /// set the background color based on item seletion
    if (self.selectedMenuItem == indexPath.row) {
        [menuTableViewCell setBackgroundColor:[UIColor defaultColor:DefaultColorMenuItemSelectedBackground]];
    } else {
        [menuTableViewCell setBackgroundColor:[UIColor defaultColor:DefaultColorMenuItemDeselectedBackground]];
    }
    
    /// set menu item text
    [menuTableViewCell.menuTitleLabel setText:[self.operations[indexPath.row] objectForKey:OPERATION_TITLE_KEY]];
    [menuTableViewCell.menuTitleLabel setNumberOfLines:0];
    [menuTableViewCell.menuTitleLabel sizeToFit];
    [menuTableViewCell.menuTitleLabel layoutIfNeeded];
    
    /// update view heigth for menu item
    self.cellHeights[indexPath.row] = [NSNumber numberWithFloat:menuTableViewCell.menuTitleLabel.frame.size.height + 17];
    
    return menuTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.row] floatValue];
}


#pragma mark - NSNotification Selector Methods

/*!
 * @discussion Method executed when the machine's up button in pressed.  If possible, changes the menu selection to the option above the currect selected one.
 */
- (void)upButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.selectedMenuItem > 0) {
            self.selectedMenuItem--;
            [self.tableView reloadData];
        }
    }
}

/*!
 * @discussion Method executed when the machine's down button in pressed.  If possible, changes the menu selection to the option below the currect selected one.
 */
- (void)downButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.selectedMenuItem < [self.operations count] - 1) {
            self.selectedMenuItem++;
            [self.tableView reloadData];
        }
    }
}

/*!
 * @discussion Method executed when the any of the machine's number buttons are pressed.  If possible, changes the menu selection to the selected number item.
 */
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

/*!
 * @discussion Method executed when the machine's confirm button is pressed.  Changes the machine's UI to the next screen.
 */
- (void)confirmButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        [self performSegueWithIdentifier:@"pushToSelectValue" sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToSelectValue"]) {
        SelectValueViewController *selectValueViewController = (SelectValueViewController *)[segue destinationViewController];
        
        /// setup new view controller with the selected user options
        
        NSInteger operationNumber = [[self.operations[self.selectedMenuItem] valueForKey:OPERATION_CODE_KEY] integerValue];
        selectValueViewController.selectedOperationNumber = operationNumber;
        selectValueViewController.isOperationCombined = [[self.operations[self.selectedMenuItem] valueForKey:OPERATION_IS_COMBINED_KEY] boolValue];
    }
}

@end
