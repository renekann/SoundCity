//
//  CSImageAnnotationView.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSImageAnnotationView.h"
#import "CSMapAnnotation.h"
#import "POI.h"

#define kHeight 20
#define kWidth  20
#define kBorder 2

// Interne Klasse DrawingView um auf den POI zu zeichnen

@interface DrawingView:UIView
{
	NSObject* mkAnno;
}
@property (nonatomic, retain) NSObject* mkAnno;
@end

@implementation DrawingView
@synthesize mkAnno;

- (void)drawRect:(CGRect) rect
{
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	// Zeichnen für POIs
	if([mkAnno isKindOfClass:[POI class]]){
		context = [((POI*)mkAnno) drawPOI:context];
		CGContextStrokePath(context);
	}
	
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
	[super dealloc];
}
@end

// Ende der internen Klasse POIInternalView

@implementation CSImageAnnotationView
@synthesize imageView = _imageView, mkAnno;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	self.frame = CGRectMake(0, 0, kWidth, kHeight);
	//self.backgroundColor = [UIColor whiteColor];
	
	CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
	
	UIImage* image = [UIImage imageNamed:csAnnotation.userData];
	_imageView = [[UIImageView alloc] initWithImage:image];
	
	_imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2 * kBorder, kWidth - 2 * kBorder);
	[self addSubview:_imageView];
	
	self.backgroundColor = [UIColor clearColor];
	
	// do not clip the bounds. We need the CSRouteViewInternal to be able to render the route, regardless of where the
	// actual annotation view is displayed. 
	self.clipsToBounds = NO;
	
	internalDrawingView = [[DrawingView alloc] init];
	internalDrawingView.mkAnno = annotation;
	
	[self addSubview:internalDrawingView];
	
	internalDrawingView.frame = CGRectMake(0,0,50,50);
	[internalDrawingView setNeedsDisplay];
	
	
	return self;
	
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
				
		
	}
	
	return self;
}

-(void) dealloc
{
	[internalDrawingView release];
	[_imageView release];
	[super dealloc];
}

	 
@end
