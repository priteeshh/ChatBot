//
//  WelcomeVC.swift
//  ChatBotApp
//
//  Created by Preeteesh Remalli on 07/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import ScrollableGraphView

class WelcomeVC: UIViewController {
    @IBOutlet weak var helloNameLbl: UILabel!
    @IBOutlet weak var barChart: ScrollableGraphView!
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var linePlotData = [Double]()
    var linePlotData1 = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        barChart.dataSource = self
        linePlotData = generateRandomData(30, max: 100, shouldIncludeOutliers: false)
        linePlotData1 = generateRandomData(30, max: 100, shouldIncludeOutliers: false)


        //AWS refresh Data
        self.refresh()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(true)
        loadBarChart()
    }
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        
            self.user?.signOut()
            self.title = nil
            self.response = nil
            self.refresh()
        }

    func loadBarChart(){
        //Line Chart
        /*
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        let referenceLines = ReferenceLines()
        
        barChart.addPlot(plot: linePlot)
        barChart.shouldAdaptRange = false
        barChart.shouldAnimateOnAdapt = true
        barChart.addReferenceLines(referenceLines: referenceLines)
        */
        
        /*
        // Curve line plot.
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        linePlot.fillGradientEndColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        //referenceLines.absolutePositions = [10, 20, 25, 30]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        barChart.backgroundFillColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        barChart.dataPointSpacing = 80
        
        barChart.shouldAnimateOnStartup = true
        barChart.shouldAdaptRange = true
        barChart.shouldRangeAlwaysStartAtZero = true
        
        barChart.rangeMax = 50
        
        // Add everything to the graph.
        barChart.addReferenceLines(referenceLines: referenceLines)
        barChart.addPlot(plot: linePlot)
        barChart.addPlot(plot: dotPlot)
        */
 
        /*
        //Bar
        let barPlot = BarPlot(identifier: "bar")
        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.barLineColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        barPlot.barColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        barChart.backgroundFillColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        barChart.shouldAnimateOnStartup = true
        
        barChart.rangeMax = 100
        barChart.rangeMin = 0
        
        // Add everything
        barChart.addPlot(plot: barPlot)
        barChart.addReferenceLines(referenceLines: referenceLines)
        */
        
        //Double Line
        
        
        // Setup the plot
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineWidth = 1
        blueLinePlot.lineColor = #colorLiteral(red: 0.0862745098, green: 0.6666666667, blue: 0.9882352941, alpha: 1)
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = #colorLiteral(red: 0.0862745098, green: 0.6666666667, blue: 0.9882352941, alpha: 1)
        
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second line plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineWidth = 1
        orangeLinePlot.lineColor =  #colorLiteral(red: 1, green: 0.4901960784, blue: 0.4705882353, alpha: 1)
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        orangeLinePlot.shouldFill = true
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = #colorLiteral(red: 1, green: 0.4901960784, blue: 0.4705882353, alpha: 1)
        
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
        
        // Setup the graph
        barChart.backgroundFillColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        barChart.dataPointSpacing = 80
        barChart.shouldAnimateOnStartup = true
        barChart.shouldAdaptRange = true
        
        barChart.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        barChart.addReferenceLines(referenceLines: referenceLines)
        barChart.addPlot(plot: blueLinePlot)
        barChart.addPlot(plot: orangeLinePlot)

    }
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                print("User Details",self.response?.userAttributes!)
                self.helloNameLbl.text = "Hello " + (self.user?.username)!
            })
            return nil
        }
    }
    func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }

}
extension WelcomeVC: ScrollableGraphViewDataSource{
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "multiBlue":
            return linePlotData[pointIndex]
        case "multiOrange":
            return linePlotData1[pointIndex]
        default:
            return 0
        }
       // return linePlotData[pointIndex]

    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return linePlotData.count
    }
}
