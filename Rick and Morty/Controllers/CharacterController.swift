//
//  CharacterController.swift
//  Rick and Morty
//
//  Created by Vladimir Kholevin on 22.09.2020.
//  Copyright © 2020 Vladimir Kholevin. All rights reserved.
//

import UIKit

class CharacterController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    let characterManager: ICharacterManager
        
    var timer: Timer?
    
    // MARK: - Initialization
    
    public init() {
        self.characterManager = CharacterManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.characterManager = CharacterManager()
        super.init(coder: coder)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialControllerSetup()
    }
    
    // MARK: - Private methods
    
    private func initialControllerSetup() {
        title = "Rick and Morty"
        setupTableView()
        fetchCharacters()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "CharacterListCell", bundle: nil), forCellReuseIdentifier: "CharacterListCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchCharacters() {
        characterManager.fetchCharacters() { [weak self] error in
            guard let self = self else {return}
            
            self.tableView.tableFooterView = nil
            if error == nil {
                self.tableView.reloadData()
            } else {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
                    self.showOfflineAlert() // сообщение об отсутствии доступа в сеть показывается с задержкой
                }
            }
        }
    }
    
    private func showOfflineAlert() {
        let alertController = UIAlertController(title: "The Internet connection appears to be offline. Try again later.", message: nil, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .dark
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    private func createSpinnerFooterView() -> UIView {
        let spinnerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinnerIndicator = UIActivityIndicatorView()
        spinnerIndicator.center = spinnerView.center
        spinnerView.addSubview(spinnerIndicator)
        spinnerIndicator.startAnimating()
        spinnerIndicator.overrideUserInterfaceStyle = .dark
        return spinnerView
    }
}



extension CharacterController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterManager.characters.count
    }
      
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCell", for: indexPath) as? CharacterListCell else { return UITableViewCell() }
        
        let characterName = characterManager.characters[indexPath.row].name
        let characterImage = characterManager.characterImages[indexPath.row] ?? nil
        cell.setupCell(withName: characterName, image: characterImage)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return view
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // подгружаю новые элементы в список, если требуется
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
  
        guard translation.y < 0 else { return } // достаем новых персонажей, только если проматываем вниз
        guard !characterManager.isFetchingData else { return }
        guard !characterManager.nextPageIsNull else { return }
        
        let bottomPoint = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomPoint > scrollView.contentSize.height - 300 {
            tableView.tableFooterView = createSpinnerFooterView()
            fetchCharacters()
        }
    }
    
}

