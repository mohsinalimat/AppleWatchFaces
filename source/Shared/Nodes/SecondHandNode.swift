//
//  SecondHandNode.swift
//  AppleWatchFaces
//
//  Created by Mike Hill on 11/11/15.
//  Copyright © 2015 Mike Hill. All rights reserved.
//

//import Cocoa
import SpriteKit
import SceneKit

enum SecondHandTypes: String {
    case SecondHandTypeSwiss, SecondhandTypeSwissCircle, SecondHandTypeRail, SecondHandTypeBlocky, SecondHandTypeRoman, SecondHandTypePointy, SecondHandTypeSquaredHole, SecondHandTypeArrow, SecondHandTypeSphere, SecondHandTypeFancyRed, SecondHandTypeFlatDial, SecondHandTypeThinDial, SecondHandTypePacMan, SecondHandTypeMsPacMan, SecondHandTieFighter, SecondHandRadar,
        SecondHandTypeImageMoon,
        SecondHandNodeTypeNone
    
    static let userSelectableValues = [SecondHandTypeSwiss, SecondhandTypeSwissCircle, SecondHandTypeRail, SecondHandTypeBlocky, SecondHandTypePointy, SecondHandTypeSquaredHole, SecondHandTypeRoman, SecondHandTypeArrow, SecondHandTypeSphere, SecondHandTypeFancyRed, SecondHandTypeFlatDial, SecondHandTypeThinDial, SecondHandRadar, SecondHandTypePacMan, SecondHandTypeMsPacMan, SecondHandTieFighter, SecondHandTypeImageMoon,
        SecondHandNodeTypeNone ]
    
    static let randomizableValues = userSelectableValues
    
    static func random() -> SecondHandTypes {
        let randomIndex = Int(arc4random_uniform(UInt32(randomizableValues.count)))
        return randomizableValues[randomIndex]
    }
    
    static func isDialType(type: SecondHandTypes) -> Bool {
        return ([SecondHandTypeFlatDial, SecondHandTypeThinDial].lastIndex(of: type) != nil)
    }
}

enum SecondHandMovements: String {
    case SecondHandMovementStep, SecondHandMovementStepOver, SecondHandMovementSmooth, SecondHandMovementOscillate
    
    static let randomizableValues = [SecondHandMovementStep, SecondHandMovementStepOver, SecondHandMovementSmooth, SecondHandMovementOscillate]
    static let userSelectableValues = randomizableValues
    
    static func random() -> SecondHandMovements {
        let randomIndex = Int(arc4random_uniform(UInt32(randomizableValues.count)))
        return randomizableValues[randomIndex]
    }
}

class SecondHandNode: SKSpriteNode {
    
    let sizeMultiplier = CGFloat(SKWatchScene.sizeMulitplier)
    var secondHandType:SecondHandTypes = .SecondHandNodeTypeNone
    var material = ""
    var strokeColor:SKColor = SKColor.white
    var lineWidth: CGFloat = 0.0
    var cornerRadius:CGFloat = 0.0
    var glowWidth: CGFloat = 0.0
    
    //used for dials
    var innerRadius:CGFloat = 0.0
    var outerRadius:CGFloat = 0.0
    
    static func descriptionForType(_ nodeType: SecondHandTypes) -> String {
        var typeDescription = ""
        
        if (nodeType == .SecondHandTypeSwiss)  { typeDescription = "Swiss Railway" }
        if (nodeType == .SecondhandTypeSwissCircle)  { typeDescription = "Swiss Dot End" }
        if (nodeType == .SecondHandTypeRail)  { typeDescription = "Rail" }
        if (nodeType == .SecondHandTypeRoman)  { typeDescription = "Roman" }
        if (nodeType == .SecondHandTypeBlocky)  { typeDescription = "Blocky" }
        if (nodeType == .SecondHandTypePointy)  { typeDescription = "Pointy" }
        if (nodeType == .SecondHandTypeSquaredHole)  { typeDescription = "Squared Hole" }
        if (nodeType == .SecondHandTypeArrow)  { typeDescription = "Arrow" }
        if (nodeType == .SecondHandTypeSphere)  { typeDescription = "Magnetic Sphere" }
        if (nodeType == .SecondHandTypeFlatDial)  { typeDescription = "Flat Dial" }
        if (nodeType == .SecondHandTypeThinDial)  { typeDescription = "Thin Dial" }
        if (nodeType == .SecondHandTypePacMan)  { typeDescription = "Dot Eater" }
        if (nodeType == .SecondHandTypeMsPacMan)  { typeDescription = "Ms Dot Eater" }
        if (nodeType == .SecondHandRadar) { typeDescription = "Radar Pointer" }
        
        // IMAGE BASED EXAMPLES
        if (nodeType == .SecondHandTypeFancyRed)  { typeDescription = "Image: Fancy Red" }
        if (nodeType == .SecondHandTieFighter)  { typeDescription = "Image: Tie Fighter" }
        if (nodeType == .SecondHandTypeImageMoon)  { typeDescription = "Image: Moon" }
        
        if (nodeType == .SecondHandNodeTypeNone)  { typeDescription = "None" }
        
        return typeDescription
    }
    
    static func typeDescriptions() -> [String] {
        var typeDescriptionsArray = [String]()
        for nodeType in SecondHandTypes.userSelectableValues {
            typeDescriptionsArray.append(descriptionForType(nodeType))
        }
        
        return typeDescriptionsArray
    }
    
    static func typeKeys() -> [String] {
        var typeKeysArray = [String]()
        for nodeType in SecondHandTypes.userSelectableValues {
            typeKeysArray.append(nodeType.rawValue)
        }
        
        return typeKeysArray
    }
    
    static func descriptionForMovement(_ nodeType: SecondHandMovements) -> String {
        var typeDescription = ""
        
        if (nodeType == SecondHandMovements.SecondHandMovementStep)  { typeDescription = "Step" }
        if (nodeType == SecondHandMovements.SecondHandMovementStepOver)  { typeDescription = "Step Over" }
        if (nodeType == SecondHandMovements.SecondHandMovementSmooth)  { typeDescription = "Smooth" }
        if (nodeType == SecondHandMovements.SecondHandMovementOscillate)  { typeDescription = "Oscillate" }
        
        
        return typeDescription
    }
    
    static func movementDescriptions() -> [String] {
        var typeDescriptionsArray = [String]()
        for nodeType in SecondHandMovements.userSelectableValues {
            typeDescriptionsArray.append(descriptionForMovement(nodeType))
        }
        
        return typeDescriptionsArray
    }
    
    static func movementKeys() -> [String] {
        var typeKeysArray = [String]()
        for nodeType in SecondHandMovements.userSelectableValues {
            typeKeysArray.append(nodeType.rawValue)
        }
        
        return typeKeysArray
    }
    
    func addArcNode(endAngle: CGFloat) {
        let newNode = ArcNode.init(cornerRadius: cornerRadius, innerRadius: innerRadius, outerRadius: outerRadius, endAngle: endAngle, material: material, strokeColor: strokeColor, lineWidth: lineWidth, glowWidth: glowWidth)
        newNode.name = "arcNode"
        
        self.addChild(newNode)
    }
    
