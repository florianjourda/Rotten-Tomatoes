# Rotten Tomatoes

This is an iOS application to show Rotten Tomatoes movies.

Time spent: 8 hours spent in total

Completed user stories:


* [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
* [x] Required: User can view movie details by tapping on a cell.
	Hint: The Rotten Tomatoes API stopped returning high resolution images. To get around that, use the URL to the thumbnail poster, but replace 'tmb' with 'ori'.
* [X] Required: User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at http://cocoapods.wantedly.com?q=hud.
* [X] Required: User sees error message when there's a networking error. You may not use UIAlertView or a 3rd party library to display the error. See this screenshot for what the error message should look like: network error screenshot.
* [X] Required: User can pull to refresh the movie list. Guide: Using UIRefreshControl
* [X] Optional: Add a tab bar for Box Office and DVD.
* [X] Optional: Implement segmented control to switch between list view and grid view
	Hint: The segmented control should hide/show a UITableView and a UICollectionView
	NOTE: I reused the same searchBar to go above both the UITableView and a UICollectionView. There are still some glitches. It was pretty hard to get to work. 
* [X] Optional: Add a search bar.
	Hint: Consider using a UISearchBar for this feature. Don't use the UISearchDisplayController.
* [X] Optional: All images fade in
	Hint: Use the - (void)setImageWithURLRequest:(NSURLRequest *)urlRequest method in AFNetworking. Create an additional category method that has a success block that fades in the image. The image should only fade in if it's coming from network, not cache.
	NOTE: I added a ImageLoaderHelper for this (used for the tableViewCell and also the detail page
* [X] Optional: For the large poster, load the low-res image first, switch to high-res when complete
	NOTE: Made high-res image appear on the low-res image with a smooth cross-dissolve effect
* [X] Optional: Customize the highlight and selection effect of the cell.
	NOTE: I just changed setSelectedBackgroundView on the cell
* [x] Optional: Customize the navigation bar.
	The code for this is in [self customizeNavigationBar] but I have actually decided to hide the bar completely and use swipe-right to come back to the main screen.

* [X] Extra: Tap on the movie detail screen hides the text so that the poster is shown completely
* [X] Extra: The poster image is on a parallax following the scrolling of the movie synopsis

Walkthrough of all user stories:

![Video Walkthrough](rotten-tomatoes.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
