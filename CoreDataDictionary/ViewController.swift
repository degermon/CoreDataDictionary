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
    var dictionaryWords: [NSManagedObject] = []
    
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
        guard (words.0 != nil) && (words.1 != nil) else {  // checks if all fields are filled
            alert(alertMessage: "TextFields not filled")
            return
        }
        update(ltWord: words.0!, engWord: words.1!)
        save(words: words as! (String, String))
    }
    
    @IBAction func recallButtonTapped(_ sender: UIButton) {
        fetchData()
    }
    
    //MARK: Alert Method
    
    func alert(alertMessage: String) { // allert function
        let alertController = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion:nil)
    }
    
    //MARK: Methods
    
    func resignResponder() {
        lithuanianTextField.resignFirstResponder()
        englishTextField.resignFirstResponder()
    }
    
    func read() -> (String?, String?) {  // reads data from text fields
        let ltWord : String? = readLithuanianTextField()
        let engWord : String? = readEnglishTextField()
        return (ltWord, engWord)
    }
    
    func readLithuanianTextField() -> String? {
        if lithuanianTextField.text != "" {
            let ltWord = lithuanianTextField.text
            return ltWord
        } else {
            print("Error, there is no text in textfield in lt")
            return nil
        }
    }
    
    func readEnglishTextField() -> String? {
        if englishTextField.text != "" {
            let engWord = englishTextField.text
            return engWord
        } else {
            print("Error, there is no text in textfield in eng")
            return nil
        }
    }
    
    
    //MARK: CoreData actions
    
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
        let dictWord = NSManagedObject(entity: entity,
                                              insertInto: managedContext)
        
        dictWord.setValue(ltWord, forKey: "lithuanianWord")
        dictWord.setValue(engWord, forKey: "englishWord")
        
        savePermanently(dictWord: dictWord, managedContext: managedContext)
    }
    
    func fetchData(){
        var dictionary = [String:String]()
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Dictionary")
        do {
            dictionaryWords = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        for dictWord in dictionaryWords {
            if let lithuanian = dictWord.value(forKey: "lithuanianWord") as! String?, let english = dictWord.value(forKey: "englishWord") as! String? {
                dictionary[lithuanian] = english
            }
        }
        print(dictionary)
    }
    
    func update(ltWord: String, engWord: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for dictWord in dictionaryWords {
            if let lithuanian = dictWord.value(forKey: "lithuanianWord") as! String?, let english = dictWord.value(forKey: "englishWord") as! String? {
                
                if lithuanian == ltWord || english == engWord {
                    dictWord.setValue(ltWord, forKey: "lithuanianWord")
                    alert(alertMessage: "English word was updated")
                    
                    if english == engWord {
                        dictWord.setValue(engWord, forKey: "englishWord")
                        alert(alertMessage: "Lithuanian word was updated")
                    }
                
                    savePermanently(dictWord: dictWord, managedContext: managedContext)
                }
            }
        }
    }
    
    func savePermanently(dictWord: NSManagedObject, managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
            dictionaryWords.append(dictWord)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

