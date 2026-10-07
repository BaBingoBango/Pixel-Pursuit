//
//  GameAudio.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/13/22.
//

import AVFoundation
import os

/// Plays the game's music and sound effects. Only one track plays at a time, so starting a new one replaces the last.
///
/// Commands run in the order they're given, once the audio session is active, so a track never starts
/// after the stop that was meant to end it.
enum GameAudio {
    private static var player: AVAudioPlayer?
    private static var sessionActivation: Task<Void, Never>?
    private static var lastCommand: Task<Void, Never>?
    private static let logger = Logger(subsystem: "Ethan-Marshall.Pixel-Pursuit", category: "GameAudio")

    /// Activates the audio session asynchronously, once, so the first track doesn't stall the interface.
    private static func activateSessionIfNeeded() {
        guard sessionActivation == nil else { return }
        sessionActivation = Task {
            do {
                if #available(iOS 27, *) {
                    _ = try await AVAudioSession.sharedInstance().activate(options: [])
                } else {
                    // Before iOS 27 the only option is the blocking call, so keep it off the main actor.
                    try await Task.detached {
                        try AVAudioSession.sharedInstance().setActive(true)
                    }.value
                }
            } catch {
                logger.error("Couldn't activate the audio session: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    /// Plays the named bundled MP3 on a loop until something else plays or `stop()` is called.
    static func playLooping(_ name: String) {
        enqueue { play(name, loops: -1) }
    }

    /// Plays the named bundled MP3 once.
    static func playOnce(_ name: String) {
        enqueue { play(name, loops: 0) }
    }

    /// Stops whatever is playing.
    static func stop() {
        enqueue {
            player?.stop()
            player = nil
        }
    }

    private static func enqueue(_ command: @escaping @MainActor () -> Void) {
        activateSessionIfNeeded()
        let previousCommand = lastCommand
        lastCommand = Task {
            await previousCommand?.value
            await sessionActivation?.value
            command()
        }
    }

    private static func play(_ name: String, loops: Int) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            logger.error("Couldn't find \(name, privacy: .public).mp3 in the app bundle.")
            return
        }

        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = loops
            newPlayer.play()
            player = newPlayer
        } catch {
            logger.error("Couldn't play \(name, privacy: .public).mp3: \(error.localizedDescription, privacy: .public)")
        }
    }
}
