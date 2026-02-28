//
//  iOSConnector.swift
//  MacroTracker
//
//  Created by Никита Сторчай on 26.02.2026.
//
import Foundation
import WatchConnectivity
import SwiftData

// MARK: - Watch to iOS Bridge

// Handles communication from Apple Watch
// and saves received macros into SwiftData
final class iOSConnector: NSObject, ObservableObject, WCSessionDelegate {

    // MARK: - Shared Instance

    static let shared = iOSConnector()

    // MARK: - SwiftData Container

    // Injected from App to allow saving data
    var modelContainer: ModelContainer? {
        didSet {
            flushPendingPayloadsIfPossible()
        }
    }

    private var pendingPayloads: [[String: Any]] = []

    // MARK: - Initialization

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Session Activation

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
    }

    // MARK: - Receive Background Data

    func session(_ session: WCSession,
                 didReceiveUserInfo userInfo: [String : Any]) {
        saveMacro(from: userInfo)
    }

    // MARK: - Receive Live Message

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        print("iOS: didReceiveMessage called")
        print("iOS: message =", message)
        saveMacro(from: message)
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

    // MARK: - Save Macro

    // Converts payload into Macro model and saves to SwiftData
    private func saveMacro(from payload: [String: Any]) {
        let food = payload["food"] as? String ?? "Not Found"
        let carbs = payload["carbs"] as? Int ?? 0
        let fats = payload["fats"] as? Int ?? 0
        let protein = payload["protein"] as? Int ?? 0

        let createdAt = dateValue(forKey: "createdAt", in: payload) ?? .now
        let date = dateValue(forKey: "date", in: payload) ?? .now

        guard let modelContainer else {
            pendingPayloads.append(payload)
            return
        }

        Task { @MainActor in
            let macro = Macro(
                food: food,
                createdAt: createdAt,
                date: date,
                carbs: carbs,
                fats: fats,
                protein: protein
            )

            modelContainer.mainContext.insert(macro)

            do {
                try modelContainer.mainContext.save()
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Watch State Changes

    func sessionWatchStateDidChange(_ session: WCSession) {
    }

    // MARK: - Date Parsing

    // Extracts Date from payload in multiple formats
    private func dateValue(forKey key: String, in payload: [String: Any]) -> Date? {
        if let date = payload[key] as? Date {
            return date
        }

        if let timestamp = payload[key] as? TimeInterval {
            return Date(timeIntervalSince1970: timestamp)
        }

        if let timestamp = payload[key] as? Double {
            return Date(timeIntervalSince1970: timestamp)
        }

        if let timestamp = payload[key] as? Int {
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }

        return nil
    }

    // MARK: - Flush Pending Data

    // Saves queued payloads once modelContainer becomes available
    private func flushPendingPayloadsIfPossible() {
        guard modelContainer != nil,
              pendingPayloads.isEmpty == false else { return }

        let payloads = pendingPayloads
        pendingPayloads.removeAll()

        for payload in payloads {
            saveMacro(from: payload)
        }
    }
}
