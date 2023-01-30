//
//  ViewController.swift
//  ChatApp
//
//  Created by Adel Al-Aali on 1/19/23.
//

import UIKit
import Foundation

import LocalAuthentication
import LocalAuthenticationEmbeddedUI




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
        
         userNameField.addTarget(self, action: #selector(didTextfield), for: .allEditingEvents) // FIXME: May have to change this to textview
        
        
        addConstraint()
        
    }
    
    // MARK: INIT First Responder
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.becomeFirstResponder()
        ChatManager.shared.APISetUp()
        // checks the api for current login, if current login show the chatlist
        if ChatManager.shared.isSignedIn {
            print("[!] User Currently Signed in! ")
            showChatList(animated: true)
        } else {
            print("[-] Users not signed in. ")
        }
    }
    
    
    
    // MARK: Constriants -- button / usernamefield
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            
            userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            userNameField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50),
            userNameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50),
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
    
    
    
    
    // MARK: START OF BUTTON / TEXTFIELD FUNCTIONALITY (obj-c)
    
    
    // MARK: UserName Field + Constraints
    let userNameField: UITextField = {
        
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
    
    
}

