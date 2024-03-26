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
	
	@Binding var calendar: EKCalendar?
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var connector: CalendarConnector
	@State private var showingSheet = false
	
	private let content: [EKCalendar]
	private let dismissOnSelection: Bool
	private let showCalendarCreator: Bool
	
	var body: some View {
		if content.isEmpty {
			ContentUnavailableView("You don't have any subscribed calendars", systemImage: "calendar.badge.exclamationmark")
		} else {
			Form {
				Section {
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
				
				if showCalendarCreator {
					Section {
						Button("Create new calendar") {
							showingSheet = true
						}
					}
				}
			}
			.sheet(isPresented: $showingSheet) {
				if calendar != nil {
					dismiss()
				}
			} content: {
				CreateNewCalendarView() { newCalendar in
					calendar = newCalendar
				}
				.environmentObject(connector)
			}
		}
	}
	
	
	/// Custom picker for choosing calendar from given calendars list
	/// - Parameters:
	///   - calendar: Binding to property in which selected calendar is saved
	///   - content: List of calendars to choose from
	///   - dismissOnSelection: If set to `true` picker dismisses itself after selecting calendar
	///   - showCalendarCreator: If set to `true` section for creating new calendar appears
	init(calendar: Binding<EKCalendar?>, content: [EKCalendar], dismissOnSelection: Bool = true, _ showCalendarCreator: Bool) {
		self.content = content
		self.dismissOnSelection = dismissOnSelection
		self.showCalendarCreator = showCalendarCreator
		
		self._calendar = calendar
	}
}
