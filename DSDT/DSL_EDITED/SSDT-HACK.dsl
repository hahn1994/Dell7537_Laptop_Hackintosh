// SSDT-UIAC.dsl
//
// This SSDT demonstrates a custom configuration for USBInjectAll.kext.
//

DefinitionBlock ("SSDT-HACK.aml", "SSDT", 1, "hack", "hack", 0x00003000)
{
    
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)

    // All _OSI calls in DSDT are routed to XOSI...
    // XOSI simulates "Windows 2012" (which is Windows 8)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //  Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //  http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx
        Store(Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            //"Windows 2006.1",     // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Sesrver 2012
            "Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        }, Local0)
        Return (LNotEqual(Match(Local0, MEQ, Arg0, MTR, 0, 0), Ones))
    }

//    // In DSDT, native XSEL is renamed XXEL with Clover binpatch.
//    // Calls to it will land here.
//    External(_SB.PCI0.XHC, DeviceObj)
//    External(_SB.PCI0.XHC.PR2, FieldUnitObj)
//    External(_SB.PCI0.XHC.PR2M, FieldUnitObj)
//    External(_SB.PCI0.XHC.PR3, FieldUnitObj)
//    External(_SB.PCI0.XHC.PR3M, FieldUnitObj)
//    // Note about path of XUSB. In DSDT, it is declared as follows:
//    //
//    //Scope (\_SB)
//    //{
//    //    OperationRegion (PCI0.LPCB.LPC1, PCI_Config, Zero, 0x0100)
//    //    Field (PCI0.LPCB.LPC1, AnyAcc, NoLock, Preserve)
//    //    {
//    //        //...
//    //        XUSB,   1
//    //    }
//    //
//    // Initially assumed the full path for XUSB was \_SB.PCI0.LPCB.XUSB, but it is
//    // actually \_SB.XUSB.  The path in OperationRegion/Field only locates
//    // the particular PCI_Config, but the symbols within Field are scoped to
//    // \_SB.  It is a handy little feature that may be useful in other cases...
//    External(_SB.XUSB, FieldUnitObj)
//    External(_SB.PCI0.XHC.XRST, IntObj)
//    Method(_SB.PCI0.XHC.XSEL)
//    {
//        // This code is based on original XSEL, but without all the conditionals
//        // With this code, USB works correctly even in 10.10 after booting Windows
//        // setup to route all USB2 on XHCI to XHCI (not EHCI, which is disabled)
//        Store(1, XUSB)
//        Store(1, XRST)
//        Or(And (PR3, 0xFFFFFFC0), PR3M, PR3)
//        Or(And (PR2, 0xFFFF8000), PR2M, PR2)
//    }
//    
//    // Override for USBInjectAll.kext
//    Device(UIAC)
//    {
//        Name(_HID, "UIA00000")
//        Name(RMCF, Package()
//        {
//            // EH01
//            "EH01", Package()
//            {
//                "port-count", Buffer() { 0x01, 0, 0, 0 },
//                "ports", Package() 
//                {
//                    "PR11", Package() 
//                    {
//                        "UsbConnector", 0,
//                        "port", Buffer() { 0x01, 0, 0, 0 },
//                    }
//                },
//            },
//            // XHC overrides
//            "8086_9xxx", Package()
//            {
//                "port-count", Buffer() { 0x06, 0, 0, 0},
//                "ports", Package()
//                {
//                    "HS01", Package() // HS USB3 Port
//                    {
//                        "UsbConnector", 3,
//                        "port", Buffer() { 0x01, 0, 0, 0 },
//                    },
//                    "HS02", Package() // HS USB3 Port
//                    {
//                        "UsbConnector", 3,
//                        "port", Buffer() { 0x02, 0, 0, 0 },
//                    },
//                    "HS03", Package() // HS USB3 Port
//                    {
//                        "UsbConnector", 3,
//                        "port", Buffer() { 0x03, 0, 0, 0 },
//                    },
//                    "HS04", Package() // HS USB3 Port
//                    {
//                        "UsbConnector", 3,
//                        "port", Buffer() { 0x04, 0, 0, 0 },
//                    },
//                    "HS05", Package() // camera
//                    {
//                        "UsbConnector", 255,
//                        "port", Buffer() { 0x05, 0, 0, 0 },
//                    },
//                    "HS06", Package() // bluetooth
//                    {
//                        "UsbConnector", 255,
//                        "port", Buffer() { 0x06, 0, 0, 0 },
//                    }
//                },
//            },
//        })
//    }
    
    //Audio ALC283 CodecCommander
    External(_SB.PCI0.HDEF, DeviceObj)
    
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                Package()
                {
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x25
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x25 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x21 SET_UNSOLICITED_ENABLE 0x83
                    "Commannd", Buffer() { 0x02, 0x17, 0x08, 0x83 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
            "Perform Reset", ">n",
            "Send Delay", 10,
            "Sleep Nodes", ">n",
        },
    })

    //
    // Keyboard/Trackpad
    //

    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        // Select specific keyboard map in VoodooPS2Keyboard.kext
        Method(_DSM, 4)
        {
            If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "RM,oem-id", "DELL",
                "RM,oem-table-id", "HSW-LPT",
            })
        }

        // overrides for VoodooPS2 configuration...
        Name(RMCF, Package()
        {
            "Controller", Package()
            {
                "WakeDelay", 0,
            },
            "Sentelic FSP", Package()
            {
                "DisableDevice", ">y",
            },
            "ALPS GlidePoint", Package()
            {
                "DisableDevice", ">y",
            },
            "Synaptics TouchPad", Package()
            {
                "MultiFingerVerticalDivisor", "-9",
                "MultiFingerHorizontalDivisor", "-9",
                "MomentumScrollThreshY", 12,
            },
        })
    }
}

//EOF