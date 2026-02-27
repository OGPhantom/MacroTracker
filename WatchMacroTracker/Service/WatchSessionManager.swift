//
//  WatchSessionManager.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 26.02.2026.
//


import WatchConnectivity

final class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    // MARK: - Shared Instance & Initialization
    // Single shared manager used across the app
    static let shared = WatchSessionManager()

    // Sets up and activates WatchConnectivity session
    private override init() {
        super.init()

        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // MARK: - Send Data to iPhone
    // Sends data immediately if reachable,
    // otherwise queues it for background delivery
    func send(_ data: [String: Any]) {
        let session = WCSession.default

        if session.isReachable {
            session.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }

        let transfer = session.transferUserInfo(data)
    }

    // MARK: - Session Activation Callback
    // Called when the WatchConnectivity session finishes activating
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
    }

    // MARK: - Background Transfer Completion
    // Called when a queued transferUserInfo delivery completes
    func session(_ session: WCSession,
                 didFinish userInfoTransfer: WCSessionUserInfoTransfer,
                 error: Error?) {
    }

    // MARK: - Reachability Updates
    // Called when connection status between Watch and iPhone changes
    func sessionReachabilityDidChange(_ session: WCSession) {
    }
}
