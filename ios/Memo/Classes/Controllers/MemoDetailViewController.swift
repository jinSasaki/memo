//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var memo: Memo?
    fileprivate var canBack: Bool = true
    
    @IBAction func didTapDoneButton(_ sender: AnyObject) {
        if var memo = self.memo {
            // Update
            memo.title = self.titleTextField.text ?? memo.title
            memo.body = self.bodyTextView.text
            memo.editor = self.nameTextField.text ?? memo.editor
            API.updateMemo(memo: memo, handler: { (result) in
                switch result {
                case .success(let memo):
                    Alerts.success("Update succeeded: " + memo.title)
                    self.canBack = true
                    self.dismissViewController()
                case .failure(let error):
                    Alerts.handleError(error)
                }
            })
        } else {
            // Create
            API.createMemo(
                title: self.titleTextField.text ?? "",
                body: self.bodyTextView.text,
                author: self.nameTextField.text ?? "",
                handler: { (result) in
                    switch result {
                    case .success(let memo):
                        Alerts.success("Create succeeded: " + memo.title)
                        self.canBack = true
                        self.dismissViewController()
                    case .failure(let error):
                        Alerts.handleError(error)
                    }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.memo == nil ? "Create" : "Edit"

        self.titleTextField.delegate = self
        self.nameTextField.delegate = self
        self.bodyTextView.delegate = self

        if let memo = self.memo {
            // Update content
            self.titleTextField.text = memo.title
            self.bodyTextView.text = memo.body
        }
        self.nameTextField.text = ""
        
        // To Close keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MemoDetailViewController.closeKeyboard)))
        
        // To confirm that content will be clear
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissViewController))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeKeyboard()
    }
    
    dynamic private func dismissViewController() {
        self.closeKeyboard()
        if self.canBack {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Memo is edited.", message: "If back to list, current memo will be clear. You want to back?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func closeKeyboard() {
        self.titleTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.bodyTextView.resignFirstResponder()
    }
}

extension MemoDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.closeKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.canBack = false
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.canBack = false
    }
}
