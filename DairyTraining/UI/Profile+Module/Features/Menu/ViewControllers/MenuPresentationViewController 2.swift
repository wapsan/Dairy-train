import UIKit

class MenuPresentationViewController: UIPresentationController{
    
    //MARK: - Properties
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = self.containerView else { return CGRect.zero }
        return CGRect(x: 0,
                      y: container.frame.height / 2,
                      width: container.frame.width,
                      height: container.frame.height / 2)
    }
    
    //MARK: - GUI Properties
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - Recognizers
    private lazy var tapGestureRecogmizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(self.dismiss))
        return tapRecognizer
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(self.swipeToDissmis(_:)))
        return panRecognizer
    }()
    
    //MARK: - Private methods
    private func setUpPresentedView() {
        self.presentedView?.layer.cornerRadius = 20
        self.presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.presentedView?.layer.shadowColor = UIColor.darkGray.cgColor
        self.presentedView?.layer.shadowOffset = .init(width: 0, height: -5)
        self.presentedView?.layer.shadowOpacity = 5
        self.presentedView?.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    //MARK: - Initialization
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.setUpBackgroundView()
    }
    
    private func setUpBackgroundView() {
        self.backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.addGestureRecognizer(self.tapGestureRecogmizer)
    }
    
    //MARK: - Public methods
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                self.backgroundView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.backgroundView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        self.backgroundView.alpha = 0
        self.containerView?.addSubview(backgroundView)
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                self.backgroundView.alpha = 0.7
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.setUpPresentedView()
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let containerView = self.containerView else { return }
        self.backgroundView.frame = containerView.frame
    }
    
    //MARK: - Actions
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeToDissmis(_ sender: UIPanGestureRecognizer) {
        guard let presentedView = self.presentedView,
            let containerView = self.containerView else { return }
        
        let bottomEdgeForDissmis = containerView.bounds.size.height - (containerView.bounds.size.height * 0.25)
        let yTransition = sender.translation(in: presentedView).y
        
        if presentedView.frame.origin.y >= containerView.frame.height / 2 {
            presentedView.frame.origin = CGPoint(x: presentedView.frame.origin.x,
                                                 y: presentedView.frame.origin.y + yTransition)
            if sender.state == .ended {
                UIView.animate(withDuration: 0.2, animations: {
                    presentedView.frame.origin = CGPoint(x: presentedView.frame.origin.x,
                                                         y: containerView.frame.height / 2)
                })
            }
            
            if presentedView.frame.origin.y > bottomEdgeForDissmis {
                self.dismiss()
            }
            
        } else {
            presentedView.frame.size = CGSize(width: presentedView.frame.size.width,
                                              height: presentedView.frame.size.height - yTransition)
            sender.state = .cancelled
            
            if sender.state == .cancelled {
                UIView.animate(withDuration: 0.2, animations: {
                    presentedView.frame.origin = CGPoint(x: presentedView.frame.origin.x,
                                                         y: containerView.frame.height / 2)
                })
            }
        }
        sender.setTranslation(CGPoint.zero, in: presentedView)
    }
}
