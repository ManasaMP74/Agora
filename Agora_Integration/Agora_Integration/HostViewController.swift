//
//  HostViewController.swift
//  Agora_Integration
//
//  Created by Manasa M P on 24/04/23.
//

import UIKit
import AgoraRtcKit

class HostViewController: UIViewController {
    var localView: UIView!
    var agoraKit: AgoraRtcEngineKit!
    var remoteView: UIView!
    /// Setting to zero will tell Agora to assign one for you
    lazy var userID: UInt = 0
    
    
    var camButton = UIButton(type: .custom)
    var micButton = UIButton(type: .custom)
    var flipButton = UIButton(type: .custom)
    var beautyButton = UIButton(type: .custom)
    
    var beautyOptions: AgoraBeautyOptions = {
        let bopt = AgoraBeautyOptions()
        bopt.smoothnessLevel = 1
        bopt.rednessLevel = 0.1
        return bopt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "", delegate: self)
        agoraKit.enableVideo()
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(.broadcaster)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.renderMode = .hidden
        videoCanvas.uid = userID
        videoCanvas.view = localView
        agoraKit.setupLocalVideo(videoCanvas)
        
        /*
        // call backend api to get the channel id, stream id and RTC Token and RTC userId.
        // If UID IS SET ZERO Agora will automatically assign one for us
        GoLiveAPIHandler().fetchGoLiveData(title: "Live with jio", channelId:  nil, streamId: nil, isSchedule: false) { [weak self] (result)  in
            switch (result) {
            case .failure(let err):
                Printer.log.information(details: "Error: \(err.localizedDescription)")
            case .success(let model):
                DispatchQueue.main.async {
                    self?.agoraKit.joinChannel(byToken: model.rtc!.token!, channelId: model.channelId!, info: nil, uid: UInt(model.rtc!.userCommId!)) { channelId, uid, elapsed in
                        print("new uid \(uid)")
                        print("new RTC Token \(model.rtc!.token!)")
                        print("new Channel ID \(model.channelId!)")
                        print("new userCommId \(model.rtc!.userCommId!)")
                    }
                }
            }
        }
         */
        
        /*
         Above is used for fetching data
         */
        agoraKit.joinChannel(byToken: "", channelId: "", info: nil, uid: 845230181) { channelId, uid, elapsed in
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

extension HostViewController {
    func setupView() {
        localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localView)
        NSLayoutConstraint.activate([
            localView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
             localView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            localView.heightAnchor.constraint(equalToConstant: 150),
            localView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        remoteView = UIView()
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        remoteView.backgroundColor = .blue
        view.addSubview(remoteView)
        NSLayoutConstraint.activate([
            remoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150),
            remoteView.topAnchor.constraint(equalTo: localView.bottomAnchor)
        ])
        addBackButton()
        setupSubViews()
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
    
    func setupSubViews() {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            stackview.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        camButton.setTitle("Cam", for: .normal)
        camButton.setTitleColor(.label, for: .normal)
        camButton.setTitleColor(.secondaryLabel, for: .focused)
        camButton.backgroundColor = .systemGray
        camButton.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        camButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        micButton.setTitle("Mic", for: .normal)
        micButton.setTitleColor(.label, for: .normal)
        micButton.setTitleColor(.secondaryLabel, for: .focused)
        micButton.backgroundColor = .systemGray
        micButton.addTarget(self, action: #selector(MicTapped), for: .touchUpInside)
        micButton.translatesAutoresizingMaskIntoConstraints = false
        
        flipButton.setTitle("Flip", for: .normal)
        flipButton.setTitleColor(.label, for: .normal)
        flipButton.setTitleColor(.secondaryLabel, for: .focused)
        flipButton.backgroundColor = .systemGray
        flipButton.addTarget(self, action: #selector(flipTapped), for: .touchUpInside)
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        
        beautyButton.setTitle("Beauty", for: .normal)
        beautyButton.setTitleColor(.label, for: .normal)
        beautyButton.setTitleColor(.secondaryLabel, for: .focused)
        beautyButton.backgroundColor = .systemGray
        beautyButton.addTarget(self, action: #selector(beautyTapped), for: .touchUpInside)
        beautyButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackview.addArrangedSubview(camButton)
        stackview.addArrangedSubview(beautyButton)
        stackview.addArrangedSubview(flipButton)
        stackview.addArrangedSubview(micButton)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func toggleCamera() {
        camButton.isSelected.toggle()
        camButton.backgroundColor = camButton.isSelected ? .systemRed : .systemGray
        self.agoraKit.enableLocalVideo(!camButton.isSelected)
    }
    
    @objc func MicTapped() {
        micButton.isSelected.toggle()
        micButton.backgroundColor = micButton.isSelected ? .systemRed : .systemGray
        agoraKit.muteLocalAudioStream(micButton.isSelected)
    }
    
    /// Turn on/off the 'beautify' effect. Visual and voice change.
    @objc func beautyTapped() {
        beautyButton.isSelected.toggle()
        beautyButton.backgroundColor = beautyButton.isSelected ? .systemGreen : .systemGray
        agoraKit.setVoiceBeautifierPreset(beautyButton.isSelected ? .timbreTransformationClear : .ultraHighQuality)
        agoraKit.setBeautyEffectOptions(beautyButton.isSelected, options: self.beautyOptions)
    }
    
    @objc func flipTapped() {
        agoraKit.switchCamera()
    }
}

extension HostViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("UserJoined in host UID \(uid)")
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalAudioFramePublished elapsed: Int) {
        print("first local audio frame published in host")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print("first remote video frame of uid in host")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print("firstRemoteVideoDecodedOfUid in host")
    }
}

