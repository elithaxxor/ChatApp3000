//
//  SettingsViewController.swift
//  ChatApp3000
//
//  Created by Adel Al-Aali on 1/19/23.
//

import UIKit

final class SettingsViewController: UIViewController {

    var chatList : UIViewController

    
    // MARK: Build subviews
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "person.circle")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    fileprivate let label:  UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    fileprivate let button : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.setTitle("leave.", for: .normal)
        return button
    }()
    
    @objc private func didTapButton() {
        print("[!] sign out btn pressed ")
        
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.modalPresentationStyle = .fullScreen
        ChatManager.shared.userSignOut()
        present(vc, animated: true)
    }
    
    fileprivate func addConstriants() {
        imageView.widthAnchor.constraint(equalToConstant: 100)
        imageView.heightAnchor.constraint(equalToConstant: 100)
        imageView.topAnchor.constraint(equalTo: )
    }
    //.. fin
    
    
//    init(chatList: UIViewController) {
//        super.init(nibName: nil, bundle: nil){return}
//            self.chatList = chatList
//        print("")
//    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "tweakz"
        view.backgroundColor = .darkGray
        addSubviews()
        addConstriants()
        setupActions()
    }
    
    fileprivate func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
    }
    
    fileprivate func setupActions() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
}
