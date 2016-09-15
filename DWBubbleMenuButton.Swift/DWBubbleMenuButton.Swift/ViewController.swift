//
//  ViewController.swift
//  DWBubbleMenuButton.Swift
//
//  Created by feiin on 14/10/25.
//  Copyright (c) 2014 year swiftmi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    var downMenuButton:DWBubbleMenuButton!
    
    var upMenuView:DWBubbleMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func hiddenAll(_ sender: AnyObject) {
        
        downMenuButton.dismissButtons()
        upMenuView.dismissButtons()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        // Create down menu button
        let homeLabel = self.createHomeButtonView()
        
         downMenuButton = DWBubbleMenuButton(frame: CGRect(x: 20.0,
            y: 20.0,
            width: homeLabel.frame.size.width,
            height: homeLabel.frame.size.height), expansionDirection: ExpansionDirection.directionDown)
       downMenuButton.homeButtonView = homeLabel;
       downMenuButton.addButtons(self.createDemoButtonArray())
      self.view.addSubview(downMenuButton)

        
        
        // Create up menu button
        let homeLabel2 =  self.createHomeButtonView()
        
         upMenuView = DWBubbleMenuButton(frame: CGRect(x: self.view.frame.size.width - homeLabel2.frame.size.width - 20.0,y: self.view.frame.size.height - homeLabel2.frame.size.height - 20.0,
            width: homeLabel2.frame.size.width,height: homeLabel2.frame.size.height),expansionDirection: .directionUp)
        upMenuView.homeButtonView = homeLabel2
        
        upMenuView.addButtons(self.createDemoButtonArray())
        
        self.view.addSubview(upMenuView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createHomeButtonView() -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
    
        label.text = "Tap";
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.layer.cornerRadius = label.frame.size.height / 2.0;
        label.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
        label.clipsToBounds = true;
    
        return label;
    }
    
    func createDemoButtonArray() -> [UIButton] {
        var buttons:[UIButton]=[]
        var i = 0
        for str in ["A","B","C","D","E","F"] {
            let button:UIButton = UIButton(type: UIButtonType.system)
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.setTitle(str, for: UIControlState())
            
            button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0);
            button.layer.cornerRadius = button.frame.size.height / 2.0;
            button.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            button.clipsToBounds = true;
            i += 1
            button.tag = i;
            button.addTarget(self, action: #selector(ViewController.buttonTap(_:)), for: UIControlEvents.touchUpInside)
            
            buttons.append(button)
            
        }
        return buttons
        
    }
    
    func createButtonWithName(_ imageName:NSString) -> UIButton {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName as String), for: UIControlState())
        button.sizeToFit()
        button.addTarget(self, action: #selector(ViewController.buttonTap(_:)), for: UIControlEvents.touchUpInside)
        
        return button
        
    }
    
    func buttonTap(_ sender:UIButton){

        print("Button tapped, tag:\(sender.tag)")
    }
    
       
  


}

