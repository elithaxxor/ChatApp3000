////
////  Alerts.swift
////  ChatApp3000
////
////  Created by Adel Al-Aali on 1/19/23.
////
//
//import Foundation
//import UIKit
//
struct Intro {
     let banner = """
          __,
         (           o  /) _/_
          `.  , , , ,  //  /
        (___)(_(_/_(_ //_ (__
                     /)
                    (/
        
        version 0.0.1 Beta
        copyleft, [all wrongs reserved] @elit_haxxor
        
        
        """
    
}
//class Alerts : UIViewController{
//    // TODO: May have to remove @IBAction. If not, then lnk to the storyboard
//    @IBAction private func showSymbolAlert(controller: UIViewController){
//        print("[!] User Entered the wrong input, asking for new Symbol ")
//        let alert = UIAlertController(title: "🛑🛑🛑", message: "🛑enter a proper symbol🛑", preferredStyle: .alert)
//
//        // NOTE: Left Btn action --
//        // TODO: ADD LOGIIV TO REFRESH THE HOMEVIEW.
//        alert.addAction(UIAlertAction(title: "edit", style: .default, handler: { [weak self] (editor) in
//            print("[!] User is editing symnol \(editor)")
//            self?.showAlertTextField()
//        }))
//
//        //TODO: Add to refresh table view and reload data for verifiation.
//        alert.addAction(UIAlertAction(title: "reload", style: .cancel, handler: { [weak self] (reloadData) in
//            print("[!] User initiated reload data \(reloadData)")
//            // self?.reloadData()
//
//        }))
//
//        // TASK: The red btn
//        alert.addAction(UIAlertAction(title: "dismiss", style: .destructive, handler: { [weak self] (goBack) in
//            print("[!] User initiated alert canncel \(goBack)")
//
//        }))
//
//        self.present(alert, animated: true, completion: {
//            print("[!] Alert View Initiated")
//        })
//    }
//
//
//    // TODO: Take user input for alert view and pass on to verificatno class.
//    private func showAlertTextField() {
//        print("[!] User is Editing the symbol via the alert view.")
//        let notifiedSymbol = Notification.Name.symbol
//        let alertController = UIAlertController(title: "enter new symbol", message: "\(notifiedSymbol) not valid", preferredStyle: .alert)
//
//        let confirmEditBtn = UIAlertAction(title: "add", style: .default) { [weak self] (edit) in
//            print("[!] Editing UITextField ")
//            if let alertField = alertController.textFields?.first, let text = alertField.text {
//                NotificationCenter.default.post(name: .symbol, object: text)
//                print("[!] User entered \(text)")
//                self?.reloadData()
//                self?.validateField(symbol: text)
//                self?.dispatchGroup.leave()
//            }
//        }
//        let cancelAlertBtn = UIAlertAction(title: "dismiss", style: .cancel) { [weak self] (cancel) in
//            DispatchQueue.global(qos: .userInitiated).async {
//                self?.reloadData()
//                self?.dispatchGroup.leave()
//            }
//
//        }
//        alertController.addTextField { textField in (textField)
//            textField.placeholder = "$symbol"
//            print("[!] [ALERT-TEXT-FIELD] \(textField.text)")
//        }
//
//        alertController.addAction(confirmEditBtn)
//        alertController.addAction(cancelAlertBtn)
//        self.present(alertController, animated: true, completion: nil)
//
//    }
//}
