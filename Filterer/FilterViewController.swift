//
//  ViewController.swift
//  Filterer
//
//  Created by Administrator on 19.03.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topImageView: UIImageView!

    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderView: UIView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    let image = UIImage(named: "sample")
    var filteredImage: UIImage?
    let avgRed = 117
    let avgGreen = 98
    let avgBlue = 83

    var previousFilter : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let image = UIImage(named: "sample")
        
        
        self.imageView.image = image
        compareButton.enabled = false
        editButton.enabled = false
        self.originLabel.text = ""
        
/* setup */
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
      
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action:Selector("toggleImage:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
 
        
    }

    func toggleImage(sender: UILongPressGestureRecognizer){
        
        guard compareButton.enabled == true else {
            print("FILTER SWITCHED OFF")
            return
        }
        
        if sender.state == .Began{
            self.imageView.image = image
            self.originLabel.text = "ORIGIN"
        }else if sender.state == .Ended{
            self.originLabel.text = ""
            self.imageView.image = setupPreviousFilter()
        }
    }
    
    
    
    @IBAction func onNewPhoto(sender: AnyObject) {
        
        let actionSheet = UIAlertController (title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action : UIAlertAction) in
           self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { (action : UIAlertAction) in
            self.showAlbum()
        }))
        
/* For "Cancel" action handler not needed because  it is dismissed */
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil
        ))
 
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func showCamera () {

        
/* we need to declare UIImagePickerControllerDelegate, UINavigationControllerDelegate (without required delegate methods) in class */
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
        
    }
    
    func showAlbum () {
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
/* Delegate methods for UIImagePickerControllerDelegate */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)

    /* UNCOMMENT TO VIEW OPTIONAL BINDING AND CAST */
//        let  image = info[UIImagePickerControllerOriginalImage]
//        imageView.image = image
        
        if let  image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
/* We change sender AnyObject to UIButton */
    @IBAction func onFilter(sender: UIButton) {
        
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    
    func showSecondaryMenu () {

        hideSliderView()
        view.addSubview(secondaryMenu)
        
        /* FIX THE BUG OF the autolayout - tells to the system that we gonna control the constraints, we don't want you to do anything for us */
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()

        
/* ANIMATION */
        self.secondaryMenu.alpha = 0.0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    
    
    func  hideSecondaryMenu () {

/* ANIMATION */
/* the difference in completion is it tells you wether or not the animation completed or not, which is not useful here,b ut potentially useful */
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0.0
        }) { completion in
            self.previousFilter = ""
            self.compareButton.enabled = false
            self.secondaryMenu.removeFromSuperview()
        }
        
 /* animation option that can handle double click on the filter button */
//        UIView.animateWithDuration(0.4, animations: {
//            self.secondaryMenu.alpha = 0.0
//        }) { completion in
//            if completion == true {
//                self.secondaryMenu.removeFromSuperview()
//            }
//        }

    }

    
    @IBAction func onEdit(sender: UIButton) {
        
        if (sender.selected) {
            hideSliderView()
            sender.selected = false
        } else {
            hideSecondaryMenu()
            showSliderView()
            sender.selected = true
        }
    }
    
    
    func showSliderView () -> Void {
        
        view.addSubview(sliderView)
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(44)
        
//        sliderView.backgroundColor
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()

//        addSliderConstraints()
        
    }
    
    
