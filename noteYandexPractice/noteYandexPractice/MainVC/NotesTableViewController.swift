//
//  NotesTableViewController.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//


import UIKit

class NotesTableViewController: UITableViewController {
    
    var notebook = FileNotebook()
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()
    @objc func addNoteTaped(_ sender: Any) {
         performSegue(withIdentifier: "ShowEditNote", sender: sender)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let loadNotesOperation = LoadNoteOperation(
            notebook: notebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue
        )
        let updateUI = BlockOperation {
            self.tableView.reloadData()
            print("data reloaded")
            print("load notes is finished? \(loadNotesOperation.isFinished)")
        }
        updateUI.addDependency(loadNotesOperation)
        commonQueue.addOperation(loadNotesOperation)
        OperationQueue.main.addOperation(updateUI)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заметки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteTaped(_:)))
        
        backendQueue.maxConcurrentOperationCount = 1
        dbQueue.maxConcurrentOperationCount = 1
        commonQueue.maxConcurrentOperationCount = 1
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let note = notebook.notes[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content
        cell.detailTextLabel?.numberOfLines = 5
        cell.imageView?.image = UIImage.from(color: note.color)
        cell.imageView?.sizeToFit()
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        cell.imageView?.layer.borderWidth = 2

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeNoteOperation = RemoveNoteOperation(note: notebook.notes[indexPath.row], notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue)
            commonQueue.addOperation(removeNoteOperation)
            let deleteCellOperation = BlockOperation {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            deleteCellOperation.addDependency(removeNoteOperation)
            OperationQueue.main.addOperation(deleteCellOperation)
        } else if editingStyle == .insert {
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEditNote", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? EditNote,
            segue.identifier == "ShowEditNote" {
            let selectedRow = sender as? Int
            if let _ = selectedRow {
                controller.note = notebook.notes[selectedRow!]
            } else {
                controller.note = nil
            }
            controller.mainViewController = self
        }
    }
    func updateNotes(note: Note) {
        notebook.add(note, override: true)
        tableView.reloadData()
        print(notebook.notes)
    }
    

}
