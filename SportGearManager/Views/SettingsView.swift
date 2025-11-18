//
//  SettingsView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showingPrivacy = false
    @State private var showingTerms = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About")) {
                    Button(action: {
                        showingPrivacy = true
                    }) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        showingTerms = true
                    }) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        rateApp()
                    }) {
                        HStack {
                            Text("Rate Us")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    .foregroundColor(.primary)
                }
                
                Section(header: Text("App")) {
                    Button(action: {
                        hasSeenOnboarding = false
                    }) {
                        HStack {
                            Text("Show Onboarding")
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundColor(.mainColorApp)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .background(Color.backColorApp)
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPrivacy) {
                WebView(url: "https://www.termsfeed.com/live/9279f2ff-fb67-44ae-9135-09394cf5a8c7")
                    .navigationTitle("Privacy Policy")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $showingTerms) {
                WebView(url: "https://www.termsfeed.com/live/1385150d-6626-413a-bf41-38ffda12568f")
                    .navigationTitle("Terms of Service")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .background(Color.backColorApp)
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

struct WebView: View {
    let url: String
    
    var body: some View {
        if let url = URL(string: url) {
            SafariView(url: url)
        } else {
            Text("Unable to load page")
                .foregroundColor(.secondary)
        }
    }
}

import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

