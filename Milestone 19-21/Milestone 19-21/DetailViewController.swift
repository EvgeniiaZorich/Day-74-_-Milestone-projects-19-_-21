//
//  DetailViewController.swift
//  Milestone 19-21
//
//  Created by Евгения Зорич on 13.03.2023.
//

import UIKit

protocol DetailDelegate {
    func editor(_ editor: DetailViewController, didUpdate notes: [Note])
}

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var notes: [Note]!
    var noteIndex: Int!
    var delegate: DetailDelegate?
    
    var buttonSave: UIBarButtonItem!
    var buttonShare: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = notes[noteIndex].text

        
        
        buttonShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [buttonShare]
        
            notes[noteIndex].text = textView.text
            notes[noteIndex].date = Date()
            
            DispatchQueue.global().async { [weak self] in
                if let notes = self?.notes {
                Saved.save(notes: notes)
                }
            }
        
        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard noteIndex != nil else { return }

        saveNote()
    }
    
    func setParameters(notes: [Note], noteIndex: Int) {
        self.notes = notes
        self.noteIndex = noteIndex
    }
    
    func saveNote(isNew: Bool = false) {
            notes[noteIndex].text = textView.text
            notes[noteIndex].date = Date()
            
            DispatchQueue.global().async { [weak self] in
                if let notes = self?.notes {
                    Saved.save(notes: notes)
                }
            }
        }
    
//    @objc func saveTapped() {
//        hideKeyboard()
//    }
    
    func hideKeyboard() {
        textView.endEditing(true)
    }
    
    @objc func share() {
            hideKeyboard()
            saveNote()
            let vc = UIActivityViewController(activityItems: [notes[noteIndex].text], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = buttonShare
            present(vc, animated: true)
    }
}
