import Foundation
import UIKit
import LocalAuthentication


extension HomeViewController {
    
    // MARK: Denit first responder
    @objc internal func didTapContinue() {
        
        userNameField.resignFirstResponder()
        guard let text = userNameField.text, !text.isEmpty else { return }
        print("[!] User tapped continue. [TEXT] \(text)")
        
        ChatManager.shared.userSignIn(with: text) { [weak self] success in
            guard success else {
                print("\(LoginError.loginInput)")
                return }
        }
        
        DispatchQueue.main.async { self.showChatList() }
    }
    
    
    
    
    // OBJC- For Segue to chat-channel
    @objc internal func didTapCompose() {
        let alert = UIAlertController(title: "new convo ",
                                      message: "room name ",
                                      preferredStyle: .alert
        )
        alert.addTextField()
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Create", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            DispatchQueue.main.async {
                ChatManager.shared.createNewChannel(name: text)
            }
        }))
        presentedViewController?.present(alert, animated: true)
    }
    
    
    
    // OBJ-C For Face-Authentication ---> makes call to didTapCompose
    @objc func didTextfield() {
        var error : NSError? = nil
        let context = LAContext()
        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            let reason = "open sesame"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard  success, error == nil
                    else {  // fail
                        let alert = UIAlertController(
                            title: "guess again..",
                            message: "try bruteforce ;)",
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "leave",
                                                      style: .cancel,
                                                      handler: nil))
                        self?.present(alert, animated: true)
                        return
                        
                    }
                    print("success")
                    let vc = UIViewController()
                    vc.title = "enter young padawon"
                    vc.view.backgroundColor = .systemBlue
                    self?.present(UINavigationController(rootViewController: vc),
                                  animated: true,
                                  completion: nil)
                }
            }
        }
        didTapCompose()
    }
}
    
    
