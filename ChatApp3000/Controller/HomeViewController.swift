//
//  ViewController.swift
//  ChatApp
//
//  Created by Adel Al-Aali on 1/19/23.
//

import UIKit
import Foundation


class HomeViewController: UIViewController {
    
    // MARK: Classes / Debugloggers
    var timer = AppTimer()
    let dispatchGroup = DispatchGroup()
    static var VC = HomeViewController()
    
    
    // MARK: Start View
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yet another chat app \(\Intro.banner)")
        
        // MARK: Loggers / Timer Setup
        timer.setupTimer()
        createLogFile()
        NSLog("[LOGGING--> <START> [HOME VC]")
        
        
        // MARK: Initial View
        view.backgroundColor = .lightGray
        view.addSubview(userNameField)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        addConstraint()
        
    }
    
    // MARK: INIT First Responder
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.becomeFirstResponder()
        
        // checks the api for current login, if current login show the chatlist
        if ChatManager.shared.isSignedIn {
            print("[!] User Currently Signed in! ")
            showChatList(animated: false)
        } else {
            print("[-] Users not signed in. ")
        }
    }
    
    // MARK: UserName Field + Constraints
    private let userNameField: UITextField = {
        
        let field = UITextField()
        
        field.placeholder = "username "
        field.backgroundColor = .darkGray
        field.textColor = .white
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        
        return field
    }()
    
    // MARK: UIButton
    private let button : UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = .systemMint
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("Continue.. ", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: Constriants
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            userNameField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50 ),
            userNameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50 ),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            
            button.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: View- Present Chat list (after continue btn pressed)
    // the function will granb the channelVC from the ChatManager/API
    // It passes the 'compose' icon (top right)
    
    func showChatList(animated: Bool = true){
        
        print("[!] opening chat list")
        guard let vc = ChatManager.shared.createChannelList() else { // pulls channel-list from API
            print("\(VCError.channelListVC.errorDescription)")
            return
        }
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,   // creates 'compose' icone for new view (top right)
                                                               target: self,
                                                               action: #selector(didTapCompose))
        
        let tabVC = TabBarViewController(chatList: vc)
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: animated)
    }
    
    
    // MARK: Denit first responder
    @objc private func didTapContinue() {
        
        userNameField.resignFirstResponder()
        
        guard let text = userNameField.text, !text.isEmpty else { return }
        ChatManager.shared.userSignIn(with: text) { [weak self] success in
            guard success else {
                print("\(LoginError.loginInput)")
                return }
        }
        
        print("[!] LOGIN SUCCESS [!] ")
        DispatchQueue.main.async { self.showChatList() }
    }
    
    
    
    
    @objc private func didTapCompose() {
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
}

