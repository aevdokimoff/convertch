//
//  ResultsInterfaceController.swift
//  Convertch WatchKit Extension
//
//  Created by Artem Evdokimov on 26.05.20.
//


import WatchKit
import Foundation

struct Conversion: Codable {
    var base: String
    var rates: [String: Double]
}

class ConversionInterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var done: WKInterfaceButton!
    @IBOutlet var status: WKInterfaceLabel!

    var fetchedCurrencies = [(symbol: String, rate: Double)]()
    var amountToConvert = 0.0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard let settings = context as? [String: String] else { return }
        guard let amount = settings["amount"] else { return }
        guard let baseCurrency = settings["base"] else { return }

        amountToConvert = Double(amount) ?? 50
        setTitle("\(amount) \(baseCurrency)")

        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchData(for: baseCurrency)
        }
    }

    override func willActivate() {
        WKExtension.shared().isAutorotating = true
    }

    override func didDeactivate() {
        WKExtension.shared().isAutorotating = false
    }

    func fetchData(for baseCurrency: String) {
        if let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)&base=\(baseCurrency)") {
            let urlRequest = URLRequest(url: url)
            print("here: \(url)")

            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    self.parse(data)
                } else {
                    DispatchQueue.main.async {
                        self.status.setText("Fetch failed")
                        self.done.setHidden(false)
                    }
                }
            }.resume()
        }
    }

    func parse(_ contents: Data) {
        let decoder = JSONDecoder()

        guard let result = try? decoder.decode(Conversion.self, from: contents) else {
            DispatchQueue.main.async {
                self.status.setText("Fetch failed")
                self.done.setHidden(false)
            }

            return
        }

        let currencies = currenciesList
        for symbol in result.rates {
            guard currencies.contains(symbol.key) else { continue }
            let rateName = symbol.key
            let rateValue = symbol.value
            fetchedCurrencies.append((symbol: rateName, rate: rateValue))
        }

        updateTable()
        status.setHidden(true)
        table.setHidden(false)
        done.setHidden(false)
    }

    func updateTable() {
        table.setNumberOfRows(fetchedCurrencies.count, withRowType: "Row")

        for (index, currency) in fetchedCurrencies.enumerated() {
            
            guard let row = table.rowController(at: index) as? CurrencyRow else { return }
            print(row)
            let value = currency.rate * amountToConvert
            let formattedValue = String(format: "%.2f", value)
            row.textLabel.setText("\(formattedValue) \(currency.symbol)")
        }
    }

    @IBAction func doneTapped() {
        WKInterfaceController.reloadRootPageControllers(withNames: ["Home", "Currencies"], contexts: nil, orientation: .horizontal, pageIndex: 0)
    }
}
