//
//  ViewController.swift
//  Nestoria House Listing
//
//  Created by Dylan Lualdi on 29/05/2019.
//  Copyright © 2019 Dylan Lualdi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
        
    @IBOutlet var tableView: UITableView!
    @IBOutlet var priceButton: UIBarButtonItem!
    @IBOutlet var bedsButton: UIBarButtonItem!
    @IBOutlet var noResultsView: UIView!
    @IBOutlet var noResultsLabel: UILabel!
    
    lazy var search = UISearchController(searchResultsController: nil)
    
    var textField = UITextField() // not visible - used to animate picker view from bottom
    var picker : UIPickerView!
    
    // used to show loading label on app launch
    var isLoading: Bool = true {
        didSet {
            self.noResultsLabel.text = self.isLoading ? "Loading..." : "No Results Found"
        }
    }
    
    // BEGIN - Search Variables
    var minBedsSelected = 0 {
        didSet {
            bedsButton.tintColor = self.minBedsSelected > 0 ? AppColor.appSecondaryColorDark : AppColor.appSecondaryColor
        }
    }
    var maxBedsSelected = 0 {
        didSet {
            bedsButton.tintColor = self.maxBedsSelected > 0 ? AppColor.appSecondaryColorDark : AppColor.appSecondaryColor
        }
    }
    
    var minPriceSelected = "0" {
        didSet {
            priceButton.tintColor = self.minPriceSelected != "0" ? AppColor.appSecondaryColorDark : AppColor.appSecondaryColor
        }
    }
    var maxPriceSelected = "0" {
        didSet {
            priceButton.tintColor = self.maxPriceSelected != "0" ? AppColor.appSecondaryColorDark : AppColor.appSecondaryColor
        }
    }
    var selectedCity: String = Constant.default_city {
        didSet {
            self.title = self.selectedCity.capitalized
        }
    }
    // END - Search Variables
    
    // Table view data source
    var housesArray = [House]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Filters data source
    var pickerBedsData = ["Studio" , "1" , "2", "3" , "4", "5" , "6"]
    var pickerPriceData = [String]()
    
    //MARK: UIViewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            // shows search bar at start
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCity = Constant.default_city
        
        tableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "HouseTableViewCell")
        self.tableView.tableFooterView = UIView()
        
        setupSearchBar()
        setupTextField()
        searchHouses()
        setupRangeOfPrices()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            // re-enable hide search bar on scroll
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            guard let detailController = segue.destination as? DetailViewController, let house = sender as? House else { return }
            detailController.house = house
        }
    }
    
    func setupSearchBar() {
        search.delegate = self
        search.searchBar.delegate = self
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.tintColor = UIColor.white
        search.searchBar.barTintColor = UIColor.white
        
        // Change search bar background color to white
        if let textfield = search.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.white
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        // Add Search Controller
        if #available(iOS 11.0, *) {
            navigationItem.searchController = search
        } else {
            // Fallback on earlier versions
            tableView.tableHeaderView = search.searchBar
        }
    }
    
    // Add invisible TextField to animate picker view
    func setupTextField() {
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.delegate = self
        self.view.addSubview(textField)
    }
    
    // Add price picker values
    func setupRangeOfPrices() {
        for i in stride(from: 0, to: 300_000, by: 20_000) {
            pickerPriceData.append(i.description)
        }
        for i in stride(from: 300_000, to: 700_000, by: 100_000) {
            pickerPriceData.append(i.description)
        }
        for i in stride(from: 700_000, to: 5_000_000, by: 500_000) {
            pickerPriceData.append(i.description)
        }
    }
    
    // Main Api Call
    func searchHouses(withPriceMin priceMin: String = Constant.min_value, withPriceMax priceMax: String = Constant.max_value, withBedroomsMin bedroomsMin: String = Constant.min_value, withBedroomsMax bedroomsMax: String = Constant.max_value,in city: String = Constant.default_city) {
        
        isLoading = true
        Alamofire.request(ApiHelper.api(priceMin: priceMin, priceMax: priceMax, bedroomsMin: bedroomsMin, bedroomsMax: bedroomsMax, city: city)).responseJSON { (responseData) -> Void in
            
            self.isLoading = false
            
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["response"]["listings"].arrayObject {
                                        
                    if let sortedResults = (resData as NSArray).sortedArray(using: [NSSortDescriptor(key: "price", ascending: true)]) as? [[String:AnyObject]] {
                        
                        self.housesArray = sortedResults.compactMap(House.init)
                        
                    }
                }
            }
        }
    }
    
    func pickUp(_ textField : UITextField, tag: Int){
        
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        self.picker.tag = tag
        
        // Check if Picker is for prices or bedrooms
        if tag == 0 {
            self.picker.selectRow(minBedsSelected, inComponent:0, animated:false)
            self.picker.selectRow(maxBedsSelected, inComponent:1, animated:false)
        } else {
            self.picker.selectRow(pickerPriceData.firstIndex(of: minPriceSelected) ?? 0, inComponent:0, animated:false)
            self.picker.selectRow(pickerPriceData.firstIndex(of: maxPriceSelected) ?? 0, inComponent:1, animated:false)
        }

        // TextField
        textField.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        textField.becomeFirstResponder()
    }
    
    // Call Bedrooms Picker
    @IBAction func bedFilter(_ sender: Any) {
        self.pickUp(textField, tag: 0)
    }
    // Call Prices Picker
    @IBAction func priceFilter(_ sender: Any) {
        self.pickUp(textField, tag: 1)
    }
    
    // Call search api on picker done button
    @objc func doneClick() {
        // Add values to search variables
        if picker.tag == 0 {
            minBedsSelected = picker.selectedRow(inComponent: 0)
            maxBedsSelected = picker.selectedRow(inComponent: 1)
        } else {
            minPriceSelected = pickerPriceData[picker.selectedRow(inComponent: 0)]
            maxPriceSelected = pickerPriceData[picker.selectedRow(inComponent: 1)]
        }
        
        searchHouses(withPriceMin: minPriceSelected, withPriceMax: maxPriceSelected, withBedroomsMin: minBedsSelected.description, withBedroomsMax: maxBedsSelected.description, in: selectedCity)
        
        textField.resignFirstResponder()
    }
    @objc func cancelClick() {
        textField.resignFirstResponder()
    }
}

