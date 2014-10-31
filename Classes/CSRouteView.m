//
//  CSRouteView.m
//  testMapp
//
//  Created by Craig on 8/18/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import "CSRouteView.h"
#import "CSRouteAnnotation.h"
#include <math.h>
#import "RouteArrow.h"


// this is an internally used view to CSRouteView. The CSRouteView needs a subview that does not get clipped to always
// be positioned at the full frame size and origin of the map. This way the view can be smaller than the route, but it
// always draws in the internal subview, which is the size of the map view. 
@interface CSRouteViewInternal : UIView
{
	// route view which added this as a subview. 
	CSRouteView* _routeView;
	BOOL drawArrows;
}
@property (nonatomic, retain) CSRouteView* routeView;
@property (nonatomic, readwrite) BOOL drawArrows;

- (NSString*)directionfOfLine:(CGPoint)fromPoint p2:(CGPoint)toPoint;
- (void)drawArrow:(CGContextRef)ctx routeArrow:(RouteArrow*)mPoint;
- (float)radians:(int)grade;
@end

@implementation CSRouteViewInternal
@synthesize routeView = _routeView, drawArrows;

-(void) drawRect:(CGRect) rect
{
	CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*)self.routeView.annotation;
	
	// only draw our lines if we're not int he moddie of a transition and we 
	// acutally have some points to draw. 
	if(!self.hidden && nil != routeAnnotation.points && routeAnnotation.points.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		
		NSMutableArray *middlePoints = [[NSMutableArray alloc] init]; 
		
		if(nil == routeAnnotation.lineColor)
			routeAnnotation.lineColor = [UIColor blueColor]; // setting the property instead of the member variable will automatically reatin it.
		
		CGContextSetStrokeColorWithColor(context, routeAnnotation.lineColor.CGColor);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 2.0);
		
		for(int idx = 0; idx < routeAnnotation.points.count; idx++)
		{
			CLLocation* location = [routeAnnotation.points objectAtIndex:idx];
			CGPoint point = [self.routeView.mapView convertCoordinate:location.coordinate toPointToView:self];
			
			
			if(idx == 0)
			{
				// move to the first point
				CGContextMoveToPoint(context, point.x, point.y);
			}
			else
			{
				if(idx%2 == 0 && self.drawArrows == YES) {
					CLLocation* location2 = [routeAnnotation.points objectAtIndex:idx-1];
					CGPoint prevPoint = [self.routeView.mapView convertCoordinate:location2.coordinate toPointToView:self];
						
					float mitteX = prevPoint.x - ((prevPoint.x - point.x)/2);
					float mitteY = prevPoint.y - ((prevPoint.y - point.y)/2);
						
					NSString *lineDirection = [self directionfOfLine:prevPoint p2:point];
					CGPoint middlePoint = CGPointMake(mitteX, mitteY);
					
					RouteArrow *ra = [[RouteArrow alloc] init];
					[ra setDirection:lineDirection];
					[ra setMiddlePoint:middlePoint];
					[ra calculateAngle:prevPoint toPoint:point];
						
					[middlePoints addObject:ra];
					
					CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
				}
				CGContextAddLineToPoint(context, point.x, point.y);
			}
		}
		
		
		CGContextStrokePath(context);
		
		if(self.drawArrows == YES) {
			for(int mp = 0; mp < middlePoints.count; mp++)
			{
				RouteArrow *ra = [middlePoints objectAtIndex:mp];
				[self drawArrow:context routeArrow:ra];
			}
		}
		
		// debug. Draw the line around our view. 
		/*
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, 0, self.frame.size.height);
		CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
		CGContextAddLineToPoint(context, self.frame.size.width, 0);
		CGContextAddLineToPoint(context, 0, 0);
		CGContextStrokePath(context);
		 */
	}
}

-(void)drawArrow:(CGContextRef)ctx routeArrow:(RouteArrow*)ra {
	
	CGPoint p = ra.middlePoint;
	
	CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, p.x, p.y);
	CGContextRotateCTM(ctx,ra.angle);
	
	UIImage *image = [UIImage imageNamed:@"routeArrow.png"];
	CGContextDrawImage(ctx, CGRectMake(-(image.size.width/2), -(image.size.height/2), image.size.width, image.size.height), image.CGImage);
	CGContextRestoreGState(ctx);
}

