//
//  POIDetailsViewController.m
//  SoundCity
//
//  Created by René Kann on 12.10.09.
//  Copyright 2009 init ag. All rights reserved.
//

#import "POIDetailsViewController.h"
#import "POI.h";
#import "AudioStreamer.h"
#import "SoundController.h"
#import "VideoPlayer.h"

@implementation POIDetailsViewController

@synthesize poi, settings, sectionArray, contentArray, footerView, videoPlayer, buttonSound;

/**
Startet und prüft aktuellen Audiostream eines POIs und setzt den Titel es Buttons auf den aktuellen Status 
*/
-(void)playSound {
	
	if(appDelegate.hasInternetConnection == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Bitte aktivieren Sie Ihre Internetverbindung, um den Audiostream wiederzugeben" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	} else {
		if(poi.appDelegate.soundController.soundstate == @"PLAYING") {
			[self.poi stopSound];
			[buttonSound setTitle:@"Audio abspielen" forState:UIControlStateNormal];
			
			/*
			NSDictionary *d = [NSDictionary dictionaryWithObject:STOPPED forKey:@"audioStatus"];
			NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"setCurrentPOI" object:self userInfo:d];
			 */
			
		} else {
			[self.poi playSound];
			[buttonSound setTitle:@"Audio stoppen" forState:UIControlStateNormal];
			
			/*
			NSDictionary *d = [NSDictionary dictionaryWithObject:PLAYING forKey:@"audioStatus"];
			NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"setCurrentPOI" object:self userInfo:d];
			 */
		}
	}
}

/**
Übergibt URL des Videos an den VideoPlayer und startet das Video
*/
-(void)playVideo {
	
	if(appDelegate.hasInternetConnection == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Bitte aktivieren Sie Ihre Internetverbindung, um den Audiostream wiederzugeben" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	} else {
		[self.videoPlayer setVideoURL:poi.videoURL];
		[self.videoPlayer play];

	}
}

/**
 Gibt die Anzahl der Bereiche (Sections) zurück. In diesem Falle 2, für "Informationen zum POI" und "Beschreibung"
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @return int mit der Anzahl der Sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

/**
 Setzt die Überschriften der einzelnen Sektionen
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @param section Nummer der aktuellen Sektion
 @return String mit Titel der Sektion
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Informationen zum POI";
	}
	
	if(section == 1) {
		sectionHeader = @"Beschreibung";
	}
	
	return sectionHeader;
}

/**
 Hier können UIViews in den Fußbereich der Tabelle eingefügt werden. Prinzipiell können alle Elemente dort dargestellt werden.
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @param section Nummer der aktuellen Sektion, für die der Fußbereich gefüllt werden soll
 @return UIView Objekt, welches im Footer eingefügt werden soll
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	/*
	if(footerView == nil && poi.details != nil) {
		NSLog(@"Footer");
		footerView = [[UIView alloc] init];
		
		// Add the label
		UILabel*    footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, poi.detailsTextLength)];
		footerLabel.backgroundColor = [UIColor clearColor];
		footerLabel.opaque = NO;
		footerLabel.text = poi.details;
		footerLabel.textColor = [UIColor blackColor];
		footerLabel.font = [UIFont systemFontOfSize:11];
		footerLabel.numberOfLines = 0;
		footerLabel.lineBreakMode = UILineBreakModeWordWrap;
		[footerLabel sizeToFit];
		[footerView addSubview: footerLabel];
		
		[footerLabel release];  
	}
	*/
	/*
	UIFont *font = [[UIFont alloc] init];
	[font setFontName:@"Arial"];
	CGSize suggestedSize = [poi.details sizeWithFont:font constrainedToSize:CGSizeMake(250.0, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	
	//float height = [self calculateHeightOfTextFromWidth:poi.details :font :250 :UILineBreakModeWordWrap];
	NSLog(@"Höhe des Detailtextes %f", suggestedSize.height);
	 */
	return nil;
}

/**
 Läd das Bild für einen POI und fügt es in den Header der Tabelle ein
 */
- (void) loadImage{
	
	if(poi.imageURL != nil) {
		NSString *imageURL = poi.imageURL;
		NSLog(@"Image URL: %@", imageURL);
		
		UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:imageURL]]];
		if(image){
			CGRect frame = CGRectMake(0, 0, 200, 200);
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
			[imageView setImage:image];
			[imageView setClipsToBounds:YES];
			imageView.contentMode = UIViewContentModeCenter;
			
			self.tableView.tableHeaderView = imageView;
			
			[imageView release];
		}
	}
}

