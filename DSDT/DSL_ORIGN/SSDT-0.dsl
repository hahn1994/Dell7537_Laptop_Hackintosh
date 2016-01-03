/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20151218-64
 * Copyright (c) 2000 - 2015 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-0.aml, Mon Dec 21 19:35:29 2015
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000228 (552)
 *     Revision         0x01
 *     Checksum         0xCA
 *     OEM ID           "DELL  "
 *     OEM Table ID     "sensrhub"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120711 (538052369)
 */
DefinitionBlock ("SSDT-0.aml", "SSDT", 1, "DELL  ", "sensrhub", 0x00000000)
{

    /*
     * External declarations that were imported from
     * the reference file [refs.txt]
     */
    External (_GPE.MMTB, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.H_EC.ECRD, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.H_EC.ECWT, MethodObj)    // 2 Arguments
    External (_SB_.PCI0.PEG0.PEGP.SGPO, MethodObj)    // 2 Arguments

    External (_SB_.PCI0.I2C0.DFUD, UnknownObj)
    External (_SB_.PCI0.I2C0.SHUB, UnknownObj)
    External (_SB_.RDGP, MethodObj)    // 1 Arguments
    External (_SB_.WTGP, MethodObj)    // 2 Arguments
    External (SDS0, FieldUnitObj)
    External (USBH, FieldUnitObj)

    Scope (\)
    {
        Device (SHAD)
        {
            Name (_HID, EisaId ("INT33D0"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                If (LOr (And (SDS0, One), And (USBH, One)))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                Name (PGCE, Zero)
                Name (PGCD, Zero)
                Name (DFUE, Zero)
                Name (DFUD, Zero)
                Name (OLDV, Zero)
                Name (PGCV, Zero)
                Name (DFUV, Zero)
                If (LEqual (Arg0, ToUUID ("03c868d5-563f-42a8-9f57-9a18d949b7cb")))
                {
                    If (LEqual (One, ToInteger (Arg1)))
                    {
                        While (One)
                        {
                            Store (ToInteger (Arg2), _T_0)
                            If (LEqual (_T_0, Zero))
                            {
                                Return (Buffer (One)
                                {
                                     0x0F                                           
                                })
                            }
                            ElseIf (LEqual (_T_0, One))
                            {
                                Store (DerefOf (Index (Arg3, Zero)), PGCE)
                                Store (DerefOf (Index (Arg3, One)), PGCD)
                                Store (\_SB.RDGP (0x2E), OLDV)
                                \_SB.WTGP (0x2E, PGCE)
                                If (LGreater (PGCD, Zero))
                                {
                                    Sleep (PGCD)
                                    \_SB.WTGP (0x2E, OLDV)
                                }

                                If (LEqual (\_SB.RDGP (0x2E), One))
                                {
                                    Sleep (0x96)
                                    If (LEqual (\_SB.RDGP (0x2C), One))
                                    {
                                        Notify (\_SB.PCI0.I2C0.SHUB, One)
                                    }
                                    Else
                                    {
                                        Notify (\_SB.PCI0.I2C0.DFUD, One)
                                    }
                                }

                                Return (Zero)
                            }
                            ElseIf (LEqual (_T_0, 0x02))
                            {
                                Store (DerefOf (Index (Arg3, Zero)), DFUE)
                                Store (DerefOf (Index (Arg3, One)), DFUD)
                                Store (\_SB.RDGP (0x2C), OLDV)
                                \_SB.WTGP (0x2C, DFUE)
                                If (LGreater (DFUD, Zero))
                                {
                                    Sleep (DFUD)
                                    \_SB.WTGP (0x2C, OLDV)
                                }

                                Return (Zero)
                            }
                            ElseIf (LEqual (_T_0, 0x03))
                            {
                                Store (\_SB.RDGP (0x2C), DFUV)
                                Store (\_SB.RDGP (0x2E), PGCV)
                                Return (Package (0x02)
                                {
                                    PGCV, 
                                    DFUV
                                })
                            }

                            Break
                        }

                        Return (Zero)
                    }

                    Return (Zero)
                }

                Return (Zero)
            }
        }
    }
}

