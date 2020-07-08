import Foundation

extension Notification.Name {
    
    static var googleSignIn = Notification.Name(rawValue: "googleSifgnIn")
    static var colorThemeChanged = Notification.Name("colorChanged")
    static var weightMetricChanged = Notification.Name("weightMetricChanged")
    static var heightMetricChanged = Notification.Name("heightMetrickChanged")
    static var trainingWasChanged = Notification.Name("addExercicesToTrain")
    static var trainingListWasChanged = Notification.Name("trainingListWasChanged")
    static var settingWasChanged = Notification.Name("settingWasChanged")
    static var startGoogleSignIn = Notification.Name("startGoogleSignIn")
    static var dataWasSynhronize = Notification.Name("dataWasSynhronize")
}
