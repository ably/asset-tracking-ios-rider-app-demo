# Ably Asset Tracking Demo: iOS Rider

_[Ably](https://ably.com) is the platform that powers synchronized digital experiences in realtime. Whether attending an event in a virtual venue, receiving realtime financial information, or monitoring live car performance data – consumers simply expect realtime digital experiences as standard. Ably provides a suite of APIs to build, extend, and deliver powerful digital experiences in realtime for more than 250 million devices across 80 countries each month. Organizations like Bloomberg, HubSpot, Verizon, and Hopin depend on Ably’s platform to offload the growing complexity of business-critical realtime data synchronization at global scale. For more information, see the [Ably documentation](https://ably.com/documentation)._

## Overview

This demo presents a mock delivery Rider app with functionality matching that expected for the typical use case for
[Ably's Asset Tracking solution](https://ably.com/solutions/asset-tracking),
being the publication of Location updates for a delivery being made to a customer,
where the Rider is using an iOS based device such as an iPhone or an iPad.
Such deliveries could be food, groceries or other packages ordered for home delivery.

This app is a member of our
[suite of **Ably Asset Tracking Demos**](https://github.com/ably/asset-tracking-demos),
developed by Ably's SDK Team to demonstrate best practice for adopting and deploying Asset Tracking.

## Status
The demo app is currently under active development and constantly improved. We're currently working on the first milestone of the [Milestoes list](https://github.com/ably/asset-tracking-demos/blob/main/app-requirements.md), but most of the basic functionality of the expected use cases can already be tested.

## Requirements
- App can be compiled using Xcode 13.4+
- App can be run on iPhone devices with iOS >= 14.0 in portrait mode.

## Usage Info

### Basic setup and running the app
- To run the app you'll first need to configure your Mapbox account and credentials. Please follow [this](https://docs.mapbox.com/ios/search/guides/install/#configure-credentials) guide.
- You'll need a `Secrets.plist` file containing Mapbox Access Token and the Ably Api Key. To do this you can rename the `SecretsExample.plist` file at the root of the project, and fill it out with your data.
- `ABLY_API_KEY`: Used by the app to authenticate with Ably using basic authentication. Will be replaced with the token auth method once the app reaches [Milestone 3](https://github.com/ably/asset-tracking-demos/blob/main/app-requirements.md#milestone-3-enhanced). You can get the Ably Api Key [here](https://ably.com/accounts).
- `MAPBOX_ACCESS_TOKEN`: Used to access Mapbox Navigation SDK/ APIs, and can be taken from [here](https://account.mapbox.com/).

### Screens description and functionalities
- `Ably Publisher Setup` - allows you to configure the resolution that the `publisher` object will be using. See more details in the [documentation](https://ably.com/docs/asset-tracking#resolution)
`Min. Displacement` and `Desired Interval` text fields must have a valid `Int` value. 
- `Status` screen shows various information about the currently tracked `trackable` object. As a debug feature you can also set the `Acceptance Distance`, that defines (as an `Int`) how close the rider's device has to be to the `Active destination` to allow tapping on the `Finish Tracking` button, that marks the order as delivered and removes the active trackable object (using the `remove` method on the publisher object).
- `Add Trackable` screen - allows you to add a new trackable, using a required trackable id text field. You can either just `Add` the new trackable (which uses the `add` method on the `publisher` object), or `Add & Actively Track` to set it as an `activeTrackable` (which uses the `track` method on the publisher object)
- `Select Trackable` screen - allows you to select one of the trackables that you've added earlier using the `Add Trackable` screen and set it as an `activeTrackable` (which uses the `track` method on the publisher object)
 
## Known Limitations

### Tracking a trackable that was added to the publisher earlier
- Currently you can either `Add`, or `Add & Actively Track` a trackable on the `Add Trackable` screen, which respectfully fires the  `add` and `track` methods on the Publisher object. However, if you `Add` a trackable on this screen, and then try to select it on the `Select Trackable` screen (which fires the `track` method), you'll get an error in the `track` method's completion block, and the selected trackable won't be  actively tracked. This problem is caused by the sdk issue: https://github.com/ably/ably-asset-tracking-swift/issues/308

## Resources
- [Asset Tracking Documentation](https://ably.com/docs/asset-tracking)
- [Ably Documentation](https://ably.com/docs)
