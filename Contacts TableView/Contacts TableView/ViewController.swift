//
//  ViewController.swift
//  Contacts TableView
//
//  Created by Srans022019 on 20/05/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {

    let cellID = "cellID"
    
    //MARK:- call back function of custom cell
    func callSomeMethodFromCell(cell: UITableViewCell) {
        
        //Getting indexpath when the particular row is clicked
        guard let indexPathTapped = tableView.indexPath(for: cell) else {return}
       
        //getting name from the particular row tapped.
        let contact = twoDimentionArray[indexPathTapped.section].names[indexPathTapped.row]
        
        print(contact)
        
        let hasFavourate = contact.isFavourite
        
        twoDimentionArray[indexPathTapped.section].names[indexPathTapped.row].isFavourite = !hasFavourate
        
       // tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = contact.isFavourite ? UIColor.lightGray : .red
    }
    
    //You can map the item to all or you can write as 3rd element in array represents the same.

    var twoDimentionArray = [ExpandCollapse]()
//    var twoDimentionArray = [
//        ExpandCollapse(isExpandable: true, names: ["Vikas", "vinay", "viswas", "vivek", "Rohan"].map{FavouritableContact(name: $0, isFavourite: false) }),
//        ExpandCollapse(isExpandable: true, names: ["Kousthub", "Vignesh", "Sreenu", "srilatha"].map{FavouritableContact(name: $0, isFavourite: false) }),
//        ExpandCollapse(isExpandable: true, names: [FavouritableContact(name: "venkat", isFavourite: false)]),
//        ExpandCollapse(isExpandable: true, names: ["venu", "gopal", "kalyani"].map{FavouritableContact(name: $0, isFavourite: false) })
//    ]
    
    //Right Bar button to check if it is tapped on not
    var showIndexPathData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up a title and adding bar button to NAV Controller
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show indexPath", style: .plain, target: self, action: #selector(showIndexPath))
        
        //Register TV cell
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellID)
        
        fetchContacts()
        
        // Do any additional setup after loading the view.
    }
    
    //Selector
    
    private func fetchContacts() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            
            if let error = error {
                print(error)
            }
            
            if granted {
                print("contacts granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let contactFetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    
                    var FavouritableContacts = [FavouritableContact]()
                    
                    try store.enumerateContacts(with: contactFetch, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating ) in
                      
                        print(contact.givenName + " " + contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        FavouritableContacts.append(FavouritableContact(contact: contact, isFavourite: false))
                       // FavouritableContacts.append(FavouritableContact(name: contact.givenName + " " + contact.familyName , isFavourite: false))
                        
                    })
                    
                    let names = ExpandCollapse(isExpandable: true, names: FavouritableContacts)
                    self.twoDimentionArray = [names]
                    
                    
                }catch let error{
                    print("No conatcts were been provided", error)
                }
                
            }else{
                print("contacts denined")
            }
        }
        
    }
    
    
    
    //MARK:- bar button item action
    @objc func showIndexPath(_ sender: UIBarButtonItem) {
        
        var indexPathToLoad = [IndexPath]()
        
        //finding number of sections in twodimensional array
        for section in twoDimentionArray.indices {
            
            //checks the number of sections are available
            //checks if section is expanded or not
            //performs row animation from .right or .left as per bar button selector
            if twoDimentionArray[section].isExpandable {
                
                //finding number of rows in two dimentional array based on sections
                for row in twoDimentionArray[section].names.indices {
                    
                    //Assign the row and section from dimensional array to indexpath and appends it
                    let indexPath = IndexPath(row: row, section: section)
                    indexPathToLoad.append(indexPath)
                }
                
                print("is expanded")
            }
            
        }
        
        //Checks and resiprocates the action eg: if true then false
        showIndexPathData = !showIndexPathData
        
        //Animating row and making 2 action as per the click type action
        let animateStyle = showIndexPathData ? UITableView.RowAnimation.right : .left
        tableView.reloadRows(at: indexPathToLoad, with: animateStyle)
        
    }
   
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .lightGray
//        return label
        
        let button = UIButton(type: .system)
        button.setTitle("Collapse", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(onTapExpandCollapse(button:)), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    //selector
    //MARK:- Section Header button action
    @objc func onTapExpandCollapse(button : UIButton) {
        
        //Getting button tag as per the click action
        var indexPathDetails = [IndexPath]()
        let section = button.tag
        
        //checks for the rows based on the button tag to expand or collapse
        for row in twoDimentionArray[section].names.indices {
            
            let indexPath = IndexPath(row: row, section: section)
            indexPathDetails.append(indexPath)
        }
        
        let isExpandable = twoDimentionArray[section].isExpandable
        twoDimentionArray[section].isExpandable = !isExpandable
        
        //changing title of button
        button.setTitle(isExpandable ? "Expand" : "Collapse", for: .normal)
        
        //Tableview display based on the action performed delete or insert row.
        if isExpandable {
            tableView.deleteRows(at: indexPathDetails, with: .fade)
            button.setTitle("Expand", for: .normal)
            print("expand")
        }else {
            tableView.insertRows(at: indexPathDetails, with: .fade)
            button.setTitle("Collapse", for: .normal)
            print("collapse")
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimentionArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //checking if collapsed the row count is zero
        if !twoDimentionArray[section].isExpandable {
            return 0
        }
        
        return twoDimentionArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCell
        
        let cell = CustomCell(style: .subtitle, reuseIdentifier: cellID)
        
        let favourableContact = twoDimentionArray[indexPath.section].names[indexPath.row]
        
        cell.link = self
        
        cell.accessoryView?.tintColor = favourableContact.isFavourite ? UIColor.red : .lightGray
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        
        cell.textLabel?.text = favourableContact.contact.givenName + " " + favourableContact.contact.familyName
        cell.detailTextLabel?.text = favourableContact.contact.phoneNumbers.first?.value.stringValue
        
        if showIndexPathData {
            cell.textLabel?.text = "\(favourableContact.contact.givenName + " " + favourableContact.contact.familyName) \(" ") Section: \(indexPath.section) Row: \(indexPath.row)"
        }
    
        return cell
    }

}

