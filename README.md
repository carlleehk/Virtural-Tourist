# Virtural-Tourist

The Virtual Tourist is result of **iOS Persistence and Core Data** lesson of **Udacity's iOS Developer Nanodegree** course.

Virtual Tourist allows users to tour the world without leaving the comforts of their couch. This app allows you to drop pins on a map and pull up Flickr images associated with that location. Locations and images are stored using Core Data.



## Implementation

The app has two view controller scenes:

- **MapController** - shows the map and allows user to drop pins around the world. Users can drag pin to a new location after
  dropping them. As soon as a pin is dropped photo data for the pin location is fetched from Flickr. The actual photo
  downloads occur in the CollectionController.

- **PictureController** - allow users to download photos and edit an album for a location. Users can create new
  collections and delete photos from existing albums.

Application uses CoreData to store Pins (`NSManagedObjectContext.executeFetchRequest`) and Photos 
(`NSFetchedResultsController`) objects. All API calls run in background (`NSURLSession.dataTaskWithRequest`).
Preloaded files saved in memory cache (`NSCache`) and file system (`NSFileManager`) and removed as soon as Photo object 
removed from CoreData.



## Requirements

 - Xcode 8
 - Swift 3.0

## License

Copyright (c) 2017 Carl Lee

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
