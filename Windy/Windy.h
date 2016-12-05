//
//  Windy.h
//  Windy
//
//  Created by Riccardo Massari on 05/12/2016.
//  Copyright © 2016 Riccardo Massari. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface Windy : NSPreferencePane

- (void)mainViewDidLoad;

@property (weak) IBOutlet NSButton *toggleUmbrellaButton;
@property (weak) IBOutlet NSTextField *umbrellaStatusLed;
@property (weak) IBOutlet NSTextField *umbrellaStatusText;

@end