/**
 Gibt die Anzahl der Zeilen einer Section zurück
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @param section Nummer der aktuellen Sektion, für die der Fußbereich gefüllt werden soll
 @return int mit der Anzahl der Zeilen
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(section == 0) {
		return 4;
	}
	
	return 1;
}

/**
 Bietet Möglichkeiten, die Höhe jeder Tabellenzeile individuell festzulegen.
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @param section Nummer der aktuellen Sektion, für die der Fußbereich gefüllt werden soll
 @return Höhe einer Tabellenzeile in Pixel
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch(indexPath.section) {
		case 1:
			
			switch(indexPath.row) {
				case 0:
					if(poi.detailsTextLength > 0) { 
						return poi.detailsTextLength + 20;
					} else {
						return 40;	
					}
					break;
			}
			
			break;
	}
	
	return 40;
}

/**
 Hauptfunktion um die Zellen einer Tabelle mit Inhalt zu füllen. Für jede Zelle wird diese Funktion aufgerufen und individuell geprüft, wo welcher Inhalt dargestellt werden soll
 @param tableView Referenz auf die das aktuelle UITableView Objekt
 @param indexPath Matrix aus Zeilen und Spalten der aktuellen Tabelle
 @return UITableViewCell der aktuellen Zelle mit Inhalt
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *identity = @"MainCell";
	
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
	
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity] autorelease];
		
		if(indexPath.section == 0) {
			
			switch(indexPath.row) {
				case 0:
					[cell.textLabel setText:[[NSString alloc] initWithFormat: @"%hi", poi.pid]];
					break;
				case 1:
					[cell.textLabel setText:[[NSString alloc] initWithFormat: @"%@", poi.title]];
					break;
				case 2:
					[cell.textLabel setText:@""];
					
					buttonSound = [UIButton buttonWithType:UIButtonTypeRoundedRect];
					
					// Button soll so groß sein wie Tabellenzelle
					[buttonSound setFrame:CGRectMake(10, 6, 280, 25)];
					
					// Button formatieren
					[buttonSound setTitle:@"Audio abspielen" forState:UIControlStateNormal];
					[buttonSound.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
					[buttonSound setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
					[buttonSound addTarget:self action:@selector(playSound) forControlEvents:UIControlEventTouchUpInside];
					
					[cell.contentView addSubview: buttonSound];
					
					break;
				case 3:
					[cell.textLabel setText:@""];
					
					if(poi.videoURL != nil) {
						UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
						
						// Button soll so groß sein wie Tabellenzelle
						[button setFrame:CGRectMake(10, 6, 280, 25)];
						 
						// Button formatieren
						[button setTitle:@"Video abspielen" forState:UIControlStateNormal];
						[button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
						[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
						[button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
						
						[cell.contentView addSubview: button];
					} else {
						[cell.detailTextLabel setText:@"Kein Video vorhanden"];
					}
					
					break;
			}
		}
		
		if(indexPath.section == 1) {
			
			if(indexPath.row == 0) {
				
					UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, poi.detailsTextLength)];
					detailsLabel.backgroundColor = [UIColor clearColor];
					detailsLabel.opaque = NO;
					detailsLabel.textColor = [UIColor blackColor];
					detailsLabel.font = [UIFont systemFontOfSize:13];
					detailsLabel.numberOfLines = 0;
					detailsLabel.lineBreakMode = UILineBreakModeWordWrap;
					
					if(poi.details != nil) {
						detailsLabel.text = poi.details;
					} else {
						detailsLabel.text = @"Keine Beschreibung vorhanden";
					}
					
					[detailsLabel sizeToFit];
				
					[cell.contentView addSubview: detailsLabel];
					
					[detailsLabel release];
			}
		}
	}
	
	return cell;
}

/**
 Legt die Höhe des Fußbereichs jeder Sektion fest
 @param tableView Referenz auf das aktuelle UITableView Objekt
 @param section Aktuelle Sektion als int
 @return Höhe in Pixel als int
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	//return poi.detailsTextLength;
	
	return 50;
}

- (void) reloadTable {
	[self.tableView reloadData];
}

- (void)soundPlaybackChanged:(NSNotification *)aNotification {
	NSString *soundstate = [[aNotification userInfo] objectForKey:@"soundstate"];
	
	NSLog(@"POI Details View - Playback %@", soundstate);
	
	[buttonSound setTitle:soundstate forState:UIControlStateNormal];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	appDelegate = (SoundCityAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Singleton der AppSettings auf MapViewController laden
	settings = [AppSettings sharedAppSettings];
	
	videoPlayer = [[VideoPlayer alloc] init];
	
	[self loadImage];
	
	if(poi.details != nil) {
		CGSize aSize = [poi.details sizeWithFont:[UIFont systemFontOfSize:13]  
						constrainedToSize:CGSizeMake(280, FLT_MAX)  
						lineBreakMode:UILineBreakModeTailTruncation];
		
		[poi setDetailsTextLength:(int)aSize.height];
		NSLog(@"Text lämge %hi", poi.detailsTextLength);
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundPlaybackChanged:) name:@"soundStateChanged" object:appDelegate.soundController];
	
	[self.navigationController.toolbar setTranslucent:YES];
	[self.navigationController.navigationBar setTranslucent:YES];
	[self.navigationController.toolbar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
	[self.navigationController.navigationBar setAlpha:0.8f];
	[self.navigationController.toolbar setAlpha:0.8f];	
	
	[self.navigationController setToolbarHidden:YES animated:YES];
	[super viewDidLoad];
}


- (void)viewWillDisappear:(BOOL)animated {
	
	//NSLog(@"[POIDetailsViewController] - viewWillDisappear");
	
	// Beim Verlassen der Detailansicht wird der aktuelle Stream gestoppt, außer der User kommt aus der Kartenansicht
	if(appDelegate.tabBarController.selectedIndex != 1) {
		[self.poi stopSound];
	}
}

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
	[videoPlayer release];
	[poi release];
	[super dealloc];
}


@end
