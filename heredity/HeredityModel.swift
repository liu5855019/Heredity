//
//  HeredityModel.swift
//  heredity
//
//  Created by iMac-03 on 2020/3/17.
//  Copyright © 2020 HBean. All rights reserved.
//

import Cocoa


class HeredityModel: NSObject {
    
    var models = [HereditySubModel]();
    
    var likeCount = 0;  // 与基础数据对比,相同的个数
    
    init(isBase:Bool) {
        if isBase {
            for i in 0...unitDNACount-1 {
                models.append(HereditySubModel(i,i));
            }
        } else {
            for _ in 0...unitDNACount-1 {
                models.append(HereditySubModel());
            }
        }
    }
    
    init(_ model1:HeredityModel ,_ model2:HeredityModel) {
        let isMutation = arc4random() % 100 < mutationRate; //是否进行突变
        let index = isMutation ? Int(arc4random()) % unitDNACount : -1;   // 突变位置
        
        for i in 0...unitDNACount-1 {
            if i == index { // 突变
                models.append(HereditySubModel());
            } else { // 正常遗传
                let random = arc4random() % 2;
                let model = random == 1 ? model2 : model1;
                
                models.append(model.models[i]);
            }
        }
    }
    
    func makeLikeCount(base:HeredityModel) {
        likeCount = 0;
        for i in 0...unitDNACount-1 {
            if isEqualCount {   // 按基因相同计算
                if (self.models[i].x == base.models[i].x &&
                    self.models[i].y == base.models[i].y) {
                    likeCount += 1;
                }
            } else {    // 按基因相似计算
                likeCount += unitDNACount - abs(self.models[i].x - base.models[i].x);
                likeCount += unitDNACount - abs(self.models[i].y - base.models[i].y);
            }
        }
    }
    
    func desc() -> String {
        var str = String();

        for item in self.models {
            str.append("\(item.x):\(item.y) ");
        }

        return str;
    }

}


class HereditySubModel: NSObject {
    var x:Int = 0;
    var y:Int = 0;
    
    init(_ x:Int , _ y:Int) {
        self.x = x;
        self.y = y;
    }
    
    override init() {
        x = Int(arc4random()) % unitDNACount;
        y = Int(arc4random()) % unitDNACount;
    }
}
