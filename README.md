# QYXPageVCDemo
多视图控制器+内存优化

注:关于缓存这一块demo里直接用了字典，比较好的方式是仿照NSCache在字典的基础之上自定义一个缓存的类，之所以不用NSCache是因为封装程度太高可自定义的部分太少，内部处理机制不明确（进入后台NSCache自动清除所有数据）,很多地方不能满足需要。
    这里建议根据自己的情况自定义