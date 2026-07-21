package com.blinklink.feedreactnative

import android.graphics.Color
import android.view.Gravity
import android.widget.FrameLayout
import android.widget.TextView
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext

/** Renders a branded placeholder on Android (iOS-only renderer in 0.x). */
class PlaceholderViewManager(private val componentName: String) :
    SimpleViewManager<FrameLayout>() {

    override fun getName() = componentName

    override fun createViewInstance(reactContext: ThemedReactContext): FrameLayout =
        FrameLayout(reactContext).apply {
            setBackgroundColor(Color.parseColor("#101014"))
            addView(
                TextView(reactContext).apply {
                    text = "Blinklink\nAndroid renderer coming soon"
                    setTextColor(Color.parseColor("#B8B8C0"))
                    textSize = 14f
                    gravity = Gravity.CENTER
                },
                FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT,
                ),
            )
        }
}
