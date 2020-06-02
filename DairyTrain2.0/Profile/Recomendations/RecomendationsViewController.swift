import UIKit

class RecomendationsViewController: UIViewController {
    
    //MARK: - GUI Properties
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        let nib = UINib(nibName: "CustomRecomandationCells", bundle: nil)
        table.register(nib, forCellReuseIdentifier: self.cellID)
        table.sectionFooterHeight = 1
        table.sectionHeaderHeight = self.view.frame.height / 15
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Privatr roperties
    private var cellID = "RecomendationCell"
    private var selectedSections = Set<Int>()
    private var supplyModel: [RecomendationInfo] = []

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSupplyModel()
        self.setUpTable()
    }
        
    //MARK: - Private Methods
    private func setUpTable() {
        self.view.addSubview(self.tableView)
        self.setUpTableConstraints()
    }
    
    private func setUpSupplyModel() {
        self.supplyModel = CaloriesCalculator.shared.getRecomendatinoInfo()
    }
    
    private func setUp(_ cell: DTCustomRecomendationsCell, in section: Int) {
        let suply = self.supplyModel[section]
        cell.caloriesLabel.text = suply.caloriesRecomendation
        cell.proteinsLabel.text = suply.proteinRecomendation
        cell.carbohydratesLabel.text = suply.carbohydratesRcomendation
        cell.fatsLabel.text = suply.fatRecomandation
    }
    
    //MARK: - Constraints
    func setUpTableConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}

//MARK: - TableView DataSourse
extension RecomendationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedSections.contains(section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecomendationCell",
                                                      for: indexPath) as! DTCustomRecomendationsCell
        self.setUp(cell, in: indexPath.section)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.supplyModel.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = self.tableView.bounds.width
        let heigt: CGFloat = 1
        let footerView = UIView(frame: .init(x: 0, y: 0, width: width, height: heigt))
        footerView.backgroundColor = .white
        return footerView
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = self.tableView.bounds.width
        let height = self.tableView.sectionHeaderHeight
        let headerView = DTRecomendationHeaderView(frame: .init(x: 0,
                                                                y: 0,
                                                                width: width,
                                                                height: height))
        headerView.label.text = self.supplyModel[section].tittle
        headerView.moreInfobutton.tag = section
        headerView.delegate = self
        return headerView
    }
    
}

//MARK: - DTRecomendationFooterViewDelegate
extension RecomendationsViewController: DTRecomendationHeaderViewDelegate {

    func tapOpenCellsButton(_ sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
             var indexPaths = [IndexPath]()
             for row in 0..<1 {
                 indexPaths.append(IndexPath(row: row,
                                             section: section))
             }
             return indexPaths
         }
         
         if self.selectedSections.contains(section) {
            self.selectedSections.remove(section)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: indexPathsForSection(), with: .top)
            self.tableView.endUpdates()
         } else {
            self.selectedSections.insert(section)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPathsForSection(), with: .top)
            self.tableView.endUpdates()
         }
    }

}