// MARK: - Search Bar Protocol
extension ViewController: UISearchControllerDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = search.searchBar.text {
            
            selectedCity = city
            housesArray.removeAll()
            
            searchHouses(withPriceMin: minPriceSelected, withPriceMax: maxPriceSelected, withBedroomsMin: minBedsSelected.description, withBedroomsMax: maxBedsSelected.description, in: selectedCity)
            
            
            search.isActive = false
        }
        
    }
    
}
// MARK: - TableView Delegate / DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        noResultsView.isHidden = housesArray.count > 0
        return housesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseTableViewCell", for: indexPath) as! HouseTableViewCell
        let dict = housesArray[indexPath.row]
        
        if let name = dict.title, let desc = dict.summary, let price = dict.priceFormatted, let image = dict.imgURL {
            cell.update(name: name, description: desc, price: price, imgUrl: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 149
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = housesArray[indexPath.row]
        self.performSegue(withIdentifier: "DetailVC", sender: dict)
    }
}

// MARK: - PickerView Delegates
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.tag == 0 ? pickerBedsData.count : pickerPriceData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if picker.tag == 0 {
            return pickerBedsData[row]
        } else {
            if row == 0 {
                return component == 0 ? "No min price" : "No max price"
            }
            return pickerPriceData[row].description.convertToPrice
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Prevents min value to be > max value
        if picker.selectedRow(inComponent: 0) > picker.selectedRow(inComponent: 1) {
            picker.selectRow(0, inComponent: 1, animated: true)
        }
    }
    
}