//    func addSliderConstraints () -> Void {
//       
//    }

    
    func hideSliderView () -> Void {
        
        sliderView.removeFromSuperview()
        
    }
    
    
    
    @IBAction func sliderEditFilter(sender: UISlider) {
       
        sender.minimumValue = 0
        sender.maximumValue = 255
       
        let selectedValue = UInt (sender.value)
        
        print(selectedValue)
        imageView.image = complexFilter(1, green: selectedValue)
        
        
    }
    
 
    @IBAction func onCompare(sender: UIButton) {
        
        if (sender.selected) {
            switch (previousFilter) {
            case "redFilter":
                sender.selected = false
                self.imageView.image = redFilter()

//                UIView.transitionWithView(self.imageView,
//                                          duration:5,
//                                          options: .TransitionCrossDissolve,
//                                          animations: { self.imageView.image = self.redFilter() },
//                                          completion: nil)

            case "coldFilter":
                sender.selected = false
                self.imageView.image = coldFilter()
            case "sepiaFilter" :
                sender.selected = false
                self.imageView.image = sepiaFilter()
            case "alphaFilter" :
                sender.selected = false
                self.imageView.image = alphaFilter(150)
            case "complexFilter" :
                sender.selected = false
                self.imageView.image = complexFilter(1, green : 1)
            default:
                self.imageView.image = image
            }
            
            
        } else {
            self.imageView.image = image
            sender.selected = true
            
        }
    }
 
 
    func setupPreviousFilter () -> UIImage {
        switch (previousFilter) {
        case "redFilter":
            return redFilter()
        case "coldFilter":
            return coldFilter()
        case "sepiaFilter" :
            return sepiaFilter()
        case "alphaFilter" :
            return alphaFilter(150)
        case "complexFilter" :
            return complexFilter(1, green : 1)
        default:
            return image!
        }

    }
    
    

    
    @IBAction func onShare(sender: AnyObject) {
        
        let activityController = UIActivityViewController (activityItems: [imageView.image!], applicationActivities: nil)
        
//        let activityController = UIActivityViewController (activityItems: ["Check out really cool app",imageView.image!], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func setupRedFilter(sender: AnyObject) {
        UIView.transitionWithView(self.imageView,
                                  duration:1,
                                  options: .TransitionCrossDissolve,
                                  animations: { self.imageView.image = self.redFilter() },
                                  completion: nil)
        
//        self.imageView.image = redFilter()
        compareButton.enabled = true
        editButton.enabled = true
    }
    
    
    @IBAction func setupBlueFilter(sender: AnyObject) {
        UIView.transitionWithView(self.imageView,
                                  duration:1,
                                  options: .TransitionCrossDissolve,
                                  animations: { self.imageView.image = self.coldFilter() },
                                  completion: nil)

//        self.imageView.image = coldFilter()
        compareButton.enabled = true
        editButton.enabled = true
    }
    
    
    @IBAction func setupSepiaFilter(sender: AnyObject) {
        UIView.transitionWithView(self.imageView,
                                  duration:1,
                                  options: .TransitionCrossDissolve,
                                  animations: { self.imageView.image = self.sepiaFilter() },
                                  completion: nil)

//        self.imageView.image = sepiaFilter()
        compareButton.enabled = true
        editButton.enabled = true
    }
    
    
    @IBAction func setupAlphaFilter(sender: AnyObject) {
        UIView.transitionWithView(self.imageView,
                                  duration:1,
                                  options: .TransitionCrossDissolve,
                                  animations: { self.imageView.image = self.alphaFilter(150) },
                                  completion: nil)

//        self.imageView.image = alphaFilter(150)
        compareButton.enabled = true
        editButton.enabled = true
    }
    
    
    @IBAction func setupComplexFilter(sender: AnyObject) {
        UIView.transitionWithView(self.imageView,
                                  duration:1,
                                  options: .TransitionCrossDissolve,
                                  animations: { self.imageView.image = self.complexFilter(1, green: 1) },
                                  completion: nil)
 
//        self.imageView.image = complexFilter(1, green: 1)
        compareButton.enabled = true
        editButton.enabled = true
    }
    
    
 
    
/* convert image to RGBA format */
    func convertImageToRGB () -> Void {
        
            }
    
    
/* RED FILTER */
    func redFilter () -> UIImage {
        
        var redRGBA = RGBAImage(image: image!)!
        for y in 0..<redRGBA.height {
            for x in 0..<redRGBA.width {
                
                let index = y * redRGBA.width + x
                var pixel = redRGBA.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                if (redDiff > 0) {
                    pixel.red = UInt8 (max (0, min (255, avgRed + redDiff*3)))
                    redRGBA.pixels[index] = pixel
                }
            }
        }
        previousFilter = "redFilter"
        return redRGBA.toUIImage()!
    }


/* COLD FILTER */
    func coldFilter () -> UIImage {
        var coldRGBA = RGBAImage(image: image!)!
        for y in 0..<coldRGBA.height {
            for x in 0..<coldRGBA.width {
                
                let index = y * coldRGBA.width + x
                var pixel = coldRGBA.pixels[index]
                let blueDiff = Int(pixel.blue) - avgBlue
                if (blueDiff > 0) {
                    pixel.blue = UInt8 (max (0, min (255, avgBlue + blueDiff*8)))
                    coldRGBA.pixels[index] = pixel
                }
            }
        }
        previousFilter = "coldFilter"
        return coldRGBA.toUIImage()!
    }

    
/* SEPIA FILTER */
    func sepiaFilter () -> UIImage {
        var greenRGBA = RGBAImage(image: image!)!
        for y in 0..<greenRGBA.height {
            for x in 0..<greenRGBA.width {
                
                let index = y * greenRGBA.width + x
                var pixel = greenRGBA.pixels[index]
                let greenDiff = Int(pixel.green) - avgGreen
                if (greenDiff > 0) {
                    pixel.green = UInt8 (max (0, min (255, avgGreen)))
                    greenRGBA.pixels[index] = pixel
                }
            }
        }
        previousFilter = "sepiaFilter"
        return greenRGBA.toUIImage()!
    }
    
    
/* ALPHA FILTER */
    func alphaFilter (alphaValue:UInt8) -> UIImage {
        var alphaRGBA = RGBAImage(image: image!)!
        for y in 0..<alphaRGBA.height {
            for x in 0..<alphaRGBA.width {
                
                let index = y * alphaRGBA.width + x
                var pixel = alphaRGBA.pixels[index]
                pixel.alpha = alphaValue
                alphaRGBA.pixels[index] = pixel
            }
        }
        previousFilter = "alphaFilter"
        return alphaRGBA.toUIImage()!
    }
    
    
/* COMPLEX FILTER */
    func complexFilter (red: UInt, green: UInt) ->UIImage {
        var complexRGBA = RGBAImage(image: image!)!
        for y in 0..<complexRGBA.height {
            for x in 0..<complexRGBA.width {
                
                let index = y * complexRGBA.width + x
                var pixel = complexRGBA.pixels[index]
                pixel.red = UInt8 (max (0, min (255, red)))
                //        pixel.blue = UInt8 (max (0, min (255, 1)))
                pixel.green = UInt8 (max (0, min (255, green)))
                pixel.alpha = 130
                complexRGBA.pixels[index] = pixel
            }
        }
        previousFilter = "complexFilter"
        return complexRGBA.toUIImage()!
    }

    
    
    

}

