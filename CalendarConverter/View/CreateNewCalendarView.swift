//
//  CreateNewCalendarView.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 26/03/2024.
//

import EventKit
import SwiftUI

struct CreateNewCalendarView: View {
	
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var connector: CalendarConnector
	@FocusState private var focused: Bool
	@State private var calendarColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
	@State private var calendarTitle = ""
	
	let onCalendarCreation: (EKCalendar) -> ()
	
	private var disableButton: Bool {
		calendarTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
	
	private var trimmedCalendarTitle: String {
		calendarTitle.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
    var body: some View {
		Form {
			Section {
				TextField("Calendar title", text: $calendarTitle)
					.focused($focused)
				
				ColorPicker("Calendar color", selection: $calendarColor, supportsOpacity: false)
				
				Button {
					if let newCalendar = connector.createCalendar(with: calendarTitle, color: calendarColor) {
						onCalendarCreation(newCalendar)
						dismiss()
					}
				} label: {
					Text("Create new calendar")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)
				.disabled(disableButton)
			}
			
			Button {
				dismiss()
			} label: {
				HStack {
					Spacer()
					
					Text("Cancel")
				}
			}
		}
		.onAppear {
			focused = true
		}
    }
}

#Preview {
	CreateNewCalendarView() { _ in }
}
