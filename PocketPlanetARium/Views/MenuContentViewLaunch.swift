//
//  MenuContentViewLaunch.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/22/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

protocol MenuContentViewLaunchDelegate {
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentPlanetARiumController planetARiumController: PlanetARiumController)
    func menuContentViewLaunch(_ controller: MenuContentViewLaunch, didPresentViewChangeWith alert: UIAlertController)
}


class MenuContentViewLaunch: UIView {
    var superView: MenuBezelView!
    var stackView: UIStackView!
    var pocketLabel: UILabel!
    var planetARiumLabel: UILabel!
    var contentLabel: UILabel!
    var launchButton: UIButton!
    var menuItem: MenuItem
    var isMuted: Bool
    var hintsAreOff: Bool
    
    var delegate: MenuContentViewLaunchDelegate?


    
    
    var planetARiumViewButton: UIButton!
    var soundButton: UIButton!
    var hintsButton: UIButton!
    
    var planetARiumViewLabel: UILabel!
    var soundLabel: UILabel!
    var hintsLabel: UILabel!
    var creditsLabel: UILabel!
    
    
    
    
    //TEMPORARY!!!!
//    var changeMusicButton: UIButton!
//    var theme = 0




    

        
    init(in superView: MenuBezelView, with menuItem: MenuItem) {
        self.superView = superView
        self.menuItem = menuItem
        isMuted = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted)
        hintsAreOff = UserDefaults.standard.bool(forKey: K.userDefaultsKey_HintsAreOff)
        
        super.init(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height))
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        //stack view
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        
        soundLabel = UILabel()
        soundLabel.text = "Fiddle"
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: K.padding),
                                     stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: -2 * K.padding),
                                     safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.padding),
                                     safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -2 * K.padding)])

        setupStackTop()
        setupStackBottom()
    }
    
    /**
     Helper method to set up the first view in the stack.
     */
    private func setupStackTop() {
        let holderView = UIView()
        holderView.clipsToBounds = true
        stackView.addArrangedSubview(holderView)
        
        
        let fontTitle: String = K.fontTitle
        let fontSize: CGFloat = 40
        let textColor = UIColor.getRandom(redRange: 175...255, greenRange: 175...255, blueRange: 175...255)
        let shadowOffset: CGFloat = 3.0
        
        //"Pocket" label
        pocketLabel = UILabel(frame: CGRect(x: -frame.width, y: frame.height / 4 - 25, width: frame.width, height: 50))
        pocketLabel.font = UIFont(name: fontTitle, size: fontSize)
        pocketLabel.textColor = textColor
        pocketLabel.textAlignment = .center
        pocketLabel.numberOfLines = 0
        pocketLabel.text = "Pocket"
        pocketLabel.shadowColor = .darkGray
        pocketLabel.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        pocketLabel.alpha = 0.0
        addSubview(pocketLabel)
        
        //"PlanetARium" label
        planetARiumLabel = UILabel(frame: CGRect(x: frame.width, y: frame.height / 4 + 25, width: frame.width, height: 50))
        planetARiumLabel.font = UIFont(name: fontTitle, size: fontSize)
        planetARiumLabel.textColor = textColor
        planetARiumLabel.textAlignment = .center
        planetARiumLabel.numberOfLines = 0
        planetARiumLabel.text = "PlanetARium"
        planetARiumLabel.shadowColor = .darkGray
        planetARiumLabel.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        planetARiumLabel.alpha = 0.0
        addSubview(planetARiumLabel)
    }
    
    /**
     Helper method to set up the second view in the stack.
     */
    private func setupStackBottom() {
        //Bottom half stack view
        let bottomStackView = UIStackView()
        bottomStackView.distribution = .fillEqually
        bottomStackView.alignment = .fill
        bottomStackView.axis = .vertical
        stackView.addArrangedSubview(bottomStackView)
        
        setupHorizontalStack(in: bottomStackView, header: "View:", description: "Solar System",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(changeView)))
        
        setupHorizontalStack(in: bottomStackView, header: "Sound:", description: isMuted ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleSound)))

        setupHorizontalStack(in: bottomStackView, header: "Hints:", description: hintsAreOff ? "Off" : "On",
                             gesture: UITapGestureRecognizer(target: self, action: #selector(toggleHints)))
        
        let creditsView = UIView()
        creditsLabel = UILabel()
        creditsLabel.text = "Credits"
        creditsLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        creditsLabel.textColor = .white
        creditsLabel.textAlignment = .center
        creditsView.addSubview(creditsLabel)
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([creditsLabel.topAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.topAnchor),
                                     creditsLabel.leadingAnchor.constraint(equalTo: creditsView.safeAreaLayoutGuide.leadingAnchor),
                                     creditsView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: creditsLabel.bottomAnchor),
                                     creditsView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: creditsLabel.trailingAnchor)])
        bottomStackView.addArrangedSubview(creditsView)

        //Just a space filler...
        setupHorizontalStack(in: bottomStackView, header: "", description: "", gesture: nil)
        setupHorizontalStack(in: bottomStackView, header: "", description: "", gesture: nil)

        //Launch button
        launchButton = UIButton(type: .system)
        launchButton.backgroundColor = UIColor(rgb: 0x3498db)
        launchButton.setTitle("Launch PlanetARium", for: .normal)
        launchButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        launchButton.tintColor = .white
        launchButton.layer.cornerRadius = 25
        launchButton.layer.shadowRadius = 4
        launchButton.layer.shadowColor = UIColor.black.cgColor
        launchButton.layer.shadowOpacity = 0.3
        launchButton.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)

        bottomStackView.addSubview(launchButton)

        launchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([launchButton.widthAnchor.constraint(equalToConstant: 225),
                                     launchButton.heightAnchor.constraint(equalToConstant: 50),
                                     launchButton.centerXAnchor.constraint(equalTo: bottomStackView.centerXAnchor),
                                     bottomStackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: launchButton.bottomAnchor, constant: K.padding)])


        
        
        
        
        
        //OLD WAY
        
