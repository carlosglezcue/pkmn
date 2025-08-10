//
//  DismissKeyboardModifier.swift
//  PokePokeMON
//
//  Created by carlos.gonzalezc on 10/8/25.
//


import SwiftUI

/// A view modifier that dismisses the keyboard when tapping outside of a text input view.
///
/// Use this modifier on any view that contains text input fields to allow users to dismiss
/// the keyboard by tapping anywhere outside of the text input area.
///
/// Example:
/// ```swift
/// struct ContentView: View {
///     @State private var text = ""
///
///     var body: some View {
///         TextField("Enter text", text: $text)
///             .dismissKeyboardOnTapGesture()
///     }
/// }
/// ```
public struct DismissKeyboardModifier: ViewModifier {
    /// Modifies the view to add tap gesture recognition for keyboard dismissal.
    /// - Parameter content: The content view to be modified.
    /// - Returns: A view with added tap gesture recognition.
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                hideKeyboard()
            }
    }
    
    /// Hides the keyboard by instructing the window's first responder to resign.
    @MainActor
    private func hideKeyboard() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        window.endEditing(true)
    }
}

public extension View {
    /// Adds the ability to dismiss the keyboard when tapping outside of a text input view.
    /// - Returns: A view that can dismiss the keyboard on tap.
    func dismissKeyboardOnTapGesture() -> some View {
        modifier(DismissKeyboardModifier())
    }
}
