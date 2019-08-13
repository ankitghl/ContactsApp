//
//  ViewController.swift
//  Contacts
//
//  Created by admin on 29/01/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

struct ContactListSection {
    let sectionTitle: String
    let contacts: [Contact]
}

class ContactsListViewController: UIViewController {

    //MARK: - Outlets -

    @IBOutlet weak var contactsListTableView: UITableView!

    //MARK: - Constants and Variables -
    let contactCellIdentifier = "ContactCell"
    var viewModel: ContactListViewModel?

    //MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK: - Private Helpers -

    private func setUpUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))
        contactsListTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: contactCellIdentifier)
        contactsListTableView.tableFooterView = UIView()
        
        viewModel = ContactListViewModel()
        viewModel?.contactListViewModelDelegate = self
        navigationItem.title = viewModel?.title
        showActivityIndicator()
        viewModel?.getContactList()
    }
    
    //MARK: - Button Tappables -

    @objc func didTapAddButton(_ barButton: UIBarButtonItem) {
        let contactAddVC = ContactAddEditViewController.instantiateFromStoryboard(from: .main)
        contactAddVC.contactUpdateDelegate = self
        contactAddVC.viewModel = viewModel?.getViewModelForAddEdit()
        present(UINavigationController(rootViewController: contactAddVC), animated: true, completion: nil)
    }

}

extension ContactsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.contactListSections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contactListSections[section].contacts.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel?.contactListSections[section].contacts.count == 0 {
            return nil
        }
        return viewModel?.contactListSections[section].sectionTitle
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.contactListSections.compactMap({ $0.sectionTitle })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ContactCell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier) as? ContactCell {
            if let contact: Contact = viewModel?.contactListSections[indexPath.section].contacts[indexPath.row] {
                cell.displayData(contact: contact)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ContactDetailsTableView.normal.height())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contactData: Contact = viewModel?.contactListSections[indexPath.section].contacts[indexPath.row] {
            let contactDetailsVC = ContactDetailsViewController.instantiateFromStoryboard(from: .main)
            contactDetailsVC.editContact = contactData
            contactDetailsVC.contactUpdateDelegate = self
            contactDetailsVC.viewModel = viewModel?.getViewModelForContact(for: indexPath)
            navigationController?.pushViewController(contactDetailsVC, animated: true)
        }
    }
}

extension ContactsListViewController: ContactViewModelProtocol {
    func didFetchContactData() {
        hideActivityIndicator()
        contactsListTableView.reloadData()
    }
    
    func didReceiveFetchContactDataError(error: String) {
        hideActivityIndicator()
        showAlert(title: "Contacts", message: error, style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
    }
}

extension ContactsListViewController: ContactUpdateProtocol {
    func didUpdateContact() {
        showActivityIndicator()
        viewModel?.getContactList()
    }
}
