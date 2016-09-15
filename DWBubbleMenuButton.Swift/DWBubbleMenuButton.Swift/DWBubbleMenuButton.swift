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
    case directionLeft = 0
    case directionRight
    case directionUp
    case directionDown
}
///----
///DWBubbleMenuViewDelegate protocol
protocol DWBubbleMenuViewDelegate:NSObjectProtocol{
    
    func bubbleMenuButtonWillExpand(_ expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonDidExpand(_ expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonWillCollapse(_ expandableView:DWBubbleMenuButton)
    func bubbleMenuButtonDidCollapse(_ expandableView:DWBubbleMenuButton)
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
            
            if self._homeButtonView!.isDescendant(of: self) == false {
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
    
    
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            
            let touchLocation:CGPoint = self.tapGestureRecognizer.location(in: self)
            
            if (self.collapseAfterSelection && isCollapsed == false && self.homeButtonView!.frame.contains(touchLocation) == false) {
               self.dismissButtons()
                
            }

        }
    }
    
    func _animateWithBlock(_ block: (() -> Void)!){
        
        UIView.transition(with: self, duration: self.animationDuration, options: UIViewAnimationOptions.beginFromCurrentState, animations: block, completion: nil)
    }
    

    func _setTouchHighlighted(_ highlighted:Bool)
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
    func addButtons(_ buttons:[UIButton]){
        
        for  button in buttons{
            self.addButton(button)
        }
        
        if(self.homeButtonView != nil){
            self.bringSubview(toFront: self.homeButtonView!)
          
        }
    }
    
    ///add button
    func addButton(_ button:UIButton){
       
        if !self._containsButton(button) {
            self.buttonContainer.append(button)
            self.addSubview(button)
            button.isHidden=true
            
            
        }
        
    }
    
    func _containsButton(_ button:UIButton)->Bool {
        for b in self.buttonContainer {
            if b == button{
                return true
            }
        }
        return false
    }
    
    func showButtons(){
        
        if (self.delegate?.responds(to: Selector("bubbleMenuButtonWillExpand:")) != nil) {
            self.delegate?.bubbleMenuButtonWillExpand(self)
        }
        
        self._prepareForButtonExpansion()
        self.isUserInteractionEnabled = false
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock{
            
            
            
            for btn in self.buttonContainer {
                
               (btn as UIButton).transform = CGAffineTransform.identity
            }
            
            if(self.delegate != nil){
                if (self.delegate?.responds(to: Selector("bubbleMenuButtonDidExpand:")) != nil) {
                    self.delegate?.bubbleMenuButtonDidExpand(self)
                }
            }
            self.isUserInteractionEnabled = true
        }
        
        var btnContainer:[UIButton] = buttonContainer
        
        if self.direction == .directionUp || direction == .directionLeft {
            btnContainer = Array(self.buttonContainer.reversed())
            
        }
        
        for i in 0..<btnContainer.count {
            
            let index = btnContainer.count - (i + 1)
            let button = btnContainer[index]
            button.isHidden = false
            
            // position animation
            let positionAnimation = CABasicAnimation(keyPath: "position")
            
            var originPosition = CGPoint.zero
            var finalPosition = CGPoint.zero
           
          
            
            switch (self.direction!) {
            case .directionLeft:
                
                originPosition = CGPoint(x: self.frame.size.width - self.homeButtonView!.frame.size.width, y: self.frame.size.height/2)
                let x = self.frame.size.width - self.homeButtonView!.frame.size.width - button.frame.size.width/2.0 - self.buttonSpacing
                    - ((button.frame.size.width + self.buttonSpacing)*CGFloat(index))
                finalPosition = CGPoint(x:x,y: self.frame.size.height/2.0)
               
                
            case .directionRight:
                originPosition = CGPoint(x: self.homeButtonView!.frame.size.width, y: self.frame.size.height/2.0)
                
                let x = self.homeButtonView!.frame.size.width + self.buttonSpacing + button.frame.size.width/2.0
                    + ((button.frame.size.width + self.buttonSpacing)*CGFloat(index))
                finalPosition = CGPoint(x:x, y: self.frame.size.height/2.0)
        
                
            case .directionUp:
                originPosition = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height - self.homeButtonView!.frame.size.height)
                
                finalPosition = CGPoint(x: self.frame.size.width/2.0,
                    y: self.frame.size.height - self.homeButtonView!.frame.size.height - self.buttonSpacing - button.frame.size.height/2.0
                        - ((button.frame.size.height + self.buttonSpacing)*CGFloat(index)));
              
                
            case .directionDown:
                originPosition = CGPoint(x: self.frame.size.width/2.0, y: self.homeButtonView!.frame.size.height)
                
                finalPosition = CGPoint(x: self.frame.size.width/2.0,
                    y: self.homeButtonView!.frame.size.height + self.buttonSpacing + button.frame.size.height/2.0
                        + ((button.frame.size.height + self.buttonSpacing)*CGFloat(index)));
              
            }

            
            
            positionAnimation.duration = self.animationDuration;
            positionAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            
            
        
            
            positionAnimation.fromValue = NSValue(cgPoint:originPosition)
            positionAnimation.toValue = NSValue(cgPoint:finalPosition)
            positionAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(btnContainer.count)*Double(i));
            positionAnimation.fillMode = kCAFillModeForwards;
            positionAnimation.isRemovedOnCompletion = false;
            
            button.layer.add(positionAnimation,forKey: "positionAnimation")
            button.layer.position = finalPosition;
            
            
            // scale animation
           let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            
            scaleAnimation.duration = self.animationDuration;
            
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            
            scaleAnimation.fromValue = NSNumber(value: 0.01 as Float)
            scaleAnimation.toValue = NSNumber(value: 1.0 as Float)
            
            scaleAnimation.beginTime = CACurrentMediaTime() + (animationDuration/Double(btnContainer.count) * Double(i)) + 0.03;
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.isRemovedOnCompletion = false;
            
            button.layer.add(scaleAnimation, forKey: "scaleAnimation")
            
             button.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
        }
        
        
        CATransaction.commit()
        
        
        isCollapsed = false
        
    }
    
    func _finishCollapse(){
         self.frame = originFrame;
    }
    
    
    func dismissButtons(){
        
    
        
        if (self.delegate?.responds(to: Selector("bubbleMenuButtonWillCollapse:")) != nil) {
            self.delegate?.bubbleMenuButtonWillCollapse(self)
        }

        
        
        self.isUserInteractionEnabled = false;
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationDuration)
        
        CATransaction.setCompletionBlock{
            
            self._finishCollapse()
            
            for btn in self.buttonContainer {
                
                let button = btn as UIButton
                button.transform = CGAffineTransform.identity
                button.isHidden = true
            }
            
            if (self.delegate != nil) {
                
                if (self.delegate?.responds(to: Selector("bubbleMenuButtonDidCollapse:")) != nil) {
                    self.delegate?.bubbleMenuButtonDidCollapse(self)
                }
               
            }
            
            self.isUserInteractionEnabled = true;
        }
        
        
         var index=0;
         let arr = (0...(buttonContainer.count-1)).reversed()
         for i in arr {
            
            var button = buttonContainer[i]
            
            
            if (self.direction == .directionDown || self.direction == .directionRight) {
                button = buttonContainer[index]
            }
            
            // scale animation
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = self.animationDuration;
            
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            scaleAnimation.fromValue = NSNumber(value: 1.0 as Float)
            scaleAnimation.toValue = NSNumber(value: 0.01 as Float)
             scaleAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(buttonContainer.count) * Double(index)) + 0.03;
            
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.isRemovedOnCompletion = false;
            
            button.layer.add(scaleAnimation, forKey: "scaleAnimation")
            
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            
            // position animation
            let positionAnimation = CABasicAnimation(keyPath: "position")
            
            let originPosition = button.layer.position;
            var finalPosition = CGPoint.zero;
            
            switch (self.direction!) {
            case .directionLeft:
                finalPosition = CGPoint(x: self.frame.size.width - self.homeButtonView!.frame.size.width, y: self.frame.size.height/2.0)
                
            case .directionRight:
                finalPosition = CGPoint(x: self.homeButtonView!.frame.size.width, y: self.frame.size.height/2.0)
              
                
            case .directionUp:
                finalPosition = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height - self.homeButtonView!.frame.size.height);
            
            case .directionDown:
                finalPosition = CGPoint(x: self.frame.size.width/2.0, y: self.homeButtonView!.frame.size.height)
                
            }
            
            positionAnimation.duration = self.animationDuration;
            positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            positionAnimation.fromValue = NSValue(cgPoint:originPosition)
            positionAnimation.toValue = NSValue(cgPoint:finalPosition)
            positionAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/Double(self.buttonContainer.count) * Double(index));
            positionAnimation.fillMode = kCAFillModeForwards;
            positionAnimation.isRemovedOnCompletion = false;
            
            button.layer.add(positionAnimation, forKey:"positionAnimation")
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
            case .directionUp:
             self.homeButtonView!.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
             var frame = self.frame
             frame.origin.y -=  buttonHeight
             frame.size.height += buttonHeight
             self.frame = frame
            
        case .directionDown:
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin
            var frame = self.frame
            frame.size.height += buttonHeight
            self.frame = frame
        case .directionLeft:
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
            var frame = self.frame
            frame.origin.x -=  buttonWidth

            frame.size.width += buttonWidth
            self.frame = frame
            
        case .directionRight:
            
            self.homeButtonView!.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
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
        
        self.direction = .directionUp;
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
       // var touch = touches.first
        
        self._setTouchHighlighted(true)
        
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
        //print("touchesMoved")
        let touch = touches.first! as UITouch
        self._setTouchHighlighted(false)
        
        if(self.homeButtonView!.frame.contains(touch.location(in: self))) {
            if(isCollapsed){
                self.showButtons()
            }
            else{
                self.dismissButtons()
            }
        }
    }
    
    override func touchesCancelled(_ touches:Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self._setTouchHighlighted(false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        let touch=touches.first! as UITouch
        self._setTouchHighlighted(self.homeButtonView!.frame.contains(touch.location(in: self)))
        
    }
    
    //pragma mark -
    //pragma mark UIGestureRecognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let touchLocation =  touch.location(in: self)
        
        if (self._subviewForPoint(touchLocation) != self && collapseAfterSelection) {
            return true;
        }
        
        return false;

    }
    
    func _subviewForPoint(_ point:CGPoint) -> UIView {
        for subView in self.subviews
        {
            if (subView.frame.contains(point)) {
                return subView ;
            }

        }
        return self
    }
    
}



