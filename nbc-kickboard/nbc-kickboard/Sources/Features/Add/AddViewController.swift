//
//  AddViewController.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/17/24.
//

import UIKit
import MapKit
import SnapKit

final class AddViewController: UIViewController {
    private var kickboardCode: String = "" {
        didSet { addButton.isEnabled = !kickboardCode.isEmpty }
    }
    private var currentLatitude: Double = 0.0
    private var currentLongitude: Double = 0.0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "등록"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.paybooc(ofSize: 26.0, weight: .bold)
        
        return label
    }()
    
    private let contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30.0
        
        return stackView
    }()
    
    private let codeSectionView = CodeSectionView()
    
    private let sortSectionView = SortSectionView(buttonTypes: [.basic, .power])
    
    private let locationSectionView = LocationSectionView()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.applyFullSizeButtonStyle(
            title: "등록",
            bgColor: UIColor(named: "colorMain")!,
            isRadius: true)
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupConstraints()
        
        codeSectionView.delegate = self
        sortSectionView.delegate = locationSectionView
        locationSectionView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [titleLabel, contentVStackView, addButton].forEach { view.addSubview($0) }
        
        [codeSectionView, sortSectionView, locationSectionView].forEach { contentVStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Layouts.padding)
            $0.left.equalToSuperview().inset(Layouts.padding)
        }
        
        contentVStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(10.0)
            $0.height.equalTo(60.0)
        }
    }
}

extension AddViewController: CodeSectoinViewDelegate {
    func createRandomKickboardCode(completion: @escaping (String) -> Void) {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        func generateCode() -> String { String((0..<8).compactMap { _ in characters.randomElement() }) }
        
        var newCode: String
        var kickboard: Kickboard? = nil
        
        // KickboardCode 중복 방지
        repeat {
            newCode = generateCode()
            kickboard = try? CoreDataStack.shared.readKickboard(kickboardCode: newCode)
        } while kickboard != nil
        
        kickboardCode = newCode
        completion(newCode)
    }
}

extension AddViewController: LocationSectionViewDelegate {
    func mapViewReginDidChange(centerCoordinate: CLLocationCoordinate2D) {
        currentLatitude = centerCoordinate.latitude
        currentLongitude = centerCoordinate.longitude
    }
}

#if DEBUG

import SwiftUI

struct AddViewController_Previews: PreviewProvider {
    static var previews: some View {
        AddViewController_Presentable()
    }
    
    struct AddViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            AddViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif
