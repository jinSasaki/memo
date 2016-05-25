//
//  MemoViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit
import ReSwift

class MemoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var memos: [Memo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // To hide unnecessary separator
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self)
        if store.state.list.fetchStatus != .Fetching {
            store.dispatch(MemoListState.fetchMemo())
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)

        self.tableView.editing = false
    }
    
    @IBAction func didTapAddButton(sender: AnyObject) {
        self.navigateToDetail()
    }
    
    @IBAction func didTapEditButton(sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    
    private func navigateToDetail(memo: Memo? = nil) {
        let storyboard = UIStoryboard(name: "MemoDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? MemoDetailViewController {
            vc.memo = memo
            vc.modalTransitionStyle = .CoverVertical
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MemoViewController: StoreSubscriber {
    func newState(state: AppState) {

        self.memos = state.list.memos
        
        if let error = state.list.error {
            Alerts.handleError(error)
        }
        if let message = state.list.alertMessage {
            Alerts.success(message)
        }
        tableView.reloadData()
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let memo = self.memos[indexPath.row]
        cell.textLabel?.text = memo.title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(memo.updated)))
        cell.detailTextLabel?.text = "Last edited at \(dateString) by \(memo.editor)"
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            store.dispatch(MemoListState.deleteMemo(self.memos[indexPath.row].id))
        default: break
        }
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigateToDetail(self.memos[indexPath.row])
    }
}
