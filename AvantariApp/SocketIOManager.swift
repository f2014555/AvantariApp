//
//  SocketIOManager.swift
//  AvantariApp
//
//  Created by SKIXY-MACBOOK on 13/02/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import SocketIO
import UserNotifications
import CoreData

class SocketIOManager: NSObject {

	static let sharedInstanceForSocket = SocketIOManager()
	var number: [NSManagedObject] = []

	let socket = SocketIOClient(socketURL: URL(string: "http://ios-test.us-east-1.elasticbeanstalk.com")!, config: [.log(false), .forcePolling(true)])
	
	var prevNumber = [Float]()
		
	func establishConnection() {
		self.socket.nsp = "/random"
		self.socket.connect()
	}


	func closeConnection() {
		socket.disconnect()
	}
	
	override init(){
		super.init()
		prevNumber.append(0)
			
		self.socket.on("capture") {data,ack in
			let temp = (data[0] as? Float)!
			self.prevNumber.append(temp)
			self.checkIfSameNumberAppearedTwice()
			self.save(name: temp)
		
		}
		
	}
	func checkIfSameNumberAppearedTwice(){

		if prevNumber[prevNumber.count - 1] == prevNumber[prevNumber.count - 2]{
			print("same random number appeared again")
			
			NotificationOnRepeatRandomNumber().didTapButton()
			

		}
		
	}

	func save(name: Float) {
		
			let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

			  let entity =
				NSEntityDescription.entity(forEntityName: "Numbers",in: managedContext)!
					
			  let person = NSManagedObject(entity: entity,
										   insertInto: managedContext)
					
			  // 3
			  person.setValue(name, forKeyPath: "number")
					
			  // 4
			  do {
				try managedContext.save()
				number.append(person)
				} catch let error as NSError {
				print("Could not save. \(error), \(error.userInfo)")
			  }
			  
	}
	
	
	
	
	
}
