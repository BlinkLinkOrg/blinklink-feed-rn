import UIKit

/// Hosts a UIViewController inside a plain UIView with proper child-VC
/// containment, so appearance callbacks (viewWillAppear etc.) fire — the
/// Blinklink player relies on them. The VC is created lazily on first
/// attach to a window (React sets props after the view is created, and the
/// responder chain has no parent VC until attach).
class BLVCContainerView: UIView {
    private var hosted: UIViewController?

    /// Subclasses return the VC to host; called once, at first attach.
    func makeViewController() -> UIViewController? { nil }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else {
            teardown()
            return
        }
        guard hosted == nil, let parent = findParentViewController(),
              let vc = makeViewController() else { return }
        parent.addChild(vc)
        addSubview(vc.view)
        vc.view.frame = bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: parent)
        hosted = vc
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hosted?.view.frame = bounds
    }

    private func teardown() {
        guard let vc = hosted else { return }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        hosted = nil
    }

    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = next
        while let current = responder {
            if let vc = current as? UIViewController { return vc }
            responder = current.next
        }
        return nil
    }
}
