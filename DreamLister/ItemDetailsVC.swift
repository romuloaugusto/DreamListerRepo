//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Romulo Augusto on 13/06/17.
//  Copyright © 2017 Romulo. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumging: UIImageView!

    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateStores()
        //generateItemTypes()
        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

//        let store = stores[row]
//        return store.name
        
        if component == 0 {
            let store = stores[row]
            return store.name
        } else if component == 1 {
            let itemType = itemTypes[row]
            return itemType.type
        }
        
        return nil
    }
    
    // number of elements
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return stores.count
        
        let row = pickerView.selectedRow(inComponent: 0)
        print("This is the pickerview \(row)")
        
        if component == 0 {
            return stores.count
        } else if component == 1 {
            return itemTypes.count
        }
        
        return 0
        
    }

    //  number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let dateSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            //  handle the error
        }
    }
    
    func getItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        let typeSort = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [typeSort]
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle the error
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumging.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }

        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
//        _ = navigationController?.popViewController(animated: true)
        
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumging.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat {
                    
                    let s = stores[index]
                    if(s.name == store.name) {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
            }
            
            if let itemType = item.toItemType {
                
                var index = 0
                
                repeat {
                    
                    let i = itemTypes[index]
                    if(i.type == itemType.type) {
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumging.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func generateStores() {
        let store1 = Store(context: context)
        store1.name = "Audi"
        let store2 = Store(context: context)
        store2.name = "Apple"
        let store3 = Store(context: context)
        store3.name = "Best Buy"
        let store4 = Store(context: context)
        store4.name = "Amazon"
        let store5 = Store(context: context)
        store5.name = "Porshe"
        
        ad.saveContext()
    }
    
    func generateItemTypes() {
        let itemType1 = ItemType(context: context)
        itemType1.type = "Car"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Watch"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Electronic"
        
        ad.saveContext()
    }
}
