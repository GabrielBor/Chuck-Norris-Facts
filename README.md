# Chuck-Norris-Facts

This project shows the facts of the career of actor Carlos Ray Norris known as Chuck Norris.

# Installation

Use xcode 11.2.1 to open the project, it is using carthage as a dependency manager, if necessary before open project use the command in terminal ```carthage update --platform iOS```. This project use:

* Xcode 11.2.1
* Swift 5.0
* iOS 12.0 or later

# Architecture

Use MVVM + Coordinator

# Framework used

* [RxSwift - 5.0](https://github.com/ReactiveX/RxSwift)
* RxCocoa
* RxRelay

# Network layer

I'm using URLSession to do all the requisition of the app together with URLComponents to create my urls. At the network layer you will find:

* URLSessionProtocol
* URLSessionDataTaskProtocol
* ChuckNorrisAPI
* ChuckNorrisGenericError with segments of ChuckNorrisError, NetworkError and ChuckNorrisParseError
* ChuckNorrisFetch
* ChuckNorrisParse
* ChuckNorrisRequets
* ChuckNorrisServices

# Preview app

<img src=images/launch.png alt="" width="190" height="340"> <img src=images/homeFactsEmpty.png alt="" width="190" height="340"> <img src=images/homeFacts.png alt="" width="190" height="340"> <img src=images/searchFacts.png alt="" width="190" height="340"> <img src=images/shareFacts.png alt="" width="190" height="340">

# ViewModel code coverage with Unit test

* HomeFactsViewModel - 100%
* HomeFactsViewModel - 100%

# Continuos Integration with Github Actions

I'm using Github Actions to run the app and unit tests. It works from commits in the develop branch and pull requests to the master.

# Author

* **Gabriel Borges** - *iOS developer* - [Linkedin](https://www.linkedin.com/in/gabriel-borges-034420100/)
* **Phone number:** (34) 99947 - 3324
