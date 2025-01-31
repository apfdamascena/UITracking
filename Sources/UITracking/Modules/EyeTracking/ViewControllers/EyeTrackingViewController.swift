//
//  ViewController.swift
//  eye-tracking
//
//  Created by alexdamascena on 25/08/24.
//

import UIKit
import RxSwift

/// A view controller that integrates Eye Tracking functionality for navigating and interacting with the user interface.
///
/// The `EyeTrackingViewController` class coordinates the various components of the Eye Tracking system,
/// including the `EyeTrackingDatasource`, `EyeTrackingDelegate`, and `EyeMovePresentable`. It manages the lifecycle
/// of the eye-tracking session, processes user interactions through eye movements, and executes commands
/// based on the user's focus and gestures.
public class EyeTrackingViewController: UIViewController,
                                 @preconcurrency EyeTrackingSetupViewController {

    /// The main view responsible for rendering the eye-tracking interface.
    private var eyeTrackingView: EyeTrackingView
    
    /// The presenter responsible for calculating view sections and managing focus-related drawing.
    var presenter: EyeMovePresentable?
    
    /// The data source that provides the Eye Tracking system, adapter, and interpreter.
    private(set) var datasource: EyeTrackingDatasource
    
    /// The delegate responsible for handling navigation actions triggered by Eye Tracking.
    private(set) var delegate: EyeTrackingDelegate
    
    /// Dispose bag for managing RxSwift subscriptions.
    private(set) var disposeBag = DisposeBag()
    
    /// Initializes the Eye Tracking view controller with its dependencies.
    ///
    /// - Parameters:
    ///   - view: The main `EyeTrackingView` to be displayed.
    ///   - datasource: The data source providing Eye Tracking components.
    ///   - delegate: The delegate for navigation actions.
    ///   - presenter: The presenter for focus and section calculations. Defaults to a new instance of `EyeMovePresenter`.
    init(view: EyeTrackingView,
         datasource: EyeTrackingDatasource,
         delegate: EyeTrackingDelegate,
         presenter: EyeMovePresentable = EyeMovePresenter()
    ) {
        self.eyeTrackingView = view
        
        var _presenter = presenter
        _presenter.view = eyeTrackingView
        self.presenter = _presenter
        
        self.datasource = datasource
        self.delegate = delegate
    
        super.init(nibName: nil, bundle: nil)
        datasource.trackerAdapter.delegate = self
        setupPopViewController()
    }
    
    /// Required initializer for storyboard-based instances. Not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Loads the main `EyeTrackingView` as the controller's view.
    public override func loadView() {
        view = eyeTrackingView
    }
    
    /// Sets up the Eye Tracking session and initializes the view.
    public override func viewDidLoad() {
        super.viewDidLoad()
        datasource.tracking.startSession()
        eyeTrackingView.setupView()
    }
    
    /// Handles logic when the view appears, recalculating sections and setting the interpreter's state.
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        datasource.tracking.showPointer()
        let viewQuantity = presenter?.calculateSectionsAtDepth(on: datasource.depths) ?? 0
        datasource.interpreter.setSectionViewQuantity(viewQuantity)
        
        datasource.depths.removeAll()
        datasource.trackerAdapter.delegate = self
        presenter?.view = eyeTrackingView
    }
    
    /// Configures the logic for handling the pop action triggered by Eye Tracking.
    ///
    /// This method subscribes to the `popActionSubject` and performs a `popViewController` action when triggered.
    func setupPopViewController() {
        delegate.popActionSubject
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let navigationController = self?.navigationController else {
                    return
                }
                navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - EyeTracingInterpreterDelegate
extension EyeTrackingViewController: @preconcurrency EyeTracingInterpreterDelegate {
    
    /// Handles eye actions, such as selecting or deselecting views, or navigating back.
    ///
    /// - Parameters:
    ///   - action: The `EyeAction` detected (e.g., `.select`, `.deselect`, `.pop`).
    ///   - section: The section index where the action occurred.
    func onEyeAction(_ action: EyeAction, _ section: Int) {
        
        if action == .select {
            guard let isLastViewSection = presenter?.isLastSectionReachable(on: datasource.depths, and: section),
                  isLastViewSection else {
                datasource.depths.append(section)
                let viewQuantity = presenter?.calculateSectionsAtDepth(on: datasource.depths) ?? 0
                datasource.interpreter.setSectionViewQuantity(viewQuantity)
                return
            }
            
            guard let event = presenter?.loadEvent(on: datasource.depths, and: section) else { return }
            datasource.depths.removeAll()
            datasource.commandBus.executeEvent(event, controller: self)
        }
        
        if action == .deselect && !datasource.depths.isEmpty {
            datasource.depths.removeLast()
            let viewQuantity = presenter?.calculateSectionsAtDepth(on: datasource.depths) ?? 0
            datasource.interpreter.setSectionViewQuantity(viewQuantity)
        }
        
        if action == .pop {
            delegate.userTappedGoBack()
        }
        
        presenter?.drawFocusArea(for: section, on: datasource.depths)
    }

    /// Handles eye movements, updating the focus area for the current section.
    ///
    /// - Parameter section: The section index where the eye movement occurred.
    func onEyeMovement(_ section: Int) {
        presenter?.drawFocusArea(for: section, on: datasource.depths)
    }
}

