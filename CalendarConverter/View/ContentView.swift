//
//  ContentView.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 02/03/2024.
//

import EventKit
import SwiftUI

struct ContentView: View {
	
	@AppStorage("showingOnboarding") private var showingOnboarding = true
	@StateObject private var connector = CalendarConnector()
	@StateObject private var vm = ViewModel()
	
	private var subscriptionHint: String {
		vm.subscribedCalendar != nil ? "\(vm.subscribedCalendar!.title) selected" : ""
	}
	
	private var localHint: String {
		vm.localCalendar != nil ? "\(vm.localCalendar!.title) selected" : ""
	}
	
	var body: some View {
		NavigationStack {
			if showingOnboarding {
				OnboardingView()
			} else if !connector.accessGranted {
				ContentUnavailableView(label: {
					Label("No calendar access", systemImage: "calendar.badge.minus")
					
				}, description: {
					Text("App needs full calendar access to get events from subscription calendars and create events in your local calendar.")
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
					.accessibilityLabel("Subscription calendar selection")
					.accessibilityHint(subscriptionHint)
					
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
						.accessibilityLabel("Local calendar selection")
						.accessibilityHint(localHint)
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
