//
//  ViewController.swift
//  ARRuler
//
//  Created by Hunter Hudson on 11/10/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //Init array of SCNNode objects:
    var dotNodes = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //Show feature points on screen for testing purposes (TODO: comment out later):
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //Method for when the user touches the screen:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch detected.")
        
        /*Grabs the location of the first touch (no need to worry about multitouch for this app):
        */
        if let touchLocation = touches.first?.location(in: sceneView) {
            //Init result of hitTest in the sceneView using the touchLocaiton:
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            //Init hitResult equal to the first hit result:
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        //Init material, node, and dotGeometry:
        let material = SCNMaterial()
        let dotNode = SCNNode()
        let dotGeometry = SCNSphere(radius: 0.005)
        
        //Set the material contents to the color red:
        material.diffuse.contents = UIColor.red
        
        //Assign previously created material to dotGeometry:
        dotGeometry.materials = [material]
        
        /*Set the node's geometry to the previously cretaed dotGeometry and sets the node's position to the location of where the user tapped:
        */
        dotNode.geometry = dotGeometry
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
        
        //Add node to the scene:
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        //If there are 2 or more dots in the dotNodes array...
        if (dotNodes.count >= 2) {
            //...calculate the distance between them:
            calculate()
        }
    }
    
    //Logic for measuring distance:
    func calculate() {
        //Init start and end points:
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        /*Init constants for math formula (a, b, and c are declared as separate constants for readability purposes):
        */
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(abs(distance))
        
        updateText(text: "\(abs(distance))")
    }
    
    func updateText(text: String) {
        //Init geometry of text in AR and node:
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        let textNode = SCNNode(geometry: textGeometry)
        
        /*Set the material of the textGeometry to red (NOTE: can use firstMaterial instead of the array of materials if you know there's only going to be one material):
        */
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        //Set position of the text to a reasonable distance in front of the user:
        textNode.position = SCNVector3(x: 0, y: 0.01, z: -0.1)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
