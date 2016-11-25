
**目录**

* [0 简介](#brief)
* [1 系统版本](#version)
* [2 实现过程](#process)
	* [1 备份](#backup)
	* [2 Manifest.db](#Manifest.db)
	* [3 WCDB_Contact.sqlite](#WCDB)
	* [4 MM.sqlite](#MM.sqlite)
	* [4 导出](#output)
* [3 待完善](#todo)
* [4 Reference](#reference)


0 简介<a name="brief"></a>
====


想把微信聊天记录导出来，没找个太顺手的，我的手机也没有越狱，作为一个有追求的程序员，自己就瞎捣鼓了一个，简单的demo，木有UI，实现功能而已，导出都是Hard Code，反正我就想导出一个人的聊天记录。
源码奉上。 [source](https://github.com/toolazytoname/WeChatExport)


1 系统版本<a name="version"></a>
====

都是此刻2016年11月25日能获取的最新版本

    1. iTunes 12.5.3.7
    2. iOS 10.1.1 未越狱
    3. WeChat 6.3.31
    4. Mac 10.12.1 

 
# 2 实现过程<a name="process"></a>
====

## 1 备份<a name="backup"></a>
	
在iTunes中执行备份操作，不要加密，备份到本地。因为我的iOS设备没有越狱，所以只能通过这种方式访问微信沙盒中的文件。
cd 到这个目录就可以看到所有设备的备份文件，如果有多台设备的备份，会有多个文件夹。

~~~
cd ~/Library/Application\ Support/MobileSync/Backup/
~~~

我发现同一设备，不同电脑上生成的备份文件夹名字都是一样的。可以通过iTunes的设备偏好设置，找到所属的文件夹。其实通过Manifest.plist文件也可以看出来。

## 2 Manifest.db<a name="Manifest.db"></a>
可以用数据库工具打开这个文件，
里面的Files表存放了，备份文件夹中文件路径和沙盒文件的一个映射。
执行这个SQL语句，可以获取所有微信的沙盒文件。

~~~
SELECT fileID,relativePath FROM Files WHERE domain='AppDomain-com.tencent.xin'
~~~

这里拿到的是fileID，有一个小技巧，通过fileID，知道备份文件的路径，直接上代码

~~~
NSString *backupPath = [[fileID substringWithRange:NSMakeRange(0, 2)] stringByAppendingPathComponent:fileID];
~~~


## 3 WCDB_Contact.sqlite  <a name="WCDB"></a>


因为我其实就想导出一个人的聊天记录，直接向下一张表找就是了，所以这步没管。


## 4 MM.sqlite<a name="MM.sqlite"></a>
聊天记录就存在这个库里面，都是Chat_######### 这种格式的表。具体的逻辑可以参考下面的饮用参考的第一篇和第二篇。
音频这块内容多花了些时间，我主要参考狗神的那篇文章搞定的。大体思路是

silk格式

 1. 如果是silik 格式则用NSMutableData删除第一个字节,存成一个silk文件
 2. 用 decoder 转化成 pcm
 3. 用ffmpeg 转成 wav

如果是AMR（这块代码因为没数据，所以没测过）

1. 文件前面加上#!AMR
2. ffmpeg 转成 wav
 
 
## 5 导出
    
    
简单写了个HTML，里面嵌上视频，音频，文字。我主要关注这几块内容，别的就懒得管了。自己能看就行，懒得整样式了。
    
3 待完善
====

    1. 项目中很多Hard Code，可以做个UI完善一下。因为我自己的目的已经达到了，所以懒得做了
    2. 导出格式UI也可以完善一下，不做的理由同上。
    3. 音频decode 这块，看能不能写个函数，调一下，不用命令行的方式
    4. ffmpeg 也是，集成源码，这样，本地就不一定非的安装ffmpeg 了。

    
4 参考
====

   1. [一些业务微信内部的逻辑以及整体思路，内有C#源码，亏我还搞过C#，然而已经看不懂了。我猜是因为没装VS](https://zhuanlan.zhihu.com/p/22474033)
   2. [微信内部业务逻辑的补充。](http://www.cnblogs.com/cxun/p/4338643.html#3548267)
   3. [狗神的文章，主要参考这篇搞定音频的](http://bbs.iosre.com/t/topic/3199)
   4. [他也是参考狗神的 ](https://zhuanlan.zhihu.com/p/21783890)
   5. [顺道学习一下音频格式的一些基础知识  ](https://www.raywenderlich.com/69365/audio-tutorial-ios-file-data-formats-2014-edition)
   6. [如何用Mac自带的命令行工具转换](https://www.raywenderlich.com/69367/audio-tutorial-ios-converting-recording-2014-edition)
