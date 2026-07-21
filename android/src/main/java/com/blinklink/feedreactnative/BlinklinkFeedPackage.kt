package com.blinklink.feedreactnative

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class BlinklinkFeedPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> =
        listOf(BlinklinkFeedModule(reactContext))

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> =
        listOf(
            PlaceholderViewManager("BlinklinkScreen"),
            PlaceholderViewManager("BlinklinkFeedView"),
            PlaceholderViewManager("BlinklinkSuperFeed"),
        )
}
