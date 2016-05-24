//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemoViewModel {
    let original: Memo?
    var title: Variable<String>
    var name: Variable<String>
    var body: Variable<String>
    var isNew: Bool {
        return self.original == nil
    }
    
    init(memo: Memo?) {
        self.original = memo
        self.title = Variable<String>(memo?.title ?? "")
        self.name = Variable<String>("")
        self.body = Variable<String>(memo?.body ?? "")
    }
    
    func memo() -> Memo {
        var memo = self.original ?? Memo()
        memo.title = self.title.value
        memo.body = self.body.value
        if self.isNew {
            memo.author = self.name.value
        }
        memo.editor = self.name.value
        return memo
    }
}

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var viewModel: MemoViewModel!
    private var canBack: Bool = true
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.isNew ? "Create" : "Edit"
        
        // Bind Title
        viewModel.title.asObservable().bindTo(titleTextField.rx_text).addDisposableTo(disposeBag)
        self.titleTextField.rx_text.subscribeNext { (text) in
            self.viewModel.title.value = text
            }.addDisposableTo(self.disposeBag)
        
        // Bind name
        viewModel.name.asObservable().bindTo(nameTextField.rx_text).addDisposableTo(disposeBag)
        self.nameTextField.rx_text.subscribeNext { (text) in
            self.viewModel.name.value = text
            }.addDisposableTo(self.disposeBag)
        
        // Bind body
        viewModel.body.asObservable().bindTo(bodyTextView.rx_text).addDisposableTo(disposeBag)
        self.bodyTextView.rx_text.subscribeNext { (text) in
            if text != (self.viewModel.original?.body ?? "") {
                self.canBack = false
            }
            self.viewModel.body.value = text
            }.addDisposableTo(self.disposeBag)
        
        // Bind Done button
        self.doneButton
            .rx_tap.subscribeNext { _ in
                let memo = self.viewModel.memo()
                if self.viewModel.isNew {
                    // Create
                    API.createMemo(
                        title: memo.title,
                        body: memo.body,
                        author: memo.author)
                        .subscribe(
                            onNext: { (memo) in
                                Alerts.success("Create succeeded: " + memo.title)
                                self.canBack = true
                                self.dismiss()
                            },
                            onError: { (error) in
                                Alerts.handleError(error)
                            },
                            onCompleted: nil,
                            onDisposed: nil)
                        .addDisposableTo(self.disposeBag)
                } else {
                    // Update
                    API.updateMemo(memo: memo)
                        .subscribe(
                            onNext: { (memo) in
                                Alerts.success("Update successded: " + memo.title)
                                self.canBack = true
                                self.dismiss()
                            },
                            onError: { (error) in
                                Alerts.handleError(error)
                            },
                            onCompleted: nil,
                            onDisposed: nil)
                        .addDisposableTo(self.disposeBag)
                }
            }
            .addDisposableTo(self.disposeBag)
        
        // To Close keyboard
        let tapGesutre = UITapGestureRecognizer()
        tapGesutre
            .rx_event.subscribeNext { _ in
                self.closeKeyboard()
            }
            .addDisposableTo(self.disposeBag)
        self.view.addGestureRecognizer(tapGesutre)
        
        // To confirm that content will be clear
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        barButton.style = .Plain
        barButton.rx_tap
            .subscribeNext { _ in
                self.dismiss()
            }
            .addDisposableTo(self.disposeBag)
        self.navigationItem.leftBarButtonItem = barButton
        
        // Textfield delegate
        Observable
            .combineLatest(
                self.titleTextField.rx_controlEvent(.EditingDidEndOnExit),
                self.nameTextField.rx_controlEvent(.EditingDidEndOnExit)
            ) { _ in }
            .subscribeNext { () in
                self.closeKeyboard()
            }
            .addDisposableTo(self.disposeBag)
        
        Observable
            .combineLatest(
                self.titleTextField.rx_controlEvent(.EditingDidBegin),
                self.nameTextField.rx_controlEvent(.EditingDidBegin)
            ) { _ in }
            .subscribeNext { () in
                self.canBack = false
            }
            .addDisposableTo(self.disposeBag)
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
