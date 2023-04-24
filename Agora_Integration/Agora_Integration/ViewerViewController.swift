//
//  ViewerViewController.swift
//  Agora_Integration
//
//  Created by Manasa M P on 24/04/23.
//

import UIKit
import AgoraRtcKit

class ViewerViewController: UIViewController {
    var agoraKit: AgoraRtcEngineKit!
    var remoteView: UIView!
    lazy var userID: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "App id get from agora console", delegate: self)
        agoraKit.enableVideo()
        agoraKit.setClientRole(.audience)
        agoraKit.joinChannel(byToken: "RTC TOKEN", channelId: "Channel id", info: nil, uid: userID) { channelId, uid, elapsed in
            print("new uid \(uid)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        agoraKit.setupLocalVideo(nil)
        agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
}

extension ViewerViewController {
    func setupView() {
        view.backgroundColor = UIColor.green
        remoteView = UIView()
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(remoteView)
        NSLayoutConstraint.activate([
            remoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            remoteView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        addBackButton()
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.label, for: .normal)
        backButton.setTitleColor(.secondaryLabel, for: .focused)
        backButton.backgroundColor = .systemGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension ViewerViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("UserJoined UID \(uid)")
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalAudioFramePublished elapsed: Int) {
        print("first local audio frame published in viewer")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print("first remote video frame of uid in viewer")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print("firstRemoteVideoDecodedOfUid in viewer")
    }
}
