//
//  ViewController.swift
//  ChatApp
//
//  Created by Adel Al-Aali on 1/19/23.
//

import UIKit
import Foundation
import MapKit
import LocalAuthentication
import LocalAuthenticationEmbeddedUI
import CoreLocation
import CoreLocationUI
import _CoreLocationUI_SwiftUI



class HomeViewController: UIViewController {
    
    // sets userdefaults to swtich from darkmode and light
    let styleSegmentedControl = UISegmentedControl()
    let defaults = UserDefaults.standard
    var isDarkMode = false
    struct keys {
        static let darkMode = "preferDarkMode"
        static let defaultUser = "me"
        static let loggedDirections : [MKDirections] = []
    }
    func setUserDefault() {
        defaults.set(isDarkMode, forKey: Keys.darkMode)
        defaults.set(defaultUser, forKey: Keys.defaultUser)
        defaults.set(loggedDirections, forKey: Keys.loggedDirections)
    }
    
    // [retrieves data] checks user defualts, switches if bool
    func checkUserDefault() {
        let darkMode = defaults.bool(forKey: keys.darkMode)
        if isDarkMode {
            isDarkMode = true
            styleSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    
    
    // checks if name is set and shows coreesponding value on text field
    func saveName() {
        defaults.set(userNameField.text!, forKey: keys.defaultUser)
    }
    
    // sets the user login name
    func saveUserName() {
        let userID = defualts.set(nameTextField.text!, forKey: keys.defaultUser)
        userNameField.text = userId
    }
    
    
    
//
//    var chatList : UIViewController
//
//    let footer = TabBarViewController(chatList: chatList)
//
    // MARK: MAP SETUP
    weak var statusLabel : UILabel!
    weak var latitudeLabel : UILabel!
    weak var longitudeLabel : UILabel!
    weak var addressLabel : UILabel!
    
    
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    let mapConfig = MKStandardMapConfiguration()
    var label: CLLocationButtonLabel?
    func configMap() {
        mapConfig.showsTraffic = true
        mapConfig.emphasisStyle = .default
        mapConfig.elevationStyle = .flat
        mapConfig.pointOfInterestFilter = .includingAll
        
    }

    

    
    var LM = LocationDataManager()
    
    // MARK: Classes / Debugloggers
    var timer = AppTimer()
    let dispatchGroup = DispatchGroup()
    static var VC = HomeViewController()
    
    
    // MARK: Start View
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yet another chat app \(\Intro.banner)")
        NSLog("[LOGGING--> <START> [HOME VC]")

        LocationDataManager.getDirections(self)
        
        //mapView.delegate = self // TODO: MAY HAVE TO CHANGE
        
        // MARK: Loggers / Timer Setup
        timer.setupTimer()
        createLogFile()
        
        // MARK: Initial View
        
        initButtons()
        addSubViews()
        addConstraint()
        
        DispatchQueue.main.async {
            self.configMap()
        }
    }
    
//    mapView
//    The map view that requests the renderer object.
//
//    overlay
//    The overlay object that the map view is about to display.
//

    
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
    // TODO: ADD LOCATION BUTTON
    //weak var findLocationButton : UIButton!

    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            
            userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            userNameField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50),
            userNameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            
            
            button.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            locationButton.topAnchor.constraint(equalTo:  button.bottomAnchor, constant: 40),
            locationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            locationButton.heightAnchor.constraint(equalToConstant: 50),

            mapView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 50),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            mapView.heightAnchor.constraint(equalToConstant: 50)
            
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

    
    let locationButton: CLLocationButton = {
        let lb = CLLocationButton()
        
        
        lb.cornerRadius = 30
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.addSubview(UIView(frame: .init(x: 0, y: 0, width: 10, height: 40)))
        
        lb.sizeToFit()
        
        
//        locationButton.cornerRadius = 25.0
//
        return lb
    }()
    
    // MARK: UserName Field + Constraints
    let userNameField: UITextField = {
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false

        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "username "
        field.backgroundColor = .darkGray
        field.textColor = .white
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        
        
        return field
    }()
    
    // MARK: UIButton
    internal let button : UIButton = {
        
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



extension HomeViewController {


}
