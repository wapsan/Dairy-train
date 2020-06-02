import UIKit

class SettingVC: SettingsSectionVC {
    
    //MARK: - Private properties
    private var settingInfo: Setting?
    
    //MARK: - Initialization
    init(with setting: Setting) {
        super.init(with: setting.tittle)
        self.settingInfo = setting
        self.tableView.allowsMultipleSelection = false
        self.tableView.sectionHeaderHeight = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Table view methods
extension SettingVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let setingVariant = self.settingInfo?.possibleList.count else  { return 0 }
        return setingVariant
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DTSettingCell", for: indexPath)
            as! DTSettingCell
    
        if let possibleVariants = self.settingInfo?.possibleList {
            cell.mainSettingLabel.text = possibleVariants[indexPath.row]
            cell.currentsSetting.text = nil
        }
        if (self.settingInfo?.isChekedOn(indexPath.row))! {
            cell.markImage?.image = UIImage(named: "checkMark")
           
        } else {
         
            cell.markImage?.image = nil
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingInfo?.header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentValue = self.settingInfo?.possibleSetting[indexPath.row]
        self.settingInfo?.curenttValue = currentValue
        self.tableView.reloadData()
    }
    
}
