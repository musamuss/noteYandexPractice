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
        /*
        let note1 = Note(uid: "firstone", title: "Заголовок Один", content: "интересный текст", color: UIColor.blue, importance: .normal, selfDestructionDate: Date(timeIntervalSinceReferenceDate: 118800))
        let note2 = Note(title: "Заголовок Два", content: "кот съел собаку \n\n\n\nследующую строку не будет видно\n\nэту строку не видно", importance: .high)
        notebook.add(note1)
        notebook.add(note2)
        notebook.saveToFile()
        */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notebook.notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let removeNoteOperation = RemoveNoteOperation(note: notebook.notes[indexPath.row], notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue)
            commonQueue.addOperation(removeNoteOperation)
            //notebook.remove(with: notebook.notes[indexPath.row].uid)
            let deleteCellOperation = BlockOperation {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            deleteCellOperation.addDependency(removeNoteOperation)
            OperationQueue.main.addOperation(deleteCellOperation)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEditNote", sender: indexPath.row)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
