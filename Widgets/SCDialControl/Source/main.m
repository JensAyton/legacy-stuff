//
//  main.m
//  CPUInfo
//
//  Created by Jens Ayton on Wed Nov 17 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <mach/processor.h>
#import <mach/processor_info.h>
#import <mach/mach_host.h>

int main(int argc, const char *argv[])
{
	
	UInt32					major, minor, release, revision;
	const char				*version;
	
	// It’s reasonable to assume that Multiprocessing Services 2 or later will be
	// available to an OS X program, but what the hey
	if (!_MPIsFullyInitialized())
	{
		printf("Error: Multiprocessing Services not available.\n");
		return EXIT_FAILURE;
	}
	
	_MPLibraryVersion(&version, &major, &minor, &release, &revision);
	if (2 < major)
	{
		printf("Multiprocessing Services version %s installed, 2.0 or later required\n", version);
	}
	
	return NSApplicationMain(argc, argv);
	
	return 0;
}
