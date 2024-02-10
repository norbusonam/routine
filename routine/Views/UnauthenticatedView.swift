//
//  UnauthenticatedView.swift
//  routine
//
//  Created by Norbu Sonam on 1/25/24.
//

import SwiftUI
import AuthenticationServices

struct UnauthenticatedView: View {
    @Environment(\.colorScheme) var userColorScheme
    
    @State private var showView = false
    @State private var logoRotation = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accent)
                .frame(width: UIScreen.main.bounds.width / 6)
                .rotationEffect(.degrees(logoRotation))
                .animation(Animation.linear(duration: 6).repeatForever(autoreverses: false), value: logoRotation)
                .onAppear {
                    logoRotation = 360
                }
            Spacer()
            SignInWithAppleButton(
                onRequest: { request in
                    // Handle the sign-in request if needed
                },
                onCompletion: { result in
                    // Handle the sign-in completion
                    switch result {
                    case .success(let authorization):
                        // Handle successful sign-in
                        if authorization.credential is ASAuthorizationAppleIDCredential {
                            // Handle the user's Apple ID credential
                            // You may extract user information like name, email, etc. from appleIDCredential
                        }
                    case .failure(let error):
                        // Handle sign-in failure
                        print("Sign in with Apple failed: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(userColorScheme == .dark ? .white : .black)
            .frame(width: UIScreen.main.bounds.width - 50, height: 50)
            .padding(.bottom)
            .id(userColorScheme)
        }
        .opacity(showView ? 1 : 0)
        .animation(.easeIn(duration: 1), value: showView)
        .onAppear {
            showView = true
        }
    }
}

#Preview {
    UnauthenticatedView()
}
