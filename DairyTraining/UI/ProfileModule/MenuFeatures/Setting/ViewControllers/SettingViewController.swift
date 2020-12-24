import UIKit

class SettingViewController: SettingsSectionViewController {
    
    //MARK: - Private properties
    private var settingInfo: SettingModel?
        
    //MARK: - Initialization
    init(with setting: SettingModel) {
        super.init(with: setting.title)
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

//MARK: - UITableViewDelegate, UITableViewDataSourse
extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.settingInfo?.possibleSetting.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTSettingCell.cellID,
                                                 for: indexPath)
        guard let settinginfo = self.settingInfo,
            let isSettingSelected = self.settingInfo?.isSettingSelected(at: indexPath.row) else {
                return UITableViewCell()
        }
        
        (cell as? DTSettingCell)?.setCurrentSettingCell(for: settinginfo, and: indexPath.row)
        
        if isSettingSelected {
            (cell as? DTSettingCell)?.setCheked()
        } else {
            (cell as? DTSettingCell)?.setUncheked()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingInfo?.sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentValue = self.settingInfo?.possibleSetting[indexPath.row] else { return }
        self.settingInfo?.currentValue = currentValue
        self.settingWasChanged()
        self.tableView.reloadData()
    }
}
