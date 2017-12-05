[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5a23c8a77463140001ebc7c0&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5a23c8a77463140001ebc7c0/build/latest?branch=master)
# GoogleVisionSwiftClient

## Usage

``` swift
 let googleAPIKey = "### YOUR GOOGLE API KEY ###"
 let client = Client(googleAPIKey: googleAPIKey)
 client.detectWords(fromImage: imageWithTextInside) { result in
            switch result {
            case let .success(detectedWords):
                print(detectedWords)
            case let .error(error):
                print(error)
            }
 }
```

## Installation
### Carthage
```
github "ambas/GoogleVisionSwiftClient"
```
