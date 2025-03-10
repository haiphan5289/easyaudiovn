// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let icAddMusic = ImageAsset(name: "ic_add_music")
  internal static let icAnimateVideo = ImageAsset(name: "ic_animate_video")
  internal static let icMerge = ImageAsset(name: "ic_merge")
  internal static let icMute = ImageAsset(name: "ic_mute")
  internal static let icRec = ImageAsset(name: "ic_rec")
  internal static let icWifi = ImageAsset(name: "ic_wifi")
  internal static let icAudioNew = ImageAsset(name: "ic_audio_new")
  internal static let icIcloud = ImageAsset(name: "ic_icloud")
  internal static let icBack = ImageAsset(name: "ic_back")
  internal static let icClose = ImageAsset(name: "ic_close")
  internal static let icEmptyView = ImageAsset(name: "ic_emptyView")
  internal static let icSplit = ImageAsset(name: "ic_split")
  internal static let appColor = ColorAsset(name: "AppColor")
  internal static let color292929 = ColorAsset(name: "Color292929")
  internal static let textColorEffect = ColorAsset(name: "TextColorEffect")
  internal static let blackOpacity60 = ColorAsset(name: "blackOpacity60")
  internal static let blue1553FF = ColorAsset(name: "blue1553FF")
  internal static let blue41C5FF = ColorAsset(name: "blue41C5FF")
  internal static let lineColor = ColorAsset(name: "lineColor")
  internal static let icArrowWhite = ImageAsset(name: "ic_arrow_white")
  internal static let icBackBlack = ImageAsset(name: "ic_back_black")
  internal static let icCheck = ImageAsset(name: "ic_check")
  internal static let icClose16 = ImageAsset(name: "ic_close16")
  internal static let icFavourite = ImageAsset(name: "ic_favourite")
  internal static let icFilter = ImageAsset(name: "ic_filter")
  internal static let icImport = ImageAsset(name: "ic_import")
  internal static let icPlacdeHolder = ImageAsset(name: "ic_placdeHolder")
  internal static let icSortAscending = ImageAsset(name: "ic_sort_ascending")
  internal static let icSortDescending = ImageAsset(name: "ic_sort_descending")
  internal static let icUncheck = ImageAsset(name: "ic_uncheck")
  internal static let icHandlingCopy = ImageAsset(name: "ic_handling_copy")
  internal static let icHandlingRedo = ImageAsset(name: "ic_handling_redo")
  internal static let icHandlingSpeed = ImageAsset(name: "ic_handling_speed")
  internal static let icHandlingStatusUp = ImageAsset(name: "ic_handling_statusUp")
  internal static let icHandlingTextBlock = ImageAsset(name: "ic_handling_textBlock")
  internal static let icHandlingTrash = ImageAsset(name: "ic_handling_trash")
  internal static let icHandlingUndo = ImageAsset(name: "ic_handling_undo")
  internal static let icHandlingVolumeHigh = ImageAsset(name: "ic_handling_volumeHigh")
  internal static let icHandlingVolumeMute = ImageAsset(name: "ic_handling_volumeMute")
  internal static let icMaCache = ImageAsset(name: "ic_ma_cache")
  internal static let icMaEditVideo = ImageAsset(name: "ic_ma_edit_video")
  internal static let icMaFiles = ImageAsset(name: "ic_ma_files")
  internal static let icMaMerge = ImageAsset(name: "ic_ma_merge")
  internal static let icMaMix = ImageAsset(name: "ic_ma_mix")
  internal static let icMaMusic = ImageAsset(name: "ic_ma_music")
  internal static let icMaMute = ImageAsset(name: "ic_ma_mute")
  internal static let icMaRec = ImageAsset(name: "ic_ma_rec")
  internal static let icMaSleep = ImageAsset(name: "ic_ma_sleep")
  internal static let icMaWifi = ImageAsset(name: "ic_ma_wifi")
  internal static let icPause = ImageAsset(name: "ic_pause")
  internal static let icPlay = ImageAsset(name: "ic_play")
  internal static let icStop = ImageAsset(name: "ic_stop")
  internal static let icAboutMe = ImageAsset(name: "ic_about_me")
  internal static let icPrivacy = ImageAsset(name: "ic_privacy")
  internal static let icTerm = ImageAsset(name: "ic_term")
  internal static let icVersion = ImageAsset(name: "ic_version")
  internal static let icAllFiles = ImageAsset(name: "ic_all_files")
  internal static let icAudio = ImageAsset(name: "ic_audio")
  internal static let icSettings = ImageAsset(name: "ic_settings")
  internal static let icVideo = ImageAsset(name: "ic_video")
  internal static let icWorking = ImageAsset(name: "ic_working")
  internal static let icPhotoLibrary = ImageAsset(name: "ic_photo_library")
  internal static let icViideo = ImageAsset(name: "ic_viideo")
  internal static let imgPlacephoto = ImageAsset(name: "img_placephoto")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
