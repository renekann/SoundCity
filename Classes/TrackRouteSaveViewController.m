//
//  TrackRouteSaveViewController.m
//  SoundCity
//
//  Created by René Kann on 29.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "TrackRouteSaveViewController.h"


@implementation TrackRouteSaveViewController

@synthesize route;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(section == 0)
		return 2;
	
	if(section == 1)
		return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case(0):
			return @"Daten";
			break;
		case(1):
			return @"Bild aufnehmen";
			break;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	

	
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0) {
			
			UITextField *textfieldTitle = [ [ UITextField alloc ] initWithFrame: CGRectMake(15, 7, 290, 20) ];
			textfieldTitle.adjustsFontSizeToFitWidth = YES;
			textfieldTitle.textColor = [UIColor blackColor];
			textfieldTitle.font = [UIFont systemFontOfSize:14.0];
			textfieldTitle.placeholder = @"Titel der Route";
			textfieldTitle.backgroundColor = [UIColor whiteColor];
			textfieldTitle.autocorrectionType = UITextAutocorrectionTypeDefault; // no auto correction support
			textfieldTitle.autocapitalizationType = UITextAutocapitalizationTypeSentences; // no auto capitalization support
			textfieldTitle.textAlignment = UITextAlignmentLeft;
			textfieldTitle.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
			textfieldTitle.returnKeyType = UIReturnKeyDone;
			textfieldTitle.tag = 0;
			textfieldTitle.delegate = self;
			
			textfieldTitle.text = @"";
			[ textfieldTitle setEnabled: YES ];
			[ cell addSubview: textfieldTitle ];
			cell.text = @"";
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			[textfieldTitle release];
		}
		
		if(indexPath.row == 1) {
			
			UITextField *textfieldDesc = [ [ UITextField alloc ] initWithFrame: CGRectMake(15, 7, 290, 80) ];
			textfieldDesc.adjustsFontSizeToFitWidth = YES;
			textfieldDesc.textColor = [UIColor blackColor];
			textfieldDesc.font = [UIFont systemFontOfSize:14.0];
			textfieldDesc.placeholder = @"Beschreibung der Route";
			textfieldDesc.backgroundColor = [UIColor whiteColor];
			textfieldDesc.autocorrectionType = UITextAutocorrectionTypeDefault; // no auto correction support
			textfieldDesc.autocapitalizationType = UITextAutocapitalizationTypeSentences; // no auto capitalization support
			textfieldDesc.textAlignment = UITextAlignmentLeft;
			textfieldDesc.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
			textfieldDesc.returnKeyType = UIReturnKeyDone;
			textfieldDesc.tag = 0;
			textfieldDesc.delegate = self;
			
			textfieldDesc.text = @"";
			[ textfieldDesc setEnabled: YES ];
			[ cell addSubview: textfieldDesc ];
			cell.text = @"";
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			[textfieldDesc release];
		}
		
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case(0):
			
			switch(indexPath.row) {
				case(0):
					return 35;
					break;
				case (1):
					return 100;
					break;
			}
			
			break;
		case(1):
			return 80;
			break;
	}
	
	return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
