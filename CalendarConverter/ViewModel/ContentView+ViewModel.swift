//
//  ContentViewModel.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 05/03/2024.
//

import EventKit
import Foundation

extension ContentView {
	
	@Observable
	class ViewModel {
		var sourceCalendar: EKCalendar?
		var destinationCalendar: EKCalendar?
		
		var sourceCalendarSelected: Bool {
			sourceCalendar != nil
		}
		
		var destinationCalendarSelected: Bool {
			destinationCalendar != nil
		}
	}
}
