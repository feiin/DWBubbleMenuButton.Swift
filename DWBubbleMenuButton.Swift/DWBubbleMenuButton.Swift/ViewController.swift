//
//  ViewController.swift
//  DWBubbleMenuButton.Swift
//
//  Created by feiin on 14/10/25.
//  Copyright (c) 2014 year swiftmi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
         var menuButton =UIButton.buttonWithType(UIButtonType.System)
        
        
        // Create down menu button
        var homeLabel = self.createHomeButtonView()
        
        var downMenuButton = DWBubbleMenuButton(frame: CGRectMake(20.0,
            20.0,
            homeLabel.frame.size.width,
            homeLabel.frame.size.height), expansionDirection: ExpansionDirection.DirectionDown)
       downMenuButton.homeButtonView = homeLabel;
       downMenuButton.addButtons(self.createDemoButtonArray())
      self.view.addSubview(downMenuButton)

        
        
        // Create up menu button
        var homeLabel2 =  self.createHomeButtonView()
        
        var upMenuView = DWBubbleMenuButton(frame: CGRectMake(self.view.frame.size.width - homeLabel2.frame.size.width - 20.0,self.view.frame.size.height - homeLabel2.frame.size.height - 20.0,
            homeLabel2.frame.size.width,homeLabel2.frame.size.height),expansionDirection: .DirectionUp)
        upMenuView.homeButtonView = homeLabel2
        
        upMenuView.addButtons(self.createDemoButtonArray())
        
        self.view.addSubview(upMenuView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createHomeButtonView() -> UILabel {
        
        var label = UILabel(frame: CGRectMake(0.0, 0.0, 40.0, 40.0))
    
        label.text = "Tap";
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = label.frame.size.height / 2.0;
        label.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
        label.clipsToBounds = true;
    
        return label;
    }
    
    func createDemoButtonArray() -> [UIButton] {
        var buttons:[UIButton]=[]
        var i = 0
        for str in ["A","B","C","D","E","F"] {
            var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitle(str, forState: UIControlState.Normal)
            
            button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
            button.layer.cornerRadius = button.frame.size.height / 2.0;
            button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            button.clipsToBounds = true;
            button.tag = i++;
            button.addTarget(self, action: Selector("buttonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            buttons.append(button)
            
        }
        return buttons
        
    }
    
    func createButtonWithName(imageName:NSString) -> UIButton {
        var button = UIButton()
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.sizeToFit()
        button.addTarget(self, action: Selector("buttonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        
    }
    
    func buttonTap(sender:UIButton){

        println("Button tapped, tag:\(sender.tag)")
    }
    
       
  


}

