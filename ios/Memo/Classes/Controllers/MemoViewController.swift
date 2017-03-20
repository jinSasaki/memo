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
    
    fileprivate var memos: [Memo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // To hide unnecessary separator
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadMemo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView.isEditing = false
    }
    
    fileprivate func loadMemo() {
        API.getMemos { result in
            switch result {
            case .success(let memos):
                DispatchQueue.main.async {
                    self.memos = memos.memos
                    self.tableView.reloadData()
                }
            case .failure(let error):
                Alerts.handleError(error)
            }
        }
    }
    
    @IBAction func didTapAddButton(_ sender: AnyObject) {
        self.navigateToDetail()
    }
    
    @IBAction func didTapEditButton(_ sender: AnyObject) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    fileprivate func navigateToDetail(_ memo: Memo? = nil) {
        let storyboard = UIStoryboard(name: "MemoDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? MemoDetailViewController {
            vc.memo = memo
            vc.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let memo = self.memos[indexPath.row]
        cell.textLabel?.text = memo.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(memo.updated)))
        cell.detailTextLabel?.text = "Last edited at \(dateString) by \(memo.editor)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // TODO: Delete
            API.deleteMemo(memoId: self.memos[indexPath.row].id, handler: { (result) in
                switch result {
                case .success(_):
                    Alerts.success("success delete.")
                    self.loadMemo()
                case .failure(let error):
                    Alerts.handleError(error)
                }
            })
        default: break
        }
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigateToDetail(self.memos[indexPath.row])
    }
}
