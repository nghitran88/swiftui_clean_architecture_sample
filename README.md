iOS SwiftUI `Photos` App
============================================

This is an iOS sample app that applies Clean Architecture and MVVM-C

## Requirement:
1. `Photos List` page:
	1. Fetch photos' info from the end-point: https://jsonplaceholder.typicode.com/photos. 
    2. The images are downloaded from https://dummyimage.com by replacing it with https://via.placeholder.com. Example: https://via.placeholder.com/600/92c952 -> https://dummyimage.com/600/92c952 ;
	3. Implement the functionality: 
	    1. Search;
	    2. Switch between all list and the favorites list;
        3. Handle infinity loading with 20 items per pages;
2. `Photo Detail` page: 
    1. Add to favorites;
    2. Remove from favorites;
3. Sample unit tests for the photo list view model;
4. Sample automation test for the photo list screen;

## Install
Open the `PhotoListSample.xcodeproj` in the root directory with Xcode.
