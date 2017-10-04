//
//  showPostTableController.swift
//  Tester
//
//  Created by Elijah Carrington on 10/2/17.
//  Copyright © 2017 Elijah Carrington. All rights reserved.
//

import UIKit
import Firebase

class PostTableController: UITableViewController {

    var defaultStore: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide back bar button item
        navigationItem.setHidesBackButton(true, animated: false)
        
        // Configure Firestore
        defaultStore = Firestore.firestore()
        
        self.addDocumentToCollection()
    }
    
    func addDocumentToCollection() {
        // Create reference
        //        var ref: DocumentReference? = nil
        
        // Add document to user collection
        //        ref = defaultStore.collection("users").addDocument(data: [
        //            "first": "Elijah",
        //            "last": "Carrington",
        //            "born": 1994
        //            ], completion: { (error) in
        //                if let error = error {
        //                    print("Error adding document: \(error)")
        //                } else {
        //                    print("Document added with ID: \(ref!.documentID)")
        //                }
        //        })
        
        defaultStore?.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA",
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document written")
                }
        })
    }
    
    func queryFirestoreCollection() {
        // Query the Firestore
        defaultStore!.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
