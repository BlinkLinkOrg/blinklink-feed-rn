import BlinklinkFeed
import Foundation
import React

@objc(BlinklinkFeedModule)
class BlinklinkFeedModule: RCTEventEmitter {
    static var interceptedTypes = Set<String>()
    static weak var sharedEmitter: BlinklinkFeedModule?
    private var hasListeners = false

    override init() {
        super.init()
        Self.sharedEmitter = self
    }

    override static func requiresMainQueueSetup() -> Bool { true }

    override func supportedEvents() -> [String] { ["blinklinkAction"] }

    override func startObserving() { hasListeners = true }
    override func stopObserving() { hasListeners = false }

    private func emit(_ payload: [String: Any]) {
        guard hasListeners else { return }
        sendEvent(withName: "blinklinkAction", body: payload)
    }

    @objc func configure(_ options: NSDictionary) {
        let clientId = options["clientId"] as? String ?? ""
        let environment: BLEnvironment =
            (options["environment"] as? String) == "development" ? .development : .production
        Self.interceptedTypes = Set(options["interceptActions"] as? [String] ?? [])

        DispatchQueue.main.async {
            Blinklink.configure(
                clientId: clientId,
                environment: environment,
                stream: options["stream"] as? String ?? "videos",
                placement: options["placement"] as? String ?? "videos-tab"
            ) { action in
                let payload = Self.serialize(action)
                DispatchQueue.main.async { Self.sharedEmitter?.emit(payload) }
                let type = payload["type"] as? String ?? ""
                return Self.interceptedTypes.contains(type) ? .handled : .useDefault
            }
        }
    }

    @objc func setUser(_ ref: String) {
        Blinklink.setUser(ref: ref)
    }

    @objc func clearUser() {
        Blinklink.clearUser()
    }

    @objc func handleUniversalLink(
        _ urlString: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter _: @escaping RCTPromiseRejectBlock
    ) {
        guard let url = URL(string: urlString) else {
            resolve(false)
            return
        }
        DispatchQueue.main.async {
            resolve(Blinklink.handleUniversalLink(url))
        }
    }

    static func serialize(_ action: BLAction) -> [String: Any] {
        switch action {
        case .openURL(let url):
            return ["type": "openURL", "url": url.absoluteString]
        case .navigate(let screenID, let params):
            return ["type": "navigate", "screenId": screenID, "params": params]
        case .openSheet(let kind, let contentID):
            return ["type": "openSheet", "kind": kind, "contentId": contentID]
        case .fireEvent(let name, let attributes):
            return ["type": "fireEvent", "name": name, "attributes": attributes]
        }
    }
}
