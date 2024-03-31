//
//  OnboardingView.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 31/03/2024.
//

import SwiftUI

struct OnboardingView: View {
	
	/// Animating with `selectedPage` didn't work so this is why `symbolAnimator` is needed
	@State private var symbolAnimator = false
	@State private var selectedPage = 0
	@AppStorage("showingOnboarding") private var showingOnboarding = true
	
	var body: some View {
		TabView(selection: $selectedPage) {
			OnboardingPageView(
				pageTitle: String(localized: "Select calendars"),
				pageMessage: String(localized: "Select subscribed calendar and your local calendar."),
				pageSymbolName: "calendar",
				buttonTitle: String(localized: "Next")) {
					withAnimation {
						selectedPage = 1
					}
				}
				.onAppear(perform: toggleSymbolAnimator)
				.tag(0)
			
			OnboardingPageView(
				pageTitle: String(localized: "Select date range"),
				pageMessage: String(localized: "Select date range in which you want to convert events."),
				pageSymbolName: "calendar.badge.clock",
				buttonTitle: String(localized: "Next")) {
					withAnimation {
						selectedPage = 2
					}
				}
				.onAppear(perform: toggleSymbolAnimator)
				.tag(1)
			
			OnboardingPageView(
				pageTitle: String(localized: "And that's it!"),
				pageMessage: String(localized: "Events from subscribed calendar are saved in your local calendar!"),
				pageSymbolName: "calendar.badge.checkmark",
				buttonTitle: String(localized: "To the app!")) {
					showingOnboarding = false
				}
				.onAppear(perform: toggleSymbolAnimator)
				.tag(2)
		}
		.symbolEffect(.bounce.byLayer, value: symbolAnimator)
		.multilineTextAlignment(.center)
		.tabViewStyle(.page)
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
	
	private func toggleSymbolAnimator() {
		withAnimation {
			symbolAnimator.toggle()
		}
	}
}

#Preview {
	OnboardingView()
}
