# Rotten Tomatoes

This is an iOS application to show Rotten Tomatoes movies.

Time spent: 3 hours spent in total

Completed user stories:


* [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
* [x] Required: User can view movie details by tapping on a cell.
	Hint: The Rotten Tomatoes API stopped returning high resolution images. To get around that, use the URL to the thumbnail poster, but replace 'tmb' with 'ori'.
* [] Required: User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at http://cocoapods.wantedly.com?q=hud.
* [] Required: User sees error message when there's a networking error. You may not use UIAlertView or a 3rd party library to display the error. See this screenshot for what the error message should look like: network error screenshot.
* [] Required: User can pull to refresh the movie list. Guide: Using UIRefreshControl
* [] Optional: Add a tab bar for Box Office and DVD. (optional)
* [] Optional: Implement segmented control to switch between list view and grid view (optional)
	Hint: The segmented control should hide/show a UITableView and a UICollectionView
* [] Optional: Add a search bar. (optional)
	Hint: Consider using a UISearchBar for this feature. Don't use the UISearchDisplayController.
* [] Optional: All images fade in (optional)
	Hint: Use the - (void)setImageWithURLRequest:(NSURLRequest *)urlRequest method in AFNetworking. Create an additional category method that has a success block that fades in the image. The image should only fade in if it's coming from network, not cache.
* [x] Optional: For the large poster, load the low-res image first, switch to high-res when complete (optional)
* [] Optional: Customize the highlight and selection effect of the cell. (optional)
* [x] Optional: Customize the navigation bar. (optional)




 * [x] Required: All required tasks
 * [x] Optional: Animate the main view between a state when the bill amount is empty and another state when it's not empty.
 * [x] Optional: Remember the bill amount across app restarts. After an extended period of time, clear the state.
 * [x] Optional: Use locale specific currency and currency thousands separators.
 * [x] Optional: Add a light/dark color theme to the settings view. In viewWillAppear, update views with the correct theme colors.

Notes:

*

Walkthrough of all user stories:

![Video Walkthrough](rotten-tomatoes.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
