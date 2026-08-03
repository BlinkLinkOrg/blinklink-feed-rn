import BlinklinkFeed
import React
import UIKit

// MARK: - SuperFeed

class BlinklinkSuperFeedHostView: BLVCContainerView {
    override func makeViewController() -> UIViewController? {
        BLSuperFeedViewController()
    }
}

@objc(BlinklinkSuperFeedManager)
class BlinklinkSuperFeedManager: RCTViewManager {
    override static func requiresMainQueueSetup() -> Bool { true }
    override func view() -> UIView! { BlinklinkSuperFeedHostView() }
}

// MARK: - Referrer feed (a plain UIView — no VC containment needed)

class BlinklinkFeedHostView: UIView {
    @objc var layout: NSString = "carousel"
    @objc var title: NSString?
    // Reserved for 1.0 (stream/placement are global in configure today).
    @objc var stream: NSString?
    @objc var placement: NSString?

    private var feedView: BLReferrerFeedView?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, feedView == nil else { return }
        let feedLayout: BLFeedLayout
        switch layout as String {
        case "carousel3D": feedLayout = .carousel3D
        case "grid": feedLayout = .grid
        default: feedLayout = .carousel
        }
        let view = BLReferrerFeedView(layout: feedLayout, title: title as String?)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        feedView = view
    }
}

@objc(BlinklinkFeedViewManager)
class BlinklinkFeedViewManager: RCTViewManager {
    override static func requiresMainQueueSetup() -> Bool { true }
    override func view() -> UIView! { BlinklinkFeedHostView() }
}
