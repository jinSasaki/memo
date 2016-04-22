//
//  MemoViewController.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import UIKit

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
        
        self.loadMemo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView.editing = false
    }
    
    private func loadMemo() {
        API.getMemos { result in
            switch result {
            case .Success(let memos):
                dispatch_async(dispatch_get_main_queue(), {
                    self.memos = memos.memos
                    self.tableView.reloadData()
                })
            case .Failure(let error):
                Alerts.handleError(error)
            }
        }
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
            // TODO: Delete
            API.deleteMemo(memoId: self.memos[indexPath.row].id, handler: { (result) in
                switch result {
                case .Success(_):
                    Alerts.success("success delete.")
                    self.loadMemo()
                case .Failure(let error):
                    Alerts.handleError(error)
                }
            })
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
