//
//  AnimatedImageView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 5/14/22.
//

import ImageIO
import SwiftUI
import UIKit

/// Plays an animated GIF stored as a data set in the asset catalog, filling whatever space it's given.
///
/// This is plain SwiftUI on purpose: a UIKit-backed view inside a fading container would stop taking taps
/// while the fade animates, which is exactly where this background is used.
struct AnimatedImageView: View {
    /// The name of the data set in the asset catalog.
    let assetName: String

    @State private var animation: GIFAnimation?

    var body: some View {
        TimelineView(.animation(minimumInterval: animation?.frameDuration ?? 1)) { context in
            if let animation {
                let elapsed = context.date.timeIntervalSinceReferenceDate
                let frame = Int(elapsed / animation.frameDuration) % animation.frames.count
                Image(uiImage: animation.frames[frame])
                    .resizable()
                    .scaledToFill()
                    .accessibilityHidden(true)
            } else {
                Color.clear
            }
        }
        .task {
            animation = GIFAnimation(assetName: assetName)
        }
    }
}

/// The frames of a GIF and how long each one is on screen.
struct GIFAnimation {
    let frames: [UIImage]
    let frameDuration: TimeInterval

    /// Decodes a GIF from a data set in the asset catalog. GIFs can time each frame differently; this keeps
    /// the first frame's timing for all of them, which is exact for the game's evenly timed static.
    init?(assetName: String) {
        guard let asset = NSDataAsset(name: assetName),
              let source = CGImageSourceCreateWithData(asset.data as CFData, nil) else {
            return nil
        }

        var frames: [UIImage] = []
        for index in 0..<CGImageSourceGetCount(source) {
            if let frame = CGImageSourceCreateImageAtIndex(source, index, nil) {
                frames.append(UIImage(cgImage: frame))
            }
        }
        guard !frames.isEmpty else { return nil }

        self.frames = frames
        self.frameDuration = Self.frameDelay(in: source, at: 0)
    }

    private static func frameDelay(in source: CGImageSource, at index: Int) -> TimeInterval {
        let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any]
        let gifProperties = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        let unclampedDelay = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval ?? 0
        let clampedDelay = gifProperties?[kCGImagePropertyGIFDelayTime] as? TimeInterval ?? 0
        let delay = unclampedDelay > 0 ? unclampedDelay : clampedDelay

        // Frames with no delay play at ten per second, which is what browsers do.
        return delay > 0 ? delay : 0.1
    }
}
