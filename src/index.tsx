import {
  NativeEventEmitter,
  NativeModules,
  Platform,
  requireNativeComponent,
  type EmitterSubscription,
  type ViewProps,
} from 'react-native';

const NativeModule = NativeModules.BlinklinkFeedModule;

const emitter =
  Platform.OS === 'ios' && NativeModule
    ? new NativeEventEmitter(NativeModule)
    : null;

export type BlinklinkEnvironment = 'development' | 'production';

export type BlinklinkActionType =
  | 'openURL'
  | 'navigate'
  | 'openSheet'
  | 'fireEvent';

/** A declarative action fired by a server-driven component. */
export type BlinklinkAction =
  | { type: 'openURL'; url: string }
  | { type: 'navigate'; screenId: string; params: Record<string, string> }
  | { type: 'openSheet'; kind: string; contentId: string }
  | { type: 'fireEvent'; name: string; attributes: Record<string, string> };

export interface ConfigureOptions {
  /** Your Client ID from the Blinklink portal. */
  clientId: string;
  /**
   * Backend environment. ⚠️ Defaults to 'production' — during evaluation
   * use 'development' and the clientId provided by Blinklink.
   */
  environment?: BlinklinkEnvironment;
  /** Stream identifier provisioned for your account. */
  stream?: string;
  /** Placement identifier provisioned for your account. */
  placement?: string;
  /**
   * Action types the SDK should NOT handle itself. Every action is emitted
   * to `Blinklink.onAction` listeners; types listed here are additionally
   * marked handled-by-host, suppressing the SDK default (e.g. the in-app
   * browser for 'openURL').
   */
  interceptActions?: BlinklinkActionType[];
}

export const Blinklink = {
  /** Configure the SDK once at app startup. */
  configure(options: ConfigureOptions): void {
    if (Platform.OS === 'ios') {
      NativeModule?.configure(options);
    }
  },

  /**
   * Associate your own user reference with this device so likes and
   * personalization follow the account across devices.
   */
  setUser(ref: string): void {
    if (Platform.OS === 'ios') {
      NativeModule?.setUser(ref);
    }
  },

  /** Clear the user association (logout). */
  clearUser(): void {
    if (Platform.OS === 'ios') {
      NativeModule?.clearUser();
    }
  },

  /**
   * Route a Blinklink share link (universal link) to the video player.
   * Resolves true when the link was a Blinklink share link. Call
   * `configure` before forwarding links (a cold-start link that arrives
   * earlier resolves false).
   */
  handleUniversalLink(url: string): Promise<boolean> {
    if (Platform.OS === 'ios') {
      return NativeModule?.handleUniversalLink(url) ?? Promise.resolve(false);
    }
    return Promise.resolve(false);
  },

  /** Subscribe to component actions (CTAs, navigation, analytics events). */
  onAction(listener: (action: BlinklinkAction) => void): EmitterSubscription {
    return (
      emitter?.addListener('blinklinkAction', listener) ??
      ({ remove() {} } as EmitterSubscription)
    );
  },
};

export type FeedLayout = 'carousel' | 'carousel3D' | 'grid';

export interface BlinklinkScreenProps extends ViewProps {
  /** Server-driven screen id, e.g. "inspire" or "videos". */
  id?: string;
}

export interface BlinklinkFeedViewProps extends ViewProps {
  /** Embed style; the marketer "Type" setting overrides it when configured. */
  layout?: FeedLayout;
  /** Feed title rendered above the videos (the "Today" header). */
  title?: string;
  /** Reserved for 1.0 — per-view stream (currently set globally in configure). */
  stream?: string;
  /** Reserved for 1.0 — per-view placement (currently set globally in configure). */
  placement?: string;
}

const NativeScreen = requireNativeComponent<ViewProps & { screenId?: string }>(
  'BlinklinkScreen'
);
const NativeFeedView =
  requireNativeComponent<BlinklinkFeedViewProps>('BlinklinkFeedView');
const NativeSuperFeed = requireNativeComponent<ViewProps>('BlinklinkSuperFeed');

/**
 * A server-driven Blinklink screen (e.g. the full Frontline Feed
 * experience). Give it flex: 1 or an explicit size.
 */
export function BlinklinkScreen({ id = 'inspire', ...rest }: BlinklinkScreenProps) {
  return <NativeScreen screenId={id} {...rest} />;
}

/**
 * An embeddable referrer feed (carousel / 3D carousel / grid). Give it an
 * explicit height (e.g. style={{ height: 320 }}).
 */
export function BlinklinkFeedView(props: BlinklinkFeedViewProps) {
  return <NativeFeedView {...props} />;
}

/** A directly scrollable player surface for a whole tab. Give it flex: 1. */
export function BlinklinkSuperFeed(props: ViewProps) {
  return <NativeSuperFeed {...props} />;
}
