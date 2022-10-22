# 自制操作系统
***

## 工程运行说明
本工程基于Window10环境

需要下载相关的软件，链接如下：

- [NASM](https://www.nasm.us/):汇编语言编译器，第一本书是用自写的nask，但找不到啊，只能网上搜索，然后用这个了（可能后面会导致一些困难，但也没办法了，总有困难在前方）
- [qemu](https://qemu.weilnetz.de/w64/)：虚拟机，用来启动我们的操作系统，vm和物理机感觉太麻烦了，这个直接用一行命令启动就行了，很方便
- [git for windows](https://gitforwindows.org/):在本篇中需要拼接其他文件放到镜像文件后面，本文使用的linux下的dd命令，使用git的bash窗口可以使用dd命令，比较方便

下载完成后，在git bash中运行run.sh脚本即可：

如下图：运行git bash、运行脚本、成功显示

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fa31095aef684b8589a7f313fbee32a9~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d645364d2e114e0a8b57ad68ecba7121~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9021fb684a4548c8b5c9463f6916c696~tplv-k3u1fbpfcp-watermark.image?)

## 博客文章列表
- [自制操作系统系列（一）：显示hello world开始旅程](https://juejin.cn/post/7148604415652397070)
- [自制操作系统系列（二）：软盘读取](https://juejin.cn/post/7153429890220916767)
- [自制操作系统系列（三）：加载其他文件执行](https://juejin.cn/post/7154194485444870152/)

## 参考书籍列表
- [《三十天自制操作系统》](https://github.com/yourtion/30dayMakeOS)
- 《汇编程序语言设计》
- [《一个64位操作系统的设计与实现》](https://github.com/yifengyou/The-design-and-implementation-of-a-64-bit-os)

## 参考链接
- [writing-an-os-in-rust:使用rust写操作系统](https://github.com/rustcc/writing-an-os-in-rust)
- [5分钟理解make/makefile/cmake/nmake](https://zhuanlan.zhihu.com/p/111110992)
- [cmd中内容如何输出到文件中](https://blog.csdn.net/pltang/article/details/79765256)
- [BIOS系统服务 —— 直接磁盘服务（int 0x13）](https://blog.csdn.net/cherisegege/article/details/79835737)
- [nasm常用指令](http://www.daileinote.com/computer/assembly/06)

### 书籍源码仓库
- [《三十天自制操作系统》yourtion/30dayMakeOS](https://github.com/yourtion/30dayMakeOS)
- [一个64位操作系统的设计和实现](https://github.com/yifengyou/The-design-and-implementation-of-a-64-bit-os)

### 相关软件下载
- [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm)
- [《一个64位操作系统的设计与实现》学习笔记](https://github.com/yifengyou/The-design-and-implementation-of-a-64-bit-os
- [NASM](https://www.nasm.us/):汇编语言编译器，第一本书是用自写的nask，但找不到啊，只能网上搜索，然后用这个了（可能后面会导致一些困难，但也没办法了，总有困难在前方）
- [qemu](https://qemu.weilnetz.de/w64/)：虚拟机，用来启动我们的操作系统，vm和物理机感觉太麻烦了，这个直接用一行命令启动就行了，很方便
- [dd for windows](http://www.chrysocome.net/dd)
- [WinHex Hex Editor](http://www.winhex.com/winhex/hex-editor.html)
- [DiskGenius](https://www.diskgenius.cn/download.php)
- [git for windows](https://gitforwindows.org/):在本篇中需要拼接其他文件放到镜像文件后面，本文使用的linux下的dd命令，使用git的bash窗口可以使用dd命令，比较方便

### 相关博客
- [写操作系统之开发引导扇区](https://www.cnblogs.com/chuganghong/p/15412601.html)
- [汇编语言一发入魂 0x0C - 解放生产力](https://kviccn.github.io/posts/2020/05/%E6%B1%87%E7%BC%96%E8%AF%AD%E8%A8%80%E4%B8%80%E5%8F%91%E5%85%A5%E9%AD%82-0x0c-%E8%A7%A3%E6%94%BE%E7%94%9F%E4%BA%A7%E5%8A%9B/)
- [关于16、32、64位系统支持内存大小](https://blog.csdn.net/lolloli/article/details/121652854)

## 备忘
一般说来，如果能用一个寄存器来表示内存地址的话，当然会很方便，但一个BX只能表示0～0xffff的值，也就是只有0～65535，最大才64K
于是为了解决这个问题，就增加了一个叫EBX的寄存器，这样就能处理4G内存了。这是CPU能处理的最大内存量，没有任何问题。但EBX的导入是很久以后的事情，在设计BIOS的时代，CPU甚至还没有32位寄存器，所以当时只好设计了一个起辅助作用的段寄存器（segment register）。在指定内存地址的时候，可以使用这个段寄存器。
于是为了解决这个问题，就增加了一个叫EBX的寄存器，这样就能处理4G内存了。这是CPU能处理的最大内存量，没有任何问题。但EBX的导入是很久以后的事情，在设计BIOS的时代，CPU甚至还没有32位寄存器，所以当时只好设计了一个起辅助作用的段寄存器（segment register）。在指定内存地址的时候，可以使用这个段寄存器。
0x7c00～0x7dff用于启动区，0x7e00以后直到0x9fbff为止的区域都没有特别的用途，操作系统可以随便使用。
但0x8000～0x81ff这512字节是留给启动区的，要将启动区的内容读到那里，所以就这样吧。

当电脑启动时，主板上特殊的闪存中存储的BIOS固件将被加载。BIOS固件将会上电自检、初始化硬件，然后它将寻找一个可引导的存储介质。如果找到了，那电脑的控制权将被转交给引导程序（bootloader）：一段存储在存储介质的开头的、512字节长度的程序片段。大多数的引导程序长度都大于512字节——所以通常情况下，引导程序都被切分为一段优先启动、长度不超过512字节、存储在介质开头的第一阶段引导程序（first stage bootloader），和一段随后由其加载的、长度可能较长、存储在其它位置的第二阶段引导程序（second stage bootloader）。

引导程序必须决定内核的位置，并将内核加载到内存。引导程序还需要将CPU从16位的实模式，先切换到32位的保护模式（protected mode），最终切换到64位的长模式（long mode）：此时，所有的64位寄存器和整个主内存（main memory）才能被访问。引导程序的第三个作用，是从BIOS查询特定的信息，并将其传递到内核；如查询和传递内存映射表（memory map）。

本系统的内核程序起始地址位于物理地址0x100000（1 MB）处，因为1 MB以下的物理地址并不全是可用内存地址空间，这段物理地址被划分成若干个子空间段，它们可以是内存空间、非内存空间以及地址空洞。随着内核体积的不断增长，未来的内核程序很可能会超过1 MB，因此让内核程序跳过这些纷繁复杂的内存空间，从平坦的1 MB地址开始，这是一个非常不错的选择。

BIOS在实模式下只支持上限为1 MB的物理地址空间寻址，所以必须先将内核程序读入到临时转存空间，然后再通过特殊方式搬运到1 MB以上的内存空间中。