//
//  CalendarPicker.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 03/03/2024.
//

import EventKit
import SwiftUI

struct CalendarPicker: View {
	@Environment(\.dismiss) var dismiss
	
	@Binding var calendar: EKCalendar?
	
	let pickerTitle: String
	let content: [EKCalendar]
	
	var body: some View {
		Form {
			ForEach(content, id: \.self) { element in
				HStack {
					Circle()
						.frame(width: 10)
						.foregroundStyle(Color(cgColor: element.cgColor))
					
					Text(element.title)
					
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
						dismiss()
					}
				}
			}
		}
	}
	
	init(title pickerTitle: String, calendar: Binding<EKCalendar?>, content: [EKCalendar]) {
		self.pickerTitle = pickerTitle
		self.content = content
		
		self._calendar = calendar
	}
}
