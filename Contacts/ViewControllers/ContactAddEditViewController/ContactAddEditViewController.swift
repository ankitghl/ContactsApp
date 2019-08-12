//
//  ContactInfoViewController.swift
//  Contacts
//
//  Created by Ankit.Gohel on 10/08/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ContactAddEditViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var contactTableView: UITableView!
    
    //MARK: - Variables and Constants -
    var path: String?
    var viewModel: ContactAddEditViewModel?
    var contactUpdateDelegate: ContactUpdateProtocol?

    let productImageCellIdentifier = "ProfileImageTableViewCell"
    let fieldCellIdentifier = "FieldTableViewCell"

    //MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK: - Private Helpers -
    private func setUpUI() {
        viewModel?.contactAddDeleteViewModelDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton(_:)))
        contactTableView.tableFooterView = UIView()
        contactTableView.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: productImageCellIdentifier)
        contactTableView.register(UINib(nibName: "FieldTableViewCell", bundle: nil), forCellReuseIdentifier: fieldCellIdentifier)
        
    }

    private func validateAndUpdateContact() {
        if let _errorMessage = viewModel?.validateContactAndThrowErrorMessage(contact: (viewModel?.contactData)!), !_errorMessage.isEmpty {
            showAlert(title: "Contacts", message: _errorMessage, style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        } else {
            showActivityIndicator()
            viewModel?.createNewContact()
        }
    }
    
    //MARK: - Button Tappables -
    @objc func didTapDoneButton(_ barButton: UIBarButtonItem) {
        if let _contactDetailsChanges = viewModel?.isFieldValuesChanged, !_contactDetailsChanges {
            self.dismiss(animated: false , completion: nil)
        } else {
            validateAndUpdateContact()
        }
    }

}

extension ContactAddEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
}

extension ContactAddEditViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell: ProfileImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: productImageCellIdentifier, for: indexPath) as? ProfileImageTableViewCell {
                cell.infoContainerStackView.isHidden = true
                cell.configure(details: viewModel?.contactData)
                return cell
            }
        } else {
            if let cell: FieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: fieldCellIdentifier, for: indexPath) as? FieldTableViewCell {
                cell.selectionStyle = .none
                cell.fieldTextField.delegate = self
                cell.fieldTextField.tag = (indexPath.section) + 10
                cell.didEditText = { [weak self] (text, tag)  in
                    self?.viewModel?.isFieldValuesChanged = true
                    if self?.viewModel?.contactData == nil {
                        self?.viewModel?.contactData = ContactDisplayModel(contact: Contact(id: 0,
                                                                                            firstName: "",
                                                                                            lastName: "",
                                                                                            profilePic: "",
                                                                                            favorite: false,
                                                                                            url: "",
                                                                                            phoneNumber: "",
                                                                                            email: ""))
                    }
                    switch tag {
                    case ContactDetailsFields.firstName.tag(): self?.viewModel?.contactData?.firstName = text
                    case ContactDetailsFields.lastName.tag(): self?.viewModel?.contactData?.lastName = text
                    case ContactDetailsFields.mobile.tag(): self?.viewModel?.contactData?.phoneNumber = text
                    case ContactDetailsFields.email.tag(): self?.viewModel?.contactData?.email = text
                    default: break
                    }
                }
                
                switch indexPath.section {
                case 1: //FirstName
                    cell.configure(fieldType: ContactDetailsFields.firstName.placeholder(), fieldValue: viewModel?.contactData?.firstName ?? "")
                case 2: // LastName
                    cell.configure(fieldType: ContactDetailsFields.lastName.placeholder(), fieldValue: viewModel?.contactData?.lastName ?? "")
                case 3: // Mobile
                    cell.configure(fieldType: ContactDetailsFields.mobile.placeholder(), fieldValue: viewModel?.contactData?.phoneNumber ?? "")
                case 4: // Email
                    cell.configure(fieldType: ContactDetailsFields.email.placeholder(), fieldValue: viewModel?.contactData?.email ?? "")
                default: break
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ContactAddEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 56
    }
}

extension ContactAddEditViewController: ContactViewModelProtocol {
    func didFetchContactData() {
        hideActivityIndicator()
        
        self.dismiss(animated: true, completion: { [weak self] in
            self?.contactUpdateDelegate?.didUpdateContact()
        })
        if viewModel?.contactActionType != .create {
            let appDelegate = UIApplication.shared.delegate
            if let navigationVC = appDelegate?.window??.rootViewController as? UINavigationController {
                navigationVC.viewControllers = navigationVC.viewControllers.dropLast()
            }
        }
    }
    
    func didReceiveFetchContactDataError(error: String) {
        hideActivityIndicator()
        showAlert(title: "Contacts", message: error, style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
    }
}
