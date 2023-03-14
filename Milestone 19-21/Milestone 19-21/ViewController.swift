//
//  ViewController.swift
//  Milestone 19-21
//
//  Created by Евгения Зорич on 13.03.2023.
//

import UIKit

class ViewController: UITableViewController, DetailDelegate {
  
    var notes = [Note]()
    
    var newNoteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        
        toolbarItems = [newNoteButton]
        navigationController?.isToolbarHidden = false
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        reloadSaved()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }

    func reloadSaved() {
        DispatchQueue.global().async { [weak self] in
            self?.notes = Saved.load()
            
            DispatchQueue.main.async {
            self?.updateData()
            }
        }
    }
    
    func updateData() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            
            DispatchQueue.global().async { [weak self] in
                if let notes = self?.notes {
                    Saved.save(notes: notes)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            toDetailViewController(noteIndex: indexPath.row)
    }
    
   
    
    func toDetailViewController(noteIndex: Int) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.setParameters(notes: notes, noteIndex: noteIndex)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func createNote() {
        notes.append(Note(text: "", date: Date()))
        DispatchQueue.global().async { [weak self] in
            if let notes = self?.notes {
                Saved.save(notes: notes)
                
                DispatchQueue.main.async {
                    self?.toDetailViewController(noteIndex: notes.count - 1)
                }
            }
        }
    }
    
    func editor(_ editor: DetailViewController, didUpdate notes: [Note]) {
        self.notes = notes
    }
    
    func deleteNotes(rows: [IndexPath]) {
        for path in rows {
            notes.remove(at: path.row)
        }
        
        DispatchQueue.global().async { [weak self] in
            if let notes = self?.notes {
            Saved.save(notes: notes)
            }
            
            DispatchQueue.main.async {
                self?.updateData()
//                self?.editModeOut()
            }
        }
    }
}
   

