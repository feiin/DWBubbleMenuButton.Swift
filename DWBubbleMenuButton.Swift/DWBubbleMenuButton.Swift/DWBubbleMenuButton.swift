//
//  DWBubbleMenuButton.swift
//  DWBubbleMenuButton.Swift
//
//  Created by feiin on 14/10/25.
//  Copyright (c) 2014 year swiftmi. All rights reserved.
//

import Foundation
import UIKit

///ExpansionDirection
enum ExpansionDirection:Int{
    case DirectionLeft = 0
    case DirectionRight
    case DirectionUp
    case DirectionDown
}
///----
///DWBubbleMenuViewDelegate protocol
protocol DWBubbleMenuViewDelegate:NSObjectProtocol{
    
    func bubbleMenuButtonWillExpand(expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonDidExpand(expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonWillCollapse(expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonDidCollapse(expandableView:DWBubbleMenuButton)
}

///DWBubbleMenuButton
class DWBubbleMenuButton:UIView,UIGestureRecognizerDelegate{
    
    var tapGestureRecognizer:UITapGestureRecognizer!
    var buttonContainer:[UIButton] = []
    var originFrame:CGRect!
    
    var direction:ExpansionDirection?
    
    weak var delegate:DWBubbleMenuViewDelegate?
    
    var buttonSpacing:CGFloat = 20
    var _homeButtonView:UIView?
    var homeButtonView:UIView?{
        get{
            return _homeButtonView
        }
        set{
            if(self._homeButtonView != newValue){
                self._homeButtonView = newValue
            }
            
            if self._homeButtonView!.isDescendantOfView(self) == false {
                self.addSubview(self._homeButtonView!)
            }
        }
    }
    
    var animationDuration:Double = 0.25
    
    var isCollapsed:Bool = false
    
    var collapseAfterSelection = false
    
    var animatedHighlighting = false
    
    var standbyAlpha:CGFloat = 0.0
    var highlightAlpha:CGFloat = 0.0
    
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            
            let touchLocation:CGPoint = self.tapGestureRecognizer.locationInView(self)
            
            if (self.collapseAfterSelection && isCollapsed == false && CGRectContainsPoint(self.homeButtonView!.frame, touchLocation) == false) {
               self.dismissButtons()
                
            }

        }
    }
    
    func _animateWithBlock(block: (() -> Void)!){
        
        UIView.transitionWithView(self, duration: self.animationDuration, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: block, completion: nil)
    }
    

    func _setTouchHighlighted(highlighted:Bool)
    {
        
        let alphaValue = highlighted ? highlightAlpha : standbyAlpha;
    
        if (self.homeButtonView!.alpha == alphaValue) {
           return
        }
        
        if (animatedHighlighting) {
            self._animateWithBlock{
                
                if(self.homeButtonView != nil){
                    self.homeButtonView!.alpha = alphaValue;
                }
            }
            
        } else {
            self._animateWithBlock{
                if(self.homeButtonView != nil){
                    self.homeButtonView!.alpha = alphaValue;
                }
            }

        }
    
    }
    
    
    ///add buttons
    func addButtons(buttons:[UIButton]){
        
        for  button in buttons{
            self.addButton(button)
        }
        
        if(self.homeButtonView != nil){
            self.bringSubviewToFront(self.homeButtonView!)
          
        }
    }
    
    ///add button
    func addButton(button:UIButton){
       
        if !self._containsButton(button) {
            self.buttonContainer.append(button)
            self.addSubview(button)
            button.hidden=true
            
            
        }
        
    }
    
    func _containsButton(button:UIButton)->Bool {
        for b in self.buttonContainer {
            if b == button{
                return true
            }
        }
        return false
    }
    
    func showButtons(){
        
        if (self.delegate?.respondsToSelector(Selector("bubbleMenuButtonWillExpand:")) != nil) {
            self.delegate?.bubbleMenuButtonWillExpand(self)
        }
        
        self._prepareForButtonExpansion()
        self.userInteractionEnabled = false
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock{
            
            
            
            for btn in self.buttonContainer {
                
               (btn as UIButton).transform = CGAffineTransformIdentity
            }
            
            if(self.delegate != nil){
                if (self.delegate?.respondsToSelector(Selector("bubbleMenuButtonDidExpand:")) != nil) {
                    self.delegate?.bubbleMenuButtonDidExpand(self)
                }
            }
            self.userInteractionEnabled = true
        }
        
        var btnContainer:[UIButton] = buttonContainer
        
        if self.direction == .DirectionUp || direction == .DirectionLeft {
            btnContainer = Array(self.buttonContainer.reverse())
            
        }
        
        for i in 0..<btnContainer.count {
            
            let index = btnContainer.count - (i + 1)
            let button = btnContainer[index]
            button.hidden = false
            
            // position animation
            let positionAnimation = CABasicAnimation(keyPath: "position")
            
            var originPosition = CGPointZero
            var finalPosition = CGPointZero
           
          
            
            switch (self.direction!) {
            case .DirectionLeft:
                
                originPosition = CGPointMake(self.frame.size.width - self.homeButtonView!.frame.size.width, self.frame.size.height/2)
                
                finalPosition = CGPointMake(self.frame.size.width - self.homeButtonView!.frame.size.width - button.frame.size.width/2.0 - self.buttonSpacing
                    - ((button.frame.size.width + self.buttonSpacing)*CGFloat(index)),
                    self.frame.size.height/2.0)
               
                
            case .DirectionRight:
                originPosition = CGPointMake(self.homeButtonView!.frame.size.width, self.frame.size.height/2.0)
                
                finalPosition = CGPointMake(self.homeButtonView!.frame.size.width + self.buttonSpacing + button.frame.size.width/2.0
                    + ((button.frame.size.width + self.buttonSpacing)*CGFloat(index)),
                    self.frame.size.height/2.0)
              
                
            case .DirectionUp:
                originPosition = CGPointMake(self.frame.size.width/2.0, self.frame.size.height - self.homeButtonView!.frame.size.height)
                
                finalPosition = CGPointMake(self.frame.size.width/2.0,
                    self.frame.size.height - self.homeButtonView!.frame.size.height - self.buttonSpacing - button.frame.size.height/2.0
                        - ((button.frame.size.height + self.buttonSpacing)*CGFloat(index)));
              
                
            case .DirectionDown:
                originPosition = CGPointMake(self.frame.size.width/2.0, self.homeButtonView!.frame.size.height)
                
                finalPosition = CGPointMake(self.frame.size.width/2.0,
                    self.homeButtonView!.frame.size.height + self.buttonSpacing + button.frame.size.height/2.0
                        + ((button.frame.size.height + self.buttonSpacing)*CGFloat(index)));
              
            }

            
            
            positionAnimation.duration = self.animationDuration;
            positionAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            
            
        
            
            positionAnimation.fromValue = NSValue(CGPoint:originPosition)
            positionAnimation.toValue = NSValue(CGPoint:finalPosition)
            positionAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(btnContainer.count)*Double(i));
            positionAnimation.fillMode = kCAFillModeForwards;
            positionAnimation.removedOnCompletion = false;
            
            button.layer.addAnimation(positionAnimation,forKey: "positionAnimation")
            button.layer.position = finalPosition;
            
            
            // scale animation
           let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            
            scaleAnimation.duration = self.animationDuration;
            
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            
            scaleAnimation.fromValue = NSNumber(float: 0.01)
            scaleAnimation.toValue = NSNumber(float:1.0)
            
            scaleAnimation.beginTime = CACurrentMediaTime() + (animationDuration/Double(btnContainer.count) * Double(i)) + 0.03;
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.removedOnCompletion = false;
            
            button.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            
             button.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
        
        
        CATransaction.commit()
        
        
        isCollapsed = false
        
    }
    
    func _finishCollapse(){
         self.frame = originFrame;
    }
    
    
    func dismissButtons(){
        
    
        
        if (self.delegate?.respondsToSelector(Selector("bubbleMenuButtonWillCollapse:")) != nil) {
            self.delegate?.bubbleMenuButtonWillCollapse(self)
        }

        
        
        self.userInteractionEnabled = false;
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationDuration)
        
        CATransaction.setCompletionBlock{
            
            self._finishCollapse()
            
            for btn in self.buttonContainer {
                
                let button = btn as UIButton
                button.transform = CGAffineTransformIdentity
                button.hidden = true
            }
            
            if (self.delegate != nil) {
                
                if (self.delegate?.respondsToSelector(Selector("bubbleMenuButtonDidCollapse:")) != nil) {
                    self.delegate?.bubbleMenuButtonDidCollapse(self)
                }
               
            }
            
            self.userInteractionEnabled = true;
        }
        
        
         var index=0;
         let arr = (0...(buttonContainer.count-1)).reverse()
         for i in arr {
            
            var button = buttonContainer[i]
            
            
            if (self.direction == .DirectionDown || self.direction == .DirectionRight) {
                button = buttonContainer[index]
            }
            
            // scale animation
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = self.animationDuration;
            
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            scaleAnimation.fromValue = NSNumber(float: 1.0)
            scaleAnimation.toValue = NSNumber(float: 0.01)
             scaleAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(buttonContainer.count) * Double(index)) + 0.03;
            
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.removedOnCompletion = false;
            
            button.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            // position animation
            let positionAnimation = CABasicAnimation(keyPath: "position")
            
            let originPosition = button.layer.position;
            var finalPosition = CGPointZero;
            
            switch (self.direction!) {
            case .DirectionLeft:
                finalPosition = CGPointMake(self.frame.size.width - self.homeButtonView!.frame.size.width, self.frame.size.height/2.0)
                
            case .DirectionRight:
                finalPosition = CGPointMake(self.homeButtonView!.frame.size.width, self.frame.size.height/2.0)
              
                
            case .DirectionUp:
                finalPosition = CGPointMake(self.frame.size.width/2.0, self.frame.size.height - self.homeButtonView!.frame.size.height);
            
            case .DirectionDown:
                finalPosition = CGPointMake(self.frame.size.width/2.0, self.homeButtonView!.frame.size.height)
                
            }
            
            positionAnimation.duration = self.animationDuration;
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            positionAnimation.fromValue = NSValue(CGPoint:originPosition)
            positionAnimation.toValue = NSValue(CGPoint:finalPosition)
            positionAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(self.buttonContainer.count) * Double(index));
            positionAnimation.fillMode = kCAFillModeForwards;
            positionAnimation.removedOnCompletion = false;
            
