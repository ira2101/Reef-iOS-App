//
//  ReefLevelView.swift
//  Reef
//
//  Created by Ira Einbinder on 12/10/22.
//

import UIKit
import SnapKit
import RealmSwift

class ReefLevelView: UIView {
    var levelProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .lightGray
//        progressView.progress = 0.5
    
        return progressView
    }()
    
    var reefLevelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    var nextLevelLabel: UILabel =  {
        let label = UILabel()
        label.text = "5,000 more reef points"
        return label
    }()
    
    convenience init(fish: String) {
        self.init()
        setupView()
        populateView()
    }
    
    func setupView() {
        self.addSubview(reefLevelLabel)
        reefLevelLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        self.addSubview(levelProgressView)
        levelProgressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(reefLevelLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(10)
        }

        self.addSubview(nextLevelLabel)
        nextLevelLabel.snp.makeConstraints { make in
            make.top.equalTo(levelProgressView.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func populateView() {
        Task {
            do {
                let reefLevel = try await ReefUser.getReefLevel()
                let reefScore = try await ReefUser.getReefScore()
                let scoreForNextLevel = try await ReefUser.scoreForNextLevel()
                
                let progress = Float(reefScore) / Float(scoreForNextLevel)
                levelProgressView.progress = progress
                
                print("Reef score is \(reefScore)")
                
                reefLevelLabel.text = "Reef Level " + reefLevel.description
                nextLevelLabel.text = "Next level at " + scoreForNextLevel.description + " points"
            } catch {
                print(error.localizedDescription)
            }
        }
        
        for i in 1..<10 {
            print("Level \(i) -> Level \(i + 1) = \(toNextLevel(level: Double(i)))")
        }
        
        // You start at Level 1
        // You need 1,000 to get to Level 2
        // You need 10,000 to get to Level 3
        // You need 100,000 to get to Level 4
        // You need 1,000,000 to get to Level 5
        // You need 10,000,000 to get to Level 6
        // You need 100,000,000 to get to Level 7
        // You need 1,000,000,000 to get to Level 8
        // You need 10,000,000,000 to get to Level 9
        // You need 100,000,000,000 to get to Level 10
                
        // Congratulations, you're swimming your way to the top!
    }
    
    func toNextLevel(level: Double) -> Int {
        return Int(pow(10.0, level + 2))
//        return Int(round((4 * pow(level, 3.0)) / 5))
    }
    
    

}
