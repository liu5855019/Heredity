//
//  Heredity.swift
//  heredity
//
//  Created by iMac-03 on 2020/3/17.
//  Copyright © 2020 HBean. All rights reserved.
//

import Cocoa

/// 种群最大数
let populationMaxCount = 100;
/// 种群被筛选后剩余最小数
let populationMinCount = 30;

/// 每个 unit 特征个数
let unitDNACount = 100;
/// 突变概率, 1 代表 1% , 即: 生成model会产生突变的概率;
let mutationRate = 60;

/// 算法按 相同 算还是 相似 算
let isEqualCount = true;

/// 输出结果是按 线 输出还是按 点 输出
let isDrawLine = false;


class Heredity: NSObject {

    let baseModel = HeredityModel(isBase: true);
    
    var datas = [HeredityModel]();
    var times = 0;
    
    override init() {
        for _ in 0...populationMaxCount-1 {
            let model = HeredityModel(isBase: false);
            model.makeLikeCount(base: baseModel);
            datas.append(model);
        }
    }
    
    
    func runLoop(block:(_ datas:[HeredityModel] , _ times:Int)->Bool) {
        var isGoOn = true;
        while isGoOn {
            makeChilds();
            sort();
            weedOut();
            times += 1;
            isGoOn = block(datas,times);
        }
    }
    
    // 按照 like值 ,从大到小排序
    func sort() {
        datas.sort { (model1, model2) -> Bool in
            return model1.likeCount >= model2.likeCount;
        }
    }
    
    // 淘汰一部分 , 剩余 modelLessCount 个
    func weedOut() {
        let datas1 = datas;
        
        datas.removeAll();
        
        for i in 0...populationMinCount-1 {
            datas.append(datas1[i]);
        }
    }
    
    // 繁衍生息
    func makeChilds() {
        while datas.count < populationMaxCount - 1 {
            birthChild();
        }
    }
    
    // 造人
    func birthChild() {
        let half = populationMinCount / 2;
        let mother = datas[Int(arc4random()) % half];           // 前半数组中取一个
        let father = datas[Int(arc4random()) % half + half];    // 后半数组中取一个
        
        let child = HeredityModel(father, mother);
        child.makeLikeCount(base: baseModel);
        datas.append(child);
    }
}
