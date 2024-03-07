//
//  EKCalendar+example.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 06/03/2024.
//

import EventKit

extension EKCalendar {
	
	/// Example calendar for `.event` with `title` and random `cgColor`
	static var example: EKCalendar {
		let calendar = EKCalendar(for: .event, eventStore: EKEventStore())
		calendar.title = "Example calendar"
		calendar.cgColor = CGColor(
			red: CGFloat.random(in: 0...1),
			green: CGFloat.random(in: 0...1),
			blue: CGFloat.random(in: 0...1),
			alpha: 1
		)
		
		return calendar
	}
}
