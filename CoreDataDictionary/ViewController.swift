//
//  ViewController.swift
//  CoreDataDictionary
//
//  Created by Daniel Suskevic on 23/11/2017.
//  Copyright © 2017 Daniel Suskevic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var lithuanianTextField: UITextField!
    @IBOutlet weak var englishTextField: UITextField!
    
    var lithuanianWord : String = String()
    var englishWord : String = String()
    var dictionaryWords: [NSManagedObject] = []
    var myDataLithuanian : [String] = []
    var myDataEnglish : [String] = []
    
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
        let a = read()
        if (a.lt != nil) && (a.eng != nil) {  // checks if all fields are filled
            createObjectAndSendData(ltWord: a.lt!, engWord: a.eng!)
        } else {
            alert(alertMessage: "TextFields not filled")
        }
        // vietoj tuplu returno siust duomenys i atskira klase
        //createObjectAndSendData(ltWord: a.lt!, engWord: a.eng!)
        //update(ltWord: words.0!, engWord: words.1!)
        //save(words: words as! (String, String))
    }
    
    @IBAction func recallButtonTapped(_ sender: UIButton) {
        fetchData()
        self.myTable.reloadData()
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
    
    func createObjectAndSendData(ltWord: String, engWord: String) {
        let object = Intermidiary()
        object.intermidiaryData(ltWord: ltWord, engWord: engWord)
    }
    
    func resignResponder() {
        lithuanianTextField.resignFirstResponder()
        englishTextField.resignFirstResponder()
    }
    
    func read() -> DataClass {  // reads data from text fields
        let a = DataClass()
        a.lt = readLithuanianTextField()
        a.eng = readEnglishTextField()
        return a
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
    
    func save(ltWord: String, engWord: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
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
        //var dictionary = [String:String]()
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
                myDataLithuanian.append(lithuanian)
                myDataEnglish.append(english)
                //dictionary[lithuanian] = english
            }
        }
        //print(dictionary)
        //myData = dictionary
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
    
    //MARK: UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataLithuanian.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell : UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        tableViewCell.textLabel?.text = "\(myDataLithuanian[indexPath.row]) : \(myDataEnglish[indexPath.row])"
            //myData[indexPath.row]
        return tableViewCell
    }
}

class Intermidiary : ViewController {
    
    func intermidiaryData(ltWord: String, engWord: String) {
        update(ltWord: ltWord, engWord: engWord)
        save(ltWord: ltWord, engWord: engWord)
    }
}

class DataClass {
    var lt : String? = nil
    var eng : String? = nil
}
