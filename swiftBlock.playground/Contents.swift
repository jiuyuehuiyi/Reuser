//: Playground - noun: a place where people can play

import UIKit

//无参无返回值
typealias funcBlock = () -> () //或者 () -> Void
//返回值是String
typealias funcBlockA = (Int,Int) -> String
//返回值是一个函数指针，入参为String
typealias funcBlockB = (Int,Int) -> (String)->()
//返回值是一个函数指针，入参为String 返回值也是String
typealias funcBlockC = (Int,Int) -> (String)->String

class blockDemo
{
    //block作为属性变量
    var blockProperty : (Int,Int) -> String = {a,b in return ""/**/} // 带初始化方式
    var blockPropertyNoReturn : (String) -> () = {param in }
    
    var blockPropertyA : funcBlockA?  //这写法就可以初始时为nil了,因为生命周其中，(理想状态)可能为nil所以用?
    var blockPropertyB : funcBlockB!  //这写法也可以初始时为nil了,因为生命周其中，(理想状态)认为不可能为nil,所以用!
    var blockP : () -> () = {}
    
    init()
    {
        print("blockPropertyA = \(blockPropertyA) , blockPropertyB = \(blockPropertyB)")
        print("blockProperty = \(blockProperty) , blockPropertyNoReturn = \(blockPropertyNoReturn)")
    }
    
    func testProperty(tag:Int)
    {
        switch (tag)
        {
        case 1:
            self.blockPropertyNoReturn("OK GOOD")
        case 2:
            if let exsistBlock = self.blockPropertyA
            {
                let result = self.blockPropertyA!(7,8)
                print("result = \(result)")
            }
        case 3:
            if let exsistBlock = self.blockPropertyB
            {
                let fc = self.blockPropertyB(1,2)
                fc("输出")
            }
        default:
            let ret = self.blockProperty(3,4)
            print(ret)
        }
    }
    
    
    //block作为函数参数
    func testBlock(blockfunc:funcBlock!)//使用!号不需要再解包
    {
        if let exsistblock = blockfunc
        {
            blockfunc() //无参无返回
        }
    }
    
    func testBlockA(blockfunc:funcBlockA!)
    {
        if let exsistblock = blockfunc
        {
            let retstr = blockfunc(5,6)
            print(retstr)
        }
    }
    
    func testBlockB(blockfunc:funcBlockB!)
    {
        if let exsistblock = blockfunc
        {
            let retfunc = blockfunc(5,6)
            retfunc("结果是")
        }
    }
    
    func testBlockC(blockfunc:funcBlockC!)
    {
        if let exsistblock = blockfunc
        {
            let retfunc = blockfunc(5,6)
            let str = retfunc("最终果结是")
            print(str)
        }
    }
}



var bk = blockDemo()
//block设置前,啥也没有输出
bk.testProperty(0)
bk.testProperty(1)
bk.testProperty(2)
bk.testProperty(3)
print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝设置block属性＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")


bk.blockP = {
    () -> () in
    NSLog("ffffff")
}

bk.blockProperty = {
    (a :Int,b:Int) -> String in
    let c = a*100+b
    return "\(a)*100+\(b) = \(c)"
}
bk.testProperty(0)

bk.blockPropertyNoReturn = {
    (param:String) -> () in
    print("input param value is : \(param)")
}
bk.testProperty(1)

bk.blockPropertyA = {
    (a:Int,b:Int) -> String in
    let c = a*100+b*200
    return "\(a)*100+\(b)*200 = \(c)"
}
bk.testProperty(2)

bk.blockPropertyB = {
    (a:Int,b:Int) -> (String)->() in
    func sumprint(result:String)
    {
        let c = a + b;
        print("sumprint func print:parame :\(result) \(a) + \(b) = \(c)")
    }
    
    return sumprint
}
bk.testProperty(3)
print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝属性block完成＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")

print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block为nil时无输出＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
bk.testBlock(nil)
bk.testBlockA(nil)
bk.testBlockB(nil)
bk.testBlockC(nil)
print("＝＝＝＝＝＝＝＝＝＝＝＝＝＝函数block操作＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
bk.testBlock({
    //do something
    print("无参无返回值block 执行")
})

bk.testBlockA({
    (a:Int,b:Int) -> String in
    let c = a*400+b*1000
    return "\(a)*400 + \(b)*1000 is \(c)"
})

bk.testBlockB({
    (a:Int,b:Int) -> (String)->() in
    func sumprint(result:String)
    {
        let c = a / b;
        print("sumprint func print:parame :\(result) \(a) / \(b) = \(c)")
    }
    
    return sumprint
})

bk.testBlockC({
    (a:Int,b:Int) -> (String)->String in
    func sumrsult(res:String) -> String
    {
        let c = a*a+b*a
        return "\(res) \(a)*\(a)+\(b)*\(a) = \(c)"
    }
    return sumrsult
})







