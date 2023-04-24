//
//  ViewController.swift
//  Agora_Integration
//
//  Created by Manasa M P on 24/04/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostButton = UIButton(type: .custom)
        hostButton.setTitle("Host", for: .normal)
        hostButton.setTitleColor(.label, for: .normal)
        hostButton.setTitleColor(.secondaryLabel, for: .focused)
        hostButton.backgroundColor = .systemGray
        hostButton.addTarget(self, action: #selector(hostTapped), for: .touchUpInside)
        hostButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostButton)
        NSLayoutConstraint.activate([
            hostButton.widthAnchor.constraint(equalToConstant: 150),
            hostButton.heightAnchor.constraint(equalToConstant: 150),
            hostButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let viewerButton = UIButton(type: .custom)
        viewerButton.setTitle("Viewer", for: .normal)
        viewerButton.setTitleColor(.label, for: .normal)
        viewerButton.setTitleColor(.secondaryLabel, for: .focused)
        viewerButton.backgroundColor = .systemGray
        viewerButton.addTarget(self, action: #selector(ViewerTapped), for: .touchUpInside)
        viewerButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewerButton)
        NSLayoutConstraint.activate([
            viewerButton.widthAnchor.constraint(equalToConstant: 150),
            viewerButton.heightAnchor.constraint(equalToConstant: 150),
            viewerButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 50),
            viewerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func hostTapped() {
        let host = HostViewController()
        navigationController?.pushViewController(host, animated: false)
    }

    @objc func ViewerTapped() {
        let host = ViewerViewController()
        navigationController?.pushViewController(host, animated: false)
    }
}



