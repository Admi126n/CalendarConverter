//
//  ContentView.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 02/03/2024.
//

import EventKit
import SwiftUI

struct ContentView: View {
	
	@StateObject private var connector = CalendarConnector()
	@StateObject private var vm = ViewModel()
	
	var body: some View {
		NavigationStack {
			if !connector.accessGranted {
				ContentUnavailableView(label: {
					Label("No calendar access", systemImage: "calendar.badge.minus")
					
				}, description: {
					Text("App needs calendar access to convert events.")
				}, actions: {
					Link("Go to settings", destination: URL(string: UIApplication.openSettingsURLString)!)
				})
			} else {
				Form {
					Section("Subscription calendar") {
						NavigationLink {
							CalendarPicker(calendar: $vm.subscribedCalendar, content: vm.subscribedCalendars, false)
						} label: {
							if let safeCalendar = vm.subscribedCalendar {
								CalendarLabel(safeCalendar)
							} else {
								Text("Select")
							}
						}
					}
					if vm.subscribedCalendarSelected {
						Section("Your calendar") {
							NavigationLink {
								CalendarPicker(calendar: $vm.localCalendar, content: vm.userCalendars, true) {
									vm.fillCalendars()
							 }
							} label: {
								if let safeCalendar = vm.localCalendar {
									CalendarLabel(safeCalendar)
								} else {
									Text("Select")
								}
							}
						}
					}
					
					if vm.subscribedCalendarSelected && vm.localCalendarSelected {
						Section("Date range") {
							DatePicker("From", selection: $vm.startDate, displayedComponents: .date)
								.datePickerStyle(.compact)
							
							DatePicker("To", selection: $vm.endDate, in: vm.toDatePickerStart..., displayedComponents: .date)
								.datePickerStyle(.compact)
						}
						
						Button {
							vm.convertEvents()
						} label: {
							Text("Convert")
								.frame(maxWidth: .infinity)
						}
						.buttonStyle(.borderedProminent)
						.disabled(vm.convertButtonPressed)
					}
				}
			}
		}
		.environmentObject(connector)
		.task {
			_ = await connector.requestAccess()
			await vm.requestCalendarAccess()
		}
		.alert(vm.alertTitle, isPresented: $vm.showingAlert) { } message: {
			Text(vm.alertMessage)
		}
	}
}

#Preview {
	ContentView()
}
