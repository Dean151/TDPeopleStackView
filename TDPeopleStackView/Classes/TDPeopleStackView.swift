//
//  TDPeopleStackView.swift
//  Pods
//
//  Created by Thomas Durand on 01/05/2016.
//
//

import UIKit

// MARK: - Data Source

@objc public protocol TDPeopleStackViewDataSource: class {
    func numberOfPeopleInStackView(peopleStackView: TDPeopleStackView) -> Int
    optional func peopleStackView(peopleStackView: TDPeopleStackView, imageAtIndex index: Int) -> UIImage?
    optional func peopleStackView(peopleStackView: TDPeopleStackView, placeholderTextAtIndex index: Int) -> String?
}

// MARK: - Delegate

@objc public protocol TDPeopleStackViewDelegate: class {
    /**
     Should return the button to show in the button for the peopleStackView.
     - parameter peopleStackView: the instance of `TDPeopleStackView` for the button
     - returns: A button to show in the peopleStackView
     */
    optional func buttonForPeopleStackView(peopleStackView: TDPeopleStackView) -> UIButton?
    
    /**
     The text to show in the button for the peopleStackView. Will not be called when `buttonForPeopleStackView(_:)` is called
     - parameter peopleStackView: the instance of `TDPeopleStackView` for the button
     - returns: A String to show in the button
     */
    optional func titleForButtonInPeopleStackView(peopleStackView: TDPeopleStackView) -> String?
    
    /**
     Will be called when the button from an instance of a `TDPeopleStackView` is pressed
     - parameter button: The button that have been pressed
     - parameter peopleStackView: the instance of `TDPeopleStackView` that received the press event
    */
    optional func peopleStackViewButtonPressed(button: UIButton, peopleStackView: TDPeopleStackView)
}

// MARK: - Public properties

@objc public class TDPeopleStackView: UIView {
    
    /**
     Constant that allow to set the space between circles.
     Below 1, there will be an overlap between circles
     Default value is 0.75
    */
    public var overlapConstant: CGFloat = 0.75 {
        didSet {
            if !firstLayoutDone { return }
            reloadData()
        }
    }
    
    /**
     The maximum number of circle to show before folding.
     Set to 0 for unlimited
    */
    public var maxNumberOfCircles: Int = 0 {
        didSet {
            if !firstLayoutDone { return }
            reloadData()
        }
    }
    
    /**
     The color of the people circle's background when there is no image to show
    */
    public var placeholderBackgroundColor = UIColor.lightGrayColor() {
        didSet {
            if !firstLayoutDone { return }
            reloadData()
        }
    }
    
    /**
     The color of the people circle's text when there is no image to show
    */
    public var placeholderTextColor = UIColor.whiteColor() {
        didSet {
            if !firstLayoutDone { return }
            reloadData()
        }
    }
    
    /**
     The font of the people circle's text when there is no image to show
    */
    public var placeholderTextFont: UIFont = UIFont.systemFontOfSize(24) {
        didSet {
            if !firstLayoutDone { return }
            reloadData()
        }
    }
    
    /**
     The data source for this `PeopleStackView` instance
    */
    public var dataSource: TDPeopleStackViewDataSource?
    
    /**
     The delegate for this `PeopleStackView` instance
     */
    public var delegate: TDPeopleStackViewDelegate?
    
    private var firstLayoutDone = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        firstLayoutDone = true
        reloadData()
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        self.delegate?.peopleStackViewButtonPressed?(sender, peopleStackView: self)
    }
}

// MARK: - Drawing

extension TDPeopleStackView {
    public func reloadData() {
        
        // Remove all subviews
        subviews.forEach({ $0.removeFromSuperview() })
        
        // Create the show more button if needed
        var button: UIButton?
        
        if let fullButton = delegate?.buttonForPeopleStackView?(self) {
            button = fullButton
        } else if let buttonText = delegate?.titleForButtonInPeopleStackView?(self) {
            button = UIButton(type: .System)
            button?.setTitle(buttonText, forState: .Normal)
            button?.sizeToFit()
        }
        
        if let button = button {
            button.frame = CGRectMake(bounds.width - button.bounds.width, (bounds.height-button.bounds.height)/2, button.bounds.width, button.bounds.height)
            button.addTarget(self, action: #selector(TDPeopleStackView.buttonPressed(_:)), forControlEvents: .TouchUpInside)
            addSubview(button)
        }
        
        // Calculate the size of circles
        let circleDiameter = min(bounds.width, bounds.height)
        let circleSize = CGSizeMake(circleDiameter, circleDiameter)
        
        for index in 0..<(dataSource?.numberOfPeopleInStackView(self) ?? 0) {
            let origin = CGPointMake(circleDiameter * CGFloat(index) * overlapConstant, 0)
            let rect = CGRect(origin: origin, size: circleSize)
            
            // Calculate next circule to know when we should stop the loop
            let nextOrigin = CGPointMake(circleDiameter * CGFloat(index+1) * overlapConstant, 0)
            let nextRect = CGRect(origin: nextOrigin, size: circleSize)
            
            let willDrawLastCircle = nextRect.origin.x + nextRect.width > (bounds.width - (button?.bounds.width ?? 0) ) ||
                (maxNumberOfCircles > 0 && index+1 > maxNumberOfCircles)
            
            var circleView: UIView!
            
            if let image = dataSource?.peopleStackView?(self, imageAtIndex: index) where !willDrawLastCircle {
                // We have an image, and it's not the last to be drawn
                let imageView = UIImageView(frame: rect)
                imageView.image = image
                imageView.contentMode = .ScaleAspectFill
                circleView = imageView
            } else {
                // We create a label to show initials or the number of people for the last circle
                let label = UILabel(frame: rect)
                label.textColor = placeholderTextColor
                label.textAlignment = .Center
                
                if willDrawLastCircle {
                    if #available(iOS 8.2, *) {
                        label.font = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)
                    } else {
                        label.font = UIFont(name: "HelveticaNeue-Thin", size: 30)!
                    }
                    label.text = "\(dataSource?.numberOfPeopleInStackView(self) ?? 0)"
                } else {
                    label.font = placeholderTextFont
                    label.text = dataSource?.peopleStackView?(self, placeholderTextAtIndex: index)
                }
                
                circleView = label
            }
            
            circleView.layer.cornerRadius = circleDiameter/2
            circleView.clipsToBounds = true
            circleView.layer.borderColor = UIColor.whiteColor().CGColor
            circleView.layer.borderWidth = 1.0
            
            circleView.backgroundColor = self.placeholderBackgroundColor
            addSubview(circleView)
            
            if willDrawLastCircle {
                break;
            }
        }
        
        setNeedsDisplay()
    }
}
