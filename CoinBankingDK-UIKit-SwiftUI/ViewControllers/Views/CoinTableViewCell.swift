//
//  CoinTableViewCell.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

// Views/CoinTableViewCell.swift
import UIKit
import SwiftUI

class CoinTableViewCell: UITableViewCell {
    
    private var hostingController: UIHostingController<CoinRowView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with coin: Coin) {
        // Clean up previous SwiftUI view if it exists
        hostingController?.view.removeFromSuperview()
        hostingController = nil
        
        // Create a new SwiftUI view and embed it
        let coinRowView = CoinRowView(coin: coin)
        hostingController = UIHostingController(rootView: coinRowView)
        
        if let hostingView = hostingController?.view {
            hostingView.backgroundColor = .clear
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(hostingView)
            
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clean up SwiftUI view
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
