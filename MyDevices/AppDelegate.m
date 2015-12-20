//
//  AppDelegate.m
//  MyDevices
//
//  Created by George Dan on 19/12/2015.
//  Copyright © 2015 George Dan. All rights reserved.
//

#import "AppDelegate.h"
#import <iMobileDevice/iMobileDevice.h>

@interface AppDelegate () <NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSArray *allDevices;
@property (nonatomic) BOOL notificationsEnabled;
@end

@implementation AppDelegate

-(NSString*)getStringFromProductType:(NSString*)productType {
	// Apple TV
	if ([productType isEqualToString:@"AppleTV2,1"]) {
		return @"Apple TV 2G";
	} else if ([productType isEqualToString:@"AppleTV3,1"] || [productType isEqualToString:@"AppleTV3,2"]) {
		return @"Apple TV 3G";
	} else if ([productType isEqualToString:@"AppleTV5,3"]) {
		return @"Apple TV 4G";
	}
	// Apple Watch
	else if ([productType isEqualToString:@"Watch1,1"] || [productType isEqualToString:@"Watch1,2"]) {
		return @"Apple Watch";
	}
	// iPad
	else if ([productType isEqualToString:@"iPad1,1"]) {
		return @"iPad";
	} else if ([productType isEqualToString:@"iPad2,1"] || [productType isEqualToString:@"iPad2,2"] || [productType isEqualToString:@"iPad2,3"] || [productType isEqualToString:@"iPad2,4"]) {
		return @"iPad 2";
	} else if ([productType isEqualToString:@"iPad3,1"] || [productType isEqualToString:@"iPad3,2"] || [productType isEqualToString:@"iPad3,3"]) {
		return @"iPad 3";
	} else if ([productType isEqualToString:@"iPad3,4"] || [productType isEqualToString:@"iPad3,5"] || [productType isEqualToString:@"iPad3,6"]) {
		return @"iPad 4";
	} else if ([productType isEqualToString:@"iPad4,1"] || [productType isEqualToString:@"iPad4,2"] || [productType isEqualToString:@"iPad4,3"]) {
		return @"iPad Air";
	} else if ([productType isEqualToString:@"iPad5,3"] || [productType isEqualToString:@"iPad5,4"]) {
		return @"iPad Air 2";
	} else if ([productType isEqualToString:@"iPad6,7"] || [productType isEqualToString:@"iPad6,8"]) {
		return @"iPad Pro";
	}
	// iPad Mini
	else if ([productType isEqualToString:@"iPad2,5"] || [productType isEqualToString:@"iPad2,6"] || [productType isEqualToString:@"iPad2,7"]) {
		return @"iPad Mini";
	} else if ([productType isEqualToString:@"iPad4,4"] || [productType isEqualToString:@"iPad4,5"] || [productType isEqualToString:@"iPad4,6"]) {
		return @"iPad Mini 2";
	} else if ([productType isEqualToString:@"iPad4,7"] || [productType isEqualToString:@"iPad4,8"] || [productType isEqualToString:@"iPad4,9"]) {
		return @"iPad Mini 3";
	} else if ([productType isEqualToString:@"iPad5,1"] || [productType isEqualToString:@"iPad5,2"]) {
		return @"iPad Mini 4";
	}
	// iPhone
	else if ([productType isEqualToString:@"iPhone1,1"]) {
		return @"iPhone";
	} else if ([productType isEqualToString:@"iPhone1,2"]) {
		return @"iPhone 3G";
	} else if ([productType isEqualToString:@"iPhone2,1"]) {
		return @"iPhone 3GS";
	} else if ([productType isEqualToString:@"iPhone3,1"] || [productType isEqualToString:@"iPhone3,2"] || [productType isEqualToString:@"iPhone3,3"]) {
		return @"iPhone 4";
	} else if ([productType isEqualToString:@"iPhone4,1"]) {
		return @"iPhone 4S";
	} else if ([productType isEqualToString:@"iPhone5,1"] || [productType isEqualToString:@"iPhone5,2"]) {
		return @"iPhone 5";
	} else if ([productType isEqualToString:@"iPhone5,3"] || [productType isEqualToString:@"iPhone5,4"]) {
		return @"iPhone 5C";
	} else if ([productType isEqualToString:@"iPhone6,1"] || [productType isEqualToString:@"iPhone6,2"]) {
		return @"iPhone 5S";
	} else if ([productType isEqualToString:@"iPhone7,1"]) {
		return @"iPhone 6 Plus";
	} else if ([productType isEqualToString:@"iPhone7,2"]) {
		return @"iPhone 6";
	} else if ([productType isEqualToString:@"iPhone8,1"]) {
		return @"iPhone 6S";
	} else if ([productType isEqualToString:@"iPhone8,2"]) {
		return @"iPhone 6S Plus";
	}
	// iPod
	else if ([productType isEqualToString:@"iPod1,1"]) {
		return @"iPod Touch";
	} else if ([productType isEqualToString:@"iPod2,1"]) {
		return @"iPod Touch 2G";
	} else if ([productType isEqualToString:@"iPod3,1"]) {
		return @"iPod Touch 3G";
	} else if ([productType isEqualToString:@"iPod4,1"]) {
		return @"iPod Touch 4G";
	} else if ([productType isEqualToString:@"iPod5,1"]) {
		return @"iPod Touch 5G";
	} else if ([productType isEqualToString:@"iPod7,1"]) {
		return @"iPod Touch 6G";
	}
	
	return productType;
}

