//
//  CSImageAnnotationView.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DrawingView;

@interface CSImageAnnotationView : MKAnnotationView
{
	UIImageView* _imageView;
	DrawingView *internalDrawingView;
	NSObject* mkAnno; //could be POI, GPS...
}

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) NSObject* mkAnno;
@end
