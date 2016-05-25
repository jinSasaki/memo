//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit
import ReSwift

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var memo: Memo?

    @IBAction func didTapDoneButton(sender: AnyObject) {
        if var memo = self.memo {
            // Update
            memo.title = self.titleTextField.text ?? memo.title
            memo.body = self.bodyTextView.text
            memo.editor = self.nameTextField.text ?? memo.editor
            store.dispatch(MemoDetailState.updateMemo(memo))
        } else {
            // Create
            store.dispatch(
                MemoDetailState.createMemo(
                    title: self.titleTextField.text ?? "",
                    body: self.bodyTextView.text,
                    author: self.nameTextField.text ?? ""
                )
            )
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
        self.closeKeyboard()
    }
    
    @objc private func dismiss() {
        self.closeKeyboard()
        if store.state?.detail.canDismiss ?? true {
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

extension MemoDetailViewController: StoreSubscriber {
    func newState(state: AppState) {
        
        self.memo = state.detail.memo
        
        if let error = state.detail.error {
            Alerts.handleError(error)
        }
        if let message = state.detail.alertMessage {
            Alerts.success(message)
            self.dismiss()
        }
    }
}

extension MemoDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.closeKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        store.dispatch(MemoDetailState.changeCanDismiss(false))
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        store.dispatch(MemoDetailState.changeCanDismiss(false))
    }
}
