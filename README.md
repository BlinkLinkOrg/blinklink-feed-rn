# @blinklink/feed-rn

Blinklink server-driven short-form video feeds for React Native — a thin
passthrough over the native
[Blinklink iOS SDK](https://github.com/BlinkLinkOrg/blinklink-feed-ios).
Layouts, content, and experiments update from the Blinklink marketer app
with **no app release**.

> **Platform status (0.x)**: iOS renders the full experience. Android
> renders a placeholder — the native Android renderer arrives in an
> upcoming release with no integration changes.

## Requirements

- React Native 0.74+ recommended (works on the old and new architecture via
  the interop layer; on 0.73 with the new architecture enabled, add the
  component names to `unstable_reactLegacyComponentNames`).
- iOS 15+ — set `platform :ios, '15.0'` in your `ios/Podfile`.

## Installation

```bash
npm install @blinklink/feed-rn
cd ios && pod install
```

## Quickstart

```tsx
import {
  Blinklink,
  BlinklinkFeedView,
  BlinklinkSuperFeed,
} from '@blinklink/feed-rn';

// Once, at startup. ⚠️ environment defaults to 'production' —
// during evaluation use 'development' and the clientId provided by Blinklink.
Blinklink.configure({
  clientId: 'YOUR_CLIENT_ID',
  environment: 'development',
  stream: 'YOUR_STREAM',
  placement: 'YOUR_PLACEMENT',
});

// A carousel embed (give it a height; also available: layout="carousel3D"):
<BlinklinkFeedView layout="carousel" title="Today" style={{ height: 320 }} />

// A grid embed:
<BlinklinkFeedView layout="grid" style={{ flex: 1 }} />

// A directly scrollable player surface for a whole tab:
<BlinklinkSuperFeed style={{ flex: 1 }} />
```

## Actions (CTAs)

Every component action is emitted to your listener. By default the SDK also
performs its default behavior (e.g. CTAs open a fast in-app browser). List
action types in `interceptActions` to handle them yourself instead:

```tsx
Blinklink.configure({
  clientId: 'YOUR_CLIENT_ID',
  environment: 'development',
  interceptActions: ['openURL'],
});

const sub = Blinklink.onAction((action) => {
  if (action.type === 'openURL') {
    myRouter.open(action.url);
  }
});
// sub.remove() when done
```

## Signed-in viewers

```tsx
Blinklink.setUser('your-user-id'); // after sign-in
Blinklink.clearUser();             // on logout
```

## Share links (universal links)

After the native Associated Domains setup (see the
[iOS SDK README](https://github.com/BlinkLinkOrg/blinklink-feed-ios#share-links-universal-links)
— Blinklink must register your Team ID + bundle ID), forward links from JS.
Call `configure` before forwarding:

```tsx
import { Linking } from 'react-native';

Linking.getInitialURL().then((url) => url && Blinklink.handleUniversalLink(url));
Linking.addEventListener('url', ({ url }) => Blinklink.handleUniversalLink(url));
```

`handleUniversalLink` resolves `false` for links that aren't Blinklink share
links, so your own deep-link routing keeps working.

## Example app

See [`example/`](example/) — a bare React Native app wired to the Blinklink
development environment.

## License & support

Distributed under the Blinklink SDK License (source-available) — see
[LICENSE](LICENSE). Questions or a Client ID: **support@blinklink.com**.
