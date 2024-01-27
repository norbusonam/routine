//
//  AuthView.swift
//  routine
//
//  Created by Norbu Sonam on 1/25/24.
//

import SwiftUI
import AuthenticationServices

struct UnauthenticatedView: View {
    var body: some View {
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
        .frame(width: 200, height: 50)
    }

}

#Preview {
    UnauthenticatedView()
}
