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
    static var customAlerOkPressed = Notification.Name("customAlerOkPressed")
    static let mainInfoWasUpdated = Notification.Name("mainInfoWasUpdated")
    static let nutritionmodeWasChanged = Notification.Name("nutrition_mode_was_changed")
    static let mealWasAddedToDaily = Notification.Name("meal_was_added_to_daily")
    static let exerciseWasAdedToPatern = Notification.Name("exercise_was_added_to_patern")
    static let paternNameWasChanged = Notification.Name("patern_name_was_chagned")
}
