//
//  OnboardingView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.backColorApp
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    imageName: "tshirt.fill",
                    title: "Track Your Gear",
                    description: "Keep track of all your sports equipment in one place. Add photos, track condition, and monitor usage."
                )
                .tag(0)
                
                OnboardingPageView(
                    imageName: "bell.fill",
                    title: "Smart Reminders",
                    description: "Get automatic reminders for cleaning, replacement, and maintenance. Never forget to take care of your gear."
                )
                .tag(1)
                
                OnboardingPageView(
                    imageName: "checklist",
                    title: "Packing Lists",
                    description: "Create custom packing lists for different sports. Check off items as you pack for your workouts."
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                if currentPage == 2 {
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.mainColorApp)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.mainColorApp)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .background(Color.backColorApp)
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(.mainColorApp)
                .padding(.bottom, 20)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.backColorApp)
    }
}

