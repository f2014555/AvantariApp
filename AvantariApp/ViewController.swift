import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController,ChartDelegate {

	@IBOutlet weak var chart: Chart!
	var number: [NSManagedObject] = []
	
	var data = [Float]()
	var checkChart = false
	override func viewDidLoad() {
		chart.delegate = self
		
		//super.viewDidLoad()
		self.data.append(0 as Float)
		
		//print(self.data)
		modifyGraph()
		_ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(modifyGraph), userInfo: nil, repeats: true)

	}
	
	func modifyGraph(){
	
		fetchDataFromCore()
		
		let length = self.data.count
		var test:Array<Float> = []
		var lengthForGraph = 0
		
		if length < 10 {
				lengthForGraph = length
		}
		else{
			lengthForGraph = 10
		}
		
		for i in 1...lengthForGraph {
			test.append(self.data[length - i])
		}
		print(test)
		
		if checkChart{
		 chart.removeAllSeries()
		}
		createGraph(test)

	}

	func createGraph(_ test:Array<Float>){
		let series = ChartSeries(test)
		series.area = true
		series.colors = (above: ChartColors.blueColor(), below: ChartColors.greyColor(), 7)
		chart.add(series)
	
		chart.minY = 1
		chart.maxY = 9
		
		chart.yLabelsFormatter = { String(Int($1))}
		chart.xLabelsFormatter = { String(Int($1))}

		checkChart = true
		chart.setNeedsDisplay()
	}
	override func viewWillAppear(_ animated: Bool) {
			  super.viewWillAppear(animated)
			fetchDataFromCore()
		
	}
	
	func fetchDataFromCore(){
		//1
		guard let appDelegate =
			UIApplication.shared.delegate as? AppDelegate else {
				return
		}
		
		let managedContext =
			appDelegate.persistentContainer.viewContext
		
		//2
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Numbers")
		
		//3
		do {
			number = try managedContext.fetch(fetchRequest)
						for num in number{
							if let a = num as? NSManagedObject {
								self.data.append(a.value(forKey: "number")! as! Float)
							}
						}
			
			}
			catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	// Chart delegate
	
	func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
		for (seriesIndex, dataIndex) in indexes.enumerated() {
			if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
				print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
			}
		}
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		super.viewWillTransition(to: size, with: coordinator)
		
		// Redraw chart on rotation
		
	}
	

}
