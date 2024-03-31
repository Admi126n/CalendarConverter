//
//  ContentViewModel.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 05/03/2024.
//

import EventKit
import SwiftUI

extension ContentView {
	
	class ViewModel: ObservableObject {
		
		/// Property set to `true` if app has full access to calendar
		@Published private var accessGranted = false {
			didSet {
				fillCalendars()
			}
		}
		
		/// Choosen `Date` from which events to convert will be fetched
		@Published var startDate: Date = Calendar.current.startOfDay(for: .now) {
			didSet {
				endDate = startDate.addingTimeInterval(24 * 3600)
			}
		}
		
		/// Choosen `Date` to which events to convert will be fetched
		///
		/// Property is set automatically on `startDate` `didSet` to 24 hours after `startDate`
		@Published var endDate: Date = Calendar.current.startOfDay(for: .now.addingTimeInterval(24 * 3600)) {
			didSet {
				convertButtonPressed = false
			}
		}
		
		/// Choosen subscribed `EKCalendar` from which events to convers will be fetched
		@Published var subscribedCalendar: EKCalendar? {
			didSet {
				convertButtonPressed = false
			}
		}
		
		/// Choosen local `EKCalendar` in which events from `subscribedCalendar` will be created
		@Published var localCalendar: EKCalendar? {
			didSet {
				convertButtonPressed = false
			}
		}
		
		/// Set to `true` after converting events
		///
		/// After change of `subscribedCalendar`, `localCalendar`, 
		/// `startDate` or `endDate` property is set back to false
		@Published var convertButtonPressed: Bool = false
		
		@Published var showingAlert: Bool = false
		
		/// List of subscribed `EKCalendars`
		@Published private(set) var subscribedCalendars: [EKCalendar] = []
		
		/// List od user `EKCalendars`
		@Published private(set) var userCalendars: [EKCalendar] = []
		
		/// Instance of `CalendarConnector`
		private var calendarConnector = CalendarConnector()
		
		/// Number of duplicated events, set to `nil` if no events were converted
		private var duplicatedEventsCount: Int?
		
		/// Alert title
		private(set) var alertTitle = ""
		
		/// Alert message
		private(set) var alertMessage = ""
		
		/// Returnes `true` if `localCalendar` is not `nil`
		var localCalendarSelected: Bool {
			localCalendar != nil
		}
		
		/// Returnes `true` if `subscribedCalendar` is not `nil`
		var subscribedCalendarSelected: Bool {
			subscribedCalendar != nil
		}
		
		/// Property set to 24 hours after `startDate`
		var toDatePickerStart: Date {
			startDate.addingTimeInterval(24 * 3600)
		}
		
		func fillCalendars() {
			subscribedCalendars = calendarConnector.getSubscribedCalendars()
			userCalendars = calendarConnector.getUserCalendars()
		}
		
		func requestCalendarAccess() async {
			let result = await calendarConnector.requestAccess()
			
			Task { @MainActor in
				self.accessGranted = result
			}
		}
		
		func convertEvents() {
			guard subscribedCalendar != nil else { return }
			
			duplicatedEventsCount = nil
			
			let events = calendarConnector.getEvents(
				for: subscribedCalendar!,
				startDate,
				endDate.addingTimeInterval(24 * 3600)
			)
			
			duplicatedEventsCount = calendarConnector.duplicate(events, in: localCalendar)
			configureAlert()
			
			withAnimation {
				convertButtonPressed = true
				showingAlert = true
			}
		}
		
		private func configureAlert() {
			if duplicatedEventsCount != nil {
				alertTitle = String(localized: "alert.success.title")
				alertMessage = String(localized: "alert.success.message \(duplicatedEventsCount!) \(localCalendar!.title)")
			} else {
				alertTitle = String(localized: "alert.error.title")
				alertMessage = String(localized: "alert.error.message")
			}
		}
	}
}
