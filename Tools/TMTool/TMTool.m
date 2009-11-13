#define _DARWIN_BETTER_REALPATH

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <stdlib.h>


static void PrintUsageAndQuit(void) __attribute__((noreturn));
static void PrintStatus(NSURL *url);
static void SetExcluded(NSURL *url, BOOL exclude, BOOL byPath);


int main (int argc, const char * argv[])
{
	[[NSAutoreleasePool alloc] init];
	
	if (argc != 3)
	{
		PrintUsageAndQuit();
	}
	
	NSString *verb = [NSString stringWithUTF8String:argv[1]];
	NSString *path = [NSString stringWithUTF8String:argv[2]];
	
	char buffer[PATH_MAX];
	realpath([[path stringByExpandingTildeInPath] UTF8String], buffer);
	path = [NSString stringWithUTF8String:buffer];
	NSURL *url = [NSURL fileURLWithPath:path];
	
	if ([verb isEqualToString:@"status"])  PrintStatus(url);
	else if ([verb isEqualToString:@"include"])  SetExcluded(url, NO, NO);
	else if ([verb isEqualToString:@"exclude"])  SetExcluded(url, YES, NO);
	else if ([verb isEqualToString:@"excludep"])  SetExcluded(url, YES, YES);
	else  PrintUsageAndQuit();
	
	return 0;
}


static void PrintStatus(NSURL *url)
{
	Boolean byPath = NO;
	
	printf("%s: ", [[url path] UTF8String]);
	
	if (CSBackupIsItemExcluded((CFURLRef)url, &byPath))
	{
		printf("excluded (%s)\n", byPath ? "by path" : "by item");
	}
	else
	{
		printf("included\n");
	}
}


static void SetExcluded(NSURL *url, BOOL exclude, BOOL byPath)
{
	Boolean actualByPath = NO;
	
	if (!exclude)
	{
		CSBackupIsItemExcluded((CFURLRef)url, &actualByPath);
		byPath = actualByPath;
	}
	
	OSStatus err = CSBackupSetItemExcluded((CFURLRef)url, exclude, byPath);
	if (err != noErr)
	{
		fprintf(stderr, "Could not set item exclusion status (system error %i - %s).\n", err, 
		GetMacOSStatusErrorString(err));
	}
	else
	{
		BOOL actualExcluded = CSBackupIsItemExcluded((CFURLRef)url, &actualByPath);
		if ((actualExcluded != exclude) || (exclude && (byPath != actualByPath)))
		{
			// We never get here, because CSBackupIsItemExcluded() lies. How useful.
			fprintf(stderr, "Could not set item exclusion status.\n");
		}
	}
}


static void PrintUsageAndQuit(void)
{
	printf("Usage: tmtool <status|include|exclude|excludep> <path>\n");
	exit(EXIT_FAILURE);
}
