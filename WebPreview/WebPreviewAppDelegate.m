//
//  WebPreviewAppDelegate.m
//  WebPreview
//
//  Created by Brian Pfeil on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebPreviewAppDelegate.h"
#import <objc/runtime.h>

#define kDefaultsLastURL @"DefaultsLastURL"

typedef struct objc_method *Method;

struct objc_method {
    SEL method_name;
    char *method_types;
    IMP method_imp;
};


@implementation NSApplication(sendEvent)

static IMP NSApplication_sendEvent =nil;

+ (void)installSendEvent {
    NSApplication_sendEvent =[self instanceMethodForSelector:@selector(sendEvent:)];
    Method m = class_getInstanceMethod( [self class], @selector(sendEvent:) );
    Method myMethod = class_getInstanceMethod([self class], @selector(mySendEvent:));
    method_setImplementation(m, myMethod->method_imp);
    //m->method_imp = myMethod->method_imp;
    _objc_flush_caches([self class]); // From memory; there may be a
}

- (void)mySendEvent:(NSEvent*)anEvent {
    NSApplication_sendEvent(self,@selector(sendEvent:),anEvent);
    NSLog(@"anEvent = %@", [anEvent description]);
}
@end

@interface WebPreviewAppDelegate()
-(void)reloadTimerFired:(NSTimer*)timer;
- (void)loadURL:(NSString*)url;
- (void)urlTextDidChange:(id)sender;
-(void)setWebViewSize:(NSSize)size;
@end

@implementation WebPreviewAppDelegate

@synthesize window = _window;
@synthesize urlTextField = _urlTextField;
@synthesize webView = _webView;
@synthesize drawer = _drawer;
@synthesize autoRefreshCheckbox = _autoRefreshCheckbox;
@synthesize autoRefreshIntervalTextField = _autoRefreshIntervalTextField;
@synthesize webViewWidthTextField = _webViewWidthTextField;
@synthesize webViewHeightTextField = _webViewHeightTextField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)awakeFromNib {
    [NSApplication installSendEvent];    
    //self.drawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(200.0, 500.0) preferredEdge:NSMinXEdge];
    //_drawer.parentWindow = _window;
    //[_drawer open];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlTextDidChange:)  name:NSControlTextDidChangeNotification object:_urlTextField];

    NSString *lastURL = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultsLastURL];
    if (lastURL) {
        _urlTextField.stringValue = lastURL;
        [self urlTextDidChange:self];
    }
    
}

-(void)reloadTimerFired:(NSTimer*)timer {
    [self urlTextDidChange:self];
}

- (void)loadURL:(NSString*)url {
    WebFrame *mainFrame = [_webView mainFrame];
    //[_webView setFrame:NSMakeRect(10, 0, 320, 480)];
    [mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];        
}

- (void)urlTextDidChange:(id)sender {
    NSString *url = _urlTextField.stringValue;
    NSLog(@"url = %@", url);
    [self loadURL:url];
    [[NSUserDefaults standardUserDefaults] setValue:url forKey:kDefaultsLastURL];
}

-(void)startAutoRefresh {
    if (_autoRefreshTimer) {
        [_autoRefreshTimer invalidate];
        _autoRefreshTimer = nil;
    }
    
    _autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:_autoRefreshIntervalTextField.stringValue.doubleValue target:self selector:@selector(reloadTimerFired:) userInfo:nil repeats:YES];
}

-(void)stopAutoRefresh {
    if (_autoRefreshTimer) {
        [_autoRefreshTimer invalidate];
        _autoRefreshTimer = nil;
    }
}

-(IBAction)setWebViewSizeClicked:(id)sender {
    [self setWebViewSize:NSMakeSize(_webViewWidthTextField.stringValue.floatValue, _webViewHeightTextField.stringValue.floatValue)];
}

-(void)setWebViewSize:(NSSize)size {
    CGFloat widthPadding = _window.frame.size.width - _webView.bounds.size.width;
    CGFloat heightPadding = _window.frame.size.height - _webView.bounds.size.height;
        
    [_window setFrame:NSMakeRect(_window.frame.origin.x, _window.frame.origin.y, size.width + widthPadding, size.height + heightPadding) display:YES animate:YES];
}

-(IBAction)autoRefreshClick:(id)sender {
    
    if (_autoRefreshCheckbox.state == NSOnState) {
        [self reloadTimerFired:_autoRefreshTimer];
        [self startAutoRefresh];
    } else {
        [self stopAutoRefresh];
    }
}

@end
