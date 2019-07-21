//
//  NotesViewController.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit

class NotesViewController: UIViewController {

    let reuseIdentifier = "NoteCell"
    var notebook: FileNotebook = FileNotebook(notes: Note.demoNotes)
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editClicked(_:)))
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(_:)))
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let note = notebook.newNote {
            let isNew = notebook.notes.firstIndex{ $0.uid == note.uid } == nil
            notebook.add(note)
            let index = notebook.notes.firstIndex { $0.uid == note.uid }
            if let index = index {
                let indexPath = [IndexPath(row: index, section: 0)]
                if isNew {
                    tableView.insertRows(at: indexPath, with: .fade)
                } else {
                    tableView.reloadRows(at: indexPath, with: .fade)
                }
            }
            
            
            
            //tableView.reloadData()
        }
        
        
        
    }

    @objc func editClicked(_ sender: Any){
        tableView.isEditing = !tableView.isEditing
        
        
    }
    
    @objc func addClicked(_ sender: Any){
        performSegue(withIdentifier: "NoteAddSegue", sender: nil)
    }
    
    // метод для того чтобы работал програмный возврат из second view controller
    @IBAction func unwindToStartScreen(segue: UIStoryboardSegue ){
        
    }
    
    var lastNote: Note? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NoteCardViewController {
            switch segue.identifier {
            case "NoteAddSegue":
                controller.note = Note(title: "", content: "", priority: .normal)
                controller.notebook = notebook
            case "NoteEditSegue":
                controller.note = lastNote
                controller.notebook = notebook
                    //notebook.notes[tableView.indexPathForSelectedRow?.row]
                
                //Note(title: "EDIT", content: "", priority: .normal)
            default: break
            }
        
            
        }
    }

}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // кастомная ячейка
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = notebook.notes[indexPath.row]
        
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.content
        cell.colorView.backgroundColor = note.color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastNote = notebook.notes[indexPath.row]
        performSegue(withIdentifier: "NoteEditSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            notebook.remove(with:notebook.notes[indexPath.row].uid)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return categories[section].title
//    }
    
    
}


