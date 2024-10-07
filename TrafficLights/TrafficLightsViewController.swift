//
//  TrafficLightsViewController.swift
//  TrafficLights
//
//  Created by Sasha Belov on 7.10.24.
//

import UIKit

class TrafficLightsViewController: UIViewController {
    
    let makeModelLabel = UILabel(frame: .zero)
    var redLightView = UIView(frame: .zero)
    var orangeLightView = UIView(frame: .zero)
    var greenLightView = UIView(frame: .zero)
    let lightsStackView = UIStackView(frame: .zero)
    
    var make: String?
    var model: String?
    
    var trafficLightTimer: Timer?
    var currentLightIndex = 0
    let durations = [4.0, 1.0, 4.0]//red->orange->green
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        updateTrafficLight()
    }
    
    func setupMakeAndModel(make: String, model: String) {
        self.make = make
        self.model = model
    }
    
    func setupUI() {
        view.backgroundColor = .white
        makeModelLabel.font = UIFont.boldSystemFont(ofSize: 20)
        makeModelLabel.textAlignment = .center
        if let carMake = make, let carModel = model {
            makeModelLabel.text = "\(carMake) \(carModel)"
        }
        
        lightsStackView.axis = .vertical
        lightsStackView.distribution = .fillEqually
        lightsStackView.alignment = .fill
        lightsStackView.spacing = 10
        
        view.addSubview(makeModelLabel)
        view.addSubview(lightsStackView)
        lightsStackView.addArrangedSubview(redLightView.createCircleView(size: 100))
        lightsStackView.addArrangedSubview(orangeLightView.createCircleView(size: 100))
        lightsStackView.addArrangedSubview(greenLightView.createCircleView(size: 100))
    }
    
    func setupConstraints() {
        makeModelLabel.translatesAutoresizingMaskIntoConstraints = false
        lightsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            makeModelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            makeModelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            makeModelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            makeModelLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            lightsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lightsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lightsStackView.widthAnchor.constraint(equalToConstant: 100),
        ])
        
    }
    
    @objc func updateTrafficLight() {
        trafficLightTimer = Timer.scheduledTimer(timeInterval: durations[currentLightIndex], target: self, selector: #selector(updateTrafficLight), userInfo: nil, repeats: false)
        
        redLightView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        orangeLightView.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        greenLightView.backgroundColor = UIColor.green.withAlphaComponent(0.2)

        switch currentLightIndex {
        case 0:
            UIView.animate(withDuration: 0.2) {
                self.redLightView.backgroundColor = UIColor.red.withAlphaComponent(1.0)
            }
        case 1:
            UIView.animate(withDuration: 0.2) {
                self.orangeLightView.backgroundColor = UIColor.orange.withAlphaComponent(1.0)
            }
        case 2:
            UIView.animate(withDuration: 0.2) {
                self.greenLightView.backgroundColor = UIColor.green.withAlphaComponent(1.0)
            }
        default:
            break
        }
        
        currentLightIndex = (currentLightIndex + 1) % 3

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trafficLightTimer?.invalidate()
    }
}

