//
//  CalendarLabel.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 05/03/2024.
//

import EventKit
import SwiftUI

/// View representing `cgColor` and `title` of given calendar
///
/// Color and title are packed inside `Group`
struct CalendarLabel: View {
	
	private let calendar: EKCalendar
	
	var body: some View {
		Group {
			Circle()
				.frame(width: 12)
				.foregroundStyle(Color(cgColor: calendar.cgColor))
			
			Text(calendar.title)
		}
		.accessibilityElement(children: .combine)
		.accessibilityLabel(calendar.title)
	}
	
	init(_ calendar: EKCalendar) {
		self.calendar = calendar
	}
}

#Preview {
	CalendarLabel(EKCalendar.example)
}
