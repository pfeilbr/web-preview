//
//  WebPreviewAppDelegate.h
//  WebPreview
//
//  Created by Brian Pfeil on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WebPreviewAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTextFieldDelegate> {
    NSWindow *_window;
    NSTextField *_urlTextField;
    WebView *_webView;
    NSDrawer *_drawer;
    NSButton *_autoRefreshCheckbox;
    NSTextField *_autoRefreshIntervalTextField;
    NSTimer *_autoRefreshTimer;
    NSTextField *_webViewWidthTextField;
    NSTextField *_webViewHeightTextField;
}

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *urlTextField;
@property (strong) IBOutlet WebView *webView;
@property (strong) IBOutlet NSDrawer *drawer;
@property (strong) IBOutlet NSTextField *autoRefreshIntervalTextField;
@property (strong) IBOutlet NSButton *autoRefreshCheckbox;
@property (strong) IBOutlet NSTextField *webViewWidthTextField;
@property (strong) IBOutlet NSTextField *webViewHeightTextField;


@end