//        let view2 = UIView()
//        stackView.addArrangedSubview(view2)
//
//        //content label
//        contentLabel = UILabel()
//        contentLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
//        contentLabel.textColor = .white
//        contentLabel.textAlignment = .center
//        contentLabel.numberOfLines = 0
//        contentLabel.text = menuItem.item.description
//        contentLabel.alpha = 0.0
//
//        view2.addSubview(contentLabel)
//
//        contentLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([contentLabel.topAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.topAnchor, constant: 2 * K.padding),
//                                     contentLabel.leadingAnchor.constraint(equalTo: view2.safeAreaLayoutGuide.leadingAnchor),
//                                     view2.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)])
//
//
//
//
//
//
//
//
        
            //TOTALLY A TEST!!!
//            changeMusicButton = UIButton()
//            changeMusicButton.backgroundColor = UIColor(rgb: 0x3498db)
//            changeMusicButton.layer.cornerRadius = 30
//            changeMusicButton.layer.shadowRadius = 3
//            changeMusicButton.layer.shadowColor = UIColor.black.cgColor
//            changeMusicButton.layer.shadowOpacity = 0.3
//            changeMusicButton.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
//            changeMusicButton.setTitle("Change Theme", for: .normal)
//            changeMusicButton.addTarget(self, action: #selector(changeMusic), for: .touchUpInside)
//            view2.addSubview(changeMusicButton)
//            changeMusicButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([changeMusicButton.widthAnchor.constraint(equalToConstant: 225),
//                                         changeMusicButton.heightAnchor.constraint(equalToConstant: 60),
//                                         changeMusicButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor),
//                                         view2.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: changeMusicButton.bottomAnchor, constant: 0)])

    }
    
    
    private func setupHorizontalStack(in superStackView: UIStackView, header: String, description: String, gesture: UIGestureRecognizer? = nil) {
        let textPadding: CGFloat = 5.0
        
        let horizontalStackView = UIStackView()
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.axis = .horizontal

        //Header view
        let leftView = UIView()
        let headerLabel = UILabel()
        headerLabel.text = header
        headerLabel.font = UIFont(name: K.fontFaceSecondary, size: K.fontSizeMenu)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .right
        leftView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([headerLabel.topAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.topAnchor),
                                     headerLabel.leadingAnchor.constraint(equalTo: leftView.safeAreaLayoutGuide.leadingAnchor),
                                     leftView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor),
                                     leftView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: textPadding)])
        horizontalStackView.addArrangedSubview(leftView)

        //Description (menu selection) view
        let rightView = UIView()
        let descLabel = UILabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributedText = NSAttributedString(string: description, attributes: underlineAttribute)
        descLabel.attributedText = attributedText
        descLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        descLabel.textColor = UIColor(red: 175, green: 255, blue: 255)
        descLabel.textAlignment = .left
        rightView.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([descLabel.topAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.topAnchor),
                                     descLabel.leadingAnchor.constraint(equalTo: rightView.safeAreaLayoutGuide.leadingAnchor, constant: textPadding),
                                     rightView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: descLabel.bottomAnchor),
                                     rightView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor)])
        horizontalStackView.addArrangedSubview(rightView)
        
        //Calls one of the various @objc methods!
        if let gesture = gesture {
            descLabel.isUserInteractionEnabled = true
            descLabel.addGestureRecognizer(gesture)
        }

        superStackView.addArrangedSubview(horizontalStackView)
    }
    
    /**
     Helper method to setup the description Label to be used in the horizontalStackSetup helper method (a helper within a helper...)
     - parameter description: the String description for the label to display.
     */
    private func setupDescLabel(with description: String) -> UILabel {
        let descLabel = UILabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributedText = NSAttributedString(string: description, attributes: underlineAttribute)
        descLabel.attributedText = attributedText
        descLabel.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
        descLabel.textColor = UIColor(red: 175, green: 255, blue: 255)
        descLabel.textAlignment = .left
        
        return descLabel
    }
    
    /**
     One of the tap gesture recognizers that handles changing the planetarium view.
     */
    @objc private func changeView() {
        let alert = UIAlertController(title: nil, message: "Select PlanetARium View", preferredStyle: .actionSheet)

        let actionSolarSystem = UIAlertAction(title: "Solar System", style: .default) { (action) in
            print("Solar System pressed")
            K.addHapticFeedback(withStyle: .light)
            audioManager.playSound(for: "ButtonPress")
        }
        let actionConstellations = UIAlertAction(title: "Constellations (coming soon!)", style: .default) { (action) in
            print("Constellations pressed")
        }
        let actionMilkyWay = UIAlertAction(title: "Milky Way Galaxy (coming soon!)", style: .default) { (action) in
            print("Milky Way pressed")
        }
        let actionAndromeda = UIAlertAction(title: "Andromeda Galaxy (coming soon!)", style: .default) { (action) in
            print("Andromeda pressed")
        }

        actionConstellations.isEnabled = false
        actionMilkyWay.isEnabled = false
        actionAndromeda.isEnabled = false
        
        alert.addAction(actionSolarSystem)
        alert.addAction(actionConstellations)
        alert.addAction(actionMilkyWay)
        alert.addAction(actionAndromeda)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        delegate?.menuContentViewLaunch(self, didPresentViewChangeWith: alert)
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the sound on and off.
     */
    @objc private func toggleSound() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
        
        isMuted = !isMuted
        UserDefaults.standard.setValue(isMuted, forKey: K.userDefaultsKey_SoundIsMuted)
        audioManager.updateVolumes()
        
        creditsLabel.text = "Sound"
    }
    
    /**
     One of the tap gesture recognizers that handles toggling the hints at startup, on and off.
     */
    @objc private func toggleHints() {
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
        
        hintsAreOff = !hintsAreOff
        UserDefaults.standard.setValue(hintsAreOff, forKey: K.userDefaultsKey_HintsAreOff)
        
        creditsLabel.text = "Hints"

    }
    
    
    // MARK: - PlanetARium Segue
            
    @objc private func loadPlanetARium(_ sender: UIButton) {
        let duration: TimeInterval = 0.25
        
        K.addHapticFeedback(withStyle: .light)
        audioManager.playSound(for: "LaunchButton", currentTime: 0.0)
        audioManager.stopSound(for: "MenuScreen", fadeDuration: 2.0)
        
        UIView.animate(withDuration: duration, delay: duration / 2, options: .curveEaseIn, animations: {
            self.superView.label.alpha = K.masterAlpha
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let planetARiumController = storyboard.instantiateViewController(identifier: String(describing: PlanetARiumController.self)) as? PlanetARiumController {

                planetARiumController.modalTransitionStyle = .crossDissolve
                planetARiumController.modalPresentationStyle = .fullScreen
                
                self.delegate?.menuContentViewLaunch(self, didPresentPlanetARiumController: planetARiumController)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
//    @objc func changeMusic(_ sender: UIButton) {
//        K.addHapticFeedback(withStyle: .light)
//
//        theme += 1
//        if theme > 2 {
//            theme = 0
//        }
//        switch  theme {
//        case 0:
//            audioManager.setTheme(.main)
//            sender.setTitle("Main Theme", for: .normal)
//        case 1:
//            audioManager.setTheme(.mario)
//            sender.setTitle("Super Mario", for: .normal)
//        case 2:
//            audioManager.setTheme(.starWars)
//            sender.setTitle("Star Wars", for: .normal)
//        default:
//            print("Unknown theme")
//        }
//        
//        audioManager.setupSounds()
//        audioManager.playSound(for: "ButtonPress", currentTime: 0.0)
//    }

}