    //position from main watch node
    func positionHands( sec: CGFloat, secondHandMovement: SecondHandMovements, force: Bool ) {
        
        let newZAngle = -1 * MathFunctions.deg2rad(sec * 6)
        
        if secondHandType == .SecondHandTypePacMan || secondHandType == .SecondHandTypeMsPacMan {
            if let dotsNode = self.childNode(withName: "dotsNode") as? DotsNode {
                dotsNode.positionHands( sec: sec, secondHandMovement: secondHandMovement, force: force )
            }
            //EXIT
            return
        }
        
        if SecondHandTypes.isDialType(type: secondHandType) {
            self.removeAllChildren() //removing by name wasny cleaing up the init one *shrug*
            addArcNode(endAngle: newZAngle)
            
            //EXIT
            return
        }
        
        //movement jump each second
        if (secondHandMovement == .SecondHandMovementStep || force) {
            self.zRotation = newZAngle
        }
        
        //movment smoothly rotate each second
        if (secondHandMovement == .SecondHandMovementSmooth && !force) {
            //debugPrint("smooth sec:" + sec.description + " zAngle: " +  self.zRotation.description + " newAngle:" + newZAngle.description )
            self.removeAllActions()
            if sec == 0 { self.zRotation = MathFunctions.deg2rad(6) } //fix to keep it from spinning back around
            
            let smoothSecondAction = SKAction.rotate(toAngle: newZAngle, duration: 0.99)
            self.run(smoothSecondAction)
        }
        
        //movement to oscillate
        if (secondHandMovement == .SecondHandMovementOscillate && !force) {
            let stepUnderValue = CGFloat(0.05)
            let duration = 0.99
            
            self.removeAllActions()
            if sec == 0 { self.zRotation = MathFunctions.deg2rad(6) } //fix to keep it from spinning back around
            
            let rotSecondAction1 = SKAction.rotate(toAngle: newZAngle+stepUnderValue, duration: duration/2)
            rotSecondAction1.timingMode = .easeIn
            let rotSecondAction2 = SKAction.rotate(toAngle: newZAngle, duration: duration/2)
            rotSecondAction2.timingMode = .easeOut
            
            self.run( SKAction.sequence( [ rotSecondAction1, rotSecondAction2 ]) )
        }
        
        //movement to step over
        if (secondHandMovement == .SecondHandMovementStepOver && !force) {
            let stepOverValue = CGFloat(0.030)
            let duration = 0.5
            
            self.removeAllActions()
            if sec == 0 { self.zRotation = MathFunctions.deg2rad(6) } //fix to keep it from spinning back around
            
            let rotSecondAction1 = SKAction.rotate(toAngle: newZAngle-stepOverValue, duration: duration/5)
            let rotSecondAction2 = SKAction.rotate(toAngle: newZAngle, duration: duration/2)
            
            self.run( SKAction.sequence( [ rotSecondAction1, rotSecondAction2 ]) )
        }
    }
    
    convenience init(secondHandType: SecondHandTypes) {
        self.init(secondHandType: secondHandType, material: "#ffffffff")
    }
    
    convenience init(secondHandType: SecondHandTypes, material: String) {
        self.init(secondHandType: secondHandType, material: material, strokeColor: SKColor.clear, lineWidth: 2.0, glowWidth: 0, fieldType: .None, itemStrength:0)
    }
    
    func addPhysicsField(fieldType: PhysicsFieldTypes, node: SKNode, position: CGPoint, itemStrength: CGFloat) {
        
        if fieldType == .Spring {
            let field = SKFieldNode.springField()
            field.strength = Float(0.001 * itemStrength)
            field.position = position
            node.addChild(field)
        }
        
        if fieldType == .Noise {
            let field = SKFieldNode.noiseField(withSmoothness: 1.0, animationSpeed: 0.005)
            field.falloff = 0.0001
            field.strength = Float(0.0007 * itemStrength)
            field.position = position
            node.addChild(field)
        }

        
        if fieldType == .LinearGravity {
            let field = SKFieldNode.linearGravityField(withVector: vector_float3.init(x: 0, y: 5.0, z: 0))
            field.falloff = 0.0000000001
            field.strength = Float(0.1 * itemStrength)
            field.position = position
            node.addChild(field)
            
            //one the got moved out
            
            //        let field = SKFieldNode.linearGravityField(withVector: vector_float3.init(x: 0, y: 5, z: 2))
            //        field.strength = 0.1
            //        field.position = CGPoint.init(x: 0, y: 85)
            //        self.addChild(field)
        }
        
        if fieldType == .RadialGravity {
            let field = SKFieldNode.radialGravityField()
            field.falloff = 0.1
            field.strength = Float(0.05 * itemStrength)
            field.position = position
            node.addChild(field)
        }
        
    }
    
    init(secondHandType: SecondHandTypes, material: String, strokeColor: SKColor, lineWidth: CGFloat, glowWidth: CGFloat, fieldType: PhysicsFieldTypes, itemStrength: CGFloat) {
        
        super.init(texture: nil, color: SKColor.clear, size: CGSize())
        
        self.name = "secondHand"
        self.secondHandType = secondHandType
        self.material = material
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.glowWidth = glowWidth
        
        if (secondHandType == SecondHandTypes.SecondHandNodeTypeNone) {
            //none :-)
        }
        
        if (secondHandType == .SecondHandRadar) {
            let outerRingNode = SKShapeNode.init(circleOfRadius: 100.0)
            outerRingNode.fillColor = SKColor.clear
            outerRingNode.strokeColor = SKColor.init(hexString: material)
            outerRingNode.lineWidth = 1.0
            outerRingNode.glowWidth = glowWidth
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: -5, y: -10))
            bezierPath.addLine(to: CGPoint(x: 5, y: -10))
            bezierPath.addLine(to: CGPoint(x: 3, y: 54))
            bezierPath.addLine(to: CGPoint(x: -3, y: 54))
            bezierPath.addLine(to: CGPoint(x: -5, y: -10))
            bezierPath.close()
            bezierPath.apply(CGAffineTransform.init(scaleX: 0.4, y: -0.4))  //scale/stratch
            
            let tickNode = SKShapeNode.init(path: bezierPath.cgPath)
            tickNode.position = CGPoint.init(x: 0, y: 96)
            
            tickNode.fillColor = SKColor.clear
            tickNode.strokeColor = SKColor.init(hexString: material)
            tickNode.lineWidth = 1.0
            tickNode.glowWidth = glowWidth
            
            outerRingNode.addChild(tickNode)
            
            //needed to affect the physics fields
            addPhysicsField(fieldType: fieldType, node: outerRingNode, position: CGPoint.init(x: 0, y: 96), itemStrength: itemStrength)
            
