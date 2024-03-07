//
//  CalendarPicker.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 03/03/2024.
//

import EventKit
import SwiftUI

/// Custom picker for choosing calendar from given calendars list
struct CalendarPicker: View {
	@Environment(\.dismiss) private var dismiss
	
	@Binding var calendar: EKCalendar?
	
	private let content: [EKCalendar]
	private let dismissOnSelection: Bool
	
	var body: some View {
		Form {
			ForEach(content, id: \.self) { element in
				HStack {
					CalendarLabel(element)
					
					Spacer()
					
					if element == calendar {
						Image(systemName: "checkmark")
							.foregroundStyle(.green)
					}
				}
				.contentShape(.rect)
				.onTapGesture {
					withAnimation {
						calendar = element
						
						if dismissOnSelection { dismiss() }
					}
				}
			}
		}
	}
	
	
	/// Custom picker for choosing calendar from given calendars list
	/// - Parameters:
	///   - calendar: Binding to property in which selected calendar is saved
	///   - content: List of calendars to choose from
	///   - dismissOnSelection: If set to `true` picker dismisses itself after selecting calendar
	init(calendar: Binding<EKCalendar?>, content: [EKCalendar], dismissOnSelection: Bool = true) {
		self.content = content
		self.dismissOnSelection = dismissOnSelection
		
		self._calendar = calendar
	}
}
