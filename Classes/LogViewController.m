//
//  LogViewController.m
//  SoundCity
//
//  Created by René Kann on 17.11.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "LogViewController.h"

@implementation LogViewController

@synthesize logWindowTextField, btnLogIt;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"Schon wieder");
	[self readFile];
}

-(IBAction)logIt:(id)sender {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console2.log"];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self setControlls];
	
    [super viewDidLoad];
}

- (NSString *)getDocumentsDirectory { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
} 

- (void)readFile {
	
	logWindowTextField.text= @"";
	NSString *pathToDir = [self getDocumentsDirectory];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"console" ofType:@"log" inDirectory:pathToDir]; 
	
	NSLog(@"FilePath %@", filePath);
	logWindowTextField.text= filePath;
	
	if (filePath) {  
		NSString *myText = [NSString stringWithContentsOfFile:filePath];  
		if (myText) {  
			logWindowTextField.text= myText;  
		}  
	} 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)setControlls {
	[logWindowTextField setFont:[UIFont fontWithName:@"Helvetica" size:10.0f ]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
