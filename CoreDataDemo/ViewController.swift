//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Khasbulatov on 06.06.2018.
//  Copyright © 2018 testOrganization. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //Pragma MARK: IBOutlets
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameAgePassword: UILabel!
    
    //Pragma MARK: Variables
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    //Pragma MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Нам нужно создать контекст из этого контейнера
        context = appDelegate.persistentContainer.viewContext
    }

    //Pragma MARK: IBActions
    
    @IBAction func addEntity(_ sender: UIButton) {
        //Сейчас давайте создадим сущность и запишем туда нового юзера
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context!)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        //И на последок, нам нужно добавить некоторые данные в нашу новую запись по каждому ключу
        newUser.setValue(userNameTF.text ?? "emptyName", forKey: "username")
        newUser.setValue(passwordTF.text ?? "emptyPassword", forKey: "password")
        newUser.setValue(ageTF.text ?? "emptyAge", forKey: "age")
        
        //сохраняем данные
        do {
            print("context сохранен")
            try context!.save()
        } catch {
            print("Ошибка сохранения")
        }
    }
    
    @IBAction func fetchUser(_sender: UIButton) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "age > %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                let userName = data.value(forKey: "username") as! String
                let age = data.value(forKey: "age") as! String
                let password = data.value(forKey: "password") as! String
                userNameAgePassword.text =
                                        "userName = " + userName +
                                        "\nage = " + age +
                                        "\npassword = " + password
            }
        } catch {
            print("Failed")
        }
    }

}

