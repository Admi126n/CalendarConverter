//
//  CalendarConverter.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 11/03/2024.
//

import EventKit
import SwiftUI

class CalendarConnector: ObservableObject {
	let eventStore = EKEventStore()
	
	@Published var accessGranted = false
	
	func requestAccess() async -> Bool {
		let succes = try? await eventStore.requestFullAccessToEvents()
		
		if succes ?? false {
			Task { @MainActor in
				accessGranted = true
			}
		}
		
		return accessGranted
	}
	
	/// Returns list of all available subscribed calendars
	///
	/// Returned calendars have to have property `type == .subscription`
	/// Also calendar `Święta w Polsce` is filtered
	func getSubscribedCalendars() -> [EKCalendar] {
		guard accessGranted else { return [] }
		
		var calendars = eventStore.calendars(for: .event)
		calendars = calendars.filter { $0.type == .subscription }
		calendars = calendars.filter { $0.title != "Święta w Polsce" }
		
		return calendars
	}
	
	/// Returns list of all available user calendars
	///
	/// Returned calendars have to have property `allowsContentModifications == true`
	func getUserCalendars() -> [EKCalendar] {
		guard accessGranted else { return [] }
		
		var calendars = eventStore.calendars(for: .event)
		calendars = calendars.filter { $0.allowsContentModifications }
		
		return calendars
	}
	
	/// Returns list fo all events in given time interval
	/// - Parameters:
	///   - calendar: calendar from which events are fetched
	///   - from: date from which events are fetched
	///   - to: date to which events are fetched
	/// - Returns: list of events
	func getEvents(for calendar: EKCalendar, _ from: Date, _ to: Date) -> [EKEvent] {
		guard accessGranted else { return [] }
		guard from < to else { return [] }
		
		let predicate = eventStore.predicateForEvents(withStart: from, end: to, calendars: [calendar])
		let events = eventStore.events(matching: predicate)
		
		return events
	}
	
	/// Creates copy of given events in given calendar
	///  
	/// If no calendar is given copies are created in `defaultCalendarForNewEvents`
	/// - Parameters:
	///   - events: list of events to duplicate
	///   - calendar: calendar in which duplicated events are created
	/// - Returns: number of duplicated events, if no events was duplicated returns `nil`
	func duplicate(_ events: [EKEvent], in calendar: EKCalendar?) -> Int? {
		guard accessGranted else { return nil }
		
		if calendar == nil {
			guard eventStore.defaultCalendarForNewEvents != nil else { return nil }
		}
		
		for event in events {
			createEvent(from: event, in: calendar ?? eventStore.defaultCalendarForNewEvents!)
		}
		
		if events.count != 0 {
			return events.count
		} else {
			return nil
		}
	}
	
	/// Creates copy of given event in given calendar
	/// - Parameters:
	///   - event: event of which copy is created
	///   - calendar: calendar in which given event is created
	private func createEvent(from event: EKEvent, in calendar: EKCalendar) {
		let newEvent = event.getCopy(eventStore)
		newEvent.calendar = calendar
		
		do {
			try eventStore.save(newEvent, span: .thisEvent)
		} catch {
			print(error.localizedDescription)
		}
	}
}