            self.addChild(outerRingNode)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypePacMan) {
            let dotsW:CGFloat = 158
            let dotsH:CGFloat = 189
            let pathNode = DotsNode.init(pathHeight: dotsH, pathWidth: dotsW, material: "#ffb8ae", strokeColor: SKColor.init(hexString: "#ffb8ae"), lineWidth: 1.0, numDots: 66, secondHandType: secondHandType)
            pathNode.name = "dotsNode"
            pathNode.zPosition = 2.0
            
            //hacks to fit
            pathNode.position = CGPoint.init(x: -1.0, y: -5.5) //-y is down
            pathNode.xScale = 1.065
            pathNode.yScale = 1.027
            
            self.addChild(pathNode)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeMsPacMan) {
            let dotsW:CGFloat = 197
            let dotsH:CGFloat = 169
            let pathNode = DotsNode.init(pathHeight: dotsH, pathWidth: dotsW, material: "#dcdcfd", strokeColor: SKColor.init(hexString: "#dcdcfd"), lineWidth: 0.5, numDots: 78, secondHandType: secondHandType)
            pathNode.name = "dotsNode"
            pathNode.zPosition = 2.0
            
            //hacks to fit
            pathNode.position = CGPoint.init(x: -0.0, y: 2.75) //-y is down
            pathNode.xScale = 0.98
            pathNode.yScale = 1.0
            
            self.addChild(pathNode)
        }
        
        if (SecondHandTypes.isDialType(type: secondHandType)) {
            
            //fat
            let radiusCenter:CGFloat = 95.0
            innerRadius = radiusCenter - ArcNode.fatRadiusWidth/2
            outerRadius = radiusCenter + ArcNode.fatRadiusWidth/2
            
            //skinny
            if secondHandType == .SecondHandTypeThinDial {
                innerRadius = radiusCenter - ArcNode.skinnyRadiusWidth/2
                outerRadius = radiusCenter + ArcNode.skinnyRadiusWidth/2
            }
            
            addArcNode( endAngle: CGFloat.pi * 0.5)
        }
        
        if (secondHandType == .SecondHandTypeImageMoon) {
            let im = UIImage.init(named: "secondHand-ImageMoon.png")
            if let textureImage = im {
                let texture = SKTexture.init(image: textureImage)
                let textureNode = SKSpriteNode.init(texture: texture)
                textureNode.setScale(1.43)  //1.43
                textureNode.anchorPoint = CGPoint.init(x: 0.57, y: 0.09)   //how far from center of image
                textureNode.color = SKColor.init(hexString: material)
                textureNode.colorBlendFactor = 1.0
                
                let phy = SKPhysicsBody.init(rectangleOf: CGSize.init(width: 20, height: 84), center: CGPoint.init(x: 0, y: 40))
                phy.isDynamic = false
                textureNode.physicsBody = phy
                
                //needed to affect the physics fields
                addPhysicsField(fieldType: fieldType, node: textureNode, position: CGPoint.init(x: 0, y: 78.0), itemStrength: itemStrength)
                
                self.addChild(textureNode)
            }
            
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeFancyRed) {
            let im = UIImage.init(named: "secondHand-fancyRed.png")
            if let textureImage = im {
                let texture = SKTexture.init(image: textureImage)
                let textureNode = SKSpriteNode.init(texture: texture)
                textureNode.setScale(0.75)
                textureNode.color = SKColor.init(hexString: material)
                textureNode.colorBlendFactor = 1.0
                
                //needed to affect the physics fields
                addPhysicsField(fieldType: fieldType, node: textureNode, position: CGPoint.init(x: 0, y: 0), itemStrength: itemStrength)
                
                self.addChild(textureNode)
            }
            
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTieFighter) {
            let im = UIImage.init(named: "secondHand-TIEfighter.png")
            if let textureImage = im {
                let texture = SKTexture.init(image: textureImage)
                let textureNode = SKSpriteNode.init(texture: texture)
                
                textureNode.anchorPoint = CGPoint.init(x: 0, y: -1.65)   //how far from center of image
                textureNode.setScale(0.15)                              //resize
                
                textureNode.color = SKColor.init(hexString: material) //tint it ( white == color )
                textureNode.colorBlendFactor = 1.0
                
                //needed to affect the physics fields
                addPhysicsField(fieldType: fieldType, node: textureNode, position: CGPoint.init(x: 0, y: 0), itemStrength: itemStrength)
                
                self.addChild(textureNode)
            }
            
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeSphere) {
            let shape = SKShapeNode.init(circleOfRadius: 4)
            shape.position = CGPoint.init(x: 0, y: 89.0)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let phy = SKPhysicsBody.init(circleOfRadius: 4)
            phy.isDynamic = false
            shape.physicsBody = phy
            
            //needed to affect the physics fields
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 0), itemStrength: itemStrength)
            
            self.addChild(shape)
            //self.pivot = SCNMatrix4MakeTranslation(0.0, -0.89, 0)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeSquaredHole) {
            let rect = CGRect.init(x: 0, y: 0, width: 2.5, height: 90)
            let shape = SKShapeNode.init(rect: rect)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let phy = SKPhysicsBody.init(rectangleOf: rect.size, center: CGPoint.init(x: rect.midX, y: rect.midY))
            phy.isDynamic = false
            shape.physicsBody = phy
            
            //needed to affect the phyics fields
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 85), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
        
        if (secondHandType == SecondHandTypes.SecondhandTypeSwissCircle) {
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint.init(x: 8, y: 72))
            bezierPath.addCurve(to: CGPoint.init(x: 7.88, y: 70.63), controlPoint1: CGPoint.init(x: 8, y: 71.53), controlPoint2: CGPoint.init(x: 7.96, y: 71.07))
            bezierPath.addCurve(to: CGPoint.init(x: 2, y: 64.25), controlPoint1: CGPoint.init(x: 7.35, y: 67.52), controlPoint2: CGPoint.init(x: 5.02, y: 65.03))
            bezierPath.addCurve(to: CGPoint.init(x: 2, y: -22), controlPoint1: CGPoint.init(x: 2, y: 44.12), controlPoint2: CGPoint.init(x: 2, y: -22))
            bezierPath.addLine(to: CGPoint.init(x: -2, y: -22))
            bezierPath.addCurve(to: CGPoint.init(x: -2, y: 64.25), controlPoint1: CGPoint.init(x: -2, y: -22), controlPoint2: CGPoint.init(x: -2, y: 44.12))
            bezierPath.addCurve(to: CGPoint.init(x: -8, y: 72), controlPoint1: CGPoint.init(x: -5.45, y: 65.14), controlPoint2: CGPoint.init(x: -8, y: 68.27))
            bezierPath.addCurve(to: CGPoint.init(x: 0, y: 80), controlPoint1: CGPoint.init(x: -8, y: 76.42), controlPoint2: CGPoint.init(x: -4.42, y: 80))
            bezierPath.addCurve(to: CGPoint.init(x: 8, y: 72), controlPoint1: CGPoint.init(x: 4.42, y: 80), controlPoint2: CGPoint.init(x: 8, y: 76.42))
            bezierPath.close()
            
            let shape = SKShapeNode.init(path: bezierPath.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let phy =  SKPhysicsBody.init(polygonFrom: bezierPath.cgPath)
            phy.isDynamic = false
            shape.physicsBody = phy
            
            //needed to affect the phyics fields
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 75), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeArrow) {
        
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 1.5, y: -381))
            bezier2Path.addCurve(to: CGPoint(x: 4.5, y: -372), controlPoint1: CGPoint(x: 1.5, y: -381), controlPoint2: CGPoint(x: 4.5, y: -372))
            bezier2Path.addCurve(to: CGPoint(x: 4.64, y: -371.85), controlPoint1: CGPoint(x: 4.5, y: -372), controlPoint2: CGPoint(x: 4.55, y: -371.95))
            bezier2Path.addCurve(to: CGPoint(x: 32.5, y: -343), controlPoint1: CGPoint(x: 20.29, y: -370.38), controlPoint2: CGPoint(x: 32.5, y: -358.02))
            bezier2Path.addCurve(to: CGPoint(x: 32.14, y: -338.57), controlPoint1: CGPoint(x: 32.5, y: -341.49), controlPoint2: CGPoint(x: 32.38, y: -340.01))
            bezier2Path.addCurve(to: CGPoint(x: 6.89, y: -314.44), controlPoint1: CGPoint(x: 30.13, y: -326.31), controlPoint2: CGPoint(x: 19.91, y: -316.57))
            bezier2Path.addCurve(to: CGPoint(x: 6.5, y: -314), controlPoint1: CGPoint(x: 6.64, y: -314.15), controlPoint2: CGPoint(x: 6.5, y: -314))
            bezier2Path.addCurve(to: CGPoint(x: 5.03, y: -170.12), controlPoint1: CGPoint(x: 6.5, y: -314), controlPoint2: CGPoint(x: 5.77, y: -242.57))
            bezier2Path.addCurve(to: CGPoint(x: 3.52, y: -21.66), controlPoint1: CGPoint(x: 4.34, y: -102.07), controlPoint2: CGPoint(x: 3.63, y: -33.12))
            bezier2Path.addCurve(to: CGPoint(x: 20, y: 0), controlPoint1: CGPoint(x: 12.89, y: -19.83), controlPoint2: CGPoint(x: 20, y: -10.83))
            bezier2Path.addCurve(to: CGPoint(x: 3.5, y: 21.66), controlPoint1: CGPoint(x: 20, y: 10.84), controlPoint2: CGPoint(x: 12.88, y: 19.84))
            bezier2Path.addCurve(to: CGPoint(x: 3.5, y: 116), controlPoint1: CGPoint(x: 3.5, y: 34.4), controlPoint2: CGPoint(x: 3.5, y: 116))
            bezier2Path.addCurve(to: CGPoint(x: 12.32, y: 141.48), controlPoint1: CGPoint(x: 3.5, y: 116), controlPoint2: CGPoint(x: 11.05, y: 137.81))
            bezier2Path.addCurve(to: CGPoint(x: 12.8, y: 143.05), controlPoint1: CGPoint(x: 12.52, y: 141.99), controlPoint2: CGPoint(x: 12.68, y: 142.51))
            bezier2Path.addCurve(to: CGPoint(x: 13, y: 145), controlPoint1: CGPoint(x: 12.93, y: 143.68), controlPoint2: CGPoint(x: 13, y: 144.33))
            bezier2Path.addCurve(to: CGPoint(x: -0, y: 156), controlPoint1: CGPoint(x: 13, y: 151.08), controlPoint2: CGPoint(x: 7.18, y: 156))
            bezier2Path.addCurve(to: CGPoint(x: -13, y: 145), controlPoint1: CGPoint(x: -7.18, y: 156), controlPoint2: CGPoint(x: -13, y: 151.08))
            bezier2Path.addCurve(to: CGPoint(x: -12.32, y: 141.48), controlPoint1: CGPoint(x: -13, y: 143.77), controlPoint2: CGPoint(x: -12.76, y: 142.58))
            bezier2Path.addCurve(to: CGPoint(x: -3.5, y: 116), controlPoint1: CGPoint(x: -11.05, y: 137.81), controlPoint2: CGPoint(x: -3.5, y: 116))
            bezier2Path.addCurve(to: CGPoint(x: -3.5, y: 21.66), controlPoint1: CGPoint(x: -3.5, y: 116), controlPoint2: CGPoint(x: -3.5, y: 34.4))
            bezier2Path.addCurve(to: CGPoint(x: -20, y: 0), controlPoint1: CGPoint(x: -12.88, y: 19.84), controlPoint2: CGPoint(x: -20, y: 10.84))
            bezier2Path.addCurve(to: CGPoint(x: -3.5, y: -21.66), controlPoint1: CGPoint(x: -20, y: -10.84), controlPoint2: CGPoint(x: -12.88, y: -19.84))
            bezier2Path.addCurve(to: CGPoint(x: -3.5, y: -314), controlPoint1: CGPoint(x: -3.5, y: -45.35), controlPoint2: CGPoint(x: -3.5, y: -314))
            bezier2Path.addCurve(to: CGPoint(x: -3.89, y: -314.44), controlPoint1: CGPoint(x: -3.5, y: -314), controlPoint2: CGPoint(x: -3.64, y: -314.15))
            bezier2Path.addCurve(to: CGPoint(x: -29.5, y: -343), controlPoint1: CGPoint(x: -18.44, y: -316.82), controlPoint2: CGPoint(x: -29.5, y: -328.7))
            bezier2Path.addCurve(to: CGPoint(x: -1.64, y: -371.85), controlPoint1: CGPoint(x: -29.5, y: -358.02), controlPoint2: CGPoint(x: -17.29, y: -370.38))
            bezier2Path.addCurve(to: CGPoint(x: -1.5, y: -372), controlPoint1: CGPoint(x: -1.55, y: -371.95), controlPoint2: CGPoint(x: -1.5, y: -372))
            bezier2Path.addCurve(to: CGPoint(x: 1.5, y: -381), controlPoint1: CGPoint(x: -1.5, y: -372), controlPoint2: CGPoint(x: 1.46, y: -380.88))
            bezier2Path.addLine(to: CGPoint(x: 1.5, y: -381))
            bezier2Path.close()
            
            let scaledSize = CGFloat(0.4) * ( sizeMultiplier / 200 )
            
            //bezierPath.apply(CGAffineTransform.init(translationX: 0, y: 0)) //repos
            bezier2Path.apply(CGAffineTransform.init(scaleX: scaledSize, y:-scaledSize))  //scale/stratch
            
            let shape = SKShapeNode.init(path: bezier2Path.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let physicsBody = SKPhysicsBody.init(polygonFrom: bezier2Path.cgPath)
            physicsBody.isDynamic = false
            shape.physicsBody = physicsBody
            
            //needed to affect the phyics fields
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 75), itemStrength: itemStrength)
            
            self.addChild(shape)
        }

        
        if (secondHandType == SecondHandTypes.SecondHandTypePointy) {
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 0.5, y: 93))
            bezierPath.addCurve(to: CGPoint(x: 0.94, y: 3.89), controlPoint1: CGPoint(x: 0.5, y: 93), controlPoint2: CGPoint(x: 0.81, y: 30.59))
            bezierPath.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 2.7, y: 3.47), controlPoint2: CGPoint(x: 4, y: 1.88))
            bezierPath.addCurve(to: CGPoint(x: 0.98, y: -3.88), controlPoint1: CGPoint(x: 4, y: -1.87), controlPoint2: CGPoint(x: 2.72, y: -3.44))
            bezierPath.addCurve(to: CGPoint(x: 1, y: -8), controlPoint1: CGPoint(x: 0.99, y: -6.51), controlPoint2: CGPoint(x: 1, y: -8))
            bezierPath.addLine(to: CGPoint(x: -1, y: -8))
            bezierPath.addCurve(to: CGPoint(x: -0.98, y: -3.88), controlPoint1: CGPoint(x: -1, y: -8), controlPoint2: CGPoint(x: -0.99, y: -6.51))
            bezierPath.addCurve(to: CGPoint(x: -4, y: 0), controlPoint1: CGPoint(x: -2.72, y: -3.44), controlPoint2: CGPoint(x: -4, y: -1.87))
            bezierPath.addCurve(to: CGPoint(x: -0.94, y: 3.89), controlPoint1: CGPoint(x: -4, y: 1.88), controlPoint2: CGPoint(x: -2.7, y: 3.47))
            bezierPath.addCurve(to: CGPoint(x: -0.5, y: 93), controlPoint1: CGPoint(x: -0.81, y: 30.59), controlPoint2: CGPoint(x: -0.5, y: 93))
            bezierPath.addLine(to: CGPoint(x: 0.5, y: 93))
            bezierPath.addLine(to: CGPoint(x: 0.5, y: 93))
            bezierPath.close()
            
            let shape = SKShapeNode.init(path: bezierPath.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
        
            let phy =  SKPhysicsBody.init(polygonFrom: bezierPath.cgPath)
            phy.isDynamic = false
            shape.physicsBody = phy
            
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 85), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
 
        if (secondHandType == SecondHandTypes.SecondHandTypeSwiss) {
            
            let rect = CGRect(x: -2, y: -20, width: 4, height: 104)
            let bezierPath = UIBezierPath(rect: rect)
            bezierPath.flatness = 0.1
            
            let shape = SKShapeNode.init(path: bezierPath.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let phy = SKPhysicsBody.init(rectangleOf: rect.size, center: CGPoint.init(x: rect.midX, y: rect.midY))
            phy.isDynamic = false
            shape.physicsBody = phy
            
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 84), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
        
        
        if (secondHandType == SecondHandTypes.SecondHandTypeBlocky) {
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 0.8, y: 95))
            bezierPath.addCurve(to: CGPoint(x: 0.8, y: 11.59), controlPoint1: CGPoint(x: 0.8, y: 95), controlPoint2: CGPoint(x: 0.8, y: 41.91))
            bezierPath.addLine(to: CGPoint(x: 2, y: 11.59))
            bezierPath.addLine(to: CGPoint(x: 2, y: -4.88))
            bezierPath.addLine(to: CGPoint(x: 0.8, y: -4.88))
            bezierPath.addCurve(to: CGPoint(x: 0.8, y: -9), controlPoint1: CGPoint(x: 0.8, y: -7.51), controlPoint2: CGPoint(x: 0.8, y: -9))
            bezierPath.addLine(to: CGPoint(x: -0.8, y: -9))
            bezierPath.addCurve(to: CGPoint(x: -0.8, y: -4.88), controlPoint1: CGPoint(x: -0.8, y: -9), controlPoint2: CGPoint(x: -0.8, y: -7.51))
            bezierPath.addLine(to: CGPoint(x: -2, y: -4.88))
            bezierPath.addCurve(to: CGPoint(x: -2, y: 8.62), controlPoint1: CGPoint(x: -2, y: -4.88), controlPoint2: CGPoint(x: -2, y: 3.88))
            bezierPath.addCurve(to: CGPoint(x: -2, y: 11.59), controlPoint1: CGPoint(x: -2, y: 10.39), controlPoint2: CGPoint(x: -2, y: 11.59))
            bezierPath.addLine(to: CGPoint(x: -0.8, y: 11.59))
            bezierPath.addCurve(to: CGPoint(x: -0.8, y: 90.47), controlPoint1: CGPoint(x: -0.8, y: 36.57), controlPoint2: CGPoint(x: -0.8, y: 77))
            bezierPath.addCurve(to: CGPoint(x: -0.8, y: 95), controlPoint1: CGPoint(x: -0.8, y: 93.35), controlPoint2: CGPoint(x: -0.8, y: 95))
            bezierPath.addLine(to: CGPoint(x: 0.8, y: 95))
            bezierPath.addLine(to: CGPoint(x: 0.8, y: 95))
            bezierPath.close()
            
            let shape = SKShapeNode.init(path: bezierPath.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            let rect = CGRect.init(x: 0, y: 0, width: 2, height: 95)
            let phy = SKPhysicsBody.init(rectangleOf: rect.size, center: CGPoint.init(x: rect.midX, y: rect.midY))
            phy.isDynamic = false
            shape.physicsBody = physicsBody
            
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 90), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeRail) {
            let rect = CGRect.init(x: 0, y: 0, width: 1, height: 90)
            let shape = SKShapeNode.init(rect: rect)
            
            let phy = SKPhysicsBody.init(rectangleOf: rect.size, center: CGPoint.init(x: rect.midX, y: rect.midY))
            phy.isDynamic = false
            shape.physicsBody = physicsBody
            
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 85), itemStrength: itemStrength)
            
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            
            self.addChild(shape)
        }
        
        if (secondHandType == SecondHandTypes.SecondHandTypeRoman) {
            
            let secondHandPath = UIBezierPath()
            secondHandPath.move(to: CGPoint(x: -0.18, y: 291.2))
            secondHandPath.addCurve(to: CGPoint(x: -0.52, y: 291.18), controlPoint1: CGPoint(x: -0.29, y: 291.2), controlPoint2: CGPoint(x: -0.41, y: 291.19))
            secondHandPath.addCurve(to: CGPoint(x: -1.93, y: 290.8), controlPoint1: CGPoint(x: -1.01, y: 291.14), controlPoint2: CGPoint(x: -1.49, y: 291.01))
            secondHandPath.addCurve(to: CGPoint(x: -2.72, y: 290.3), controlPoint1: CGPoint(x: -2.21, y: 290.67), controlPoint2: CGPoint(x: -2.48, y: 290.5))
            secondHandPath.addCurve(to: CGPoint(x: -4.09, y: 288.47), controlPoint1: CGPoint(x: -3.34, y: 289.8), controlPoint2: CGPoint(x: -3.78, y: 289.14))
            secondHandPath.addCurve(to: CGPoint(x: -4.45, y: 287.48), controlPoint1: CGPoint(x: -4.24, y: 288.14), controlPoint2: CGPoint(x: -4.35, y: 287.8))
            secondHandPath.addCurve(to: CGPoint(x: -4.57, y: 286.98), controlPoint1: CGPoint(x: -4.49, y: 287.31), controlPoint2: CGPoint(x: -4.54, y: 287.14))
            secondHandPath.addCurve(to: CGPoint(x: -4.61, y: 286.77), controlPoint1: CGPoint(x: -4.58, y: 286.91), controlPoint2: CGPoint(x: -4.6, y: 286.85))
            secondHandPath.addCurve(to: CGPoint(x: -4.67, y: 286.49), controlPoint1: CGPoint(x: -4.61, y: 286.77), controlPoint2: CGPoint(x: -4.65, y: 286.58))
            secondHandPath.addCurve(to: CGPoint(x: -3.81, y: 282.93), controlPoint1: CGPoint(x: -4.87, y: 285.14), controlPoint2: CGPoint(x: -4.51, y: 283.88))
            secondHandPath.addCurve(to: CGPoint(x: -2.56, y: 281.76), controlPoint1: CGPoint(x: -3.45, y: 282.46), controlPoint2: CGPoint(x: -3.03, y: 282.07))
            secondHandPath.addCurve(to: CGPoint(x: -1.84, y: 281.35), controlPoint1: CGPoint(x: -2.33, y: 281.6), controlPoint2: CGPoint(x: -2.09, y: 281.46))
            secondHandPath.addLine(to: CGPoint(x: -1.47, y: 281.2))
            secondHandPath.addLine(to: CGPoint(x: -1.33, y: 281.14))
            secondHandPath.addCurve(to: CGPoint(x: -1.07, y: 281.06), controlPoint1: CGPoint(x: -1.33, y: 281.14), controlPoint2: CGPoint(x: -1.17, y: 281.09))
            secondHandPath.addCurve(to: CGPoint(x: -0.87, y: 281.01), controlPoint1: CGPoint(x: -0.97, y: 281.04), controlPoint2: CGPoint(x: -0.87, y: 281.01))
            secondHandPath.addLine(to: CGPoint(x: -0.67, y: 280.97))
            secondHandPath.addCurve(to: CGPoint(x: -0.26, y: 280.9), controlPoint1: CGPoint(x: -0.53, y: 280.94), controlPoint2: CGPoint(x: -0.4, y: 280.92))
            secondHandPath.addLine(to: CGPoint(x: -0.17, y: 280.89))
            secondHandPath.addCurve(to: CGPoint(x: 0.56, y: 280.88), controlPoint1: CGPoint(x: 0.07, y: 280.86), controlPoint2: CGPoint(x: 0.31, y: 280.87))
            secondHandPath.addCurve(to: CGPoint(x: 2.19, y: 281.24), controlPoint1: CGPoint(x: 1.11, y: 280.9), controlPoint2: CGPoint(x: 1.66, y: 281.02))
            secondHandPath.addCurve(to: CGPoint(x: 3.68, y: 282.19), controlPoint1: CGPoint(x: 2.73, y: 281.46), controlPoint2: CGPoint(x: 3.23, y: 281.78))
            secondHandPath.addCurve(to: CGPoint(x: 4.3, y: 282.86), controlPoint1: CGPoint(x: 3.9, y: 282.39), controlPoint2: CGPoint(x: 4.11, y: 282.61))
            secondHandPath.addCurve(to: CGPoint(x: 4.56, y: 283.25), controlPoint1: CGPoint(x: 4.39, y: 282.99), controlPoint2: CGPoint(x: 4.48, y: 283.12))
            secondHandPath.addLine(to: CGPoint(x: 4.67, y: 283.42))
            secondHandPath.addCurve(to: CGPoint(x: 4.79, y: 283.69), controlPoint1: CGPoint(x: 4.67, y: 283.42), controlPoint2: CGPoint(x: 4.75, y: 283.61))
            secondHandPath.addCurve(to: CGPoint(x: 4.9, y: 283.9), controlPoint1: CGPoint(x: 4.85, y: 283.79), controlPoint2: CGPoint(x: 4.9, y: 283.9))
            secondHandPath.addLine(to: CGPoint(x: 4.99, y: 284.13))
            secondHandPath.addCurve(to: CGPoint(x: 5.15, y: 284.61), controlPoint1: CGPoint(x: 5.05, y: 284.29), controlPoint2: CGPoint(x: 5.11, y: 284.44))
            secondHandPath.addCurve(to: CGPoint(x: 5.31, y: 285.61), controlPoint1: CGPoint(x: 5.24, y: 284.93), controlPoint2: CGPoint(x: 5.29, y: 285.27))
            secondHandPath.addCurve(to: CGPoint(x: 5, y: 287.72), controlPoint1: CGPoint(x: 5.35, y: 286.3), controlPoint2: CGPoint(x: 5.26, y: 287.03))
            secondHandPath.addCurve(to: CGPoint(x: 1.84, y: 290.86), controlPoint1: CGPoint(x: 4.5, y: 289.1), controlPoint2: CGPoint(x: 3.34, y: 290.32))
            secondHandPath.addCurve(to: CGPoint(x: -0.18, y: 291.2), controlPoint1: CGPoint(x: 1.2, y: 291.1), controlPoint2: CGPoint(x: 0.51, y: 291.21))
            secondHandPath.close()
            secondHandPath.move(to: CGPoint(x: 0.5, y: 326.75))
            secondHandPath.addCurve(to: CGPoint(x: 0.51, y: 326), controlPoint1: CGPoint(x: 0.5, y: 326.75), controlPoint2: CGPoint(x: 0.5, y: 326.26))
            secondHandPath.addCurve(to: CGPoint(x: 0.52, y: 325.08), controlPoint1: CGPoint(x: 0.51, y: 325.7), controlPoint2: CGPoint(x: 0.52, y: 325.39))
            secondHandPath.addCurve(to: CGPoint(x: 0.78, y: 308.74), controlPoint1: CGPoint(x: 0.61, y: 319.64), controlPoint2: CGPoint(x: 0.69, y: 314.19))
            secondHandPath.addCurve(to: CGPoint(x: 0.92, y: 299.2), controlPoint1: CGPoint(x: 0.82, y: 305.56), controlPoint2: CGPoint(x: 0.87, y: 302.38))
            secondHandPath.addCurve(to: CGPoint(x: 0.96, y: 292.35), controlPoint1: CGPoint(x: 0.94, y: 297.9), controlPoint2: CGPoint(x: 0.95, y: 294.05))
            secondHandPath.addCurve(to: CGPoint(x: 2.22, y: 292.17), controlPoint1: CGPoint(x: 1.38, y: 292.33), controlPoint2: CGPoint(x: 1.8, y: 292.27))
            secondHandPath.addCurve(to: CGPoint(x: 6.34, y: 289.31), controlPoint1: CGPoint(x: 3.83, y: 291.79), controlPoint2: CGPoint(x: 5.35, y: 290.78))
            secondHandPath.addCurve(to: CGPoint(x: 7.4, y: 283.97), controlPoint1: CGPoint(x: 7.34, y: 287.83), controlPoint2: CGPoint(x: 7.8, y: 285.94))
            secondHandPath.addLine(to: CGPoint(x: 7.34, y: 283.7))
            secondHandPath.addLine(to: CGPoint(x: 7.24, y: 283.32))
            secondHandPath.addCurve(to: CGPoint(x: 6.99, y: 282.63), controlPoint1: CGPoint(x: 7.16, y: 283.08), controlPoint2: CGPoint(x: 7.08, y: 282.86))
            secondHandPath.addCurve(to: CGPoint(x: 6.28, y: 281.33), controlPoint1: CGPoint(x: 6.8, y: 282.18), controlPoint2: CGPoint(x: 6.56, y: 281.74))
            secondHandPath.addCurve(to: CGPoint(x: 4.1, y: 279.29), controlPoint1: CGPoint(x: 5.71, y: 280.52), controlPoint2: CGPoint(x: 4.97, y: 279.82))
            secondHandPath.addCurve(to: CGPoint(x: 1.23, y: 278.28), controlPoint1: CGPoint(x: 3.24, y: 278.76), controlPoint2: CGPoint(x: 2.25, y: 278.42))
            secondHandPath.addLine(to: CGPoint(x: -0.17, y: 278.24))
            secondHandPath.addLine(to: CGPoint(x: -0.31, y: 278.25))
            secondHandPath.addCurve(to: CGPoint(x: -1.08, y: 278.35), controlPoint1: CGPoint(x: -0.57, y: 278.27), controlPoint2: CGPoint(x: -0.83, y: 278.3))
            secondHandPath.addLine(to: CGPoint(x: -1.46, y: 278.43))
            secondHandPath.addLine(to: CGPoint(x: -1.88, y: 278.55))
            secondHandPath.addLine(to: CGPoint(x: -2.15, y: 278.64))
            secondHandPath.addLine(to: CGPoint(x: -2.55, y: 278.79))
            secondHandPath.addCurve(to: CGPoint(x: -3.25, y: 279.13), controlPoint1: CGPoint(x: -2.79, y: 278.9), controlPoint2: CGPoint(x: -3.02, y: 279))
            secondHandPath.addCurve(to: CGPoint(x: -4.51, y: 280.02), controlPoint1: CGPoint(x: -3.7, y: 279.39), controlPoint2: CGPoint(x: -4.12, y: 279.68))
            secondHandPath.addCurve(to: CGPoint(x: -6.3, y: 282.45), controlPoint1: CGPoint(x: -5.28, y: 280.7), controlPoint2: CGPoint(x: -5.89, y: 281.53))
            secondHandPath.addCurve(to: CGPoint(x: -6.5, y: 288.14), controlPoint1: CGPoint(x: -7.14, y: 284.27), controlPoint2: CGPoint(x: -7.18, y: 286.38))
            secondHandPath.addCurve(to: CGPoint(x: -6.37, y: 288.43), controlPoint1: CGPoint(x: -6.49, y: 288.18), controlPoint2: CGPoint(x: -6.37, y: 288.43))
            secondHandPath.addCurve(to: CGPoint(x: -6.21, y: 288.78), controlPoint1: CGPoint(x: -6.32, y: 288.54), controlPoint2: CGPoint(x: -6.27, y: 288.67))
            secondHandPath.addCurve(to: CGPoint(x: -5.84, y: 289.38), controlPoint1: CGPoint(x: -6.09, y: 288.99), controlPoint2: CGPoint(x: -5.98, y: 289.19))
            secondHandPath.addCurve(to: CGPoint(x: -4.92, y: 290.41), controlPoint1: CGPoint(x: -5.58, y: 289.77), controlPoint2: CGPoint(x: -5.27, y: 290.11))
            secondHandPath.addCurve(to: CGPoint(x: -4.39, y: 290.83), controlPoint1: CGPoint(x: -4.75, y: 290.56), controlPoint2: CGPoint(x: -4.58, y: 290.7))
            secondHandPath.addCurve(to: CGPoint(x: -2.65, y: 291.73), controlPoint1: CGPoint(x: -3.84, y: 291.22), controlPoint2: CGPoint(x: -3.25, y: 291.51))
            secondHandPath.addCurve(to: CGPoint(x: -0.78, y: 292.22), controlPoint1: CGPoint(x: -2.03, y: 291.96), controlPoint2: CGPoint(x: -1.41, y: 292.11))
            secondHandPath.addCurve(to: CGPoint(x: -0.67, y: 296.29), controlPoint1: CGPoint(x: -0.81, y: 293.56), controlPoint2: CGPoint(x: -0.69, y: 294.95))
            secondHandPath.addCurve(to: CGPoint(x: -0.6, y: 301.06), controlPoint1: CGPoint(x: -0.65, y: 297.88), controlPoint2: CGPoint(x: -0.62, y: 299.47))
            secondHandPath.addCurve(to: CGPoint(x: -0.47, y: 310.06), controlPoint1: CGPoint(x: -0.55, y: 304.06), controlPoint2: CGPoint(x: -0.51, y: 307.06))
            secondHandPath.addCurve(to: CGPoint(x: -0.22, y: 326.01), controlPoint1: CGPoint(x: -0.39, y: 315.37), controlPoint2: CGPoint(x: -0.3, y: 320.69))
            secondHandPath.addCurve(to: CGPoint(x: -0.21, y: 326.75), controlPoint1: CGPoint(x: -0.22, y: 326.26), controlPoint2: CGPoint(x: -0.21, y: 326.75))
            secondHandPath.addLine(to: CGPoint(x: 0.5, y: 326.75))
            secondHandPath.addLine(to: CGPoint(x: 0.5, y: 326.75))
            secondHandPath.close()
            secondHandPath.move(to: CGPoint(x: 1.13, y: 236.43))
            secondHandPath.addCurve(to: CGPoint(x: 1.27, y: 226.45), controlPoint1: CGPoint(x: 1.18, y: 233.18), controlPoint2: CGPoint(x: 1.23, y: 229.85))
            secondHandPath.addCurve(to: CGPoint(x: 1.93, y: 226.67), controlPoint1: CGPoint(x: 1.5, y: 226.51), controlPoint2: CGPoint(x: 1.72, y: 226.58))
            secondHandPath.addCurve(to: CGPoint(x: 3.41, y: 227.61), controlPoint1: CGPoint(x: 2.47, y: 226.89), controlPoint2: CGPoint(x: 2.97, y: 227.21))
            secondHandPath.addCurve(to: CGPoint(x: 4.04, y: 228.29), controlPoint1: CGPoint(x: 3.64, y: 227.82), controlPoint2: CGPoint(x: 3.85, y: 228.04))
            secondHandPath.addCurve(to: CGPoint(x: 4.3, y: 228.68), controlPoint1: CGPoint(x: 4.13, y: 228.42), controlPoint2: CGPoint(x: 4.22, y: 228.55))
            secondHandPath.addLine(to: CGPoint(x: 4.41, y: 228.85))
            secondHandPath.addCurve(to: CGPoint(x: 4.53, y: 229.12), controlPoint1: CGPoint(x: 4.41, y: 228.85), controlPoint2: CGPoint(x: 4.49, y: 229.03))
            secondHandPath.addCurve(to: CGPoint(x: 4.64, y: 229.33), controlPoint1: CGPoint(x: 4.58, y: 229.22), controlPoint2: CGPoint(x: 4.64, y: 229.33))
            secondHandPath.addLine(to: CGPoint(x: 4.73, y: 229.56))
            secondHandPath.addCurve(to: CGPoint(x: 4.89, y: 230.03), controlPoint1: CGPoint(x: 4.79, y: 229.71), controlPoint2: CGPoint(x: 4.84, y: 229.87))
            secondHandPath.addCurve(to: CGPoint(x: 5.05, y: 231.04), controlPoint1: CGPoint(x: 4.97, y: 230.36), controlPoint2: CGPoint(x: 5.03, y: 230.7))
            secondHandPath.addCurve(to: CGPoint(x: 4.74, y: 233.15), controlPoint1: CGPoint(x: 5.09, y: 231.73), controlPoint2: CGPoint(x: 5, y: 232.46))
            secondHandPath.addCurve(to: CGPoint(x: 1.57, y: 236.29), controlPoint1: CGPoint(x: 4.24, y: 234.53), controlPoint2: CGPoint(x: 3.08, y: 235.75))
            secondHandPath.addCurve(to: CGPoint(x: 1.13, y: 236.43), controlPoint1: CGPoint(x: 1.43, y: 236.34), controlPoint2: CGPoint(x: 1.28, y: 236.39))
            secondHandPath.close()
            secondHandPath.move(to: CGPoint(x: -0.82, y: 236.61))
            secondHandPath.addCurve(to: CGPoint(x: -2.98, y: 235.73), controlPoint1: CGPoint(x: -1.61, y: 236.53), controlPoint2: CGPoint(x: -2.38, y: 236.22))
            secondHandPath.addCurve(to: CGPoint(x: -4.35, y: 233.9), controlPoint1: CGPoint(x: -3.6, y: 235.22), controlPoint2: CGPoint(x: -4.05, y: 234.56))
            secondHandPath.addCurve(to: CGPoint(x: -4.71, y: 232.9), controlPoint1: CGPoint(x: -4.5, y: 233.57), controlPoint2: CGPoint(x: -4.61, y: 233.23))
            secondHandPath.addCurve(to: CGPoint(x: -4.83, y: 232.41), controlPoint1: CGPoint(x: -4.75, y: 232.74), controlPoint2: CGPoint(x: -4.8, y: 232.57))
            secondHandPath.addCurve(to: CGPoint(x: -4.88, y: 232.2), controlPoint1: CGPoint(x: -4.84, y: 232.34), controlPoint2: CGPoint(x: -4.86, y: 232.28))
            secondHandPath.addCurve(to: CGPoint(x: -4.94, y: 231.92), controlPoint1: CGPoint(x: -4.88, y: 232.2), controlPoint2: CGPoint(x: -4.92, y: 232.01))
            secondHandPath.addCurve(to: CGPoint(x: -4.07, y: 228.36), controlPoint1: CGPoint(x: -5.13, y: 230.57), controlPoint2: CGPoint(x: -4.78, y: 229.31))
            secondHandPath.addCurve(to: CGPoint(x: -2.82, y: 227.19), controlPoint1: CGPoint(x: -3.71, y: 227.89), controlPoint2: CGPoint(x: -3.29, y: 227.49))
            secondHandPath.addCurve(to: CGPoint(x: -2.1, y: 226.78), controlPoint1: CGPoint(x: -2.59, y: 227.03), controlPoint2: CGPoint(x: -2.35, y: 226.89))
            secondHandPath.addLine(to: CGPoint(x: -1.73, y: 226.62))
            secondHandPath.addLine(to: CGPoint(x: -1.59, y: 226.57))
            secondHandPath.addCurve(to: CGPoint(x: -1.33, y: 226.49), controlPoint1: CGPoint(x: -1.59, y: 226.57), controlPoint2: CGPoint(x: -1.42, y: 226.52))
            secondHandPath.addCurve(to: CGPoint(x: -1.13, y: 226.44), controlPoint1: CGPoint(x: -1.23, y: 226.47), controlPoint2: CGPoint(x: -1.13, y: 226.44))
            secondHandPath.addCurve(to: CGPoint(x: -0.97, y: 226.41), controlPoint1: CGPoint(x: -1.13, y: 226.44), controlPoint2: CGPoint(x: -1.03, y: 226.42))
            secondHandPath.addCurve(to: CGPoint(x: -0.82, y: 236.61), controlPoint1: CGPoint(x: -0.92, y: 229.88), controlPoint2: CGPoint(x: -0.87, y: 233.29))
            secondHandPath.close()
            secondHandPath.move(to: CGPoint(x: 0.5, y: 278.09))
            secondHandPath.addCurve(to: CGPoint(x: 0.51, y: 277.35), controlPoint1: CGPoint(x: 0.5, y: 278.1), controlPoint2: CGPoint(x: 0.51, y: 277.6))
            secondHandPath.addCurve(to: CGPoint(x: 1.11, y: 237.75), controlPoint1: CGPoint(x: 0.68, y: 267.16), controlPoint2: CGPoint(x: 0.88, y: 253.41))
            secondHandPath.addCurve(to: CGPoint(x: 1.95, y: 237.6), controlPoint1: CGPoint(x: 1.39, y: 237.72), controlPoint2: CGPoint(x: 1.68, y: 237.67))
            secondHandPath.addCurve(to: CGPoint(x: 6.08, y: 234.73), controlPoint1: CGPoint(x: 3.57, y: 237.21), controlPoint2: CGPoint(x: 5.09, y: 236.21))
            secondHandPath.addCurve(to: CGPoint(x: 7.14, y: 229.4), controlPoint1: CGPoint(x: 7.07, y: 233.26), controlPoint2: CGPoint(x: 7.54, y: 231.37))
            secondHandPath.addLine(to: CGPoint(x: 7.08, y: 229.13))
            secondHandPath.addLine(to: CGPoint(x: 6.98, y: 228.75))
            secondHandPath.addCurve(to: CGPoint(x: 6.73, y: 228.06), controlPoint1: CGPoint(x: 6.9, y: 228.51), controlPoint2: CGPoint(x: 6.82, y: 228.29))
            secondHandPath.addCurve(to: CGPoint(x: 6.02, y: 226.76), controlPoint1: CGPoint(x: 6.53, y: 227.61), controlPoint2: CGPoint(x: 6.3, y: 227.17))
            secondHandPath.addCurve(to: CGPoint(x: 3.84, y: 224.72), controlPoint1: CGPoint(x: 5.45, y: 225.95), controlPoint2: CGPoint(x: 4.7, y: 225.25))
            secondHandPath.addCurve(to: CGPoint(x: 1.31, y: 223.76), controlPoint1: CGPoint(x: 3.07, y: 224.25), controlPoint2: CGPoint(x: 2.21, y: 223.92))
            secondHandPath.addCurve(to: CGPoint(x: 3.46, y: 60.99), controlPoint1: CGPoint(x: 2.27, y: 157.4), controlPoint2: CGPoint(x: 3.46, y: 68.15))
            secondHandPath.addCurve(to: CGPoint(x: 3.05, y: 20.87), controlPoint1: CGPoint(x: 3.46, y: 53.8), controlPoint2: CGPoint(x: 3.01, y: 24.51))
            secondHandPath.addCurve(to: CGPoint(x: 3.2, y: 6.41), controlPoint1: CGPoint(x: 3.11, y: 16.05), controlPoint2: CGPoint(x: 3.2, y: 11.23))
            secondHandPath.addCurve(to: CGPoint(x: -0.09, y: -15.2), controlPoint1: CGPoint(x: 3.2, y: -5.53), controlPoint2: CGPoint(x: -0.09, y: -15.2))
            secondHandPath.addCurve(to: CGPoint(x: -3.39, y: 6.41), controlPoint1: CGPoint(x: -0.09, y: -15.2), controlPoint2: CGPoint(x: -3.39, y: -5.52))
            secondHandPath.addCurve(to: CGPoint(x: -3.24, y: 20.86), controlPoint1: CGPoint(x: -3.39, y: 11.23), controlPoint2: CGPoint(x: -3.3, y: 16.05))
            secondHandPath.addCurve(to: CGPoint(x: -3.13, y: 60.99), controlPoint1: CGPoint(x: -3.21, y: 23.61), controlPoint2: CGPoint(x: -3.12, y: 53.82))
            secondHandPath.addCurve(to: CGPoint(x: -1.01, y: 223.72), controlPoint1: CGPoint(x: -3.13, y: 68.15), controlPoint2: CGPoint(x: -1.95, y: 157.36))
            secondHandPath.addCurve(to: CGPoint(x: -1.34, y: 223.77), controlPoint1: CGPoint(x: -1.12, y: 223.74), controlPoint2: CGPoint(x: -1.23, y: 223.75))
            secondHandPath.addLine(to: CGPoint(x: -1.72, y: 223.86))
            secondHandPath.addLine(to: CGPoint(x: -2.14, y: 223.98))
            secondHandPath.addLine(to: CGPoint(x: -2.41, y: 224.07))
            secondHandPath.addLine(to: CGPoint(x: -2.81, y: 224.22))
            secondHandPath.addCurve(to: CGPoint(x: -3.51, y: 224.56), controlPoint1: CGPoint(x: -3.06, y: 224.32), controlPoint2: CGPoint(x: -3.29, y: 224.43))
            secondHandPath.addCurve(to: CGPoint(x: -4.77, y: 225.44), controlPoint1: CGPoint(x: -3.96, y: 224.81), controlPoint2: CGPoint(x: -4.38, y: 225.11))
            secondHandPath.addCurve(to: CGPoint(x: -6.56, y: 227.88), controlPoint1: CGPoint(x: -5.54, y: 226.13), controlPoint2: CGPoint(x: -6.15, y: 226.96))
            secondHandPath.addCurve(to: CGPoint(x: -6.76, y: 233.57), controlPoint1: CGPoint(x: -7.4, y: 229.69), controlPoint2: CGPoint(x: -7.44, y: 231.81))
            secondHandPath.addCurve(to: CGPoint(x: -6.63, y: 233.86), controlPoint1: CGPoint(x: -6.75, y: 233.6), controlPoint2: CGPoint(x: -6.63, y: 233.86))
            secondHandPath.addCurve(to: CGPoint(x: -6.47, y: 234.21), controlPoint1: CGPoint(x: -6.58, y: 233.97), controlPoint2: CGPoint(x: -6.53, y: 234.09))
            secondHandPath.addCurve(to: CGPoint(x: -6.1, y: 234.81), controlPoint1: CGPoint(x: -6.36, y: 234.42), controlPoint2: CGPoint(x: -6.24, y: 234.62))
            secondHandPath.addCurve(to: CGPoint(x: -5.18, y: 235.84), controlPoint1: CGPoint(x: -5.84, y: 235.19), controlPoint2: CGPoint(x: -5.53, y: 235.54))
            secondHandPath.addCurve(to: CGPoint(x: -2.91, y: 237.16), controlPoint1: CGPoint(x: -4.5, y: 236.45), controlPoint2: CGPoint(x: -3.7, y: 236.87))
            secondHandPath.addCurve(to: CGPoint(x: -1.04, y: 237.64), controlPoint1: CGPoint(x: -2.29, y: 237.38), controlPoint2: CGPoint(x: -1.67, y: 237.53))
            secondHandPath.addCurve(to: CGPoint(x: -0.93, y: 241.71), controlPoint1: CGPoint(x: -1.07, y: 238.98), controlPoint2: CGPoint(x: -0.95, y: 240.38))
            secondHandPath.addCurve(to: CGPoint(x: -0.86, y: 246.48), controlPoint1: CGPoint(x: -0.91, y: 243.3), controlPoint2: CGPoint(x: -0.88, y: 244.89))
            secondHandPath.addCurve(to: CGPoint(x: -0.73, y: 255.48), controlPoint1: CGPoint(x: -0.82, y: 249.48), controlPoint2: CGPoint(x: -0.77, y: 252.49))
            secondHandPath.addCurve(to: CGPoint(x: -0.48, y: 271.43), controlPoint1: CGPoint(x: -0.65, y: 260.8), controlPoint2: CGPoint(x: -0.56, y: 266.12))
            secondHandPath.addCurve(to: CGPoint(x: -0.47, y: 272.17), controlPoint1: CGPoint(x: -0.48, y: 271.69), controlPoint2: CGPoint(x: -0.47, y: 272.17))
            secondHandPath.addCurve(to: CGPoint(x: -0.3, y: 272.17), controlPoint1: CGPoint(x: -0.47, y: 272.17), controlPoint2: CGPoint(x: -0.4, y: 272.17))
            secondHandPath.addCurve(to: CGPoint(x: -0.22, y: 277.35), controlPoint1: CGPoint(x: -0.27, y: 273.99), controlPoint2: CGPoint(x: -0.24, y: 275.71))
            secondHandPath.addCurve(to: CGPoint(x: -0.2, y: 278.09), controlPoint1: CGPoint(x: -0.21, y: 277.6), controlPoint2: CGPoint(x: -0.2, y: 278.09))
            secondHandPath.addCurve(to: CGPoint(x: 0.5, y: 278.1), controlPoint1: CGPoint(x: -0.03, y: 278.09), controlPoint2: CGPoint(x: 0.5, y: 278.1))
            secondHandPath.addLine(to: CGPoint(x: 0.5, y: 278.09))
            secondHandPath.close()
            
            secondHandPath.flatness = 0.5
            
            let shape = SKShapeNode.init(path: secondHandPath.cgPath)
            shape.setMaterial(material: material)
            shape.strokeColor = strokeColor
            shape.lineWidth = lineWidth
            shape.glowWidth = glowWidth
            shape.setScale(0.31)
            
            let rect = CGRect.init(x: 0, y: 0, width: 40, height: 275)
            let phy = SKPhysicsBody.init(rectangleOf: rect.size, center: CGPoint.init(x: rect.midX, y: rect.midY))
            phy.isDynamic = false
            shape.physicsBody = physicsBody
            
            addPhysicsField(fieldType: fieldType, node: shape, position: CGPoint.init(x: 0, y: 275), itemStrength: itemStrength)
            
            self.addChild(shape)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

