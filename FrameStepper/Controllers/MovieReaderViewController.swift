//
//  MovieReaderViewController.swift
//  FrameStepper
//
//  Created by Kazuya Shida on 2017/10/31.
//  Copyright © 2017 mani3. All rights reserved.
//

import UIKit

class MovieReaderViewController: UIViewController {

    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = self.url {
            loadFile(url: url)
        } else {
            dismiss(animated: true) {}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadFile(url: URL) {
        var formatContext: UnsafeMutablePointer<AVFormatContext>?
        av_register_all()

        if avformat_open_input(&formatContext, url.absoluteString.urlDecode, nil, nil) != 0 {
            NSLog("Cloud not open file: %@", url.absoluteString.urlDecode)
            return
        }

        var tag: UnsafeMutablePointer<AVDictionaryEntry>! = av_dict_get(formatContext!.pointee.metadata, "", nil, AV_DICT_IGNORE_SUFFIX)
        while tag != nil {
            let key = String(cString: tag.pointee.key)
            let value = String(cString: tag.pointee.value)
            NSLog("%@=%@", key, value)
            tag = av_dict_get(formatContext!.pointee.metadata, "", tag, AV_DICT_IGNORE_SUFFIX)
        }
        guard var fmt_ctx = formatContext?.pointee else {
            NSLog("AVFormatContext is null")
            return
        }

        let filename: String = withUnsafePointer(to: &fmt_ctx.filename) { (filenamePtr) in
            return UnsafePointer(filenamePtr).withMemoryRebound(to: CChar.self, capacity: 1, { (charPtr) -> String in
                String(cString: charPtr)
            })
        }
        NSLog("filename: %@", filename)
        NSLog("nb_streams: %d", fmt_ctx.nb_streams)
        NSLog("nb_programs: %d", fmt_ctx.nb_programs)
        let formatName: String = fmt_ctx.iformat.pointee.name.withMemoryRebound(to: CChar.self, capacity: 1) { (charPtr) in String(cString: charPtr) }
        NSLog("format_name: %d", formatName)
        let longName: String = fmt_ctx.iformat.pointee.long_name == nil ? "unknown" : fmt_ctx.iformat.pointee.long_name.withMemoryRebound(to: CChar.self, capacity: 1) { (charPtr) in String(cString: charPtr) }
        NSLog("format_long_name: %d", longName)
        NSLog("start_time: %d", fmt_ctx.start_time)
        NSLog("duration: %d", fmt_ctx.duration)
        let size = fmt_ctx.pb != nil ? avio_size(fmt_ctx.pb) : -1
        NSLog("size: %d", size)
        NSLog("bit_rate: %d", fmt_ctx.bit_rate)
        NSLog("probe_score: %d", fmt_ctx.probe_score)

        for i in 0..<fmt_ctx.nb_streams {
            if fmt_ctx.streams[Int(i)]?.pointee.codecpar.pointee.codec_type == AVMEDIA_TYPE_VIDEO {
            }
            let stream = fmt_ctx.streams[Int(i)]!.pointee
            let fps = av_q2d(stream.r_frame_rate)
            NSLog("FPS (r_fream_rate): %f", fps)
            let fps2 = av_q2d(stream.avg_frame_rate)
            NSLog("FPS (avg_fream_rate): %f", fps2)
            let ratio = av_q2d(stream.display_aspect_ratio)
            NSLog("Aspect ratio: %f", ratio)
            NSLog("Duration: %d, Codec Info Frames: %d, Frames: %d", stream.duration, stream.codec_info_nb_frames, stream.nb_frames)
            let codec = stream.codecpar.pointee
            NSLog("Bit rate: %d, Aspect Ratio: %f", codec.bit_rate, av_q2d(codec.sample_aspect_ratio))
        }

        let ret = avformat_find_stream_info(formatContext, nil)
        NSLog("ret=%@", ret)
        avformat_close_input(&formatContext)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