            button.layer.addAnimation(positionAnimation, forKey:"positionAnimation")
            button.layer.position = originPosition;
            index += 1;

            
        }
        CATransaction.commit()
        
        isCollapsed = true;
    }
    
    
    func _prepareForButtonExpansion(){
        let buttonHeight:CGFloat = self._combinedButtonHeight()
        let buttonWidth:CGFloat = self._combinedButtonWidth()
        
        switch(self.direction!){
            case .DirectionUp:
             self.homeButtonView!.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
             var frame = self.frame
             frame.origin.y -=  buttonHeight
             frame.size.height += buttonHeight
             self.frame = frame
            
        case .DirectionDown:
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin
            var frame = self.frame
            frame.size.height += buttonHeight
            self.frame = frame
        case .DirectionLeft:
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
            var frame = self.frame
            frame.origin.x -=  buttonWidth

            frame.size.width += buttonWidth
            self.frame = frame
            
        case .DirectionRight:
            
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
            var frame = self.frame
            frame.size.width += buttonWidth
            self.frame = frame
        }
    }
    
  
    
    
    func _combinedButtonHeight() -> CGFloat {
        
        var height:CGFloat = 0;
        
        for button in buttonContainer {
            height += button.frame.size.height + self.buttonSpacing
        }
        return height
    }
    
    func _combinedButtonWidth() -> CGFloat {
        
        var width:CGFloat = 0;
        
        for button in buttonContainer {
            width += button.frame.size.width + self.buttonSpacing
        }
        
        return width
    }
    
    
    func _defaultInit() {
     
        
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
        
        self.direction = .DirectionUp;
        self.animatedHighlighting = true;
        self.collapseAfterSelection = true;
        
        self.standbyAlpha = 1.0;
        self.highlightAlpha = 0.450;
        self.originFrame = self.frame;
        self.buttonSpacing = 20.0;
        isCollapsed = true;

        
        
        self.originFrame = self.frame;
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DWBubbleMenuButton.handleTapGesture(_:)))
        self.tapGestureRecognizer.cancelsTouchesInView = false
        self.tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
   
    override init(frame: CGRect) {
 
        super.init(frame: frame)
        _defaultInit()
        
        
    }
    
    convenience init(frame: CGRect,expansionDirection direction:ExpansionDirection) {
        self.init(frame: frame)
        self._defaultInit()
        self.direction = direction
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //pragma mark -
    //pragma mark Touch Handling Methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
       // var touch = touches.first
        
        self._setTouchHighlighted(true)
        
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        
        //print("touchesMoved")
        let touch = touches.first! as UITouch
        self._setTouchHighlighted(false)
        
        if(CGRectContainsPoint(self.homeButtonView!.frame, touch.locationInView(self))) {
            if(isCollapsed){
                self.showButtons()
            }
            else{
                self.dismissButtons()
            }
        }
    }
    
    override func touchesCancelled(touches:Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        self._setTouchHighlighted(false)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesMoved(touches, withEvent: event)
        
        let touch=touches.first! as UITouch
        self._setTouchHighlighted(CGRectContainsPoint(self.homeButtonView!.frame, touch.locationInView(self)))
        
    }
    
    //pragma mark -
    //pragma mark UIGestureRecognizer Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let touchLocation =  touch.locationInView(self)
        
        if (self._subviewForPoint(touchLocation) != self && collapseAfterSelection) {
            return true;
        }
        
        return false;

    }
    
    func _subviewForPoint(point:CGPoint) -> UIView {
        for subView in self.subviews
        {
            if (CGRectContainsPoint(subView.frame, point)) {
                return subView ;
            }

        }
        return self
    }
    
}



