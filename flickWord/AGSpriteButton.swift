/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

enum AGButtonControlEvent : Int {
    case TouchDown = 1
    case TouchUp
    case TouchUpInside
    case AllEvents
}

class AGSpriteButton: SKSpriteNode {
    private var currentTouch: UITouch
    private var marrSelectors: [AnyObject]
    private var marrBlocks: [AnyObject]
    private var marrActions: [AnyObject]
    private var actionTouchDown: SKAction
    private var actionTouchUp: SKAction
    
    var exclusiveTouch: Bool
    var label: SKLabelNode
    class func buttonWithImageNamed(image: String) -> AGSpriteButton {
    }
    
    class func buttonWithColor(color: SKColor, andSize size: CGSize) -> AGSpriteButton {
    }
    
    class func buttonWithTexture(texture: SKTexture, andSize size: CGSize) -> AGSpriteButton {
    }
    
    class func buttonWithTexture(texture: SKTexture) -> AGSpriteButton {
    }
    
    func setLabelWithText(text: String, andFont font: UIFont, withColor fontColor: SKColor) {
        if self.label == nil {
            self.label = SKLabelNode.node()
            self.label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter
        } else {
            self.label.removeFromParent()
        }
        if text != nil {
            self.label.text = text
        }
        if font != nil {
            self.label.fontName = font.fontName
            self.label.fontSize = font.pointSize
        }
        if fontColor != nil {
            self.label.fontColor = fontColor
        }
        self.addChild(self.label)
    }
    
    func addTarget(target: AnyObject, selector: Selector, withObject object: AnyObject, forControlEvent controlEvent: AGButtonControlEvent) {
        if marrSelectors == nil {
            marrSelectors = NSMutableArray.new()
        }
        var mdicSelector = NSMutableDictionary()
        mdicSelector.setObject(target, forKey: "target")
        mdicSelector.setObject(NSValue.valueWithPointer(selector), forKey: "selector")
        if object {
            mdicSelector.setObject(object, forKey: "object")
        }
        mdicSelector.setObject(NSNumber.numberWithInt(controlEvent), forKey: "controlEvent")
        marrSelectors.addObject(mdicSelector)
    }
    
    func removeTarget(target: AnyObject, selector: Selector, forControlEvent controlEvent: AGButtonControlEvent) {
        var arrSelectors = marrSelectors.mutableCopy()
        for var i = 0; i < arrSelectors.count(); i++ {
            var dicSelector = arrSelectors.objectAtIndex(i)
            var shouldRemove = false
            var shouldCheckSelector = false
            var shouldCheckControlEvent = false
            var selTarget = dicSelector.objectForKey("target")
            var valSelector = dicSelector.objectForKey("selector")
            var selSelector = nil
            if valSelector {
                selSelector = valSelector.pointerValue()
            }
            var selControlEvent = dicSelector.objectForKey("controlEvent").intValue()
            if target != nil {
                if selTarget.isEqual(target) {
                    shouldCheckSelector = true
                }
            } else {
                shouldCheckSelector = true
            }
            if shouldCheckSelector {
                if selector != nil {
                    if selSelector == selector {
                        shouldCheckControlEvent = true
                    }
                } else {
                    shouldCheckControlEvent = true
                }
            }
            if shouldCheckControlEvent {
                if controlEvent == AGButtonControlEventAllEvents {
                    shouldRemove = true
                } else {
                    if selControlEvent == controlEvent {
                        shouldRemove = true
                    }
                }
            }
            if shouldRemove {
                arrSelectors.removeObject(dicSelector)
                i--
            }
        }
        marrSelectors = arrSelectors
    }
    
    func removeAllTargets() {
        marrSelectors.removeAllObjects()
        marrSelectors = nil
    }
    
    func performBlock(block: Void -> Void, onEvent event: AGButtonControlEvent) {
        var dicBlock = NSDictionary.dictionaryWithObjectsAndKeys(block, "block", NSNumber.numberWithInteger(event), "controlEvent", nil)
        if dicBlock {
            if marrBlocks == nil {
                marrBlocks = NSMutableArray.new()
            }
            marrBlocks.addObject(dicBlock)
        }
    }
    
    func performAction(action: SKAction, onNode object: SKNode, withEvent event: AGButtonControlEvent) {
        if object.respondsToSelector("runAction:") {
            var dicAction = NSDictionary.dictionaryWithObjectsAndKeys(action, "action", object, "object", NSNumber.numberWithInteger(event), "controlEvent", nil)
            if marrActions == nil {
                marrActions = NSMutableArray.new()
            }
            marrActions.addObject(dicAction)
        } else {
            NSException.raise("Incompatible object.", format: "Object %@ cannot perform actions.", object)
        }
    }
    
