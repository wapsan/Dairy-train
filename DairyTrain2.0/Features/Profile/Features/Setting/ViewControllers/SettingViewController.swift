import UIKit

class SettingViewController: SettingsSectionViewController {
    
    //MARK: - Private properties
    private var settingInfo: Setting?
    
    //MARK: - Initialization
    init(with setting: Setting) {
        super.init(with: setting.tittle)
        self.tableView.allowsMultipleSelection = false
        self.tableView.sectionHeaderHeight = 10
        self.settingInfo = setting
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func settingWasChanged() {
        NotificationCenter.default.post(name: .settingWasChanged, object: nil)
    }
}

//MARK: - Table view methods
extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingCount = self.settingInfo?.possibleList.count else { return 0 }
        return settingCount
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTSettingCell.cellID,
                                                 for: indexPath)
        guard let settingInfo = self.settingInfo,
            let isCheckedIn = self.settingInfo?.isChekedIn(indexPath.row) else {
                return UITableViewCell() }
        
        (cell as? DTSettingCell)?.setCurrentSettingCell(for: settingInfo, and: indexPath.row)
        
        if isCheckedIn {
            (cell as? DTSettingCell)?.setCheked()
        } else {
            (cell as? DTSettingCell)?.setUncheked()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingInfo?.header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentValue = self.settingInfo?.possibleSetting[indexPath.row] else { return }
        self.settingInfo?.curenttValue = currentValue
        self.settingWasChanged()
        self.tableView.reloadData()
    }
}
