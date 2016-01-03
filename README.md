# Dell Inspiron 7537 Hackintosh Guide
*****

## 简介

本文省略了一些通用的步骤，如果你机型和我一样，可以直接用我提供的文件，反正请认真阅读英文原帖，里面介绍的很详细。
文中一些补丁和驱动均源自RehabMan、the-darkvoid、vbo等所有为黑果做出贡献的开发者，谢谢你们！
本文提供的一些修改方法全部源自于论坛，其中本文结构主要参考Dummyone和Nguyenmac的帖子，原帖地址附上:
- [Dummyone’s Guide](http://www.tonymacx86.com/el-capitan-laptop-guides/177410-guide-dell-inspiron-3x37-5x37-7x37-clover-yosemite-el-capitan.html)
- [Nguyenmac’s Guide](http://www.tonymacx86.com/mavericks-laptop-support/125911-dell-inspiron-3x37-5x37-7x37-clover-install-guide.html)

*****

### 我的硬件配置

- 电脑型号:Dell Inspiron 7537
- 硬盘:Seagate 500GB HDD
- 内存:Samsung DDR3 8G
- 处理器:Intel i5-4210U
- 显卡:Intel HD4400 + Nvidia GT750M
- 声卡:Realtek ALC 3223(ALC283)
- 以太网卡:Realtek RTL 8111
- 无线网卡:Broadcom BCM 94352 HMB
- 蓝牙:Broadcom 20702A
- 触摸板:Synaptics Touchpad

*****

### 要求

1. Dell Inspiron 7537 (3x37/5x37/7x37同样适用)
2. 原版OS X El Capitan安装镜像
3. 至少一个U盘
4. Clover引导
5. 认真阅读此文档！
6. 最新版BIOS(我的版本是A13) 并确保设置了以下参数
    - Disk:AHCI
    - Intel Rapid Storage:Disabled
    - UEFI Boot:Enabled
    - Secure Boot:Disabled
    - Function key behavior:Multimedia key
    - Legacy Rom:Enabled(可选)

*****

## 目前完善进度

####已完善

- [x] 电源管理
- [x] 内建HD4400显卡驱动(包括QE/CI、OpenCL)
- [x] 内建HDMI输出(画面+声音)
- [x] 内建键盘驱动(包括Fn组合键)
- [x] 内建触摸板驱动Synaptics(可实现两指，三指正在修改中)
- [x] 内建声卡驱动ALC283
- [x] 内建有线网卡驱动RTL8111
- [x] 内建无线网卡驱动+蓝牙驱动(自带的Intel7260无解，某宝找来的一块BCM94352HMB半高卡换上，包括5Ghz+Handoff)
- [x] USB 2.0/3.0驱动
- [x] 背光调节
####未完善
- [ ] 摄像头驱动
- [ ] SD卡驱动
- [ ] Nvidia GT750M 显卡驱动

*****

## 引导安装、完善教程

### 安装OSX原版系统

#### 一、创建硬盘安装镜像

#### 二、创建U盘Clover引导

- 格式化U盘为MS-DOS(FAT)格式。
- 将Clover文件夹放入U盘中。

#### 三、完成OSX初步安装

*****

### 完善安装

#### 一、将Clover引导安装到系统盘



#### 二、更换Clover配置文件



#### 三、有线网卡驱动



#### 四、给DSDT/SSDT文件打补丁

	黑苹果的完美取决于你的DSDT文件是否修改得当，所以请认真阅读这个部分

##### 准备工作

- 去U盘 `CLOVER/ACPI/origin` 文件夹中。
    - 找到以**DSDT**和**SSDT**开头的所有ACPI文件(后缀名为.aml)。
    - 将他们复制到我们桌面一个新建的`DSDT`文件夹。
    - 同样的将`refs.txt`放到`DSDT`文件夹。
- 将`iasl`文件放到 `/usr/bin` 目录下。
    - 打开终端，输入下面命令:
	>		cd ~/Desktop/DSDT
	>		iasl -da -dl -fe refs.txt *.aml

	- 等待命令执行完成，我们会得到后缀名为.dsl的反编译文件。
	- 下载RehabMan提供的[MaciASL](https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads)，用它来编辑我们的dsl文件。

##### 给DSDT打补丁

- 用**MaciASL**打开**`DSDT.dsl`**，并设置`Preferences>iASL>Compiler options` 为 `ACPI 5.0`。
- 再转到`Sources`标签下，添加:
	- Name: `RehabMan DSDT Patches`
	- URL: `http://raw.github.com/RehabMan/Laptop-DSDT-Patch/master`
- 来主窗口点击`Patch`，在弹出来的页面，将`DSDT-Patches.txt`的内容粘贴进去，点击应用。
- 关闭`Patch`页面，然后点击`Compile`，如果没有报错，继续。
- 点击`Patch`，在左侧对话框中选择下面的补丁并应用:
		Rename GFX0 to IGPU
		7/8-series USB
		IRQ Fix
		SMBUS Fix
		RTC Fix
		Shutdown Fix 2
		HPET Fix
		OS Check Fix(Windows 7/8 两个中选一个最合适的)
		AC Adapter Fix
		Add MCHC
		Fix _WAK arg0 2
		Fix PNOT/PPNT
		Add IMEI
		Fix _WAK IAOE
		Rename B0D3 to HDAU
		USB3 _PRW(0x6D)
		Add MCHC
		[battery]Dell-Inspiron-15-7xxx
- 关闭`Patch`页面，然后再次点击`Compile`，如果没有报错，继续点击`Patch`，将`DSDT-Brightness.txt`的内容粘贴进去，点击应用。
- (这一步 For 10.11)关闭`Patch`页面，然后再次点击`Compile`，如果没有报错，继续点击`Patch`，将`DSDT-USB-Rename.txt`的内容粘贴进去，点击应用。
- 所有补丁打完后，再次编译`Compile`,没有报错就保存文件，先保存为.dsl文件(方便以后修改)，再另存为`ACPI Machine Language Binary`格式的.aml文件,文件放置在一个新建的文件夹`patches`中，文件命名为`DSDT.aml`。

##### 给SSDT文件打补丁

- 在`DSDT`文件夹中找到**`SSDT-7.dsl`**,用MaciASL打开它，然后`Patch`以下补丁:
		Rename GFX0 to IGPU
		Haswell HD4400/HD4600/HD5000
		Brightness fix (Haswell/broadwell)
		Rename B0D3 to HDAU
- 点击`Compile`，如果没有报错可以保存为.dsl文件，再另存为名为**`SSDT-1.aml`**，保存到文件夹`patches`中。
- 在`DSDT`文件夹中找到**`SSDT-8.dsl`**,用MaciASL打开它，然后`Patch`,将`SSDT8-Patches.txt`的内容粘贴进去，应用。
- 点击`Compile`，如果没有报错可以保存为.dsl文件，再另存为名为**`SSDT-2.aml`**，保存到文件夹`patches`中。
- (如果还有**`SSDT-9.dsl`**，继续此步骤，没有则跳过)选择**`SSDT-9.dsl`**,应用`SSDT9-Patches.txt`,编译没有报错就保存

#### 五、安装其他驱动



#### 六、更改睡眠模式



#### 七、驱动 BCM94352HMB



#### 八、修复不能登录AppStore和iCloud的错误

*****

## 可能遇到的问题



#### 使用打过补丁的AppleHDA



#### 睡眠唤醒后无声音输出



#### 启动第二阶段花屏



#### 长时间开机后电脑无法关机或睡眠



#### 睡眠唤醒后找不到蓝牙设备



#### iMessages不能登录





