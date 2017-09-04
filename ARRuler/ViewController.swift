//
//  ViewController.swift
//  ARRuler
//
//  Created by David Hurd on 9/4/17.
//  Copyright © 2017 Imagitale Studios. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var nodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if nodes.count >= 2 {
            for dot in nodes {
                dot.removeFromParentNode()
            }
            
            nodes.removeAll()
        }
        if let touchLocation = touches.first?.location(in: sceneView)  {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitTestResult = hitTestResults.first {
                addDot(at: hitTestResult)
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func addDot(at hitResult: ARHitTestResult) {
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        let node = SCNNode(geometry : sphere)
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                   hitResult.worldTransform.columns.3.y,
                                   hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        nodes.append(node)
        
        if nodes.count >= 2 {
            let distance = calculateDistance()
            updateText(text: "\(distance)", atPosition: nodes[0].position)
            
        }
        
    }
    
    func calculateDistance() -> Float {
        let start = nodes[0]
        let end = nodes[1]
        let distance = sqrt(pow(end.position.x - start.position.x, 2) +
                            pow(end.position.y - start.position.y, 2) +
                            pow(end.position.z - start.position.z, 2))
        return distance
        
    }
    
    func updateText (text: String, atPosition position: SCNVector3) {
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y +  0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
  
}

