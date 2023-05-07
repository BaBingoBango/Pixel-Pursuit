//
// PixelPursuit.swift
// GENERATED CONTENT. DO NOT EDIT.
//

import Foundation
import RealityKit
import simd
import Combine

@available(iOS 13.0, macOS 10.15, *)
public enum PixelPursuit {

    public class NotifyAction {

        public let identifier: Swift.String

        public var onAction: ((RealityKit.Entity?) -> Swift.Void)?

        private weak var root: RealityKit.Entity?

        fileprivate init(identifier: Swift.String, root: RealityKit.Entity?) {
            self.identifier = identifier
            self.root = root

            Foundation.NotificationCenter.default.addObserver(self, selector: #selector(actionDidFire(notification:)), name: Foundation.NSNotification.Name(rawValue: "RealityKit.NotifyAction"), object: nil)
        }

        deinit {
            Foundation.NotificationCenter.default.removeObserver(self, name: Foundation.NSNotification.Name(rawValue: "RealityKit.NotifyAction"), object: nil)
        }

        @objc
        private func actionDidFire(notification: Foundation.Notification) {
            guard let onAction = onAction else {
                return
            }

            guard let userInfo = notification.userInfo as? [Swift.String: Any] else {
                return
            }

            guard let scene = userInfo["RealityKit.NotifyAction.Scene"] as? RealityKit.Scene,
                root?.scene == scene else {
                    return
            }

            guard let identifier = userInfo["RealityKit.NotifyAction.Identifier"] as? Swift.String,
                identifier == self.identifier else {
                    return
            }

            let entity = userInfo["RealityKit.NotifyAction.Entity"] as? RealityKit.Entity

            onAction(entity)
        }

    }

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadDisktable() throws -> PixelPursuit.Disktable {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Disktable.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("disktable", isDirectory: false)
        let anchorEntity = try PixelPursuit.Disktable.loadAnchor(contentsOf: realityFileSceneURL)
        return createDisktable(from: anchorEntity)
    }

