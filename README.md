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

## Known Limitations

### Tracking a trackable that was added to the publisher earlier

Currently you can either `Add`, or `Add & Actively Track` a trackable on the `Add Trackable` screen, which respectfully fires the  `add` and `track` methods on the Publisher object. However, if you `Add` a trackable on this screen, and then try to select it on the `Select Trackable` screen (which fires the `track` method), you'll get an error in the `track` method's completion block, and the selected trackable won't be  actively tracked. This problem is caused by the sdk issue: https://github.com/ably/ably-asset-tracking-swift/issues/308
