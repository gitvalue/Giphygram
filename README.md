# Giphygram
A tiny application that performs Giphy GIF images search

# Features

- Dark and light theme support (based on system setting)
- Smooth infinite scrolling of search results
- Memory efficient
- Zero external dependencies
- Swift 5
- Combine
- MVVM
- UIKit
- XCTest

### Installing

Just clone this repo and open `Giphygram/Giphygram.xcodeproj`, then run the application.

```bash
git clone git@github.com:gitvalue/Giphygram.git
xed Giphygram/Giphygram.xcodeproj
```

## Architecture
Project is built using MVVM archtectural pattern. I believe it's the best option for building an iOS application which roadmap is not transparent. 

Main task of any architecture is to control complexity, i.e. amount of effort should be adequate comparing to the requested changes. And any iOS application in a nutshell is just a set of screens hence the nature of this screens dictates the architecture. In our case, we have just two screens:
1. Dashboard
2. Details screen

Details screen is passive, meaning it doesn't request any data by itself, just waits until something will _push data_ into it.

Dashboard screen, on the other hand, especially search results list is dynamic, meaning it _pulls data_ it needs to display.

Most popular alternatives, like MVP and VIPER are designed to _push_ data into view, MVVM — to let view _pull_ data from its viewModel. 

And that, I believe, makes MVVM best option in our case, because lists are more than common in iOS application and most certainly are going to come up once application will start to grow. And if we take a look at the way lists can be built it iOS application:
1. UIKit (Regular `UITable/UICollectionView`) - pull data model
2. UIKit (Modern `UICollectionView`) — push data model
3. SwiftUI - pull data model

We'll see that MVVM is perfect for 2 out of 3 options (1 and 3), and just fine for the option 2, while MVP and VIPER really work well only with option 2.

## Versioning

This repo do not use any versioning system because I have no plans of maintaining the application in the future

## Troubleshooting

For any questions please fell free to contact [Dmitry Volosach](dmitry.volosach@gmail.com).

## Further steps

- Use animated GIFs in search result list instead of previews
- Make maximum concurrent operations count of images loading queue a computable parameter
- Make page size a computable parameter
- Make image pool size a computable parameter or optimal

## Authors

* **Dmitry Volosach** - *Initial work* - dmitry.volosach@gmail.com


