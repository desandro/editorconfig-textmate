//
//  NSWindow+EditorConfig.m
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import "ECConstants.h"
#import "NSObject+ECSwizzle.h"
#import "NSWindow+EditorConfig.h"

@implementation NSWindow (EditorConfig)

+ (void)ec_init {
    [self ec_swizzleMethod:@selector(setRepresentedFilename:)
                withMethod:@selector(ec_setRepresentedFilename:)];
}

- (void)ec_setRepresentedFilename:(NSString *)fileName {
    BOOL shouldNotify = NO;
    if (![[self representedFilename] isEqualToString:fileName]) {
        shouldNotify = YES;
    }
    
    // the original has been swapped with this one; call it
    [self ec_setRepresentedFilename:fileName];
    
    if (shouldNotify) {
        NSDictionary *info = [NSDictionary dictionaryWithObject:self.representedFilename forKey:@"fileName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kECDocumentDidChange
                                                            object:self
                                                          userInfo:info];
    }
}

- (NSView *)ec_statusBar {
    // windowController.documentView is an ivar, so we need to catch for NSUndefinedKeyException
    @try {
        return [self valueForKeyPath:@"windowController.documentView.statusBar"];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (NSView *)ec_textView {
    SEL textViewSelector = @selector(textView);
    NSWindowController *controller = self.windowController;
    
    // in TM1, we can get to the text view pretty easily from the window controller
    if ([controller respondsToSelector:textViewSelector]) {
        return [controller performSelector:textViewSelector];
    }
    // in TM2, it's on the documentView, which is only an ivar on the window controller
    else {
        @try {
            return [controller valueForKey:@"textView"];
        }
        @catch (NSException *exception) {
            return nil;
        }
    }
}

- (BOOL)ec_setSoftTabs:(BOOL)softTabs {
    BOOL success = NO;
    SEL softTabSelector = @selector(setSoftTabs:);
    
    NSView *textView = self.ec_textView;
    if ([textView respondsToSelector:softTabSelector]) {
        IMP setter = [textView methodForSelector:softTabSelector];
        setter(textView, softTabSelector, softTabs);
        DebugLog(@"(text view) Setting softabs: %@", softTabs ? @"ON" : @"OFF");
        success = YES;
    }
    
    NSView *statusBar = self.ec_statusBar;
    if ([statusBar respondsToSelector:softTabSelector]) {
        IMP setter = [statusBar methodForSelector:softTabSelector];
        setter(statusBar, softTabSelector, softTabs);
        DebugLog(@"(status bar) Setting softabs: %@", softTabs ? @"ON" : @"OFF");
    }
    else {
        success = NO;
    }
    
    return success;
}

- (BOOL)ec_setTabSize:(int)tabSize {
    BOOL success = NO;
    
    if (tabSize > 0) {
        SEL tabSizeSelector = @selector(setTabSize:);
        
        NSView *textView = self.ec_textView;
        if ([textView respondsToSelector:tabSizeSelector]) {
            IMP setter = [textView methodForSelector:tabSizeSelector];
            setter(textView, tabSizeSelector, tabSize);
            DebugLog(@"(text view) Setting tab size: %d", tabSize);
            success = YES;
        }
        
        NSView *statusBar = self.ec_statusBar;
        if ([statusBar respondsToSelector:tabSizeSelector]) {
            IMP setter = [statusBar methodForSelector:tabSizeSelector];
            setter(statusBar, tabSizeSelector, tabSize);
            DebugLog(@"(status bar) Setting tab size: %d", tabSize);
        }
        else {
            success = NO;
        }
    }
    
    return success;
}

@end
