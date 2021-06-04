//
//  CatalystSparkleDriver.swift
//  Whaler
//
//  Created by Zack Rhodes on 6/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import SparkleBridgeClient

class CatalystSparkleDriver: SparkleDriver, ObservableObject {
	var setupError: NSError?
	var updateCallback: UpdateAlertCallback?
	var installCallback: UpdateStatusCallback?
	var okCallback: (() -> Void)?
	
	override init() {
		let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
		hasBeenUpdated = build == "2"
		super.init()
	}
	
	var expected: UInt64 = 0 {
		didSet {
			progress = expected > 0 ? Double(received)/Double(expected) : 0
		}
	}
	var received: UInt64 = 0 {
		didSet {
			progress = expected > 0 ? Double(received)/Double(expected) : 0
		}
	}
	
	var percent: Int {
		return Int(progress * 100)
	}
	
	@Published var progress: Double = 0
	@Published var status: String = ""
	var hasBeenUpdated = false
	@Published var canCheck = false
	
	var hasUpdate: Bool {
		return updateCallback != nil
	}
	
	func downloadUpdate() {
		updateCallback?(.update)
		updateCallback = nil
	}
	
	func skipUpdate() {
		updateCallback?(.skip)
		updateCallback = nil
	}
	
	func ignoreUpdate() {
		updateCallback?(.later)
		updateCallback = nil
	}
	
	func installUpdate() {
		installCallback?(.installAndRelaunch)
		installCallback = nil
	}
	
	override func showCanCheck(forUpdates canCheckForUpdates: Bool) {
		Log.debug("canCheckForUpdates: \(canCheckForUpdates)")
		canCheck = canCheckForUpdates
	}
	
	override func showUpdatePermissionRequest(_ request: UpdatePermissionRequest, reply: @escaping (UpdatePermissionResponse) -> Void) {
		Log.debug("show")
	}
	
	override func showUserInitiatedUpdateCheck(completion updateCheckStatusCompletion: @escaping (UserInitiatedCheckStatus) -> Void) {
		Log.debug("showUserInitiatedUpdateCheck")
		status = "Checking for update."
	}
	
	override func dismissUserInitiatedUpdateCheck() {
		print("dismissUserInitiatedUpdateCheck")
		status = ""
	}
	
	override func showUpdateFound(with appcastItem: AppcastItem, userInitiated: Bool, reply: @escaping UpdateAlertCallback) {
		Log.debug("showUpdateFound")
		status = "Update available."
		updateCallback = reply
	}
	
	override func showDownloadedUpdateFound(with appcastItem: AppcastItem, userInitiated: Bool, reply: @escaping UpdateAlertCallback) {
		Log.debug("showDownloadedUpdateFound")
	}
	
	override func showResumableUpdateFound(with appcastItem: AppcastItem, userInitiated: Bool, reply: @escaping UpdateStatusCallback) {
		Log.debug("showResumableUpdateFound")
	}
	
	override func showInformationalUpdateFound(with appcastItem: AppcastItem, userInitiated: Bool, reply: @escaping InformationCallback) {
		Log.debug("showInformationalUpdateFound")
	}
	
	override func showUpdateReleaseNotes(withDownloadData downloadData: Data, encoding: String?, mimeType: String?) {
		Log.debug("showUpdateReleaseNotes")
	}
	
	override func showUpdateReleaseNotesFailedToDownloadWithError(_ error: Error) {
		Log.debug("showUpdateReleaseNotesFailedToDownloadWithError")
	}
	
	override func showUpdateNotFound(acknowledgement: @escaping () -> Void) {
		Log.debug("showUpdaterError")
		status = "Update Not Found"
		okCallback = acknowledgement
	}
	
	override func showUpdaterError(_ error: Error, acknowledgement: @escaping () -> Void) {
		Log.debug("showUpdaterError")
		status = "Failed to launch installer.\n\(error)"
		okCallback = acknowledgement
	}
	
	override func showDownloadInitiated(completion downloadUpdateStatusCompletion: @escaping DownloadStatusCallback) {
		Log.debug("showDownloadInitiated")
		status = "Downloading update..."
	}
	
	override func showDownloadDidReceiveExpectedContentLength(_ expectedContentLength: UInt64) {
		Log.debug("showDownloadDidReceiveExpectedContentLength")
		expected = expectedContentLength
	}
	
	override func showDownloadDidReceiveData(ofLength length: UInt64) {
		Log.debug("showDownloadDidReceiveData")
		received += length
		status = "Downloading update... (\(percent)%)"
	}
	
	override func showDownloadDidStartExtractingUpdate() {
		Log.debug("showDownloadDidStartExtractingUpdate")
		status = "Extracting update..."
	}
	
	override func showExtractionReceivedProgress(_ progress: Double) {
		Log.debug("showExtractionReceivedProgress")
		self.progress = progress
		status = "Extracting update... (\(percent)%)"
	}
	
	override func showReady(toInstallAndRelaunch installUpdateHandler: @escaping UpdateStatusCallback) {
		Log.debug("showReady")
		status = "Update Ready To Install."
		installCallback = installUpdateHandler
	}
	
	override func showInstallingUpdate() {
		Log.debug("showInstallingUpdate")
		status = "Installing update..."
	}
	
	override func showSendingTerminationSignal() {
		Log.debug("showSendingTerminationSignal")
		status = "Sending termination..."
	}
	
	override func showUpdateInstallationDidFinish(acknowledgement: @escaping () -> Void) {
		Log.debug("showUpdateInstallationDidFinish")
		status = "Installation finished."
		okCallback = acknowledgement
	}
	
	override func dismissUpdateInstallation() {
		Log.debug("dismissUpdateInstallation")
		status = ""
	}
}
