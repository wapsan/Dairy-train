import UIKit

protocol TrainingProgramsLevelsViewProtocol: AnyObject {

}

final class TrainingProgramsLevelsViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - GUI Properties
    private var stretchableHeader: StretchableHeader?
    
    // MARK: - Module properties
    private let viewModel: TrainingProgramsLevelsViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: TrainingProgramsLevelsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        tableView.register(cell: LevelOfTrainingCell.self)
        setupHeader()
    }

    private func setupHeader() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 250)
        stretchableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        stretchableHeader?.backgroundColor = .black
        stretchableHeader?.backButtonImageType = .close
        stretchableHeader?.minimumContentHeight = 44
        stretchableHeader?.onBackButtonAction = { [unowned self] in
            self.viewModel.backButtonPressed()
        }
        stretchableHeader?.title = "Training levels"
        stretchableHeader?.customDescription = "First of all select you training levels, and we will proporse for you special ready training programms."
        guard let header = stretchableHeader else { return }
        tableView.addSubview(header)
    }
}

// MARK: - UITableViewDataSource
extension TrainingProgramsLevelsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.levelsOfTrainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LevelOfTrainingCell.cellID, for: indexPath)
        (cell as? LevelOfTrainingCell)?.setCell(for: viewModel.levelOfTraining(for: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDataSource
extension TrainingProgramsLevelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}
 
// MARK: - TrainingProgramsLevelsViewProtocol
extension TrainingProgramsLevelsViewController: TrainingProgramsLevelsViewProtocol {
    
  
}

