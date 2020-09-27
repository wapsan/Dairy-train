import UIKit

class TrainingPaternsViewController: DTBackgroundedViewController {

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //FIXME: - Finish setup hiden tab bar 
        self.extendedLayoutIncludesOpaqueBars = true
        self.setTabBarHidden(true, animated: true, duration: 0.25)
    }
}

//MARK: - Private extension
private extension TrainingPaternsViewController {
    
    func setup() {
        print(CoreDataManager.shared.fetchTrainingPaterns().count)
        self.title = NSLocalizedString("Training paterns", comment: "")
    }
}
