/*
See LICENSE folder for this sample’s licensing information.

Abstract:
ContextMenu object this sample uses to build each context menu.
*/

import UIKit

protocol ContextMenu {
    
    // Adopters of this protocol implement the actual actions.
    func performInspect()
    func performDuplicate()
    func performDelete()
}

extension ContextMenu {
    
    
    
    func renameAction() -> UIAction {
        return UIAction(title: "Rename",
                        image: UIImage(systemName: "arrow.up.square")) { action in
           self.performInspect()
        }
    }
        
    func inspectAction() -> UIAction {
        return UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                        image: UIImage(systemName: "arrow.up.square")) { action in
           self.performInspect()
        }
    }
        
    func duplicateAction() -> UIAction {
        return UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                        image: UIImage(systemName: "plus.square.on.square")) { action in
           self.performDuplicate()
        }
    }
        
    func deleteAction() -> UIAction {
        return UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { action in
           self.performDelete()
        }
    }

}

// MARK: - IndexPathContextMenu
//@objc protocol IndexPathContextMenu {
//
//    // Adopters of this protocol implement the actual actions.
//    @objc optional func performDeleteFolder(_ indexPath: IndexPath)
//    @objc optional func performRename(_ indexPath: IndexPath)
//    @objc optional func performInspect(_ indexPath: IndexPath)
//    @objc optional func performDuplicate(_ indexPath: IndexPath)
//    @objc optional func performDelete(_ indexPath: IndexPath)
//    @objc optional func performShare(_ indexPath: IndexPath)
//}

protocol IndexPathContextMenu {
    
    // Adopters of this protocol implement the actual actions.
    func deleteFolderPerform(_ indexPath: IndexPath)
    func renameActionPerform(_ indexPath: IndexPath)
    func shareActionPerform(_ indexPath: IndexPath)
    func editActionPerform(_ indexPath: IndexPath)
    func deleteAcionPerform(_ indexPath: IndexPath)
    func starActionPerform(_ indexPath: IndexPath)
    func duplicateActionPerform(_ indexPath: IndexPath)
    func saveToCameraActionPerform(_ indexPath: IndexPath)
    func moveToTrashActionPerform(_ indexPath: IndexPath)
}

extension IndexPathContextMenu {
    
    func startAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.QuickAction.star",
                        image: UIImage(systemName: "star")) { action in
            self.starActionPerform(indexPath)
        }
    }
    
    func duplicateAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.QuickAction.duplicate",
                        image: UIImage(systemName: "doc.on.doc.fill")) { action in
            self.duplicateActionPerform(indexPath)
        }
    }
    
    func moveToTrashAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.QuickAction.moveToTrash",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { action in
            self.moveToTrashActionPerform(indexPath)
        }
    }
    
    func saveToAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.QuickAction.savetoCamera",
                        image: UIImage(systemName: "square.and.arrow.down")) { action in
            self.saveToCameraActionPerform(indexPath)
        }
    }
    
    func editAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.QuickAction.edit",
                        image: UIImage(systemName: "pencil"),
                        attributes: .hidden) { action in
            self.editActionPerform(indexPath)
        }
    }
    
    func deleteFolderAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.Home.deleteFolder",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { action in
            self.deleteFolderPerform(indexPath)
        }
    }
    
    func renameAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "L10n.Home.rename",
                        image: UIImage(systemName: "pencil")) { action in
            self.renameActionPerform(indexPath)
        }
    }
    
    func shareAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "Share",
                        image: UIImage(systemName: "square.and.arrow.up")) { action in
            self.shareActionPerform(indexPath)
        }
    }
        
    func deleteAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { action in
            self.deleteAcionPerform(indexPath)
        }
    }

}

// MARK: - WebViewContextMenu

protocol WebViewContextMenu {
    
    // Adopters of this protocol implement the actual actions.
    func performExtra(_ url: URL)
}

extension WebViewContextMenu {
    
    func extraAction(_ url: URL) -> UIAction {
        let imageIcon = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        return UIAction(title: NSLocalizedString("ExtraTitle", comment: ""),
                        image: imageIcon) { action in
           self.performExtra(url)
        }
    }

}

