//
//  ContactDetailsViewController.swift
//  Contacts
//
//  Created by admin on 02/02/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController {

    //MARK: - Outlets -
    @IBOutlet weak var contactDetailsTableView: UITableView!

    //MARK: - Constants and Variables -
    var editContact: Contact?
    var viewModel: ContactDetailsViewModel?
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditBarButton(_:)))
        contactDetailsTableView.tableFooterView = UIView()
        contactDetailsTableView.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: productImageCellIdentifier)
        contactDetailsTableView.register(UINib(nibName: "FieldTableViewCell", bundle: nil), forCellReuseIdentifier: fieldCellIdentifier)

        showActivityIndicator()
        viewModel?.contactDetailsViewModelDelegate = self
        viewModel?.getContactDetails()
    }

    
    private func action(for button: UIButton) {
        switch button.tag {
        case ContactDetailsActionTags.message.tag(): // Message
            guard let phoneNumber = viewModel?.contactData?.phoneNumber else { return }
            sendText(to: phoneNumber)
        case ContactDetailsActionTags.phone.tag(): //Phone
            guard let phoneNumber = viewModel?.contactData?.phoneNumber else { return }
            makeACall(phoneNumber: phoneNumber)
        case ContactDetailsActionTags.email.tag(): // Mail
            guard let email = viewModel?.contactData?.email, email != "" else { return }
            send(email: email)
        case ContactDetailsActionTags.favourite.tag(): // ContactActionType
            showActivityIndicator()
            viewModel?.updatefavourites()
        default: break
        }
    }

    private func makeACall(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    //MARK: - Button Tappables -
    @objc func didTapEditBarButton(_ barButton: UIBarButtonItem) {        
        let contactAddVC = ContactAddEditViewController.instantiateFromStoryboard(from: .main)
        contactAddVC.contactUpdateDelegate = contactUpdateDelegate
        contactAddVC.viewModel = viewModel?.getViewModel()
        present(UINavigationController(rootViewController: contactAddVC), animated: true, completion: nil)
    }

}

extension ContactDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return viewModel?.isPresent(field: viewModel?.contactData?.phoneNumber) ?? false ? 1 : 0
        case 2: return viewModel?.isPresent(field: viewModel?.contactData?.email) ?? false ? 1 : 0
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell: ProfileImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: productImageCellIdentifier, for: indexPath) as? ProfileImageTableViewCell {
                cell.cameraButton.isHidden = true
                cell.configure(details: viewModel?.contactData)
                cell.didButtonTap = { [weak self] button in
                    self?.action(for: button)
                }
                return cell
            }
        } else {
            if let cell: FieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: fieldCellIdentifier, for: indexPath) as? FieldTableViewCell {
                cell.selectionStyle = .none
                cell.fieldTextField.isUserInteractionEnabled = false
                if indexPath.section == 1 {
                    cell.configure(fieldType: ContactDetailsFields.mobile.placeholder(), fieldValue: viewModel?.contactData?.phoneNumber)
                } else {
                    cell.configure(fieldType: ContactDetailsFields.email.placeholder(), fieldValue: viewModel?.contactData?.email)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ContactDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        switch indexPath.section {
        case 0: height = UITableView.automaticDimension
        case 1: height = CGFloat(viewModel?.isPresent(field: viewModel?.contactData?.phoneNumber) ?? false ? ContactDetailsTableView.textCell.height() : ContactDetailsTableView.zero.height())
        case 2: height = CGFloat(viewModel?.isPresent(field: viewModel?.contactData?.email) ?? false ? ContactDetailsTableView.textCell.height() : ContactDetailsTableView.zero.height())
        default: break
        }
        return height
    }
}

extension ContactDetailsViewController: ContactViewModelProtocol {
    func didFetchContactData() {
        hideActivityIndicator()
        contactDetailsTableView.reloadData()
        contactUpdateDelegate?.didUpdateContact()
    }
    
    func didReceiveFetchContactDataError(error: String) {
        hideActivityIndicator()
        showAlert(title: "Contacts", message: error, style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
    }
}


extension ContactDetailsViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func send(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        } else {
            showAlert(title: nil, message: "Unable to compose Mail", style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
    }
    
    func sendText(to mobile: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = " "
            controller.recipients = [mobile]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            showAlert(title: nil, message: "Unable to send Message", style: .alert, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
