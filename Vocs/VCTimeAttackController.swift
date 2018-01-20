//
//  VCTimeAttackController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 19/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import UIKit

class VCTimeAttackController: VCTraductionViewController {
    
    let heigthProgressBar = CGFloat(8)
    let FLUIDITY = 200
    
    let progressBar : UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor(hex: 0x277CC0)
        return view
    }()

    private var timerAvancer : Timer?
    private var compteurTimer : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Time attack"
    }
    
    func motAttendu() -> String {
        let wordTrad = mots[motActuelIndex]
        var motAttendu : String?
        if (isFrenchToEnglish) {
            //On prend le trad ( Anglais ) pour voir si il est égal au mot word
            motAttendu = wordTrad.trad?.content
        } else {
            motAttendu = wordTrad.word?.content
        }
        return motAttendu!
    }
    
    func startChrono() {
        progressBar.setProgress(0, animated: false)
        let delay = CGFloat(Parametre.loadInstance().TIME_PER_LETTER_TIME_ATTACK) * CGFloat(motAttendu().count)
        timerAvancer = Timer.scheduledTimer(timeInterval: TimeInterval(delay / CGFloat(FLUIDITY)), target: self, selector: #selector(avancerBarre), userInfo: nil, repeats: true)
    }
    
    @objc func avancerBarre() {
        compteurTimer += 1
        if compteurTimer > FLUIDITY {
            timerAvancer?.invalidate()
            userLoose()
            compteurTimer = 0
        } else {
            progressBar.progress += 1/200
        }
    }
    
    @objc override func loadWordOnScreen(){
        super.loadWordOnScreen()
        startChrono()
    }
    
    func userLoose() {
        self.validateButton.isEnabled = false
        compteur += 1
        finir()
    }
    
    override init() {
        super.init()
        self.navigationItem.title = "Time attack"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func handleCheck() {
        super.handleCheck()
        timerAvancer?.invalidate()
        compteurTimer = 0
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15),
            progressBar.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier : 0.9),
            progressBar.heightAnchor.constraint(equalToConstant: heigthProgressBar)
        ])
        progressBar.setProgress(0, animated: true)
    }
}
