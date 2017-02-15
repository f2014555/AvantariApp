import UIKit
import UserNotifications

class NotificationOnRepeatRandomNumber: UIViewController,UNUserNotificationCenterDelegate {
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Configure User Notification Center
		UNUserNotificationCenter.current().delegate = self
	}
	
	func didTapButton() {
		print("didTapButton")
		// Request Notification Settings
		UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
			switch notificationSettings.authorizationStatus {
			case .notDetermined:
				self.requestAuthorization(completionHandler: { (success) in
					guard success else { return }
					
					// Schedule Local Notification
					self.scheduleLocalNotification()
				})
			case .authorized:
				// Schedule Local Notification
				self.scheduleLocalNotification()
			case .denied:
				print("Application Not Allowed to Display Notifications")
			}
		}
	}
	
	// MARK: - Private Methods
	
	private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
		// Request Authorization
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
			if let error = error {
				print("Request Authorization Failed (\(error), \(error.localizedDescription))")
			}
			
			completionHandler(success)
		}
	}
	
	private func scheduleLocalNotification() {
		// Create Notification Content
		let notificationContent = UNMutableNotificationContent()
		
		// Configure Notification Content
		notificationContent.title = "Avantari"
		notificationContent.subtitle = "Local Notifications"
		notificationContent.body = "We have found same number consecutively"
		notificationContent.sound = UNNotificationSound.default()
		
		
		// Add Trigger
		let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
		
		// Create Notification Request
		let notificationRequest = UNNotificationRequest(identifier: "customNotificationIdentifier", content: notificationContent, trigger: notificationTrigger)
		
		// Add Request to User Notification Center
		UNUserNotificationCenter.current().add(notificationRequest) { (error) in
			if let error = error {
				print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
			}
		}
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert,.sound])
	}
	
}
