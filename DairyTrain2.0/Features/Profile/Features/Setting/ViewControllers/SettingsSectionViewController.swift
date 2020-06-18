import UIKit

class SettingsSectionViewController: UITableViewController {
    
    //MARK: - Private properties
    private lazy var settingModel = [SettingSection(type: .metrics),
                                     SettingSection(type: .style)]
    private lazy var navigationTittle = LocalizedString.setting
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let choosenSetting = settingModel[indexPath.section].settings[indexPath.row]
        let setingViewController = SettingViewController(with: choosenSetting)
        self.navigationController?.pushViewController(setingViewController, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DTSettingCell.cellID,
                                                 for: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        let setting = self.settingModel[section].settings[row]
        (cell as? DTSettingCell)?.setSetingSectionCell(for: setting)
        return cell
    }
}
