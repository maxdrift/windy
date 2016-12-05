//
//  Windy.m
//  Windy
//
//  Created by Riccardo Massari on 05/12/2016.
//  Copyright © 2016 Riccardo Massari. All rights reserved.
//

#import "Windy.h"

static NSString *kUmbrellaStatusChecking = @"Checking Umbrella status...";
static NSString *kUmbrellaStatusEnabled = @"Umbrella is enabled";
static NSString *kUmbrellaStatusDisabled = @"Umbrella is disabled";

@interface Windy()

@property bool umbrellaStatus;

@end

@implementation Windy

- (void)mainViewDidLoad
{
    [_toggleUmbrellaButton setEnabled:false];
    [_umbrellaStatusLed setTextColor:[NSColor colorWithCGColor:CGColorCreateGenericRGB(0.7, 0.7, 0.7, 1.0)]];
    [_umbrellaStatusText setStringValue:kUmbrellaStatusChecking];
}

- (void)didSelect
{
    [self checkUmbrellaStatus];
}

- (IBAction)toggleUmbrella:(id)sender {
    if (_umbrellaStatus) {
        [self stopUmbrella];
    } else {
        [self startUmbrella];
    }
    [self checkUmbrellaStatus];
}

/*
 sudo launchctl remove com.opendns.osx.RoamingClientConfigUpdater;
 launchctl remove com.opendns.osx.RoamingClientMenubar;
 sudo killall OpenDNSDiagnostic &>/dev/null;
 sleep 1;
 status;
 */
-(void)stopUmbrella
{
    NSDictionary *error = [NSDictionary new];
    NSString *script =  @"do shell script \"launchctl remove com.opendns.osx.RoamingClientConfigUpdater\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    if ([appleScript executeAndReturnError:&error]) {
        NSLog(@"success! 1");
    } else {
        NSLog(@"failure! 1");
    }
    NSString *script2 =  @"do shell script \"launchctl remove com.opendns.osx.RoamingClientMenubar\"";
    NSAppleScript *appleScript2 = [[NSAppleScript alloc] initWithSource:script2];
    if ([appleScript2 executeAndReturnError:&error]) {
        NSLog(@"success! 2");
    } else {
        NSLog(@"failure! 2");
    }
    // TODO: Add status check
}

/*
 sudo launchctl load /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist;
 launchctl load /Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist;
 sleep 1;
 status;
 */
-(void)startUmbrella
{
    NSDictionary *error = [NSDictionary new];
    NSString *script =  @"do shell script \"launchctl load /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    if ([appleScript executeAndReturnError:&error]) {
        NSLog(@"success! 1");
    } else {
        NSLog(@"failure! 1");
    }
    NSString *script2 =  @"do shell script \"launchctl load /Library/LaunchAgents/com.opendns.osx.RoamingClientMenubar.plist\"";
    NSAppleScript *appleScript2 = [[NSAppleScript alloc] initWithSource:script2];
    if ([appleScript2 executeAndReturnError:&error]) {
        NSLog(@"success! 2");
    } else {
        NSLog(@"failure! 2");
    }
}

/*
 ps auwwx | egrep "dnscrypt|RoamingClientMenubar|dns-updater" | grep -vq egrep;
 if [[ 0 == $? ]]; then
 echo "Umbrella is running. Checking debug.opendns.com DNS…";
 dig debug.opendns.com txt +time=2 +tries=1 +short | sed 's/^"/  "/' | grep '"';
 [[ 1 == $? ]] && echo "Umbrella is not functioning correctly!"
 else
 echo "Umbrella is stopped";
 grep -q 127.0.0.1 /etc/resolv.conf && echo "Without umbrella running, you'll need to remove 127.0.0.1 from your DNS servers before you can resolve domains.";
 fi
 echo "Currently using name servers: $(cat /etc/resolv.conf | grep nameserver | sed 's/nameserver //' | tr '\n' ' ')"
 */
- (bool)checkUmbrellaStatus
{
    [_toggleUmbrellaButton setEnabled:false];
    NSDictionary *error = [NSDictionary new];
    NSString *script =  @"do shell script \"ps auwwx | egrep 'dnscrypt|RoamingClientMenubar|dns-updater' | grep -vq egrep\"";
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    if ([appleScript executeAndReturnError:&error]) {
        [_umbrellaStatusLed setTextColor:[NSColor colorWithCGColor:CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0)]];
        [_umbrellaStatusText setStringValue:kUmbrellaStatusEnabled];
        [_toggleUmbrellaButton setTitle:@"Stop"];
        _umbrellaStatus = true;
    } else {
        [_umbrellaStatusLed setTextColor:[NSColor colorWithCGColor:CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0)]];
        [_umbrellaStatusText setStringValue:kUmbrellaStatusDisabled];
        [_toggleUmbrellaButton setTitle:@"Start"];
        _umbrellaStatus = false;
    }
    [_toggleUmbrellaButton setEnabled:true];
    return _umbrellaStatus;
}


@end
