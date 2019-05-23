# unlock
手势和指纹解锁

模拟手势解锁和指纹解锁。(说明：1.手势解锁颜色取的QQ安全中心颜色。2.本demo只是简单实现了手势解锁，设置错误次数以及保存手势密码方式等逻辑后续会慢慢添加)

1.第一次下载需要登录，登录只要保证用户名和密码输入框不为空即可。

2.登录成功后直接跳转解锁页面，有两个选择，如果未设置过手势，则是“设置手势”和“指纹解锁”，否则为“手势解锁”和“指纹解锁”。

3.
3-1.点击“设置手势”：进入设置手势页面，设置你的手势，点击“确定”设置成功（手势密码不得少于4个点），进入“选择解锁方式”页面，可验证是否成功。

3-2.重新进入应用，点击“手势解锁”：输入您上次的手势密码可解锁，进入home页面，如果输入错误会给出提示，然后返回手势页面。

3-3.点击“指纹解锁”：第一次会提醒你是否开启指纹解锁，如果点“NO”，进入home页面，下次进入会继续提醒，如果点击“YES”，进入home页面，下次重新进入应用直接验证指纹。

4.首页可重置手势密码，点击“重置手势密码”，跳转“手势设置页面”，重新设置手势密码，设置成功，进入“选择解锁方式”页面，可验证是否成功。

5.忘记手势密码：点击“忘记手势密码”，跳转“手势设置页面”，重新设置手势密码，设置成功，进入“选择解锁方式”页面，可验证是否成功。

![image](https://yx29.oss-cn-beijing.aliyuncs.com/unlock11.png)       ![image](https://yx29.oss-cn-beijing.aliyuncs.com/unlock22.png?Expires=1550480538&OSSAccessKeyId=TMP.AQHpaxJCB8wK6ESawGyicgp__RWlSvbYVFCwfLTvYjOfvYXObErzY4WWwMjeAAAwLAIUFbgS1PIUCvdHTiKE-3nckPQZVAQCFBg3hShd5QrY-1MpJSGQbfVyhRrg&Signature=33KRYuAz6XXLlhKbheRBu3kB9oQ%3D)
![image](https://yx29.oss-cn-beijing.aliyuncs.com/unlock33.png)       ![image](https://yx29.oss-cn-beijing.aliyuncs.com/unlock44.png?Expires=1550480552&OSSAccessKeyId=TMP.AQHpaxJCB8wK6ESawGyicgp__RWlSvbYVFCwfLTvYjOfvYXObErzY4WWwMjeAAAwLAIUFbgS1PIUCvdHTiKE-3nckPQZVAQCFBg3hShd5QrY-1MpJSGQbfVyhRrg&Signature=BaHq1njOLVn%2F93iKMUiAFuKgd7g%3D)
