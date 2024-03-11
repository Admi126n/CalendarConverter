//
//  EKEvent+getCopy.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 11/03/2024.
//

import EventKit

extension EKEvent {
	
	/// Creates copy of an event
	func getCopy(_ eventStore: EKEventStore) -> EKEvent {
		let copy = EKEvent(eventStore: eventStore)
		copy.title = self.title
		copy.startDate = self.startDate
		copy.endDate = self.endDate
		copy.notes = self.notes
		copy.location = self.location
		
		return copy
	}
}
