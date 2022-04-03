//
//  SongExporter.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka on 6/29/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
//import AudioKit

class SongExporter {
    
    var exportPath: String = ""
    
    init(exportPath: String) {
        self.exportPath = exportPath
    }
    
    func exportSong(_ song: MPMediaItem) {
    
        let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
        let songAsset = AVURLAsset(url: url, options: nil)
        
        var assetError: NSError?
        
        do {
            let assetReader = try AVAssetReader(asset: songAsset)
            
            // Create an asset reader ouput and add it to the reader.
            let assetReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: songAsset.tracks,audioSettings: nil)
            
            if !assetReader.canAdd(assetReaderOutput) {
                print("Can't add reader output...die!")
            } else {
                assetReader.add(assetReaderOutput)
            }
            
            // If a file already exists at the export path, remove it.
            if FileManager.default.fileExists(atPath: exportPath) {
                print("Deleting said file.")
                do {
                    try FileManager.default.removeItem(atPath: exportPath)
                } catch _ {
                }
            }
            
            // Create an asset writer with the export path.
            let exportURL = URL(fileURLWithPath: exportPath)
            let assetWriter: AVAssetWriter!
            do {
                assetWriter = try AVAssetWriter(outputURL: exportURL, fileType: AVFileType.caf)
            } catch let error as NSError {
                assetError = error
                assetWriter = nil
            }
            
            if assetError != nil {
                print("Error \(String(describing: assetError))")
                return
            }
            
            // Define the format settings for the asset writer.  Defined in AVAudioSettings.h
            
            // memset(&channelLayout, 0, sizeof(AudioChannelLayout))
            let outputSettings = [ AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32),
                                   AVSampleRateKey: NSNumber(value: 44100.0 as Float),
                                   AVNumberOfChannelsKey: NSNumber(value: 2 as UInt32),
                                   AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
                                   AVLinearPCMIsNonInterleaved: NSNumber(value: false as Bool),
                                   AVLinearPCMIsFloatKey: NSNumber(value: false as Bool),
                                   AVLinearPCMIsBigEndianKey: NSNumber(value: false as Bool)
            ]
            
