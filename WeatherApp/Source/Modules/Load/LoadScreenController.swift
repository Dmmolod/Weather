import UIKit

final class LoadScreenController: UIViewController {
    
    private var viewModel: LoadScreenViewModel
    
    init(viewModel: LoadScreenViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.viewDidLoad()
    }
    
    
    private func setupUI() {
        let spinner = UIActivityIndicatorView(style: .large)
        let background = UIImageView(image: UIImage(named: "weatherLaunch"))
        [background, spinner].forEach { view.addSubview($0) }
        
        spinner.startAnimating()
        spinner.color = .systemPink
        spinner.centerX(inView: view)
        spinner.centerY(inView: view)
        
        background.contentMode = .scaleAspectFill
        background.anchor(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
}
