//
//  CarViewController.swift
//  TrafficLights
//
//  Created by Sasha Belov on 7.10.24.
//

import UIKit

struct CarData: Codable {
    let makes: [Car]
}

struct Car: Codable {
    let make: String
    let models: [String]
}

class CarViewController: UIViewController {
    
    let makeTextField = UITextField(frame: .zero)
    let modelTextField = UITextField(frame: .zero)
    let startButton = UIButton(type: .system)
    
    var cars: [Car] = []
    var makes: [String] = []
    var models: [String] = []
    
    let makePicker = UIPickerView()
    let modelPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCars()
        
        setupUI()
        setupConstraints()
    }
    
    func loadCars() {
        if let path = Bundle.main.path(forResource: "makes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let carData = try decoder.decode(CarData.self, from: data)
                cars = carData.makes
                makes = cars.map { $0.make }
            } catch {
                print("Failed to load or decode JSON file: \(error)")
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        makeTextField.placeholder = "Select Make"
        makeTextField.borderStyle = .roundedRect
        makeTextField.inputView = makePicker
        makePicker.delegate = self
        makePicker.dataSource = self
        
        modelTextField.placeholder = "Select Model"
        modelTextField.borderStyle = .roundedRect
        modelTextField.inputView = modelPicker
        modelTextField.isUserInteractionEnabled = false
        modelPicker.delegate = self
        modelPicker.dataSource = self
        
        startButton.setTitle("Start Driving", for: .normal)
        startButton.isEnabled = false
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        view.addSubview(makeTextField)
        view.addSubview(modelTextField)
        view.addSubview(startButton)
    }
    
    func setupConstraints() {
        makeTextField.translatesAutoresizingMaskIntoConstraints = false
        modelTextField.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            makeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            makeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            makeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            makeTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            modelTextField.topAnchor.constraint(equalTo: makeTextField.bottomAnchor, constant: 20),
            modelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            modelTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: modelTextField.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func startTapped() {
        guard let make = makeTextField.text, let model = modelTextField.text else {
            return
        }
        let trafficLightsVC = TrafficLightsViewController()
        trafficLightsVC.setupMakeAndModel(make: make, model: model)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(trafficLightsVC, animated: true)
        }
    }
}

extension CarViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == makePicker {
            return makes.count
        } else if pickerView == modelPicker {
            return models.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == makePicker {
            return makes[row]
        } else if pickerView == modelPicker {
            return models[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == makePicker {
            makeTextField.text = makes[row]
            updateModelsForMake(makes[row])
            modelTextField.text = ""
            startButton.isEnabled = false
            makeTextField.resignFirstResponder()
            modelTextField.isUserInteractionEnabled = true
        } else if pickerView == modelPicker {
            modelTextField.text = models[row]
            validateInputs()
            modelTextField.resignFirstResponder()
        }
    }
    
    func updateModelsForMake(_ make: String) {
        if let selectedMake = cars.first(where: { $0.make == make }) {
            models = selectedMake.models
            modelPicker.reloadAllComponents()
        }
    }
    
    func validateInputs() {
        if !(makeTextField.text?.isEmpty ?? true) && !(modelTextField.text?.isEmpty ?? true) {
            startButton.isEnabled = true
        }
    }
}