-(float)radians:(int)grade {
	return (grade * M_PI) / 180;
}

- (NSString*)directionfOfLine:(CGPoint)fromPoint p2:(CGPoint)toPoint {
	
	NSString *lineDirection = @"";
	
	// Linie verläuft von links oben nach rechts unten, also x und y ändern sich
	if(fromPoint.x < toPoint.x && fromPoint.y < toPoint.y) {
		lineDirection = @"TOP_LEFT_TO_BOTTOM_RIGHT";
	}
	
	// Linie verläuft von rechts unten nach links oben, also x und y ändern sich
	if(fromPoint.x > toPoint.x && fromPoint.y > toPoint.y) {
		lineDirection = @"BOTTOM_RIGHT_TO_TOP_LEFT";
	}
	
	// Linie verläuft von links unten nach rechts oben
	if(fromPoint.x < toPoint.x && fromPoint.y > toPoint.y) {
		lineDirection = @"BOTTOM_LEFT_TO_TOP_RIGHT";
	}
	
	// Linie verläuft von rechts oben nach links unten
	if(fromPoint.x > toPoint.x && fromPoint.y < toPoint.y) {
		lineDirection = @"TOP_RIGHT_TO_BOTTOM_LEFT";
	}
	
	// Linie verläuft von oben nach unten (x konstant, y ändert sich)
	if(fromPoint.x == toPoint.x && fromPoint.y > toPoint.y) {
		lineDirection = @"TOP_TO_BOTTOM";
	}
	
	// Linie verläuft von unten nach oben (x konstant, y ändert sich)
	if(fromPoint.x == toPoint.x && fromPoint.y < toPoint.y) {
		lineDirection = @"BOTTOM_TO_TOP";
	}
	
	// Linie verläuft von links nach rechts (x ändert sich, y konstant)
	if(fromPoint.x < toPoint.x && fromPoint.y == toPoint.y) {
		lineDirection = @"LEFT_TO_RIGHT";
	}
	
	// Linie verläuft von rechts nach links (x ändert sich, y konstant)
	if(fromPoint.x > toPoint.x && fromPoint.y == toPoint.y) {
		lineDirection = @"RIGHT_TO_LEFT";
	}	
	
	return lineDirection;
}


-(id) init
{
	self = [super init];
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = NO;
	
	return self;
}

-(void) dealloc
{
	self.routeView = nil;
	
	[super dealloc];
}
@end

@implementation CSRouteView
@synthesize mapView = _mapView;

- (id)initWithFrame:(CGRect)frame drawArrows:(BOOL)drawArrows {
    if (self = [super initWithFrame:frame]) {
        
		self.backgroundColor = [UIColor clearColor];
		

		// do not clip the bounds. We need the CSRouteViewInternal to be able to render the route, regardless of where the
		// actual annotation view is displayed. 
		self.clipsToBounds = NO;
		
		// create the internal route view that does the rendering of the route. 
		_internalRouteView = [[[CSRouteViewInternal alloc] init] autorelease];
		_internalRouteView.routeView = self;
		_internalRouteView.drawArrows = drawArrows;
		_internalRouteView.frame = CGRectMake(0, 0, 320, 480);
		[_internalRouteView setNeedsDisplay];
		
		[self addSubview:_internalRouteView];
    }
    return self;
}

-(void) setMapView:(MKMapView*) mapView
{
	[_mapView release];
	_mapView = [mapView retain];
	
	[self regionChanged];
}
-(void) regionChanged
{
	// move the internal route view. 
	CGPoint origin = CGPointMake(0, 0);
	origin = [_mapView convertPoint:origin toView:self];
	
	_internalRouteView.frame = CGRectMake(origin.x, origin.y, _mapView.frame.size.width, _mapView.frame.size.height);
	[_internalRouteView setNeedsDisplay];
	
	// Check if path below other annotations and move it below if not
	UIView *parent = self.superview;
	
	if (parent && [parent.subviews indexOfObject:self] != 0) {
		[self removeFromSuperview];
		[parent insertSubview:self atIndex:0];
	}
	
}

- (void)dealloc 
{
	[_mapView release];
	[_internalRouteView release];
	
    [super dealloc];
}


@end
