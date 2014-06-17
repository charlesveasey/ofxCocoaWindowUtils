#include <Cocoa/Cocoa.h>
#include <AppKit/NSOpenGL.h>
#include <OpenGL/OpenGL.h>
#include "ofxTransparentWindowUtil.h"
#include <iostream>
#include <vector>

extern void menuCallback(std::vector<std::string> files);

@interface cOpenPanel : NSOpenPanel {}
@end

@implementation cOpenPanel
- (void)center {
    NSRect myFrame = [self frame];
    NSRect screenFrame = [[self screen] visibleFrame];
    myFrame.size.height = round(screenFrame.size.height / 2);
    myFrame.origin.x = screenFrame.origin.x;
    myFrame.origin.y = screenFrame.origin.y + screenFrame.size.height - myFrame.size.height;
    [self setFrame:myFrame display:YES];
}
@end

@interface AppMenu : NSMenu {}
- (void)openFile:(id)sender;
@end

@implementation AppMenu

-(void)openFile:(id)sender {
    
    std::vector<std::string> files;
    
// Create the File Open Dialog class.
    NSOpenPanel* openDlg = [cOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:YES];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog. If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [urls count]; i++ ) {
            NSString* url = [urls objectAtIndex:i];
            NSString *foo = [url path];
            std::string *bar = new std::string([foo UTF8String]);
            files.push_back(*bar);
        }
        
        if (files.size())
            menuCallback(files);
    }

}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    return [menuItem isEnabled];
}

@end;



void createWindow(int transparentType, int x, int y, int w, int h, bool showBorder) {
    
	NSOpenGLContext * myContext = nil;
	NSView *myView = nil;
	NSWindow* window = nil;
	
	myContext = [ NSOpenGLContext currentContext ];
	myView = [ myContext view ];
	window = [ myView window ];
	
    if (!showBorder) {
        // remove frame
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [window setStyleMask:NSBorderlessWindowMask];
        [pool release];
    }
    
    // set window rectangle
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSArray *screenArray = [NSScreen screens];
    NSRect screenRect = [mainScreen visibleFrame];
    NSRect windowRect;
    windowRect.size.width = w;
    windowRect.size.height = h;
    windowRect.origin.x = x;
    windowRect.origin.y = screenRect.size.height - h + 0 - y;
    [window setFrame:windowRect display:YES];
    
    // configure menu
    id menubar = [[NSMenu new] autorelease];
	id appMenuItem = [[NSMenuItem new] autorelease];
	[menubar addItem:appMenuItem];
	[NSApp setMainMenu:menubar];
	id appMenu = [[AppMenu new] autorelease];
    
    
	id appName = [[NSProcessInfo processInfo] processName];
	id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Quit"
												  action:@selector(terminate:)
										   keyEquivalent:@"q"] autorelease];
	NSMenuItem *menuItem  = [[[NSMenuItem alloc] initWithTitle:@"Open Media"
                                                  action:@selector(openFile:)
										   keyEquivalent:@"o"] autorelease];
    
    [menuItem setTarget:appMenu];
    
    [appMenu addItem:menuItem];
	[appMenu addItem:quitMenuItem];
	[appMenuItem setSubmenu:appMenu];

    // set float mode
	if (transparentType == 0) {
		[window setLevel: kCGScreenSaverWindowLevel];
	}else if (transparentType == 1) {
		[window setLevel: kCGDesktopWindowLevel];
	}else if (transparentType == 2) {
		[window setLevel: kCGNormalWindowLevel];
	}else {
		[window setLevel: kCGNormalWindowLevel];
	}
    
    // give window focus
    [window makeFirstResponder:window.contentView];
    
    // don't need a shadow
    [window setHasShadow:NO];

}



