
#import "WMFWelcomeLanguageViewController.h"
#import "WMFWelcomeLanguageTableViewCell.h"
#import "MWKLanguageLinkController.h"
#import "UIView+WMFDefaultNib.h"
#import "MWKLanguageLink.h"
#import "LanguagesViewController.h"
#import "UIViewController+WMFStoryboardUtilities.h"


@interface WMFWelcomeLanguageViewController ()<LanguageSelectionDelegate>

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UITableView* languageTableView;
@property (strong, nonatomic) IBOutlet UIButton* moreLanguagesButton;
@property (strong, nonatomic) IBOutlet UIButton* nextStepButton;

@end

@implementation WMFWelcomeLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.languageTableView.editing = YES;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[MWKLanguageLinkController sharedInstance].preferredLanguages count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    WMFWelcomeLanguageTableViewCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:[WMFWelcomeLanguageTableViewCell wmf_nibName]
                                                                                forIndexPath:indexPath];
    MWKLanguageLink* langLink = [MWKLanguageLinkController sharedInstance].preferredLanguages[indexPath.row];
    cell.numberLabel.text       = [NSString stringWithFormat:@"%li", indexPath.row + 1];
    cell.languageNameLabel.text = langLink.name;

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleNone; //remove delete control
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    MWKLanguageLink* langLink = [MWKLanguageLinkController sharedInstance].preferredLanguages[indexPath.row];
    [[MWKLanguageLinkController sharedInstance] removePreferredLanguage:langLink];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    MWKLanguageLink* langLink = [MWKLanguageLinkController sharedInstance].preferredLanguages[sourceIndexPath.row];
    [[MWKLanguageLinkController sharedInstance] reorderPreferredLanguage:langLink toIndex:destinationIndexPath.row];
    [self.languageTableView reloadData];
}

- (IBAction)addLanguages:(id)sender {
    LanguagesViewController* languagesVC = [LanguagesViewController wmf_initialViewControllerFromClassStoryboard];
    languagesVC.showPreferredLanguges     = NO;
    languagesVC.languageSelectionDelegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:languagesVC] animated:YES completion:NULL];
}

#pragma mark - LanguageSelectionDelegate

- (void)languagesController:(LanguagesViewController*)controller didSelectLanguage:(MWKLanguageLink*)language {
    [[MWKLanguageLinkController sharedInstance] appendPreferredLanguage:language];
    [self.languageTableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
