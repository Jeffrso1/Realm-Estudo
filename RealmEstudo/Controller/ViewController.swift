//
//  ViewController.swift
//  RealmEstudo
//
//  Created by Jefferson Silva on 29/10/21.
//

import UIKit
import RealmSwift

enum CellIdentifiers: String {
    case contactCell
}

class ViewController: BaseViewController<MainControllerView> {
    
    var people: Results<Contact>?
    var realm: Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController related code.
        setupNavigationController()
        
        // RealSwift related code.
        setupRealmSwift()
        
        // TableView related code.
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.contactCell.rawValue)
    }
    
    // MARK: - Setup Functions
    func setupNavigationController() {
        navigationItem.title = "Contact List"
        
        let addContact = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContactButtonWasTapped))
        navigationItem.rightBarButtonItem = addContact
    }
    
    func setupRealmSwift() {
        
        // The code below fills people with all objects we currently have and instantiates realm itself as a variable.
        do {
            people = try Realm().objects(Contact.self).sorted(byKeyPath: "name", ascending: true)
            realm = try Realm()
        } catch { fatalError("\nSome sort of error occurred.\n") }
        
        guard let realm = realm else { return }

        // If there's no data in Realm, we add one contact (in order to test if the code is working properly).
        if realm.isEmpty {
            do {
                try realm.write({
                    realm.add(Contact(name: "Jefferson Silva", phone: "+12 (34) 56789-8976"))
                })
            } catch { fatalError("\nCouldn't write new contact.\n") }
        }
        
        // This path can be used to reach our Realm storage on RealmStudio.
        let path = realm.configuration.fileURL?.path
        print("Path: \(String(describing: path))")
    }
    
    // MARK: - Buttons' actions
    @objc
    func addContactButtonWasTapped() {
        let alertController = UIAlertController(title: "Add Contact", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert in
            
            guard let textFields = alertController.textFields else { return }
            let nameField = textFields[0] as UITextField
            let phoneField = textFields[1] as UITextField
            
            // If the name and phone slots aren't empty, we write our new contacts to Realm.
            if nameField.text != "" && phoneField.text != "" {
                let newPerson = Contact(name: nameField.text ?? "", phone: phoneField.text ?? "")
                
                do {
                    try self.realm?.write({
                        self.realm?.add(newPerson)
                        
                        // After adding the new contact, we need to reload our tableView's data.
                        self.mainView.tableView.reloadData()
                    })
                    
                } catch { fatalError("\nCouldn't add new contact to Realm.\n") }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addTextField { textField in
            textField.placeholder = "New Contact Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "+11 (11) 11111-1111"
        }
        
        self.present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let people = people else { return 0 }
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.contactCell.rawValue, for: indexPath) as? ContactsTableViewCell else
        {
            return UITableViewCell()
        }
        
        guard let people = people else { return cell }
        
        cell.setupCell(username: people[indexPath.row].name, phone: people[indexPath.row].phone)
        
        return cell
    }
}
