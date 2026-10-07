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
struct AnimatedImageView: UIViewRepresentable {
    /// The name of the data set in the asset catalog.
    let assetName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(image: UIImage.animatedGIF(named: assetName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isAccessibilityElement = false
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIImageView, context: Context) -> CGSize? {
        // Fill the proposed space rather than reporting the image's own size.
        proposal.replacingUnspecifiedDimensions()
    }
}

extension UIImage {
    /// Decodes an animated GIF from a data set in the asset catalog, keeping the GIF's frame timing.
    static func animatedGIF(named assetName: String) -> UIImage? {
        guard let asset = NSDataAsset(name: assetName),
              let source = CGImageSourceCreateWithData(asset.data as CFData, nil) else {
            return nil
        }

        var frames: [UIImage] = []
        var duration: TimeInterval = 0
        for index in 0..<CGImageSourceGetCount(source) {
            guard let frame = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            frames.append(UIImage(cgImage: frame))
            duration += frameDelay(in: source, at: index)
        }

        guard !frames.isEmpty else { return nil }
        return UIImage.animatedImage(with: frames, duration: duration)
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
