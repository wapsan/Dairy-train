import UIKit

class SettingsSectionViewController: UITableViewController {
    
    //MARK: - Private properties
    private lazy var settingModel = [SettingSection(type: .metrics),
                                     SettingSection(type: .style),
                                     SettingSection(type: .synchronization)]
    private lazy var navigationTittle = LocalizedString.setting
    private lazy var lastSynhronizeDate = CoreDataManager.shared.readUserMainInfo()?.dateOfLastUpdate
                                          ?? "Data don't up to date."
    
    private lazy var a: DTDownloadHud = {
        let a = DTDownloadHud(frame: .zero)
        a.translatesAutoresizingMaskIntoConstraints = false
        return a
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataWasSynhronize), name: .dataWasSynhronize, object: nil)
    }

    //MARK: - Initialization
    init(with name: String) {
        super.init(style: .grouped)
        self.initializationTableView()
        self.addObserverForSettingChanged()
        self.navigationItem.title = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializationTableView() {
        self.tableView?.register(DTSettingCell.self, forCellReuseIdentifier: DTSettingCell.cellID)
        self.tableView.register(DTSynhronizeCell.self, forCellReuseIdentifier: DTSynhronizeCell.cellID)
        self.tableView?.backgroundColor = UIColor.black
        self.tableView?.sizeToFit()
        self.tableView?.rowHeight = 50
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.sectionHeaderHeight = 50
        self.tableView.bounces = false
    }
    
    //MARK: - Private methods
    private func addObserverForSettingChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.settingWasChanged),
                                               name: .settingWasChanged,
                                               object: nil)
    }

    //MARK: - Actions
    @objc private func settingWasChanged() {
        self.tableView.reloadData()
    }
    
    @objc private func dataWasSynhronize() {
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return }
        for indexPath in indexPaths {
            if self.settingModel[indexPath.section].type == .synchronization {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDatasourse methods
extension SettingsSectionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingModel[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.settingModel[indexPath.section].type == .synchronization {
            
           // self.az = DateHelper.shared.currentDateForSynhronize
            CoreDataManager.shared.updateDateOfLastUpdateTo(DateHelper.shared.currentDateForSynhronize)
            DTFirebaseFileManager.shared.synhronizeDataToServer(completion: {
                NotificationCenter.default.post(name: .dataWasSynhronize, object: nil)
            })
        } else {
            let choosenSetting = settingModel[indexPath.section].settings[indexPath.row]
            let setingViewController = SettingViewController(with: choosenSetting)
            self.navigationController?.pushViewController(setingViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingModel[section].tittle
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let setting = self.settingModel[section].settings[row]

        if self.settingModel[indexPath.section].type == .synchronization {
            let cell = tableView.dequeueReusableCell(withIdentifier: DTSynhronizeCell.cellID, for: indexPath)
            (cell as? DTSynhronizeCell)?.setUpdateDateTo(self.lastSynhronizeDate)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DTSettingCell.cellID,
                                                     for: indexPath)
            (cell as? DTSettingCell)?.setSetingSectionCell(for: setting)
            return cell
        }
    }
}
