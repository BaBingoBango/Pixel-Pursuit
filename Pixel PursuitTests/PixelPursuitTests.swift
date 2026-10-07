//
//  PixelPursuitTests.swift
//  Pixel PursuitTests
//
//  Created by Ethan Marshall on 4/18/23.
//

import RealityKit
import Testing
import simd
@testable import Pixel_Pursuit

struct GameFlowTests {
    @Test func everySceneHasDialogue() {
        for scene in ARSceneID.allCases {
            #expect(!Dialogue.lines(for: scene).isEmpty, "\(scene) has no lines")
        }
    }

    /// The game steps through the dialogue by index, so the lists must stay the length the logic expects.
    @Test func dialogueLengthsMatchTheGameLogic() {
        #expect(Dialogue.diskTable.count == 7)
        #expect(Dialogue.office.count == 3)
        #expect(Dialogue.disk.count == 6)
    }

    @Test func phasesAdvanceInOrderAndStopAtTheFinale() {
        #expect(GamePhase.powerSwitch.next == .initializing)
        #expect(GamePhase.initializing.advancesAutomatically)
        #expect(GamePhase.bootup.advancesAutomatically)
        #expect(!GamePhase.arInstructions.advancesAutomatically)
        #expect(GamePhase.game.next == .finale)
        #expect(GamePhase.finale.next == .finale)
    }

    @Test func proximityTriggersMapToActions() {
        #expect(GameAction(notifyActionIdentifier: "Approach Photos Table") == .viewPhotos)
        #expect(GameAction(notifyActionIdentifier: "Approach Desktop Table") == .viewDesktop)
        #expect(GameAction(notifyActionIdentifier: "Approach Web Table") == .viewWebHistory)
        #expect(GameAction(notifyActionIdentifier: "Approach Computer Table") == .accessServer)
        #expect(GameAction(notifyActionIdentifier: "Approach Photos Exit Table") == nil)
    }
}

@MainActor
struct RealitySceneTests {
    @Test func realityFileIsBundled() {
        #expect(RealitySceneLoader.realityFileURL != nil)
    }

    /// Every scene in the compiled Reality Composer file still loads with the current RealityKit, and keeps
    /// the horizontal-plane anchoring it was authored with: otherwise it would appear at the AR world origin,
    /// which is wherever the iPad was when the session started.
    @Test(arguments: ARSceneID.allCases.filter { $0.realitySceneName != nil })
    func sceneLoadsAnchoredToTheFloor(_ scene: ARSceneID) async throws {
        let anchor = try await RealitySceneLoader.loadAnchor(for: scene)
        #expect(!anchor.children.isEmpty, "\(scene) loaded without any content")

        #if !targetEnvironment(simulator)
        // The simulator has no ARKit, and its RealityKit reports world anchoring for every loaded scene.
        if case .plane(let alignment, _, _) = anchor.anchoring.target {
            #expect(alignment == .horizontal, "\(scene) is anchored to a \(alignment) plane")
        } else {
            Issue.record("\(scene) is anchored to \(anchor.anchoring.target) instead of a horizontal plane")
        }
        #endif
    }
}

struct ScenePlacementTests {
    @Test func placedSceneFacesThePlayer() {
        let position = SIMD3<Float>(1, 0, -2)
        let transform = ScenePlacement.transform(at: position, facing: SIMD3<Float>(4, 1.5, -2))

        // The scene's front is its +Z axis; it should point from the scene toward the player, along +X here.
        let front = SIMD3<Float>(transform.columns.2.x, transform.columns.2.y, transform.columns.2.z)
        #expect(simd_distance(front, SIMD3<Float>(1, 0, 0)) < 0.0001)
        #expect(simd_distance(ScenePlacement.position(of: transform), position) < 0.0001)
    }

    @Test func placedSceneStaysLevel() {
        let transform = ScenePlacement.transform(at: .zero, facing: SIMD3<Float>(-3, 2, 5))
        let up = SIMD3<Float>(transform.columns.1.x, transform.columns.1.y, transform.columns.1.z)
        #expect(simd_distance(up, SIMD3<Float>(0, 1, 0)) < 0.0001)
    }
}
