//
//  ViewController.swift
//  firestore-sample-app
//
//  Created by riku on 2021/05/10.
//

import UIKit
import Firebase

struct Person {
    var name: String
    var age: Int
    var hobbys: [Hobby]
}

struct Hobby {
    var name: String
    var year: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // リスト初期化
        var persons: [Person] = []
        
        // FirestoreのDB取得
        let db = Firestore.firestore()
        // personsコレクションを取得
        db.collection("persons").getDocuments() { collection, err in
            // エラー発生時
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // コレクション内のドキュメントを取得
                for document in collection!.documents {
                    // hobbiesフィールドを取得
                    guard let hobbyDicList: [[String : Any]] = document.get("hobbies") as? [[String : Any]] else {
                        continue
                    }
                    
                    // リスト初期化
                    var hobbies: [Hobby] = []
                    
                    // hobbies内のフィールドを取得
                    for hobbyDic in hobbyDicList {
                        guard let hobbyName = hobbyDic["name"] as? String ,
                              let hobbyYear = hobbyDic["year"] as? Int else {
                            continue
                        }
                        // Hobbyを作成
                        let hobby = Hobby(name: hobbyName, year: hobbyYear)
                        // リストに追加
                        hobbies.append(hobby)
                    }
                    
                    // Personフィールドを取得
                    guard let personName = document.get("name") as? String,
                          let personAge = document.get("age") as? Int else {
                        continue
                    }
                    
                    // Personを作成
                    let person = Person(name: personName, age: personAge, hobbys: hobbies)
                    
                    // リストに追加
                    persons.append(person)
                }
            }
            // コンソール出力
            print(persons)
        }
    }
}

