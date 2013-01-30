//
//  LSBrowserViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 06/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import "LSBrowserViewController.h"
#import "MyApplication.h"

@interface LSBrowserViewController () <UIWebViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation LSBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_activityIndicator setHidesWhenStopped:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
    
    [self updateToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)backButtonPressed:(id)sender
{
    if([_webView canGoBack]) [_webView goBack];
}


- (IBAction)forwardButtonPressed:(id)sender
{
    if([_webView canGoForward]) [_webView goForward];
}


- (IBAction)stopReloadButtonPressed:(id)sender
{
    if([_activityIndicator isAnimating]) {
        [_webView stopLoading];
        [_activityIndicator stopAnimating];
    } else {
        [_webView reload];
    }
    
    [self updateToolbar];
}

- (IBAction)actionButtonPressed:(id)sender
{
    UIActionSheet *uias = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Anullér"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Åbn i Safari", nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [uias showFromBarButtonItem:_actionButton animated:YES];
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [uias showInView:_toolbar];
    }
}


- (void)updateToolbar
{
    // toolbar
    _forwardButton.enabled = [_webView canGoForward];
    _backButton.enabled = [_webView canGoBack];
    
    if([_activityIndicator isAnimating]) {
        [_reloadButton setStyle:UIBarButtonSystemItemCancel];
        [_reloadButton setStyle:UIBarButtonItemStylePlain];
    } else {
        [_reloadButton setStyle:UIBarButtonSystemItemRefresh];
        [_reloadButton setStyle:UIBarButtonItemStylePlain];
    }
    
}

#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
    [self updateToolbar];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    [_activityIndicator stopAnimating];
    [self updateToolbar];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error");
    [self updateToolbar];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)uias clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // user pressed "Cancel"
    if(buttonIndex == [uias cancelButtonIndex]) return;
    
    // user pressed "Open in Safari"
    if([[uias buttonTitleAtIndex:buttonIndex] compare:@"Åbn i Safari"] == NSOrderedSame)
    {
        [(MyApplication*)[UIApplication sharedApplication] openURL:_url forceOpenInSafari:YES];
    }
}

@end
