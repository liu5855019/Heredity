//
//  ViewController.swift
//  heredity
//
//  Created by iMac-03 on 2020/3/17.
//  Copyright © 2020 HBean. All rights reserved.
//

import Cocoa



import CoreGraphics
import CoreImage

class ViewController: NSViewController {

    lazy var heredity = Heredity();
    override func viewDidLoad() {
        super.viewDidLoad()

        var lastLikeCount = 0;
        heredity.runLoop { (datas, times) -> Bool in
            let bast = datas.first!;
            let bastLikeCount = Float(unitDNACount*2*unitDNACount);
            
            if isEqualCount {   // 按相同计算
                print("第\(times)代 , 相似度: \(bast.likeCount)  \(Float(bast.likeCount)/Float(unitDNACount))");
            } else {    // 按相似计算
                print("第\(times)代 , 相似度: \(bast.likeCount)  \((Float(bast.likeCount)-bastLikeCount*0.7)/(bastLikeCount*0.3))");
            }
            
            if lastLikeCount != bast.likeCount {
                lastLikeCount = bast.likeCount;
                self.writeToFile(times: times, model: bast);
            }
            
            if times >= 100000 {
                return false;
            } else {
                return true;
            }
        }
    }

    func writeToFile(times:Int , model:HeredityModel) {
        
        let offscreenRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                            pixelsWide: unitDNACount,
                                            pixelsHigh: unitDNACount,
                                            bitsPerSample: 8,
                                            samplesPerPixel: 4,
                                            hasAlpha: true,
                                            isPlanar: false,
                                            colorSpaceName: NSColorSpaceName.deviceRGB,
                                            bytesPerRow: 0,
                                            bitsPerPixel: 0);
        
        //设置屏幕上下文
        let context = NSGraphicsContext(bitmapImageRep: offscreenRep!);
        NSGraphicsContext.saveGraphicsState();
        NSGraphicsContext.current = context;
        
        //使用Core Graphics绘制
        let cgCtx = context?.cgContext;
        cgCtx?.beginPath();
        
        cgCtx?.setFillColor(CGColor.white);
        cgCtx?.fill(CGRect(x: 0, y: 0, width: unitDNACount, height: unitDNACount));
        
        if isDrawLine { // 画 线
            cgCtx?.move(to: NSPoint(x: model.models[0].x, y: model.models[0].y));
            cgCtx?.setLineWidth(1);
            cgCtx?.setStrokeColor(CGColor.black);
            for i in 1...model.models.count-1 {
                cgCtx?.addLine(to: NSPoint(x: model.models[i].x, y: model.models[i].y));
            }
            cgCtx?.strokePath();
        } else {    // 画 点
            cgCtx?.setFillColor(CGColor.black);
            for i in 1...model.models.count-1 {
                cgCtx?.fill(CGRect(x: model.models[i].x, y: model.models[i].y, width: 1, height: 1));
            }
        }

        
        //做绘图，所以设置当前上下文回到它是什么
        NSGraphicsContext.restoreGraphicsState();
        
        //创建一个NSImage并将其添加到它
//        let img = NSImage(size: NSSize(width: 100, height: 100));
//        nsImg!.addRepresentation(offscreenRep);
        

        let imgData = offscreenRep?.representation(using: .png, properties: [:]);
        
        do {
#warning("此处需要自己找个文件夹用来输出")
            try imgData?.write(to: URL(fileURLWithPath: "/Users/imac-03/Desktop/MacCode/heredity/images/\(times)_\(model.likeCount).png"));
        } catch {
            print(error);
        }
        
        print(model.desc());
    }
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

