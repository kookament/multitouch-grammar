//
//  main.m
//  MultitouchGrammar
//
//  Created by Sean Kelley on 9/9/12.
//  Copyright (c) 2012 Sean Kelley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Touch.h"
#import "PrintingListener.h"
#import "GrammarListener.h"

int main(int argc, char *argv[]) {
//    PrintingListener *p = [[PrintingListener alloc] init];
    GrammarListener *g = [[GrammarListener alloc] init];
    while (YES) {
        // Because Xcode is bad and should feel bad. Continuing after
        // a breakpoint would otherwise terminate the program because
        // it would continue after sleep().
        sleep(-1);
    }
    return 0;
}