            // Create a writer input to encode and write samples in this format.
            let assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio,
                                                      outputSettings: outputSettings)
            
            // Add the input to the writer.
            if assetWriter.canAdd(assetWriterInput) {
                assetWriter.add(assetWriterInput)
            } else {
                print("cant add asset writer input...die!")
                return
            }
            
            // Change this property to YES if you want to start using the data immediately.
            assetWriterInput.expectsMediaDataInRealTime = false
            
            // Start reading from the reader and writing to the writer.
            assetWriter.startWriting()
            assetReader.startReading()
            
            // Set the session start time.
            let soundTrack = songAsset.tracks[0]
            let cmtStartTime: CMTime = CMTimeMake(value: 0, timescale: soundTrack.naturalTimeScale)
            assetWriter.startSession(atSourceTime: cmtStartTime)
            
            // Variable to store the converted bytes.
            var convertedByteCount: Int = 0
            var buffers: Float = 0
            
            // Create a queue to which the writing block with be submitted.
            let mediaInputQueue: DispatchQueue = DispatchQueue(label: "mediaInputQueue", attributes: [])
            
            // Instruct the writer input to invoke a block repeatedly, at its convenience, in
            // order to gather media data for writing to the output.
            assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue, using: {
                
                // While the writer input can accept more samples, keep appending its buffers
                // with buffers read from the reader output.
                while (assetWriterInput.isReadyForMoreMediaData) {
                    
                    if let nextBuffer = assetReaderOutput.copyNextSampleBuffer() {
                        assetWriterInput.append(nextBuffer)
                        // Increment byte count.
                        convertedByteCount += CMSampleBufferGetTotalSampleSize(nextBuffer)
                        buffers += 0.0002
                        
                    } else {
                        // All done
                        assetWriterInput.markAsFinished()
                        assetWriter.finishWriting(){
                            
                        }
                        assetReader.cancelReading()
                        break
                    }
                    // Core Foundation objects automatically memory managed in Swift
                    // CFRelease(nextBuffer)
                }
            })
            
        } catch let error as NSError {
            assetError = error
            print("Initializing assetReader Failed  \(error)")
        }
        
    }

    
    func exportSongWithURL(_ url:URL, completion: @escaping((URL) -> Void), failure: @escaping ((String) -> Void)) {
        
      
        
        let songAsset = AVURLAsset(url: url, options: nil)
        
        var assetError: NSError?
        
        do {
            let assetReader = try AVAssetReader(asset: songAsset)
            
            // Create an asset reader ouput and add it to the reader.
            let assetReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: songAsset.tracks,audioSettings: nil)
            
            if !assetReader.canAdd(assetReaderOutput) {
                print("Can't add reader output...die!")
            } else {
                assetReader.add(assetReaderOutput)
            }
            
            // If a file already exists at the export path, remove it.
            if FileManager.default.fileExists(atPath: exportPath) {
                print("Override file.")
                do {
                    try FileManager.default.removeItem(atPath: exportPath)
                } catch _ {
                }
            }
            
            // Create an asset writer with the export path.
            let exportURL = URL(fileURLWithPath: exportPath)
            print("export url\n",exportURL.path)
            let assetWriter: AVAssetWriter!
            do {
                assetWriter = try AVAssetWriter(outputURL: exportURL, fileType: AVFileType.m4a)
            } catch let error as NSError {
                assetError = error
                assetWriter = nil
            }
            
            if assetError != nil {
                print("Error \(String(describing: assetError))")
                failure(assetError?.localizedDescription ?? "")
                return
            }
            
            // Define the format settings for the asset writer.  Defined in AVAudioSettings.h
            /*
            @constant       kAudioFormatMPEG4AAC
            MPEG-4 Low Complexity AAC audio object, has no flags.
             */
            
            // memset(&channelLayout, 0, sizeof(AudioChannelLayout))
            let outputSettings = [ AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                   AVSampleRateKey: NSNumber(value: 44100.0 as Float),
                                   AVNumberOfChannelsKey: NSNumber(value: 1 as UInt32),
                                   
                                   
            ]
            
            // If one of AVLinearPCMIsFloatKey and AVLinearPCMBitDepthKey is specified, both must be specified'
            
            // Create a writer input to encode and write samples in this format.
            let assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio,
                                                      outputSettings: outputSettings)
            
            // Add the input to the writer.
            if assetWriter.canAdd(assetWriterInput) {
                assetWriter.add(assetWriterInput)
            } else {
                print("cant add asset writer input...die!")
                return
            }
            
            // Change this property to YES if you want to start using the data immediately.
            assetWriterInput.expectsMediaDataInRealTime = false
            
            // Start reading from the reader and writing to the writer.
            assetWriter.startWriting()
            assetReader.startReading()
            
            // Set the session start time.
            let soundTrack = songAsset.tracks[0]
            let cmtStartTime: CMTime = CMTimeMake(value: 0, timescale: soundTrack.naturalTimeScale)
            assetWriter.startSession(atSourceTime: cmtStartTime)
            
            // Variable to store the converted bytes.
            var convertedByteCount: Int = 0
            var buffers: Float = 0
            
            // Create a queue to which the writing block with be submitted.
            let mediaInputQueue: DispatchQueue = DispatchQueue(label: "mediaInputQueue", attributes: [])
            
            // Instruct the writer input to invoke a block repeatedly, at its convenience, in
            // order to gather media data for writing to the output.
            assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue, using: {
                
                // While the writer input can accept more samples, keep appending its buffers
                // with buffers read from the reader output.
                while (assetWriterInput.isReadyForMoreMediaData) {
                    
                    if let nextBuffer = assetReaderOutput.copyNextSampleBuffer() {
                        assetWriterInput.append(nextBuffer)
                        // Increment byte count.
                        convertedByteCount += CMSampleBufferGetTotalSampleSize(nextBuffer)
                        buffers += 0.0002
                        
                    } else {
                        // All done
                        assetWriterInput.markAsFinished()
                        assetWriter.finishWriting(){
                            completion(exportURL)
                        }
                        assetReader.cancelReading()
                        
                        break
                    }
                    // Core Foundation objects automatically memory managed in Swift
                    // CFRelease(nextBuffer)
                }
            })
            
        } catch let error as NSError {
            assetError = error
            print("Initializing assetReader Failed: \(error)")
            failure(error.localizedDescription)
        }
        
    }
    
    class func convertAudio(_ url: URL, outputURL: URL) {
        var error : OSStatus = noErr
        var destinationFile : ExtAudioFileRef? = nil
        var sourceFile : ExtAudioFileRef? = nil
        
        var srcFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        var dstFormat : AudioStreamBasicDescription = AudioStreamBasicDescription()
        
        ExtAudioFileOpenURL(url as CFURL, &sourceFile)
        
        var thePropertySize: UInt32 = UInt32(MemoryLayout.stride(ofValue: srcFormat))
        
        ExtAudioFileGetProperty(sourceFile!,
                                kExtAudioFileProperty_FileDataFormat,
                                &thePropertySize, &srcFormat)
        
        dstFormat.mSampleRate = 44100  //Set sample rate
        dstFormat.mFormatID = kAudioFormatLinearPCM
        dstFormat.mChannelsPerFrame = 1
        dstFormat.mBitsPerChannel = 16
        dstFormat.mBytesPerPacket = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mBytesPerFrame = 2 * dstFormat.mChannelsPerFrame
        dstFormat.mFramesPerPacket = 1
        dstFormat.mFormatFlags = kAudioFormatFlagIsBigEndian |
        kAudioFormatFlagIsSignedInteger
        
        // Create destination file
        error = ExtAudioFileCreateWithURL(
            outputURL as CFURL,
            kAudioFileM4AType,
            &dstFormat,
            nil,
            AudioFileFlags.eraseFile.rawValue,
            &destinationFile)
        reportError(error: error)
        
        error = ExtAudioFileSetProperty(sourceFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        reportError(error: error)
        
        error = ExtAudioFileSetProperty(destinationFile!,
                                        kExtAudioFileProperty_ClientDataFormat,
                                        thePropertySize,
                                        &dstFormat)
        reportError(error: error)
        
        let bufferByteSize : UInt32 = 32768
        var srcBuffer = [UInt8](repeating: 0, count: 32768)
        var sourceFrameOffset : ULONG = 0
        
        while(true){
            var fillBufList = AudioBufferList(
                mNumberBuffers: 1,
                mBuffers: AudioBuffer(
                    mNumberChannels: 2,
                    mDataByteSize: UInt32(srcBuffer.count),
                    mData: &srcBuffer
                )
            )
            var numFrames : UInt32 = 0
            
            if(dstFormat.mBytesPerFrame > 0){
                numFrames = bufferByteSize / dstFormat.mBytesPerFrame
            }
            
            error = ExtAudioFileRead(sourceFile!, &numFrames, &fillBufList)
            reportError(error: error)
            
            if(numFrames == 0){
                error = noErr;
                break;
            }
            
            sourceFrameOffset += numFrames
            error = ExtAudioFileWrite(destinationFile!, numFrames, &fillBufList)
            reportError(error: error)
        }
        
        error = ExtAudioFileDispose(destinationFile!)
        reportError(error: error)
        error = ExtAudioFileDispose(sourceFile!)
        reportError(error: error)
    }
    
    class func reportError(error: OSStatus) {
        // Handle error
        print("error: \(error)")
    }

}

