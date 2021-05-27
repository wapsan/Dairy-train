import XCTest
@testable import Dairy_Training

class MockAuthorizationInteractor: AuthorizationInteractorProtocol {
    
    enum TestState {
        case startSignIn
        case succesSignIn
        case errorSignIn
    }
    
    var testState: TestState!
    var output: AuthorizationInteractorOutput!
    
    func signInWithGoogle() {
        guard let testState = testState else { return }
        switch testState {
        case .startSignIn:
            output.googleStartSignIn()
            
        case .succesSignIn:
            output.succesSignIn()
            
        case .errorSignIn:
            output.failureSignIn()
            
        }
    }
    
    func signInWithApple() {
        
    }
    
    func signInWithFacebook() {
        
    }
}

class MockAuthorizationRouter: AuthorizationRouterProtocol {
    
    var isTabBarRootViewController = false
    
    func setMainTabBarToRootViewController() {
        isTabBarRootViewController = true
    }
}


class MockAuthorizationView: AuthorizationViewProtocol {
   
    var isOnCurrentScreen = true
    var isLoaderShown = false
    
    func signInSuccesed() {
        isLoaderShown = false
        isOnCurrentScreen = false
    }
    
    func signInFailure() {
        isLoaderShown = false
        isOnCurrentScreen = true
    }
    
    func googleSignInStart() {
        isLoaderShown = true
        isOnCurrentScreen = true
    }
}


class AuthorizationPresenterTest: XCTestCase {
    
    var mockInteractor: MockAuthorizationInteractor!
    var authorizationPresenter: AuthorizationPresenter!
    var mockView: MockAuthorizationView!
    var mockRouter: MockAuthorizationRouter!
    

    override func setUpWithError() throws {
        mockInteractor = MockAuthorizationInteractor()
        authorizationPresenter = AuthorizationPresenter(interactor: mockInteractor)
        mockView = MockAuthorizationView()
        mockRouter = MockAuthorizationRouter()
        mockInteractor.output = authorizationPresenter
        authorizationPresenter.view = mockView
        authorizationPresenter.router = mockRouter
    }
    
    func testGoogleSuccesSignIn() {
        mockInteractor.testState = .succesSignIn
        authorizationPresenter.signInWithGoogle()
        XCTAssertFalse(mockView.isOnCurrentScreen)
        XCTAssertFalse(mockView.isLoaderShown)
        XCTAssertTrue(mockRouter.isTabBarRootViewController)
    }
    
    func testLoadingState() {
        mockInteractor.testState = .startSignIn
        authorizationPresenter.signInWithGoogle()
        XCTAssertTrue(mockView.isOnCurrentScreen)
        XCTAssertTrue(mockView.isLoaderShown)
    }
    
    func testGoogleFailureSignIn() {
        mockInteractor.testState = .errorSignIn
        authorizationPresenter.signInWithGoogle()
        XCTAssertTrue(mockView.isOnCurrentScreen)
        XCTAssertFalse(mockView.isLoaderShown)
       
    }

    override func tearDownWithError() throws {
        mockInteractor = nil
        authorizationPresenter = nil
        mockView = nil
        mockRouter = nil
    }
}
