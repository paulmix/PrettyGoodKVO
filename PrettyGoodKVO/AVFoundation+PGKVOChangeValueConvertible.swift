//
//  PGKVOValueConvertible.swift
//  PrettyGoodKVO
//
//  Created by Jed Lewison on 2/7/16.
//  Copyright © 2016 Magic App Factory. All rights reserved.
//

import AVFoundation

extension CMTime: PGKVOChangeNSValueConvertible {
    public init?(changeValue: NSValue) {
        self = changeValue.CMTimeValue
    }
}

extension CMTimeRange: PGKVOChangeNSValueConvertible {
    public init?(changeValue: NSValue) {
        self = changeValue.CMTimeRangeValue
    }
}

extension CMTimeMapping: PGKVOChangeNSValueConvertible {
    public init?(changeValue: NSValue) {
        self = changeValue.CMTimeMappingValue
    }
}

extension AVCaptureTorchMode: PGKVOChangeValueConvertible { }
extension AVAssetExportSessionStatus: PGKVOChangeValueConvertible { }
extension AVQueuedSampleBufferRenderingStatus: PGKVOChangeValueConvertible { }
extension AVPlayerStatus: PGKVOChangeValueConvertible { }
extension AVPlayerItemStatus: PGKVOChangeValueConvertible { }
extension AVCaptureFocusMode: PGKVOChangeValueConvertible { }
extension AVCaptureExposureMode: PGKVOChangeValueConvertible { }
extension AVCaptureWhiteBalanceMode: PGKVOChangeValueConvertible { }
extension AVCaptureFlashMode: PGKVOChangeValueConvertible { }
extension AVCaptureDevicePosition: PGKVOChangeValueConvertible { }
extension AVAssetWriterStatus: PGKVOChangeValueConvertible { }

// PEM - removed "to-do" to supress build warnings
// to-do: extension AVCaptureWhiteBalanceGains: PGKVOChangeValueConvertible { }