-(void)addNewSectionToMenuWithDeviceName:(NSString*)name product:(NSString*)type productType:(NSString*)productType UDID:(NSString*)UDID {
	[self.statusMenu insertItem:[[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@: %@ (%@)", name, type, productType] action:@selector(emptySelector) keyEquivalent:@""] atIndex:[self.statusMenu numberOfItems]-1];
	NSMenuItem *udidItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"UUID: %@", UDID] action:@selector(udidClicked:) keyEquivalent:@""];
	[udidItem setToolTip:@"Click to copy to clipboard"];
	[self.statusMenu insertItem:udidItem atIndex:[self.statusMenu numberOfItems]-1];
	[self.statusMenu insertItem:[NSMenuItem separatorItem] atIndex:[self.statusMenu numberOfItems]-1];
}

-(void)emptySelector {
	
}

-(void)udidClicked:(NSMenuItem*)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	[pasteboard clearContents];
	[pasteboard setString:[sender.title substringWithRange:NSMakeRange(6, [sender.title length]-6)] forType:NSStringPboardType];
}

-(void)sendNotificationWithDevice:(iMDVLNDevice*)device disconnected:(BOOL)disconnected {
	NSUserNotification *notification = [[NSUserNotification alloc] init];
	notification.title = [NSString stringWithFormat:@"Device %@!", disconnected ? @"disconnected" : @"connected"];
	notification.informativeText = [NSString stringWithFormat:@"An %@ named %@ has just been %@", [self getStringFromProductType:device.productType], device.name, disconnected ? @"disconnected" : @"connected"];
	[[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void)reloadMenu:(BOOL)added {
	[self.statusMenu removeAllItems];
	int count = 0;
	for (iMDVLNDevice *device in [iMDVLNDeviceManager sharedManager].devices) {
		
		[device loadBasicDevicePropertiesWithCompletion:^
		 {
			 if (device.name == nil)
			 {
				 NSLog(@"Failed to load device name, something might be up");
				 
				 return;
			 }
			 
			 [self addNewSectionToMenuWithDeviceName:device.name product:[self getStringFromProductType:device.productType] productType:device.productType UDID:device.UDID];
			 if (added && count == [iMDVLNDeviceManager sharedManager].devices.count-1 && self.notificationsEnabled) {
				 [self sendNotificationWithDevice:device disconnected:NO];
			 }
		 }];
		count++;
	}
	NSMenuItem *notificationItem = [[NSMenuItem alloc] initWithTitle:@"Show Notifications" action:@selector(notificationHandler:) keyEquivalent:@""];
	notificationItem.state = YES;
	[self.statusMenu insertItem:notificationItem atIndex:self.statusMenu.numberOfItems];
	[self.statusMenu insertItem:[NSMenuItem separatorItem] atIndex:[self.statusMenu numberOfItems]];
	[self.statusMenu insertItem:[[NSMenuItem alloc] initWithTitle:@"Quit MyDevices" action:@selector(terminate:) keyEquivalent:@""] atIndex:self.statusMenu.numberOfItems];
}

-(void)notificationHandler:(NSMenuItem*)sender {
	sender.state = !sender.state;
	self.notificationsEnabled = sender.state;
}

-(void)deviceConnected {
	[self reloadMenu: YES];
	self.allDevices = [[iMDVLNDeviceManager sharedManager].devices copy];
}

-(void)deviceDisconnected {
	[self reloadMenu: NO];
	if (self.notificationsEnabled) {
		[self sendNotificationWithDevice:[self.allDevices objectAtIndex:[self.allDevices count]-1] disconnected:YES];
	}
	self.allDevices = [[iMDVLNDeviceManager sharedManager].devices copy];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialise your application
	[[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
	NSError *error = nil;
	[[iMDVLNDeviceManager sharedManager] subscribeForNotifications:&error];
	
	if (error) {
		NSLog(@"AppDelegate.applicationDidFinishLaunching error subscribing to notifications %@", error);
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceConnected) name:iMDVLNDeviceAddedNotification object:[iMDVLNDeviceManager sharedManager]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected) name:iMDVLNDeviceRemovedNotification object:[iMDVLNDeviceManager sharedManager]];

	self.notificationsEnabled = YES;
	
	// Create the status bar item
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[self.statusItem setMenu:self.statusMenu];
	[self.statusItem setImage:[NSImage imageNamed:@"StatusImage.png"]];
	[self.statusItem.image setTemplate:YES];
	[self.statusItem setHighlightMode:YES];
	
	//[self reloadMenu];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
	[[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSError *error = nil;
	[[iMDVLNDeviceManager sharedManager] unsubscribeForNotifications:&error];

	if (error) {
		NSLog(@"AppDelegate.applicationWillTerminate error unsubscribing from notifications %@", error);
	}
}

@end
