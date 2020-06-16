import UIKit

class SettingsSectionVC: UITableViewController {
    
    //MARK: - Private properties
    private lazy var settingModel = [SettingSection(type: .metrics),
                                     SettingSection(type: .style)]
    private lazy var navigationTittle = "Setting"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    //MARK: - Initialization
    init(with name: String) {
        super.init(style: .grouped)
        self.initialization()
        self.navigationItem.title = name
        self.tableView.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func initialization() {
        self.tableView?.register(DTSettingCell.self, forCellReuseIdentifier: DTSettingCell.cellID)
        self.tableView?.backgroundColor = UIColor.black
        self.tableView?.sizeToFit()
        self.tableView?.rowHeight = 50
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.sectionHeaderHeight = 50
    }
    
    //MARK: - Table view delegate, datasourse
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingModel[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settingModel[indexPath.section].settings[indexPath.row]
        let setVC = SettingVC(with: setting)
        self.navigationController?.pushViewController(setVC, animated: true)
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
                                                 for: indexPath) as! DTSettingCell
        let section = indexPath.section
        let row = indexPath.row
        let setting = self.settingModel[section].settings[row]
        cell.mainSettingLabel.text = setting.tittle
        cell.currentSettingLabel.text = setting.curenttValue
        return cell
    }
}

