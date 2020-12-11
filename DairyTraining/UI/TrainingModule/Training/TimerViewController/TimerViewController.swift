import UIKit

protocol TimerView: AnyObject {
    func timerStart(with duration: CFTimeInterval)
    func updatePlayButtonState(isPlaying: Bool)
    func updateTimeLabel(minutes: String, seconds: String, miliseconds: String)
    func updateStopAnimation()
}

final class TimerViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var restTimerLabel: UILabel!
    @IBOutlet private var timeRangeSegmentControll: UISegmentedControl!
    @IBOutlet private var timeControllView: TimerControllView!
    @IBOutlet private var playStopButton: UIButton!
    
    // MARK: - Nodule properies
    private var presenter: TimerViewPresenterProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(presenter: TimerViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        presenter.timeWasSelectTo(time: TimeRangeModel.allCases[0].duration)
        playStopButton.layer.cornerRadius = playStopButton.bounds.height / 2
    }
    
    // MARK: - Actions
    @IBAction func timeSegmentControllChangeValue(_ sender: UISegmentedControl) {
        presenter.timeWasSelectTo(time: TimeRangeModel.allCases[sender.selectedSegmentIndex].duration)
    }
    
    @IBAction func playStopButtonTouchInside(_ sender: UIButton) {
        presenter.stopPlayButtonPressed()
    }
}

// MARK: - TimerView
extension TimerViewController: TimerView {
    
    func updateStopAnimation() {
        timeControllView.stopAnimation()
    }

    func updateTimeLabel(minutes: String, seconds: String, miliseconds: String) {
        timeControllView.update(minutes: minutes, sconds: seconds, miliseconds: miliseconds)
    }

    func updatePlayButtonState(isPlaying: Bool) {
        if isPlaying {
            playStopButton.setImage(UIImage(named: "timer_icon_stop"), for: .normal)
        } else {
            playStopButton.setImage(UIImage(named: "timer_icon_play"), for: .normal)
        }
    }
    
    func timerStart(with duration: CFTimeInterval) {
        timeControllView.startDownloadAnimationWith(duration: duration)
    }
}
