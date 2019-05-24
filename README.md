# unlock
手势和指纹解锁

模拟手势解锁和指纹解锁。(说明：1.手势解锁颜色取的QQ安全中心颜色。)

**导入方法：**

1. 通过cocoapods导入

> 在Podfile中添加`pod 'YZXUnlock'`。

2. 下载`zip`将工程中的`YZXGesturesUnlock`文件夹拖入工程。

**使用方法：**
1. 通过`initWithFrame`方法初始化`YZXGesturesView`初始化界面。
2. 设置`YZXGesturesView`的block`gestureBlock`，`unlockBlock`，`settingBlock`。

    > 1. **gestureBlock:**设置成功的block，返回设置的手势密码。 
    > 2. **unlockBlock:**返回设置结果（成功或者失败），用于自己处理成功或者失败的其他操作。
    > 3. **settingBlock：**设置的密码少于4为的时候调用。
    
3. 设置`手势密码`，点击确认的时候，调用`YZXKeychain`的`yzx_savePassword:service:account:`方法，将`YZXGesturesView`的`gestureBlock`返回的密码保存到`keychain`中。

效果图展示：
![image](https://yx29.oss-cn-beijing.aliyuncs.com/%E6%89%8B%E5%8A%BF%E8%A7%A3%E9%94%81.png)