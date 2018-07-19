//
//  NotificationsManager.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 19/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import UserNotifications

private let maxContentLength = 30

class NotificationsManager: NSObject {
    
    static let instance = NotificationsManager()
    
    private let db = DisposeBag()
    private lazy var checkForPermission: Observable<Bool> = self.lazyCheckForPermission()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func scheduleNotification(for task: Task, at length: ReminderLength) {
        checkForPermission
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] granted in
                guard granted else { return }
                self?.scheduleLocalNotification(for: task, at: length)
            })
            .disposed(by: db)
    }
    
    private func scheduleLocalNotification(for task: Task, at length: ReminderLength) {
        let content = UNMutableNotificationContent()
        content.body = trimmedContent(for: task)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: length.seconds, repeats: false)
        let request = UNNotificationRequest(identifier: task.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func trimmedContent(for task: Task) -> String {
        let trimOffset = task.text.index(task.text.startIndex, offsetBy: maxContentLength, limitedBy: task.text.endIndex)
        if let offset = trimOffset {
            return String(task.text[..<offset])
        } else {
            return task.text
        }
    }
    
    private func cancelScheduledNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.identifier])
    }
    
    
    private func lazyCheckForPermission() -> Observable<Bool> {
        return checkForNotificationsPermission()
            .flatMapLatest ({ granted -> Observable<Bool> in
                if granted {
                    return Observable.of(granted)
                } else  {
                    return NotificationsManager.promptNotificationsPermissions()
                }
            })
    }
    
    private class func promptNotificationsPermissions() -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (isGranted, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(isGranted)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
    
    private func checkForNotificationsPermission() -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let granted = settings.authorizationStatus == .authorized
                observer.onNext(granted)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
}

extension NotificationsManager: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

}