    public static func loadDisktableAsync(completion: @escaping (Swift.Result<PixelPursuit.Disktable, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Disktable.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("disktable", isDirectory: false)
        let loadRequest = PixelPursuit.Disktable.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createDisktable(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createDisktable(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Disktable {
        let disktable = PixelPursuit.Disktable()
        disktable.anchoring = anchorEntity.anchoring
        disktable.addChild(anchorEntity)
        return disktable
    }

    public static func loadOffice() throws -> PixelPursuit.Office {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Office.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("office", isDirectory: false)
        let anchorEntity = try PixelPursuit.Office.loadAnchor(contentsOf: realityFileSceneURL)
        return createOffice(from: anchorEntity)
    }

    public static func loadOfficeAsync(completion: @escaping (Swift.Result<PixelPursuit.Office, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Office.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("office", isDirectory: false)
        let loadRequest = PixelPursuit.Office.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createOffice(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createOffice(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Office {
        let office = PixelPursuit.Office()
        office.anchoring = anchorEntity.anchoring
        office.addChild(anchorEntity)
        return office
    }

    public static func loadDisk() throws -> PixelPursuit.Disk {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Disk.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("disk", isDirectory: false)
        let anchorEntity = try PixelPursuit.Disk.loadAnchor(contentsOf: realityFileSceneURL)
        return createDisk(from: anchorEntity)
    }

    public static func loadDiskAsync(completion: @escaping (Swift.Result<PixelPursuit.Disk, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Disk.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("disk", isDirectory: false)
        let loadRequest = PixelPursuit.Disk.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createDisk(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createDisk(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Disk {
        let disk = PixelPursuit.Disk()
        disk.anchoring = anchorEntity.anchoring
        disk.addChild(anchorEntity)
        return disk
    }

    public static func loadPhotos() throws -> PixelPursuit.Photos {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Photos.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("photos", isDirectory: false)
        let anchorEntity = try PixelPursuit.Photos.loadAnchor(contentsOf: realityFileSceneURL)
        return createPhotos(from: anchorEntity)
    }

    public static func loadPhotosAsync(completion: @escaping (Swift.Result<PixelPursuit.Photos, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Photos.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("photos", isDirectory: false)
        let loadRequest = PixelPursuit.Photos.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createPhotos(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createPhotos(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Photos {
        let photos = PixelPursuit.Photos()
        photos.anchoring = anchorEntity.anchoring
        photos.addChild(anchorEntity)
        return photos
    }

    public static func loadDesktop() throws -> PixelPursuit.Desktop {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Desktop.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("desktop", isDirectory: false)
        let anchorEntity = try PixelPursuit.Desktop.loadAnchor(contentsOf: realityFileSceneURL)
        return createDesktop(from: anchorEntity)
    }

    public static func loadDesktopAsync(completion: @escaping (Swift.Result<PixelPursuit.Desktop, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Desktop.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("desktop", isDirectory: false)
        let loadRequest = PixelPursuit.Desktop.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createDesktop(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createDesktop(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Desktop {
        let desktop = PixelPursuit.Desktop()
        desktop.anchoring = anchorEntity.anchoring
        desktop.addChild(anchorEntity)
        return desktop
    }

    public static func loadHistory() throws -> PixelPursuit.History {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.History.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("history", isDirectory: false)
        let anchorEntity = try PixelPursuit.History.loadAnchor(contentsOf: realityFileSceneURL)
        return createHistory(from: anchorEntity)
    }

    public static func loadHistoryAsync(completion: @escaping (Swift.Result<PixelPursuit.History, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.History.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("history", isDirectory: false)
        let loadRequest = PixelPursuit.History.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createHistory(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createHistory(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.History {
        let history = PixelPursuit.History()
        history.anchoring = anchorEntity.anchoring
        history.addChild(anchorEntity)
        return history
    }

    public static func loadServer() throws -> PixelPursuit.Server {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Server.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            throw PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("server", isDirectory: false)
        let anchorEntity = try PixelPursuit.Server.loadAnchor(contentsOf: realityFileSceneURL)
        return createServer(from: anchorEntity)
    }

    public static func loadServerAsync(completion: @escaping (Swift.Result<PixelPursuit.Server, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: PixelPursuit.Server.self).url(forResource: "Pixel Pursuit", withExtension: "reality") else {
            completion(.failure(PixelPursuit.LoadRealityFileError.fileNotFound("Pixel Pursuit.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("server", isDirectory: false)
        let loadRequest = PixelPursuit.Server.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(PixelPursuit.createServer(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createServer(from anchorEntity: RealityKit.AnchorEntity) -> PixelPursuit.Server {
        let server = PixelPursuit.Server()
        server.anchoring = anchorEntity.anchoring
        server.addChild(anchorEntity)
        return server
    }

    public class Disktable: RealityKit.Entity, RealityKit.HasAnchoring {

        public var computer: RealityKit.Entity? {
            return self.findEntity(named: "computer")
        }



    }

    public class Office: RealityKit.Entity, RealityKit.HasAnchoring {

    }

    public class Disk: RealityKit.Entity, RealityKit.HasAnchoring {

        public var computerTable: RealityKit.Entity? {
            return self.findEntity(named: "Computer Table")
        }



        public var desktopTable: RealityKit.Entity? {
            return self.findEntity(named: "Desktop Table")
        }



        public var photosTable: RealityKit.Entity? {
            return self.findEntity(named: "Photos Table")
        }



        public var webTable: RealityKit.Entity? {
            return self.findEntity(named: "Web Table")
        }



        public private(set) lazy var actions = PixelPursuit.Disk.Actions(root: self)

        public class Actions {

            fileprivate init(root: RealityKit.Entity) {
                self.root = root
            }

            private weak var root: RealityKit.Entity?

            public private(set) lazy var approachComputerTable = PixelPursuit.NotifyAction(identifier: "Approach Computer Table", root: root)
            public private(set) lazy var approachDesktopTable = PixelPursuit.NotifyAction(identifier: "Approach Desktop Table", root: root)
            public private(set) lazy var approachPhotosTable = PixelPursuit.NotifyAction(identifier: "Approach Photos Table", root: root)
            public private(set) lazy var approachWebTable = PixelPursuit.NotifyAction(identifier: "Approach Web Table", root: root)

            public private(set) lazy var allActions = [ approachPhotosTable, approachDesktopTable, approachWebTable, approachComputerTable ]

        }

    }

    public class Photos: RealityKit.Entity, RealityKit.HasAnchoring {

        public private(set) lazy var actions = PixelPursuit.Photos.Actions(root: self)

        public class Actions {

            fileprivate init(root: RealityKit.Entity) {
                self.root = root
            }

            private weak var root: RealityKit.Entity?

            public private(set) lazy var approachPhotosExitTable = PixelPursuit.NotifyAction(identifier: "Approach Photos Exit Table", root: root)

            public private(set) lazy var allActions = [ approachPhotosExitTable ]

        }

    }

    public class Desktop: RealityKit.Entity, RealityKit.HasAnchoring {

        public private(set) lazy var actions = PixelPursuit.Desktop.Actions(root: self)

        public class Actions {

            fileprivate init(root: RealityKit.Entity) {
                self.root = root
            }

            private weak var root: RealityKit.Entity?

            public private(set) lazy var approachDesktopExitTable = PixelPursuit.NotifyAction(identifier: "Approach Desktop Exit Table", root: root)

            public private(set) lazy var allActions = [ approachDesktopExitTable ]

        }

    }

    public class History: RealityKit.Entity, RealityKit.HasAnchoring {

        public private(set) lazy var actions = PixelPursuit.History.Actions(root: self)

        public class Actions {

            fileprivate init(root: RealityKit.Entity) {
                self.root = root
            }

            private weak var root: RealityKit.Entity?

            public private(set) lazy var approachWebExitTable = PixelPursuit.NotifyAction(identifier: "Approach Web Exit Table", root: root)

            public private(set) lazy var allActions = [ approachWebExitTable ]

        }

    }

    public class Server: RealityKit.Entity, RealityKit.HasAnchoring {

    }

}
