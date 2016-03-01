# Dell Inspiron 7537 Hackintosh Guide
*****

## 简介

本文省略了一些通用的步骤，如果你机型和我一样，可以直接用我提供的文件，反正请认真阅读英文原帖，里面介绍的很详细。

文中一些补丁和驱动均源自RehabMan、the-darkvoid、vbo等所有为黑果做出贡献的开发者，谢谢你们！

本文提供的一些修改方法全部源自于论坛上大牛给出的建议，其中本文结构主要参考Dummyone和Nguyenmac的帖子，原帖地址附上:

- [Dummyone’s Guide](http://www.tonymacx86.com/el-capitan-laptop-guides/177410-guide-dell-inspiron-3x37-5x37-7x37-clover-yosemite-el-capitan.html)
- [Nguyenmac’s Guide](http://www.tonymacx86.com/mavericks-laptop-support/125911-dell-inspiron-3x37-5x37-7x37-clover-install-guide.html)

*****

### 我的硬件配置

- 电脑型号:Dell Inspiron 7537
- 硬盘:Galax 480G SSD
- 内存:Samsung DDR3 8G 1600MHz (4G + 4G)
- 处理器:Intel i5-4210U
- 显卡:Intel HD4400 + Nvidia GT750M
- 声卡:Realtek ALC 3223 (芯片为ALC 283)
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

#### 已完善

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

#### 未完善

- [ ] 摄像头驱动
- [ ] SD卡驱动
- [ ] Nvidia GT750M 显卡驱动

*****

## 引导安装、完善教程

### 安装OSX原版系统

#### 一、创建安装镜像

- 推荐：[【让天下没有难装的黑果】系列教程 2](http://bbs.pcbeta.com/viewthread-1649188-1-1.html)

#### 二、创建Clover引导

- 格式化U盘为MS-DOS(FAT32)格式。
- 我提供好的将Clover(r3333)文件夹放入U盘中。

#### 三、完成OSX初步安装

- 推荐：[【让天下没有难装的黑果】系列教程 3](http://bbs.pcbeta.com/viewthread-1649991-1-1.html)

*****

### 完善安装

#### 一、将Clover引导拷贝到系统盘

- 本操作在Mac或Win下都可进行，如果在Windows下操作，推荐PE环境，方便操作EFI分区

#### 二、更换Clover配置文件

- 进入Clover主目录找到`config.plist`(在我提供的文件中，名为`config_install.plist`的文件)
- 替换为我提供的文件里面的`config_normal.plist`，并将其重新命名为`config.plist`

#### 三、有线网卡驱动

- 进行下面的操作前需要连接互联网，所以我们先打上有线网卡的驱动
- 将 `RealtekRTL8111.kext` 安装至 `/Library/Extentions` 下，然后修复权限并重建缓存

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

- 用**MaciASL**打开**`DSDT.dsl`**
	- 设置`Preferences>iASL>Compiler options` 为 `ACPI 5.0`。
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

		OS Check Fix(Windows 7/8)

		AC Adapter Fix

		Add MCHC

		Fix _WAK arg0 2

		Fix PNOT/PPNT

		Add IMEI

		Fix _WAK IAOE

		Rename B0D3 to HDAU

		USB3 _PRW(0x6D)


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

- 为了让黑苹果更加完美，我们需要安装一些驱动让系统更好的工作，驱动列表如下:

	- `ACPIBacklight.kext` (可选驱动，如果亮度调节正常可以不装，这个驱动帮助黑苹果更平滑的调节亮度)
	- `ACPIBatteryManager.kext` (必备，电池状态补丁)
	- `AppleHDA.kext` (可选，这是 ALC283 的仿冒驱动，需要DSDT或者Clover注入layout-id=3，可自行选择VoodooHDA替代)
	- `FakePCIID_XHCIMux.kext` (必备，这个驱动将USB2.0的设备关联到EHCI上，将USB3.0的设备关联到XHCI上，在10.11上开启USB3.0)
	- `FakePCIID_Intel_HD_Graphics.kext` (必备，驱动Intel HD4400,需要FakeID:0x0412)
	- `FakePCIID.kext` (必备，关联以上两个驱动)
	- `FakeSMC.kext` (必备，原因不作说明)
	- `VoodooPS2Controller.kext` (必备，黑苹果键鼠和触控板驱动，支持二指、三指操作)
	- `USBXHC_Dell7537.kext` (这个和 FakePCIID_XHCIMux.kext 请二选一，两者同时用会导致USB不能识别)

- 以上驱动统一安装至 `/Library/Extentions` 下，然后修复权限并重建缓存
- 安装驱动的软件推荐`KCPM Utillity Pro` v5.1
- 安装前需要删除 `/System/Library/Extentions` 目录下的AppleHDA.kext、AppleACPIPS2Nub.kext、ApplePS2Controller.kext，请做好备份并删除！

#### 六、更改睡眠模式

- 打开终端输入

>     sudo pmset -a hibernatemode 0
>     sudo rm /var/vm/sleepimage

#### 七、驱动 BCM94352HMB

- 这个单独拿出来，因为Dell7537自带的无线网卡+蓝牙是Intel7260，Mac下无法驱动。所以我上手换了一款博通94352HMB的半高卡，很容易，在风扇左下的位置。

- 如果没有这款网卡的朋友就不要安装这个驱动了，更低成本的选择是Realtek的USB无线网卡(RTL8191\8192)。

- 驱动无线需要

	- FakePCIID_Broadcom_WiFi.kext
	- FakePCIID.kext

- 驱动蓝牙需要

	- BrcmFirmwareRepo.kext
	- BrcmPatchRAM2.kext

- 请将以上驱动安放在 `/Library/Extentions` 下，然后修复权限并重建缓存。

- 同时配合 Clover 的 *KextsToPatch* 补丁，可以让 BCM94352HMB 在Mac下开启*5Ghz*频段和*Handoff*功能

#### 八、修复不能登录AppStore和iCloud的错误

- 如果使用USB网卡或者用手机USB共享网络，可能会出现无法访问App Store或iCloud的情况，这时候我们需要*重置网络*。

- 去系统 `/Library/Preferences/SystemConfiguration/` 目录下，找到并删除以下文件:

	- CaptiveNetworkSupport
	- com.apple.airport.preferences.plist
	- com.apple.network.eapolclient.configuration.plist
	- NetworkInterfaces.plist
	- com.apple.network.identification.plist
	- com.apple.wifi.message-tracer.plist
	- preferences.plist

- 进入系统 `偏好设置 > 网络` 删除左侧窗口内所有连接，然后重启并在 `偏好设置 > 网络` 重新添加需要的网络连接

*****

## 可能遇到的问题

#### 睡眠唤醒后无声音输出

- 如果使用的是仿冒AppleHDA，可能会遇到睡眠后唤醒找不到声音设备的情况
- 这时候我们需要安装一个`CodecCommander.kext`驱动
- 并将附带的`hda-verb`移动到`/usr/bin/`目录下，即可解决这一问题

#### 长时间开机后电脑无法关机或睡眠

- 如果你和我一样，遇到了长时间开机(大约3 ~ 4个小时以后)无法关机的情况
- 那么很有可能需要更新 Intel ME 固件版本
- 这里放出原帖链接[Intel Management Engine…](http://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html)
- Dell 7537 机型的请选择 `ME firmware v9.5.x` 版本





