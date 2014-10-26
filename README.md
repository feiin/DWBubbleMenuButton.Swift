 DWBubbleMenuButton.Swift
==================

DWBubbleMenuButton[https://github.com/dwalker39/DWBubbleMenuButton] Swift Implementation 

DWBubbleMenuButton.Swift is a simple animation class for expanding and collapsing a variable sized menu. 

![](demo.gif)

Project allows for expanding menus in left, right, up, and down directions. Using the class is as simple as setting your home button and adding an array of menu buttons.

Install
==================

Swift projects is currently not supported by Cocoapods. Until support is available you should just clone the repository and drag the source folder into your project to use DWBubbleMenuButton.Swift.

Usage
==================
Create a home button

    
    var menuButton =UIButton.buttonWithType(UIButtonType.System)

    menuButton.setTitle("Menu", forState: .Normal);


Create an instance of DWBubbleMenuButton


    var bubbleMenuButton = DWBubbleMenuButton(frame: CGRectMake(20.0,
            20.0,
            menuButton.frame.size.width,
            menuButton.frame.size.height), expansionDirection: ExpansionDirection.DirectionDown)
       dbubbleMenuButton.homeButtonView = menuButton;```

Add buttons to your bubble menu


	bubbleMenuButton.addButtons(/* your buttons */)
   
    
    /* OR */
    
    bubbleMenuButton.addButton(/* your button */)
    


DWBubbleMenuButton.Swift will automatically handle the animation, frame changes, and showing your menu buttons in the proper order
