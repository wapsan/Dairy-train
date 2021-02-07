import UIKit

final class StartStopWorkoutView: UIView {
    
    //MARK: - @IBOutlets
    @IBOutlet private var startWorkoutButton: UIButton!
    @IBOutlet private var stopWorkoutButton: UIButton!
    
    
    @IBOutlet var timingButton: [UIButton]!
    
    //MARK: - Properties
    var stopButtonAction: (() -> Void)?
    var startButtonAction: (() -> Void)?
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        timingButton.forEach({
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.setTitleColor(.white, for: .normal)
            $0.isEnabled = true
        })
        
    }
    
    private func setupButtonWithStartTime(startTime: Date = Date()) {
        startWorkoutButton.isEnabled = false
        let start = DateHelper.shared.getFormatedDateFrom(startTime, with: .startStopTrainingTimeFormat)
        startWorkoutButton.setTitle(start, for: .normal)
    }
    
    private func setupButtonWithStopTime(stopTime: Date = Date()) {
        stopWorkoutButton.isEnabled = false
        let stop = DateHelper.shared.getFormatedDateFrom(stopTime, with: .startStopTrainingTimeFormat)
        stopWorkoutButton.setTitle(stop, for: .normal)
    }
    
    
    //MARK: - Configuration
    func configure(for startTime: Date?, and endTime: Date?) {
        if let startTime = startTime {
            setupButtonWithStartTime(startTime: startTime)
        }
        
        if let endTime = endTime {
            setupButtonWithStopTime(stopTime: endTime)
        }
    }
    
    //MARK: - Actions
    @IBAction func startWorkoutPressed(_ sender: Any) {
        startButtonAction?()
        setupButtonWithStartTime()
    }
    
    @IBAction func stopWorkoutPressed(_ sender: Any) {
        stopButtonAction?()
        setupButtonWithStopTime()
    }
}
