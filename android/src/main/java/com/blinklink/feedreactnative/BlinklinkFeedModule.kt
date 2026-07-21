package com.blinklink.feedreactnative

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap

/**
 * Android is a no-op in 0.x — the native Android renderer is in progress;
 * the placeholder views confirm the wiring. iOS renders the full experience.
 */
class BlinklinkFeedModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "BlinklinkFeedModule"

    @ReactMethod
    fun configure(options: ReadableMap) = Unit

    @ReactMethod
    fun setUser(ref: String) = Unit

    @ReactMethod
    fun clearUser() = Unit

    @ReactMethod
    fun handleUniversalLink(url: String, promise: Promise) {
        promise.resolve(false)
    }

    // Required stubs for NativeEventEmitter parity.
    @ReactMethod
    fun addListener(eventName: String) = Unit

    @ReactMethod
    fun removeListeners(count: Int) = Unit
}
