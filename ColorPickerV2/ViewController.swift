//
//  ViewController.swift
//  ColorPickerV2
//
//  Created by 阿部健人 on 2018/11/04.
//  Copyright © 2018 阿部健人. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var bookmarkTable: UITableView!
    
    @IBOutlet var slider1: UISlider!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var slider3: UISlider!
    
    @IBOutlet var stepper1: UIStepper!
    @IBOutlet var stepper2: UIStepper!
    @IBOutlet var stepper3: UIStepper!
    
    @IBOutlet var sliderIndexLabel1: UILabel!
    @IBOutlet var sliderIndexLabel2: UILabel!
    @IBOutlet var sliderIndexLabel3: UILabel!
    
    @IBOutlet var sliderValueLabel1: UILabel!
    @IBOutlet var sliderValueLabel2: UILabel!
    @IBOutlet var sliderValueLabel3: UILabel!
    
    @IBOutlet var slider1HueImageView: UIImageView!
    @IBOutlet var slider1SaturationView: UIView!
    @IBOutlet var slider1BrightnessView: UIView!
    
    @IBOutlet var slider2HueView: UIView!
    @IBOutlet var slider2SaturationImageView: UIImageView!
    @IBOutlet var slider2BrightnessView: UIView!
    
    @IBOutlet var slider3HueView: UIView!
    @IBOutlet var slider3SaturationView: UIView!
    @IBOutlet var slider3BrightnessImageView: UIImageView!
    
    
    @IBOutlet var hexLabel: UILabel!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    @IBOutlet var RLabel: UILabel!
    @IBOutlet var GLabel: UILabel!
    @IBOutlet var BLabel: UILabel!
    
    @IBOutlet var hueLabel: UILabel!
    @IBOutlet var saturationLabel: UILabel!
    @IBOutlet var brightnessLabel: UILabel!
    
    @IBOutlet var bookMarkButton: UIButton!
    @IBOutlet var showBookMarkButton: UIButton!
    @IBOutlet var showMoreColorButton: UIButton!
    
    @IBOutlet var backGround: UIView!
    
    
    var colorArray = [Int]()
    var bookmarkArray = [[String]]() //[[名前,赤(255),緑(255),青(255)]]
    
    var redValue: Int = 255
    var greenValue: Int = 255
    var blueValue: Int = 255
    var hueValue: Int = 0
    var saturationValue: Int = 100
    var brightnessValue: Int = 100
    
    var mode: Int = 0
    var isTableOpen: Bool = false
    
    let saveData: UserDefaults = UserDefaults.standard
    let screenheight: CGFloat = UIScreen.main.bounds.height
    let screenwidth: CGFloat = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTable.register(UINib(nibName: "BookmarkTableViewCell", bundle: nil), forCellReuseIdentifier: "Bookmark")
        
        if saveData.object(forKey: "colorMemory") != nil {
            
            colorArray = saveData.object(forKey: "colorMemory") as! [Int]
            redValue = colorArray[0]
            greenValue = colorArray[1]
            blueValue = colorArray[2]
            
        }
        
        reset()
        narashi()
        
        labelupdate()
        
        bookmarkTable.dataSource = self
        bookmarkTable.delegate = self
        
        bookmarkArray = [["#000000","0.0","0.0","0.0"],["#ffffff","1.0","1.0","1.0"],["#ff0000","1.0","0.0","0.0"],]
        
        tablePositionReset()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tablePositionReset() {
        self.bookmarkTable.center.x = -150
        self.bookmarkTable.center.y = screenheight / 2
        self.showBookMarkButton.center.x = 21
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bookmark", for: indexPath) as! BookmarkTableViewCell
        
        let cellName: String = bookmarkArray[indexPath.row][0]
        let cellRed: Double = Double(bookmarkArray[indexPath.row][1])!
        let cellGreen: Double = Double(bookmarkArray[indexPath.row][2])!
        let cellBlue: Double = Double(bookmarkArray[indexPath.row][3])!
        
        cell.bookmarkTableColorView.backgroundColor = UIColor.init(red: CGFloat(cellRed), green: CGFloat(cellGreen), blue: CGFloat(cellBlue), alpha: 1)
        cell.bookmarkTableLabel.text = cellName
        cell.bookmarkTableSubLabel.text = "R:\(Int(cellRed * 255)) G:\(Int(cellGreen * 255)) B:\(Int(cellBlue * 255))"
        
        return cell
    }
    
    func reset() {
        
        slider1.value = Float(redValue)
        slider1.maximumValue = 255
        slider2.maximumValue = 255
        slider3.maximumValue = 255
        slider2.value = Float(greenValue)
        slider3.value = Float(blueValue)
        
        stepper1.value = Double(redValue)
        stepper1.maximumValue = 255
        stepper2.maximumValue = 255
        stepper3.maximumValue = 255
        stepper2.value = Double(greenValue)
        stepper3.value = Double(blueValue)
        
    }
    
    func narashi() {
        slider1HueImageView.image = UIImage(named: "img_hsv001.png")
        slider2SaturationImageView.image = UIImage(named: "img_hsv002.png")
        slider3BrightnessImageView.image = UIImage(named: "img_hsv003.png")
        slider1HueImageView.image = UIImage(named: "")
        slider2SaturationImageView.image = UIImage(named: "")
        slider3BrightnessImageView.image = UIImage(named: "")
    }
    
    func RGBtoHSB() {
        let maxRGB = max(redValue,max(greenValue,blueValue))
        let minRGB = min(redValue,min(greenValue,blueValue))
        
        //HUE
        if redValue == greenValue && greenValue == blueValue {
            hueValue = 0
        } else if maxRGB == redValue {
            hueValue = Int(60 * (Double(greenValue - blueValue) / Double(maxRGB - minRGB)))
        } else if maxRGB == greenValue {
            hueValue = Int(60 * (Double(blueValue - redValue) / Double(maxRGB - minRGB)) + 120)
        } else if maxRGB == blueValue {
            hueValue = Int(60 * (Double(redValue - greenValue) / Double(maxRGB - minRGB)) + 240)
        }
        if hueValue < 0 {
            hueValue += 360
        }
        
        //SATURATION
        if maxRGB > 0 {
            saturationValue = Int(Double(maxRGB - minRGB) / Double(maxRGB) * 100)
        }
            
        //BRIGHTNESS
        brightnessValue = Int((Double(maxRGB) / 255.0) * 100)
        
    }
    
    func HSBtoRGB() {
        let maxRGB = Int((Double(brightnessValue) / 100.0) * 255.0)
        let minRGB = Int(Double(maxRGB) - ((Double(saturationValue) / 100.0) * Double(maxRGB)))
        let sub = maxRGB - minRGB
        
        if hueValue < 60 {
            redValue = maxRGB
            greenValue = Int((Double(hueValue) / 60.0) * Double(sub) + Double(minRGB))
            blueValue = minRGB
        } else if hueValue < 120 {
            redValue = Int((Double(120 - hueValue) / 60.0) * Double(sub) + Double(minRGB))
            greenValue = maxRGB
            blueValue = minRGB
        } else if hueValue < 180 {
            redValue = minRGB
            greenValue = maxRGB
            blueValue = Int((Double(hueValue - 120) / 60.0) * Double(sub) + Double(minRGB))
        } else if hueValue < 240 {
            redValue = minRGB
            greenValue = Int((Double(240 - hueValue) / 60.0) * Double(sub) + Double(minRGB))
            blueValue = maxRGB
        } else if hueValue < 300 {
            redValue = Int((Double(hueValue - 240) / 60.0) * Double(sub) + Double(minRGB))
            greenValue = minRGB
            blueValue = maxRGB
        } else if hueValue <= 360 {
            redValue = maxRGB
            greenValue = minRGB
            blueValue = Int((Double(360 - hueValue) / 60.0) * Double(sub) + Double(minRGB))
        }
    }
    
    func labelColor(color: UIColor) {
        redLabel.textColor = color
        greenLabel.textColor = color
        blueLabel.textColor = color
        RLabel.textColor = color
        GLabel.textColor = color
        BLabel.textColor = color
        
        hueLabel.textColor = color
        saturationLabel.textColor = color
        brightnessLabel.textColor = color
        
        hexLabel.textColor = color
        
        bookMarkButton.tintColor = color
        showBookMarkButton.tintColor = color
        showMoreColorButton.tintColor = color
    }
    
    func labelupdate() {
        
        backGround.backgroundColor = UIColor.init(displayP3Red: CGFloat(Double(redValue) / 255.0), green: CGFloat(Double(greenValue) / 255.0), blue: CGFloat(Double(blueValue) / 255.0), alpha: 1.0)
        
        redLabel.text = String(redValue)
        greenLabel.text = String(greenValue)
        blueLabel.text = String(blueValue)
        hueLabel.text = "H " + String(hueValue) + "°"
        saturationLabel.text = "S " + String(saturationValue) + "%"
        brightnessLabel.text = "B " + String(brightnessValue) + "%"
        hexLabel.text = "#" + String(format: "%02x", redValue) + String(format: "%02x", greenValue) + String(format: "%02x", blueValue)
        
        saveData.set([redValue, greenValue, blueValue], forKey: "colorMemory")
        
        let darkness = (redValue * 299 + greenValue * 587 + blueValue * 114) / 1000
        
        if darkness < 128 {
            labelColor(color: UIColor.white)
        } else {
            labelColor(color: UIColor.black)
        }
        
        if mode == 1 {
            hsbSliderColorSet()
        }
        
    }
    
    func rgbSliderColorSet () {
        slider1.minimumTrackTintColor = UIColor.init(displayP3Red: 255.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
        slider2.minimumTrackTintColor = UIColor.init(displayP3Red: 64.0 / 255.0, green: 240.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        slider3.minimumTrackTintColor = UIColor.init(displayP3Red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        slider1.maximumTrackTintColor = UIColor.init(displayP3Red: 204.0 / 255.0, green: 163.0 / 255.0, blue: 164.0 / 255.0, alpha: 1.0)
        slider2.maximumTrackTintColor = UIColor.init(displayP3Red: 161.0 / 255.0, green: 201.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
        slider3.maximumTrackTintColor = UIColor.init(displayP3Red: 163.0 / 255.0, green: 184.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
        
        slider1HueImageView.image = UIImage(named: "")
        slider2SaturationImageView.image = UIImage(named: "")
        slider3BrightnessImageView.image = UIImage(named: "")
        
        slider1SaturationView.backgroundColor = UIColor.clear
        slider1BrightnessView.backgroundColor = UIColor.clear
        slider2HueView.backgroundColor = UIColor.clear
        slider2BrightnessView.backgroundColor = UIColor.clear
        slider3HueView.backgroundColor = UIColor.clear
        slider3SaturationView.backgroundColor = UIColor.clear
    }
    
    func hsbSliderColorSet () {
        slider1.minimumTrackTintColor = UIColor.clear
        slider2.minimumTrackTintColor = UIColor.clear
        slider3.minimumTrackTintColor = UIColor.clear
        slider1.maximumTrackTintColor = UIColor.clear
        slider2.maximumTrackTintColor = UIColor.clear
        slider3.maximumTrackTintColor = UIColor.clear
        
        slider1HueImageView.image = UIImage(named: "img_hsv001.png")
        slider2SaturationImageView.image = UIImage(named: "img_hsv002.png")
        slider3BrightnessImageView.image = UIImage(named: "img_hsv003.png")
        
        slider3HueView.backgroundColor = UIColor.init(hue: CGFloat(hueValue) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        slider2HueView.backgroundColor = UIColor.init(hue: CGFloat(hueValue) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        slider1SaturationView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 - CGFloat(saturationValue) / 100.0)
        slider3SaturationView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 - CGFloat(saturationValue) / 100.0)
        slider1BrightnessView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0 - CGFloat(brightnessValue) / 100.0)
        slider2BrightnessView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0 - CGFloat(brightnessValue) / 100.0)
    }
    
    @IBAction func modeChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            slider1.value = Float(redValue)
            slider1.maximumValue = 255
            slider2.maximumValue = 255
            slider3.maximumValue = 255
            slider2.value = Float(greenValue)
            slider3.value = Float(blueValue)
            
            stepper1.value = Double(redValue)
            stepper1.maximumValue = 255
            stepper2.maximumValue = 255
            stepper3.maximumValue = 255
            stepper2.value = Double(greenValue)
            stepper3.value = Double(blueValue)
            
            sliderValueLabel1.text = String(redValue)
            sliderValueLabel2.text = String(greenValue)
            sliderValueLabel3.text = String(blueValue)
            
            sliderIndexLabel1.text = "R"
            sliderIndexLabel2.text = "G"
            
            rgbSliderColorSet()
            
            mode = 0
            
        case 1:
            slider2.value = Float(saturationValue)
            slider3.value = Float(brightnessValue)
            slider1.maximumValue = 360
            slider2.maximumValue = 100
            slider3.maximumValue = 100
            slider1.value = Float(hueValue)
            
            stepper2.value = Double(saturationValue)
            stepper3.value = Double(brightnessValue)
            stepper1.maximumValue = 360
            stepper2.maximumValue = 100
            stepper3.maximumValue = 100
            stepper1.value = Double(hueValue)
            
            sliderValueLabel1.text = String(hueValue)
            sliderValueLabel2.text = String(saturationValue)
            sliderValueLabel3.text = String(brightnessValue)
            
            sliderIndexLabel1.text = "H"
            sliderIndexLabel2.text = "S"
            
            hsbSliderColorSet()
            
            mode = 1
            
        case 2:
            
            
            mode = 2
            
        default: mode = 0
        }
    }
    
    @IBAction func slider1 (sender: UISlider) {
        if mode == 0 {
            redValue = Int(sender.value)
            sliderValueLabel1.text = String(redValue)
            stepper1.value = Double(redValue)
            RGBtoHSB()
        } else if mode == 1 {
            hueValue = Int(sender.value)
            sliderValueLabel1.text = String(hueValue)
            stepper1.value = Double(hueValue)
            HSBtoRGB()
        }
        
        labelupdate()
    }
    
    @IBAction func slider2 (sender: UISlider) {
        if mode == 0 {
            greenValue = Int(sender.value)
            sliderValueLabel2.text = String(greenValue)
            stepper2.value = Double(greenValue)
            RGBtoHSB()
        } else if mode == 1 {
            saturationValue = Int(sender.value)
            sliderValueLabel2.text = String(saturationValue)
            stepper2.value = Double(saturationValue)
            HSBtoRGB()
        }
        labelupdate()
    }
    
    @IBAction func slider3 (sender: UISlider) {
        if mode == 0 {
            blueValue = Int(sender.value)
            sliderValueLabel3.text = String(blueValue)
            stepper3.value = Double(blueValue)
            RGBtoHSB()
        } else if mode == 1 {
            brightnessValue = Int(sender.value)
            sliderValueLabel3.text = String(brightnessValue)
            stepper3.value = Double(brightnessValue)
            HSBtoRGB()
        }
        labelupdate()
    }
    
    @IBAction func stepper1 (sender: UIStepper) {
        
        if mode == 0 {
            redValue = Int(sender.value)
            slider1.value = Float(redValue)
            sliderValueLabel1.text = String(redValue)
            RGBtoHSB()
        } else if mode == 1 {
            hueValue = Int(sender.value)
            slider1.value = Float(hueValue)
            sliderValueLabel1.text = String(hueValue)
            HSBtoRGB()
        }
        labelupdate()
    }
    
    @IBAction func stepper2 (sender: UIStepper) {
        
        if mode == 0 {
            greenValue = Int(sender.value)
            slider2.value = Float(greenValue)
            sliderValueLabel2.text = String(greenValue)
            RGBtoHSB()
        } else if mode == 1 {
            saturationValue = Int(sender.value)
            slider2.value = Float(saturationValue)
            sliderValueLabel2.text = String(saturationValue)
            HSBtoRGB()
        }
        labelupdate()
    }
    
    @IBAction func stepper3 (sender: UIStepper) {
        
        if mode == 0 {
            blueValue = Int(sender.value)
            slider3.value = Float(blueValue)
            sliderValueLabel3.text = String(blueValue)
            RGBtoHSB()
        } else if mode == 1 {
            brightnessValue = Int(sender.value)
            slider3.value = Float(brightnessValue)
            sliderValueLabel3.text = String(brightnessValue)
            HSBtoRGB()
        }
        labelupdate()
    }
    
    @IBAction func tableAnimation () {
        if isTableOpen == false {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                animations: {self.bookmarkTable.center.x += 300},
                completion: nil)
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                animations: {self.showBookMarkButton.center.x += 300},
                completion: nil)
            isTableOpen = true
        } else {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                animations: {self.bookmarkTable.center.x -= 300},
                completion: {finished in self.bookmarkTable.center.x = -150})
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                animations: {self.showBookMarkButton.center.x -= 300},
                completion: {finished in self.showBookMarkButton.center.x = 21})
            isTableOpen = false
        }
    }

}

