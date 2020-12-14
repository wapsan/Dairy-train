import UIKit

protocol MainNutritionView: AnyObject {
    
}
 
final class MainNutritionVIewController: DTBackgroundedViewController {

    // MARK: - @IBOutlets
    
    
    // MARK: - Properties
    private let viewModel: NutritionViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: NutritionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
    }

    // MARK: - Actions
    @objc private func addButtonPressed() {
        MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.searchFood)
    }
}

// MARK: - MainNutritionView
extension MainNutritionVIewController: MainNutritionView {
  
}
