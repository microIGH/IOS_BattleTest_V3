//
//  SubjectsViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class SubjectsViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var subjects: [Subject] = []
    private var filteredSubjects: [Subject] = []
    
    private let connectionBanner = ConnectionBannerView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupConstraints()
        loadSubjects()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = "subjects_title".localized
        
        searchBar.placeholder = "search_subject".localized
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        activityIndicator.color = UIColor.systemBlue
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        view.addSubview(connectionBanner)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: "SubjectCell")
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        view.bringSubviewToFront(connectionBanner)
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        connectionBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            connectionBanner.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            connectionBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            connectionBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            connectionBanner.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func loadSubjects() {
        activityIndicator.startAnimating()
        
        guard NetworkMonitor.shared.isConnected else {
            loadLocalSubjects()
            connectionBanner.showOffline()
            return
        }
        
        if NetworkMonitor.shared.connectionType == .cellular {
            connectionBanner.showCellular()
        }
        
        let currentLanguage = getCurrentLanguage()
        
        APIService.shared.fetchQuizzes(language: currentLanguage) { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let remoteSubjects):
                self.subjects = remoteSubjects
                self.filteredSubjects = remoteSubjects
                self.collectionView.reloadData()
                self.connectionBanner.hide()
                
            case .failure(let error):
                print("Error fetching: \(error.localizedDescription)")
                self.loadLocalSubjects()
                self.connectionBanner.showOffline()
            }
        }
    }

    private func loadLocalSubjects() {
        subjects = QuizDataManager.shared.getLocalizedSubjects()
        filteredSubjects = subjects
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }

    private func getCurrentLanguage() -> String {
        return NSLocale.preferredLanguages.first?.prefix(2).lowercased() ?? "es"
    }
    
    private func filterSubjects(with searchText: String) {
        if searchText.isEmpty {
            filteredSubjects = subjects
        } else {
            filteredSubjects = subjects.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}

extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSubjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCollectionViewCell
        let subject = filteredSubjects[indexPath.item]
        cell.configure(with: subject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 56
        let availableWidth = view.frame.width - padding
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subject = filteredSubjects[indexPath.item]
        let quizListVC = QuizListViewController(subject: subject)
        navigationController?.pushViewController(quizListVC, animated: true)
    }
}

extension SubjectsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSubjects(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
