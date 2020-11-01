//
//  InterfaceController.swift
//  Convertch WatchKit Extension
//
//  Created by Artem Evdokimov on 26.05.20.
//

import WatchKit
import Foundation

class CurrencyRow: NSObject {
    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var textLabel: WKInterfaceLabel!
}

class InterfaceController: WKInterfaceController {
    @IBOutlet var amountLabel: WKInterfaceLabel!
//    @IBOutlet var amountSlider: WKInterfaceSlider!
    @IBOutlet var currencyPicker: WKInterfacePicker!

    var currentCurrency = "USD"
    var currentAmount = "0"

    override func awake(withContext context: Any?) {
//        WKInterfaceController.reloadRootPageControllers(withNames: ["Home"], contexts: [], orientation: .horizontal, pageIndex: 0)
        super.awake(withContext: context)
        
        var items = [WKPickerItem]()

        for currency in currenciesList {
            let item = WKPickerItem()
            item.title = currency
            items.append(item)
        }

        currencyPicker.setItems(items)
    }
    
    func customizeButtons() {
    }
    
    @IBAction func convertTapped() {
        let context = ["amount": String(currentAmount), "base": currentCurrency]
        WKInterfaceController.reloadRootPageControllers(withNames: ["Results"], contexts: [context], orientation: .horizontal, pageIndex: 0)
    }

    @IBAction func amountChanged(_ value: String) {
        currentAmount = value
        amountLabel.setText(String(currentAmount))
    }

    @IBAction func baseCurrencyChanged(_ value: Int) {
        currentCurrency = currenciesList[value]
    }
    
    func updateCurrentAmound(with number: String) {
        if (currentAmount == "0") {
            currentAmount = number
        } else {
            currentAmount += number;
        }
        self.amountLabel.setText(currentAmount)
    }
    
    @IBAction func nine() {
        updateCurrentAmound(with: "9")
    }
    @IBAction func eight() {
        updateCurrentAmound(with: "8")
    }
    @IBAction func seven() {
        updateCurrentAmound(with: "7")
    }
    @IBAction func six() {
        updateCurrentAmound(with: "6")
    }
    @IBAction func five() {
        updateCurrentAmound(with: "5")
    }
    @IBAction func four() {
        updateCurrentAmound(with: "4")
    }
    @IBAction func three() {
        updateCurrentAmound(with: "3")
    }
    @IBAction func two() {
        updateCurrentAmound(with: "2")
    }
    @IBAction func one() {
        updateCurrentAmound(with: "1")
    }
    @IBAction func zero() {
        updateCurrentAmound(with: "0")
    }
    @IBAction func comma() {
        updateCurrentAmound(with: ".")
    }
}