/*
//MARK: - For Testing

extension PrepareVC {
    
    var songName = ""
    
    func mergerAudioWithVideo(){
        
        let audioUrl = Utility.getDocumentsDirectory().appendingPathComponent("co_em_cho_mer.m4a")
        
        let videoUrl = Utility.getDocumentsDirectory().appendingPathComponent("co_em_cho_1499762749_record.m4v")
        
        mergeMutableVideoWithAudio(videoUrl: videoUrl as NSURL, audioUrl: audioUrl as NSURL)
        
        
    }
    
    
    
    func expandFile(){
        
        
        let audioFile = try? AKAudioFile(readFileName: "\(self.songName)_record0.m4a", baseDir: .documents)
        
        
        let audioFile1 = try? AKAudioFile(readFileName: "\(self.songName)_record1.m4a",
            baseDir: .documents)
        
        do{
            let _ =  try audioFile?.appendedBy(file: audioFile1!,
                                               baseDir: .documents,
                                               name: "\(self.songName)_record")
        }catch{
            print("error \(error.localizedDescription)")
        }
        
        
        
    }
    
    
    func testMergeAudio(){
        
        let file = ["sau_tat_ca.mp3", "sau_tat_ca_1501122961_record.m4a"]
        mergeAudioFiles(file: file, outPut: "test_1501122961_record.m4a");
        
    }
    
    func mergeAudioFiles(file:[String], outPut:String) {
        
        //        let audioFileUrls:NSArray = nil
        
        
        let composition = AVMutableComposition()
        
        for i in 0 ..< file.count {
            
            let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            
            
            let audioUrl = Utility.getDocumentsDirectory().appendingPathComponent("\(file[i])").path
            print("merger url \(audioUrl)")
            
            let asset = AVURLAsset(url: URL(fileURLWithPath: audioUrl))
            
            let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
            
            let timeRange = CMTimeRange(start: CMTimeMake(0, 600), duration: track.timeRange.duration)
            let start = CMTimeMake(0, 600)
            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: start)
        }
        
        
        let mergeAudioURL = Utility.getDocumentsDirectory().appendingPathComponent(outPut) as NSURL
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = mergeAudioURL as URL
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: assetExport?.error))")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: assetExport?.error))")
                default:
                    print("Audio Concatenation Complete")
                    DispatchQueue.main.async {
                        
                        //                        let file = [outPut,"xuan_nay_con_khong_ve_1499913978_record.m4a"]
                        //                        self.mergeAudioFiles(file: file, outPut: "test2.m4a");
                        
                    }
                }
        })
    }
    
    
    func play2File(){
        
        AudioKit.stop()
        
        let audioFile = try? AKAudioFile(readFileName: "\(songName).mp3",
            baseDir: .resources)
        
        audioFilePlayer = try? AKAudioPlayer(file: audioFile!)
        
        let audioFile2 = try? AKAudioFile(readFileName: "\(songName)_record.m4a",
            baseDir: .documents)
        
        audioFilePlayer2 = try? AKAudioPlayer(file: audioFile2!)
        audioFilePlayer2?.volume = 5
        
        let mixer = AKMixer(audioFilePlayer, audioFilePlayer2)
        
        AudioKit.output = mixer
        AudioKit.start()
        
        audioFilePlayer2?.play()
        audioFilePlayer?.play()
        
        
    }
    
    
    func mergeMutableVideoWithAudio(videoUrl:NSURL, audioUrl:NSURL){
        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        //start merge
        let aVideoAsset : AVAsset = AVAsset(url: videoUrl as URL)
        let aAudioAsset : AVAsset = AVAsset(url: audioUrl as URL)
        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        mutableCompositionAudioTrack.append( mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        let aVideoAssetTrack : AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioAssetTrack : AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        do{
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: kCMTimeZero)
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: kCMTimeZero)
        }catch{
            
        }
        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,aVideoAssetTrack.timeRange.duration )
        let mutableVideoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(1, 30)
        mutableVideoComposition.renderSize = CGSize(width: 1280, height: 720)
        let mergedAudioVideoURl = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo.mp4")
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = mergedAudioVideoURl as URL
        removeFileAtURLIfExists(url: mergedAudioVideoURl)
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                print("-----Merge mutable video with trimmed audio exportation complete.\(mergedAudioVideoURl)")
            case  AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport.error))")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
            default:
                print("complete")
            }
        }
    }
    
    func removeFileAtURLIfExists(url: NSURL) {
        if let filePath = url.path {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                do{
                    try fileManager.removeItem(atPath: filePath)
                } catch let error as NSError {
                    print("-----Couldn't remove existing destination file: \(error)")
                }
            }
        }
    }
    
}
*/
