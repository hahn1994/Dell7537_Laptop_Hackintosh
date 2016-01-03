/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20151218-64
 * Copyright (c) 2000 - 2015 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-8.aml, Mon Dec 21 19:35:29 2015
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00001049 (4169)
 *     Revision         0x01
 *     Checksum         0x92
 *     OEM ID           "NvORef"
 *     OEM Table ID     "NvUltTbl"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120711 (538052369)
 */
DefinitionBlock ("SSDT-8.aml", "SSDT", 1, "NvORef", "NvUltTbl", 0x00001000)
{

    /*
     * External declarations that were imported from
     * the reference file [refs.txt]
     */
    External (_GPE.MMTB, MethodObj)    // 0 Arguments
//    External (_SB_.PCI0.LPCB.H_EC.ECRD, MethodObj)    // 1 Arguments
//    External (_SB_.PCI0.LPCB.H_EC.ECWT, MethodObj)    // 2 Arguments
//    External (_SB_.PCI0.PEG0.PEGP.SGPO, MethodObj)    // 2 Arguments

    External (_PR_.CPU0, ProcessorObj)
    External (_PR_.CPU0._PPC, IntObj)
    External (_PR_.CPU0._PSS, PkgObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.IGPU, DeviceObj)
    External (_SB_.PCI0.LPCB.EC__.ECRB, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.EC__.PCA5, MethodObj)    // 3 Arguments
    External (_SB_.PCI0.RP05, DeviceObj)
    External (DGC6, FieldUnitObj)
    External (P8XH, MethodObj)    // 2 Arguments

    Scope (\_SB.PCI0.RP05)
    {
        Device (PEGP)
        {
            Name (_ADR, Zero)  // _ADR: Address
        }

        OperationRegion (RPCI, SystemMemory, 0xF80E4000, 0x1000)
        Field (RPCI, DWordAcc, Lock, Preserve)
        {
            Offset (0x50), 
            ASPM,   2, 
                ,   2, 
            LNKD,   1, 
            Offset (0x214), 
            Offset (0x216), 
            LNKS,   4, 
            Offset (0x224), 
            Offset (0x225), 
            DQDA,   1
        }
    }

    

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        OperationRegion (OPNV, SystemMemory, 0xBCF9CF98, 0x0020)
        Field (OPNV, AnyAcc, Lock, Preserve)
        {
            NVGA,   32, 
            NVHA,   32, 
            AMDA,   32, 
            EBAS,   32, 
            CPSP,   32, 
            EECP,   32, 
            EVCP,   32, 
            XBAS,   32
        }

        OperationRegion (GPIO, SystemIO, 0x0800, 0x0400)
        Field (GPIO, ByteAcc, Lock, Preserve)
        {
            Offset (0x29B), 
                ,   6, 
            DGPG,   1, 
            Offset (0x2A3), 
                ,   7, 
            DGPW,   1, 
            Offset (0x2B3), 
                ,   7, 
            DGRS,   1
        }

        OperationRegion (PCIS, SystemMemory, 0xF8400000, 0x0500)
        Field (PCIS, DWordAcc, Lock, Preserve)
        {
            SVID,   32, 
            NCMD,   8, 
            BDAT,   2000, 
            Offset (0x488), 
                ,   25, 
            NHDA,   1
        }

        Name (BKAL, Buffer (0xFA)
        {
             0x00                                           
        })
        Method (NBAK, 0, NotSerialized)
        {
            Store (BDAT, BKAL)
        }

        Method (NRST, 0, NotSerialized)
        {
            Store (Zero, NCMD)
            Store (BKAL, BDAT)
            Store (0x06, NCMD)
        }

        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            Store (Zero, \_SB.PCI0.RP05.PEGP._ADR)
            NBAK ()
            _OFF()
        }

        Method (_ON, 0, Serialized)  // _ON_: Power On
        {
            P8XH (Zero, 0x21)
            Store (Zero, DGRS)
            Sleep (0x64)
            Store (One, DGPW)
            Sleep (0x64)
            While (LNotEqual (\_SB.PCI0.RP05.PEGP.DGPG, One))
            {
                Sleep (One)
            }

            Store (Zero, DQDA)
            Store (One, DGRS)
            Sleep (0x40)
            Store (Zero, LNKD)
            Sleep (0x64)
            Store (Zero, NHDA)
            NRST ()
        }

        Method (_OFF, 0, Serialized)  // _OFF: Power Off
        {
            P8XH (Zero, 0x31)
            Store (One, DQDA)
            Store (One, LNKD)
            Sleep (0x64)
            Store (Zero, DGRS)
            Sleep (0x64)
            Store (Zero, DGPW)
            Sleep (0x64)
        }
    }

    Scope (\_SB.PCI0)
    {
        Name (OTM, "OTMACPI 2010-Mar-09 12:08:26")
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        OperationRegion (NVHM, SystemMemory, NVHA, 0x00020400)
        Field (NVHM, DWordAcc, NoLock, Preserve)
        {
            Offset (0x100), 
            Offset (0x104), 
            RVBS,   32, 
            Offset (0x400), 
            RBF1,   262144, 
            RBF2,   262144, 
            RBF3,   262144, 
            RBF4,   262144
        }
    }

    Scope (\_SB.PCI0)
    {
        OperationRegion (RTCO, SystemIO, 0x72, 0x02)
        Field (RTCO, ByteAcc, NoLock, Preserve)
        {
            CIND,   8, 
            CDAT,   8
        }

        IndexField (CIND, CDAT, ByteAcc, NoLock, Preserve)
        {
            Offset (0x70), 
            OPTF,   1
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Method (_ROM, 2, NotSerialized)  // _ROM: Read-Only Memory
        {
            Store (Arg0, Local0)
            Store (Arg1, Local1)
            If (LGreater (Local1, 0x1000))
            {
                Store (0x1000, Local1)
            }

            If (LGreater (Local0, 0x00020000))
            {
                Return (Buffer (Local1)
                {
                     0x00                                           
                })
            }

            If (LGreater (Local0, RVBS))
            {
                Return (Buffer (Local1)
                {
                     0x00                                           
                })
            }

            Multiply (Local1, 0x08, Local3)
            Name (ROM1, Buffer (0x8000)
            {
                 0x00                                           
            })
            Name (ROM2, Buffer (Local1)
            {
                 0x00                                           
            })
            If (LLess (Local0, 0x8000))
            {
                Store (RBF1, ROM1)
            }
            ElseIf (LLess (Local0, 0x00010000))
            {
                Subtract (Local0, 0x8000, Local0)
                Store (RBF2, ROM1)
            }
            ElseIf (LLess (Local0, 0x00018000))
            {
                Subtract (Local0, 0x00010000, Local0)
                Store (RBF3, ROM1)
            }
            ElseIf (LLess (Local0, 0x00020000))
            {
                Subtract (Local0, 0x00018000, Local0)
                Store (RBF4, ROM1)
            }

            Multiply (Local0, 0x08, Local2)
            CreateField (ROM1, Local2, Local3, TMPB)
            Store (TMPB, ROM2)
            Return (ROM2)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Method (GOBT, 1, NotSerialized)
        {
            Name (OPVK, Buffer (0xE2)
            {
                /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0030 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0038 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0040 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0048 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0050 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0058 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0068 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0070 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0078 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0080 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0088 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0090 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 0098 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00A0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00A8 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00B0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00B8 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00C0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00C8 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00D0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00D8 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                /* 00E0 */  0x00, 0x00                                     
            })
            CreateWordField (Arg0, 0x02, USRG)
            If (LEqual (USRG, 0x564B))
            {
                Return (OPVK)
            }

            Return (Zero)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Name (OMPR, 0x02)
        Method (NVOP, 4, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
            If (LNotEqual (Arg1, 0x0100))
            {
                Return (0x80000001)
            }

            While (One)
            {
                Store (ToInteger (Arg2), _T_0)
                If (LEqual (_T_0, Zero))
                {
                    Store (Buffer (0x04)
                        {
                             0x00, 0x00, 0x00, 0x00                         
                        }, Local0)
                    Divide (Zero, 0x08, Local2, Local1)
                    ShiftLeft (One, Local2, Local2)
                    Or (DerefOf (Index (Local0, Local1)), Local2, Index (Local0, Local1))
                    Divide (0x1A, 0x08, Local2, Local1)
                    ShiftLeft (One, Local2, Local2)
                    Or (DerefOf (Index (Local0, Local1)), Local2, Index (Local0, Local1))
                    Divide (0x10, 0x08, Local2, Local1)
                    ShiftLeft (One, Local2, Local2)
                    Or (DerefOf (Index (Local0, Local1)), Local2, Index (Local0, Local1))
                    Divide (0x1B, 0x08, Local2, Local1)
                    ShiftLeft (One, Local2, Local2)
                    Or (DerefOf (Index (Local0, Local1)), Local2, Index (Local0, Local1))
                    Return (Local0)
                }
                ElseIf (LEqual (_T_0, 0x1A))
                {
                    CreateField (Arg3, 0x18, 0x02, OPCE)
                    CreateField (Arg3, Zero, One, FLCH)
                    If (ToInteger (FLCH))
                    {
                        Store (OPCE, OMPR)
                    }

                    Store (Buffer (0x04)
                        {
                             0x00, 0x00, 0x00, 0x00                         
                        }, Local0)
                    CreateField (Local0, Zero, One, OPEN)
                    CreateField (Local0, 0x03, 0x02, CGCS)
                    CreateField (Local0, 0x06, One, SHPC)
                    CreateField (Local0, 0x18, 0x03, DGPC)
                    CreateField (Local0, 0x1B, 0x02, HDAC)
                    Store (One, OPEN)
                    Store (One, SHPC)
                    Store (0x02, HDAC)
                    Store (One, DGPC)
                    If (\_SB.PCI0.RP05.PEGP._STA ())
                    {
                        Store (0x03, CGCS)
                    }

                    Return (Local0)
                }
                ElseIf (LEqual (_T_0, 0x1B))
                {
                    Store (Arg3, Local0)
                    CreateField (Local0, Zero, One, OPFL)
                    CreateField (Local0, One, One, OPVL)
                    If (ToInteger (OPVL))
                    {
                        Store (Zero, \_SB.PCI0.OPTF)
                        If (ToInteger (OPFL))
                        {
                            Store (One, \_SB.PCI0.OPTF)
                        }
                    }

                    Store (\_SB.PCI0.OPTF, Local0)
                    Return (Local0)
                }

                Break
            }

            Return (0x80000002)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Name (GPSP, Buffer (0x24) {})
        CreateDWordField (GPSP, Zero, RETN)
        CreateDWordField (GPSP, 0x04, VRV1)
        CreateDWordField (GPSP, 0x08, TGPU)
        CreateDWordField (GPSP, 0x0C, PDTS)
        CreateDWordField (GPSP, 0x10, SFAN)
        CreateDWordField (GPSP, 0x14, SKNT)
        CreateDWordField (GPSP, 0x18, CPUE)
        CreateDWordField (GPSP, 0x1C, TMP1)
        CreateDWordField (GPSP, 0x20, TMP2)
        Name (SUBF, Zero)
        Name (PSAP, Zero)
        Method (NVGS, 4, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
            Store ("<<< GPS Method Entry Point>>>", Debug)
            Store (Zero, Local0)
            Store (ShiftLeft (DerefOf (Index (Arg3, 0x03)), 0x18), Local0)
            Add (ShiftLeft (DerefOf (Index (Arg3, 0x02)), 0x10), Local0, Local0)
            Add (ShiftLeft (DerefOf (Index (Arg3, One)), 0x08), Local0, Local0)
            Add (ShiftLeft (DerefOf (Index (Arg3, Zero)), Zero), Local0, Local0)
            If (LNotEqual (Arg1, 0x0100))
            {
                Return (0x80000002)
            }

            Store (Arg2, SUBF)
            If (LEqual (SUBF, Zero))
            {
                Store ("GPS function 0", Debug)
                Return (Buffer (0x08)
                {
                     0x01, 0x00, 0x00, 0x00, 0x0F, 0x04, 0x00, 0x00 
                })
            }
            ElseIf (LEqual (SUBF, 0x2A))
            {
                Store ("GPS Function 2AH", Debug)
                CreateByteField (Arg3, Zero, PSH0)
                CreateByteField (Arg3, One, PSH1)
                CreateBitField (Arg3, 0x08, GPUT)
                CreateBitField (Arg3, 0x09, CPUT)
                CreateBitField (Arg3, 0x0A, FANS)
                CreateBitField (Arg3, 0x0B, SKIN)
                CreateBitField (Arg3, 0x0C, ENGR)
                CreateBitField (Arg3, 0x0D, SEN1)
                CreateBitField (Arg3, 0x0E, SEN2)
                While (One)
                {
                    Store (PSH0, _T_0)
                    If (LEqual (_T_0, Zero))
                    {
                        If (CPUT)
                        {
                            Store (0x0200, RETN)
                            Or (RETN, PSH0, RETN)
                            Store (0x40, PDTS)
                        }

                        Return (GPSP)
                    }
                    ElseIf (LEqual (_T_0, One))
                    {
                        If (GPUT)
                        {
                            Or (RETN, 0x0100, RETN)
                        }

                        If (CPUT)
                        {
                            Or (RETN, 0x0200, RETN)
                            Store (0x01F4, PDTS)
                        }

                        Return (GPSP)
                    }
                    ElseIf (LEqual (_T_0, 0x02))
                    {
                        Store (0x0102, RETN)
                        Store (Zero, VRV1)
                        Store (0x4B, TGPU)
                        Store (Zero, PDTS)
                        Store (Zero, SFAN)
                        Store (Zero, CPUE)
                        Store (Zero, SKNT)
                        Store (Zero, TMP1)
                        Store (Zero, TMP2)
                        Return (GPSP)
                    }

                    Break
                }
            }
            ElseIf (LEqual (SUBF, 0x20))
            {
                Store ("GPS fun 20", Debug)
                Name (RET1, Zero)
                CreateBitField (Arg3, 0x18, NRIT)
                CreateBitField (Arg3, 0x19, NRIS)
                If (NRIS)
                {
                    If (NRIT)
                    {
                        Or (RET1, 0x01000000, RET1)
                    }
                    Else
                    {
                        And (RET1, 0xFEFFFFFF, RET1)
                    }
                }

                Or (RET1, 0x40000000, RET1)
                Return (RET1)
            }
            ElseIf (LEqual (SUBF, 0x21))
            {
                Store ("GPS fun 21", Debug)
                Return (\_PR.CPU0._PSS)
            }
            ElseIf (LEqual (SUBF, 0x22))
            {
                Store ("GPS fun 22", Debug)
                CreateDWordField (Arg3, Zero, PCAP)
                Store (PCAP, \_PR.CPU0._PPC)
                Notify (\_PR.CPU0, 0x80)
                Store (PCAP, PSAP)
                Return (PCAP)
            }
            ElseIf (LEqual (SUBF, 0x23))
            {
                Store ("GPS fun 23", Debug)
                Return (PSAP)
            }
            Else
            {
                Return (0x80000002)
            }

            Return (Zero)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Name (TGPC, Buffer (0x04)
        {
             0x00                                           
        })
        Method (CURS, 0, Serialized)
        {
            If (LEqual (DGPW, One))
            {
                P8XH (One, 0x03)
                P8XH (Zero, 0xFE)
                Return (One)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.PCA5 (0xFB, 0x9040, Zero)
                Store (\_SB.PCI0.LPCB.EC.ECRB (0x02), Local0)
                And (Local0, One, DGC6)
                If (LEqual (DGC6, One))
                {
                    P8XH (One, 0x03)
                    P8XH (Zero, 0xFF)
                    Return (0x03)
                }
                Else
                {
                    P8XH (One, 0x03)
                    P8XH (Zero, 0xF9)
                    Return (0x02)
                }
            }
        }

        Method (GC6I, 0, Serialized)
        {
            CreateField (TGPC, 0x06, 0x02, ECOC)
            CreateField (TGPC, 0x0A, 0x02, PRGE)
            If (LOr (LEqual (ToInteger (PRGE), 0x03), LEqual (ToInteger (PRGE), One)))
            {
                Store (One, DQDA)
                Store (One, LNKD)
            }

            P8XH (One, 0x03)
            P8XH (Zero, 0xFA)
            \_SB.PCI0.LPCB.EC.PCA5 (0xFB, 0x00809140, Zero)
            P8XH (One, 0x03)
            P8XH (Zero, 0xFB)
        }

        Method (GC6O, 0, Serialized)
        {
            P8XH (One, 0x03)
            P8XH (Zero, 0xFC)
            Store (Zero, DGRS)
            Sleep (0x64)
            Store (One, DGPW)
            Store (Zero, Local0)
            While (LLess (Local0, 0x3C))
            {
                Add (Local0, One, Local0)
                Stall (0x3C)
            }

            Store (One, DGRS)
            Sleep (0x40)
            Store (Zero, LNKD)
            Sleep (0x64)
            P8XH (One, 0x03)
            P8XH (Zero, 0xFD)
            \_SB.PCI0.LPCB.EC.PCA5 (0xFB, 0x00819140, Zero)
        }

        Name (FCOD, Zero)
        Method (NGC6, 4, Serialized)
        {
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
            Store ("<<< NGC6 >>>", Debug)
            If (LLess (Arg1, 0x0100))
            {
                Return (0x80000001)
            }

            Store (Arg2, FCOD)
            If (LEqual (FCOD, Zero))
            {
                Store ("GC6 fun 0", Debug)
                Return (Unicode ("\x1B"))
            }

            If (LEqual (FCOD, One))
            {
                Store ("GC6 fun 1", Debug)
                Name (JTB1, Buffer (0x04)
                {
                     0x00                                           
                })
                CreateField (JTB1, Zero, One, JTEN)
                CreateField (JTB1, One, 0x02, SREN)
                CreateField (JTB1, 0x03, 0x03, PLPR)
                CreateField (JTB1, 0x06, 0x02, FBPR)
                CreateField (JTB1, 0x08, 0x02, GUPR)
                CreateField (JTB1, 0x0A, One, GC6R)
                CreateField (JTB1, 0x0B, One, PTRH)
                CreateField (JTB1, 0x14, 0x0C, JTRV)
                Store (One, JTEN)
                Store (One, GC6R)
                Store (One, PTRH)
                Store (One, SREN)
                Store (0x0103, JTRV)
                Return (JTB1)
            }

            If (LEqual (FCOD, 0x02))
            {
                Store ("GC6 fun 2", Debug)
                Return (Arg3)
            }

            If (LEqual (FCOD, 0x03))
            {
                Store ("GC6 fun 3", Debug)
                Name (JTB3, Buffer (0x04)
                {
                     0x00                                           
                })
                CreateField (Arg3, Zero, 0x03, GUPC)
                CreateField (Arg3, 0x04, One, PLPC)
                CreateField (JTB3, Zero, 0x03, GUPS)
                CreateField (JTB3, 0x03, One, GPGS)
                CreateField (JTB3, 0x07, One, PLST)
                While (One)
                {
                    Store (GUPC, _T_0)
                    If (LEqual (_T_0, One))
                    {
                        Store (Arg3, TGPC)
                        GC6I ()
                        Store (One, PLST)
                        Break
                    }
                    ElseIf (LEqual (_T_0, 0x02))
                    {
                        Store (Arg3, TGPC)
                        GC6I ()
                        If (LEqual (ToInteger (PLPC), Zero))
                        {
                            Store (Zero, PLST)
                        }

                        Break
                    }
                    ElseIf (LEqual (_T_0, 0x03))
                    {
                        Store (Arg3, TGPC)
                        GC6O ()
                        If (LEqual (ToInteger (PLPC), Zero))
                        {
                            Store (Zero, PLST)
                        }

                        Break
                    }
                    ElseIf (LEqual (_T_0, 0x04))
                    {
                        Store (Arg3, TGPC)
                        GC6O ()
                        If (LEqual (ToInteger (PLPC), Zero))
                        {
                            Store (Zero, PLST)
                        }

                        Break
                    }
                    ElseIf (LEqual (_T_0, Zero))
                    {
                        Store (CURS (), GUPS)
                        If (LEqual (ToInteger (GUPS), One))
                        {
                            Store (One, GPGS)
                        }
                        Else
                        {
                            Store (Zero, GPGS)
                        }

                        Break
                    }
                    Else
                    {
                        Break
                    }

                    Break
                }

                Return (JTB3)
            }

            If (LEqual (SUBF, 0x04))
            {
                Store ("GC6 fun 4", Debug)
                Return (0x80000002)
            }

            Return (0x80000002)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Name (DGOS, Zero)
        OperationRegion (PCNV, PCI_Config, 0x0488, 0x04)
        Field (PCNV, AnyAcc, NoLock, Preserve)
        {
                ,   25, 
            MLTF,   1
        }

        Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
        {
            If (DGOS)
            {
                \_SB.PCI0.RP05.PEGP._ON ()
                Store (Zero, DGOS)
            }

            Store (Zero, MLTF)
            Notify (\_SB.PCI0.RP05.PEGP, One)
        }

        Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
        {
            If (LEqual (\_SB.PCI0.RP05.PEGP.OMPR, 0x03))
            {
                \_SB.PCI0.RP05.PEGP._OFF ()
                Store (One, DGOS)
                Store (0x02, \_SB.PCI0.RP05.PEGP.OMPR)
            }
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }
    }

    Scope (\)
    {
        Method (CMPB, 2, NotSerialized)
        {
            Store (SizeOf (Arg0), Local1)
            If (LNotEqual (Local1, SizeOf (Arg1)))
            {
                Return (Zero)
            }

            Store (Zero, Local0)
            While (LLess (Local0, Local1))
            {
                If (LNotEqual (DerefOf (Index (Arg0, Local0)), DerefOf (Index (Arg1, Local0))))
                {
                    Return (Zero)
                }

                Increment (Local0)
            }

            Return (One)
        }
    }

    Scope (\_SB.PCI0.RP05.PEGP)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (LEqual (Arg0, ToUUID ("a486d8f8-0bda-471b-a72b-6042a6b5bee0")))
            {
                Return (\_SB.PCI0.RP05.PEGP.NVOP (Arg0, Arg1, Arg2, Arg3))
            }

            If (LEqual (Arg0, ToUUID ("a3132d01-8cda-49ba-a52e-bc9d46df6b81")))
            {
                Return (\_SB.PCI0.RP05.PEGP.NVGS (Arg0, Arg1, Arg2, Arg3))
            }

            If (LEqual (Arg0, ToUUID ("cbeca351-067b-4924-9cbd-b46b00b86f34")))
            {
                Return (\_SB.PCI0.RP05.PEGP.NGC6 (Arg0, Arg1, Arg2, Arg3))
            }
        }
    }
}