    func setTouchDownAction(action: SKAction) {
        actionTouchDown = action
    }
    
    func setTouchUpAction(action: SKAction) {
        actionTouchUp = action
    }
    
    func transformForTouchDown() {
        self.runAction(actionTouchDown)
    }
    
    func transformForTouchUp() {
        self.runAction(actionTouchUp)
    }
    
    class func buttonWithImageNamed(image: String) -> AGSpriteButton {
        var newButton = AGSpriteButton(imageNamed: image)
        return newButton
    }
    
    class func buttonWithColor(color: SKColor, andSize size: CGSize) -> AGSpriteButton {
        var newButton = AGSpriteButton(color: color, size: size)
        return newButton
    }
    
    class func buttonWithTexture(texture: SKTexture, andSize size: CGSize) -> AGSpriteButton {
        var newButton = AGSpriteButton(texture: texture, color: SKColor.whiteColor(), size: size)
        return newButton
    }
    
    class func buttonWithTexture(texture: SKTexture) -> AGSpriteButton {
        var newButton = AGSpriteButton(texture: texture)
        return newButton
    }
    
    init(name: String) {
        if self = super(imageNamed: name) {
            self.setBaseProperties()
        }
        return self
    }
    
    init(color: SKColor, size: CGSize) {
        if self = super(color: color, size: size) {
            self.setBaseProperties()
        }
        return self
    }
    
    init(texture: SKTexture, color: SKColor, size: CGSize) {
        if self = super(texture: texture, color: color, size: size) {
            self.setBaseProperties()
        }
        return self
    }
    
    init(texture: SKTexture) {
        if self = super(texture: texture) {
            self.setBaseProperties()
        }
        return self
    }
    
    init() {
        if self = super() {
            self.setBaseProperties()
        }
        return self
    }
    
    func setBaseProperties() {
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        actionTouchDown = SKAction.scaleBy(0.8, duration: 0.1)
        actionTouchUp = SKAction.scaleBy(1.25, duration: 0.1)
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if self.exclusiveTouch {
            if currentTouch == nil {
                currentTouch = touches.anyObject()
                self.controlEventOccured(AGButtonControlEventTouchDown)
                self.transformForTouchDown()
            } else {
                
            }
        }
    }
    
    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if self.exclusiveTouch {
            if touches.containsObject(currentTouch) {
                var touchPoint = currentTouch.locationInNode(self)
                var lenX = self.size.width / 2
                var lenY = self.size.height / 2
                if (touchPoint.x > lenX + 10) || (touchPoint.x < (-lenX - 10)) || (touchPoint.y > lenY + 10) || (touchPoint.y < (-lenY - 10)) {
                    self.touchesCancelled(touches, withEvent: Nil)
                }
            }
        }
    }
    
    func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if self.exclusiveTouch {
            if touches.containsObject(currentTouch) {
                self.controlEventOccured(AGButtonControlEventTouchUp)
                self.controlEventOccured(AGButtonControlEventTouchUpInside)
                currentTouch = Nil
                self.transformForTouchUp()
            }
        }
    }
    
    func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        if self.exclusiveTouch {
            if touches.containsObject(currentTouch) {
                currentTouch = Nil
                self.transformForTouchUp()
            }
        }
    }
    
    func transformForTouchDrag() {
        
    }
    
    func controlEventOccured(controlEvent: AGButtonControlEvent) {
        for dicSelector: [AnyObject: AnyObject] in marrSelectors {
            if dicSelector.objectForKey("controlEvent").integerValue() == controlEvent {
                var target = dicSelector.objectForKey("target")
                var selector = dicSelector.objectForKey("selector").pointerValue()
                var object = dicSelector.objectForKey("object")
                var imp = target.methodForSelector(selector)
                if object {
                    var (func)_ SEL: , _  = imp as! Void
                    func(target, selector, object)
                } else {
                    var (func)_ SEL:  = imp as! Void
                    func(target, selector)
                }
            }
        }
        for dicBlock: [AnyObject: AnyObject] in marrBlocks {
            if dicBlock.objectForKey("controlEvent").integerValue() == controlEvent {
                var block: Void -> Void = dicBlock.objectForKey("block")
                block()
            }
        }
        for dicAction: [AnyObject: AnyObject] in marrActions {
            if dicAction.objectForKey("controlEvent").integerValue() == controlEvent {
                var action = dicAction.objectForKey("action")
                var object = dicAction.objectForKey("object")
                object.runAction(action)
            }
        }
    }
}
