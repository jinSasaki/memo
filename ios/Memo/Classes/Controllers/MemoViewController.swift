//
//  MemoViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import APIKit

class MemoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    var memos = Variable<[Memo]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.memos
            .asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("cell")) { _, memo, cell in
                cell.textLabel?.text = memo.title
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let dateString = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(memo.updated)))
                cell.detailTextLabel?.text = "Last edited at \(dateString) by \(memo.editor)"
            }
            .addDisposableTo(disposeBag)

        self.tableView
            .rx_itemSelected
            .subscribeNext { (indexPath) in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.navigateToDetail(self.memos.value[indexPath.row])
            }
            .addDisposableTo(disposeBag)
        
        self.tableView
            .rx_itemDeleted.flatMap({ (indexPath) in
                API.deleteMemo(memoId: self.memos.value[indexPath.row].id)
            })
            .subscribe(
                onNext: { _ in
                    Alerts.success("success delete.")
                    self.loadMemos()
                },
                onError: { (error) in
                    Alerts.handleError(error)
                }, onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        // To hide unnecessary separator
        self.tableView.tableFooterView = UIView()
        
        self.addButton.rx_tap.subscribeNext { () in
            self.navigateToDetail()
        }.addDisposableTo(self.disposeBag)
        
        self.editButton.rx_tap.subscribeNext { () in
            self.tableView.setEditing(!self.tableView.editing, animated: true)
        }
        .addDisposableTo(self.disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadMemos()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView.editing = false
    }
    
    private func loadMemos() {
        API.getMemos()
            .subscribeNext({ (memos) in
                self.memos.value = memos.memos
            })
            .addDisposableTo(disposeBag)
    }
    
    private func navigateToDetail(memo: Memo? = nil) {
        let storyboard = UIStoryboard(name: "MemoDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? MemoDetailViewController {
            vc.viewModel = MemoViewModel(memo: memo) 
            vc.modalTransitionStyle = .CoverVertical
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
