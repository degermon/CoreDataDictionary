//
//  ViewController.swift
//  CoreDataDictionary
//
//  Created by Daniel Suskevic on 23/11/2017.
//  Copyright © 2017 Daniel Suskevic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lithuanianTextField: UITextField!
    @IBOutlet weak var englishTextField: UITextField!
    
    var lithuanianWord : String = String()
    var englishWord : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        resignResponder()
        let words = read() // touple of words
        guard (words.0 != nil) && (words.1 != nil) else {
            alert(alert: true)
            return
        }
        save(words: words as! (String, String))
    }
    
    @IBAction func recallButtonTapped(_ sender: UIButton) {
        fetchData()
    }
    
    //MARK: Functions
    
    func alert(alert: Bool) {
        var alertMessage : String = ""
        switch alert {
        case true:
            alertMessage = "TextFields not filled"
        case false:
            alertMessage = "some error"
        }
        let alertController = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion:nil)
    }
    
    func resignResponder() {
        lithuanianTextField.resignFirstResponder()
        englishTextField.resignFirstResponder()
    }
    
    func read() -> (String?, String?) {
        let ltWord : String? = readLithuanianTextField()
        let engWord : String? = readEnglishTextField()
        return (ltWord, engWord)
    }
    
    func readLithuanianTextField() -> String? {
        if lithuanianTextField.text != "" {
            let ltWord = lithuanianTextField.text
            return ltWord
        } else {
            print("Error, there is no text in textfield in lt") // Temporary till implementation of error handling
            return nil
        }
    }
    
    func readEnglishTextField() -> String? {
        if englishTextField.text != "" {
            let engWord = englishTextField.text
            return engWord
        } else {
            print("Error, there is no text in textfield in eng") // Temporary till implementation of error handling
            return nil
        }
    }
    
    
    //MARK: CoreData
    
    func save(words: (String, String)) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let ltWord = words.0
        let engWord = words.1
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Dictionary",
                                       in: managedContext)!
        let wordsDictionary = NSManagedObject(entity: entity,
                                             insertInto: managedContext)

        wordsDictionary.setValue(ltWord, forKey: "lithuanian")
        wordsDictionary.setValue(engWord, forKey: "english")
    }
    
    func fetchData(){
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Dictionary")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                print(data.value(forKey: "lithuanian") as! String)
                print(data.value(forKey: "english") as! String)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
