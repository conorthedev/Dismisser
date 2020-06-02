#include "DismisserRootListController.h"

@implementation DismisserRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)code {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/cbyrne/Dismisser"] options:@{} completionHandler:nil];
}

-(void)bug {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/cbyrne/Dismisser/issues/new"] options:@{} completionHandler:nil];
}

@end
