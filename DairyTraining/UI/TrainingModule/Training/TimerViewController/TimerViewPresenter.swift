import Foundation

protocol TimerViewPresenterProtocol {
    func timeWasSelectTo(time: CFTimeInterval)
    func stopPlayButtonPressed()
}

final class TimerViewPresenter {
    
    // MARK: - Properties
    private var time: CFTimeInterval?
    private var timer: Timer?
    private var isTimerRunning = false {
        didSet {
            view?.updatePlayButtonState(isPlaying: isTimerRunning)
        }
    }
    
    weak var view: TimerView?
    weak var timerDelegate: TimerDelegate?
    
    // MARK: - Initialization
    init(timerDeleggate: TimerDelegate) {
        self.timerDelegate = timerDeleggate
    }
    
    // MARK: - Private methods
    private func startTimer() {
        guard let duration = time else { return }
        var tick: TimeInterval = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] (_) in
            tick += 0.01
            let cuntDownValue = duration - tick
            self.view?.updateTimeLabel(minutes: getMinutes(time: cuntDownValue),
                                       seconds: getSeconds(time: cuntDownValue),
                                       miliseconds: getMiliseconds(time: cuntDownValue))
            if tick > duration {
                self.timer?.invalidate()
                self.timer = nil
                MainCoordinator.shared.dismiss()
                timerDelegate?.timerFinished()
            }
        }
        view?.timerStart(with: duration)
    }
    
    private func getMinutes(time: TimeInterval) -> String {
        return String(format: "%02i:", Int(time) / 60 % 60)
    }
    
    private func getSeconds(time: TimeInterval) -> String {
        return String(format: "%02i:", Int(time) % 60)
    }
    
    private  func getMiliseconds(time: TimeInterval) -> String {
        return String(format: "%02i", Int((time.truncatingRemainder(dividingBy: 1)) * 100))
    }
    
    private  func stopTimer() {
        view?.updateStopAnimation()
        timer?.invalidate()
        timer = nil
        guard let time = self.time else { return }
        view?.updateTimeLabel(minutes: getMinutes(time: time), seconds: getSeconds(time: time), miliseconds: getMiliseconds(time: time))
    }
}

// MARK: - TimerViewPresenterProtocol
extension TimerViewPresenter: TimerViewPresenterProtocol {
    
    func stopPlayButtonPressed() {
        isTimerRunning ? stopTimer() : startTimer()
        isTimerRunning = !isTimerRunning
    }
    
    func timeWasSelectTo(time: CFTimeInterval) {
        view?.updateTimeLabel(minutes: getMinutes(time: time), seconds: getSeconds(time: time), miliseconds: getMiliseconds(time: time))
        self.time = time
    }
}
