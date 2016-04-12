/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

class Bubble: SKNode {
    var _grabbed: Bool
    var _letter: String
    var _previousPos: CGPoint
    var _previousVelocity: CGPoint
    
    var grabbed: Bool
    var letter: String
    class func bubbleWithLetter(letter: String) -> instancetype {
    }
    
    init(letter: String) {
        self = super()
        if !self {
            return nil
        }
        self.name = letter
        var circle = SKSpriteNode.spriteNodeWithImageNamed("bubble")
        self.addChild(circle)
        _letter = letter
        var letterLabel = SKLabelNode(fontNamed: "Chalkduster")
        letterLabel.text = _letter
        letterLabel.fontSize = 48
        letterLabel.fontColor = UIColor.whiteColor()
        letterLabel.position = CGPointMake(self.position.x, self.position.y - 15)
        self.addChild(letterLabel)
        var body = SKPhysicsBody.bodyWithCircleOfRadius(circle.size.width * 0.5, center: CGPointZero)
        body.dynamic = true
        body.density = 2
        body.restitution = 0.3f
        body.usesPreciseCollisionDetection = true
        body.categoryBitMask = bubble
        body.collisionBitMask = wall | bubble
        body.contactTestBitMask = wall | bubble
        self.physicsBody = body
        self.userInteractionEnabled = true
        _grabbed = false
        self.xScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f
        self.yScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f
        return self
    }
    
    func update() {
        if self.physicsBody.dynamic && _grabbed {
            self.position = _previousPos
            self.physicsBody.velocity = CGVectorMake(0.0, 0.0)
        }
    }
    
    let wall = 0x1 << 0
    let bubble = 0x1 << 1
    class func bubbleWithLetter(letter: String) -> instancetype {
        return Bubble(letter: letter)
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch = touches.anyObject()
        var location = touch.locationInNode(self.parent)
        var touchNode = self.parent.nodeAtPoint(location)
        if touchNode != nil && touchNode.parent.isEqual(self) {
            _grabbed = true
            _previousPos = (self.isOKToMove(location)) ? location : _previousPos
            self.physicsBody.setAffectedByGravity(false)
        }
    }
    
    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if self.physicsBody.dynamic && _grabbed {
            var touch = touches.anyObject()
            var location = touch.locationInNode(self.parent)
            _previousVelocity = ccpMult(ccpSub(location, _previousPos), 5)
            _previousPos = (self.isOKToMove(location)) ? location : _previousPos
        }
    }
    
    func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if self.physicsBody.dynamic && _grabbed {
            _grabbed = false
            self.physicsBody.setAffectedByGravity(true)
            if ccpLength(_previousVelocity) > 90 {
                self.runAction(SKAction.playSoundFileNamed("hwick.wav", waitForCompletion: false))
            }
            self.physicsBody.applyImpulse(CGVectorMake(_previousVelocity.x, _previousVelocity.y))
        }
    }
    
    func isOKToMove(newPoint: CGPoint) -> Bool {
        var borderRect = self.parent as! MyScene.borderRect()
        return (newPoint.x > borderRect.origin.x && newPoint.x < borderRect.size.width && newPoint.y > borderRect.origin.y && newPoint.y < borderRect.size.height)
    }
}
