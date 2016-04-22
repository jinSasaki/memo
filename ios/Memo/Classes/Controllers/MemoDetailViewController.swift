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
    private var canBack: Bool = true
    
    @IBAction func didTapDoneButton(sender: AnyObject) {
        if var memo = self.memo {
            // Update
            memo.title = self.titleTextField.text ?? memo.title
            memo.body = self.bodyTextView.text
            memo.editor = self.nameTextField.text ?? memo.editor
            API.updateMemo(memo: memo, handler: { (result) in
                switch result {
                case .Success(let memo):
                    Alerts.success("Update succeeded: " + memo.title)
                    self.canBack = true
                    self.dismiss()
                case .Failure(let error):
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
                    case .Success(let memo):
                        Alerts.success("Create succeeded: " + memo.title)
                        self.canBack = true
                        self.dismiss()
                    case .Failure(let error):
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(MemoDetailViewController.dismiss))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeKeyboard()
    }
    
    @objc private func dismiss() {
        self.closeKeyboard()
        if self.canBack {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let alertController = UIAlertController(title: "Memo is edited.", message: "If back to list, current memo will be clear. You want to back?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func closeKeyboard() {
        self.titleTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.bodyTextView.resignFirstResponder()
    }
}

extension MemoDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.closeKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.canBack = false
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.canBack = false
    }
}
