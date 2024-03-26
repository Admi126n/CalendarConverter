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
	@State private var calendarTitle = ""
	
	let onCalendarCreation: (EKCalendar) -> ()
	
    var body: some View {
		Form {
			TextField("New calendar title", text: $calendarTitle)
				.focused($focused)
			
			Button {
				if let newCalendar = connector.createCalendar(with: calendarTitle) {
					onCalendarCreation(newCalendar)
					dismiss()
				}
			} label: {
				Text("Create new calendar")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
		}
		.onAppear {
			focused = true
		}
    }
}

#Preview {
	CreateNewCalendarView() { _ in }
}
