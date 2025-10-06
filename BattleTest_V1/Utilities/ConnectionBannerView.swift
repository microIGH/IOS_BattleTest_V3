
import UIKit

class ConnectionBannerView: UIView {
    
    private let iconLabel = UILabel()
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    //
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemRed
        layer.cornerRadius = 8
        clipsToBounds = true
        
        iconLabel.font = UIFont.systemFont(ofSize: 16)
        iconLabel.textAlignment = .center
        
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .left
        
        addSubview(iconLabel)
        addSubview(messageLabel)
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 24),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        alpha = 0
    }
    
    func showOffline() {
        iconLabel.text = "⚠️"
        messageLabel.text = "Sin conexión - Modo offline"
        backgroundColor = UIColor.systemRed
        animateIn()
    }
    
    func showCellular() {
        iconLabel.text = "📱"
        messageLabel.text = "Usando datos celulares"
        backgroundColor = UIColor.systemOrange
        animateIn()
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    private func animateIn() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}
