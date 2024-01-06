//
//  TitleAudioEffectCell.swift
//  EasyAudio
//
//  Created by haiphan on 02/05/2023.
//

import UIKit

class TitleAudioEffectCell: UITableViewCell {

    private let headerView: VolumeTitleView = .loadXib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
