//
//  OnboardingPageView.swift
//  CalendarConverter
//
//  Created by Adam Tokarski on 31/03/2024.
//

import SwiftUI

struct OnboardingPageView: View {
	let pageTitle: String
	let pageMessage: String
	let pageSymbolName: String
	let buttonTitle: String
	let buttonAction: () -> Void
	
	var body: some View {
		VStack {
			Spacer()
			
			VStack(spacing: 20) {
				Text(pageTitle)
					.font(.title)
					.fontWeight(.semibold)
				
				Text(pageMessage)
					.foregroundStyle(.secondary)
				
				Image(systemName: pageSymbolName)
					.font(.title)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.overlay {
				RoundedRectangle(cornerRadius: 10)
					.stroke(.secondary, lineWidth: 2)
			}
			.accessibilityElement(children: .combine)
			.accessibilityLabel(pageTitle)
			.accessibilityHint(pageMessage)
			
			Spacer()
			
			Button(action: buttonAction) {
				HStack {
					Text(buttonTitle)
					
					Image(systemName: "arrow.forward")
				}
				.foregroundStyle(.white)
				.padding(7)
				.background(.tint)
				.clipShape(.rect(cornerRadius: 7))
			}
			.offset(y: -50)
			.accessibilityLabel(buttonTitle)
		}
		.padding()
	}
}

#Preview {
	OnboardingPageView(
		pageTitle: "Example",
		pageMessage: "Page message",
		pageSymbolName: "checkmark",
		buttonTitle: "Example") { }
}
