//
//  IntroView.swift
//  Mission Overflow
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// Sets the scene of the game with a imagery of a computer booting up.
struct BootupView: View {
    
    // MARK: View Variables
    /// Bootup text to display in the view line-by-line.
    @State var startupText = """
    BOOTING I.D.D.A. SYSTEM ALPHA
    Starting udev:                                             [  OK  ]
    Setting hostname elwood:                                   [  OK  ]
    Setting up Logical Volume Management:   No volume groups found
    [  OK  ]
    Checking filesystems
    /dev/sda2: clean, 89739/30457856 files, 2561411/121822976 blocks
    /dev/sda1: clean, 39/76912 files, 43648/307200 blocks
    Remounting root filesystem in read-write mode:             [  OK  ]
    Mounting local filesystems:                                [  OK  ]
    Enabling local filesystem quotas:                          [  OK  ]
    Enabling /etc/fstab swaps:                                 [  OK  ]
    Entering non-interactive startup
    ERROR: Wanpipe configuration file not found:
    /etc/wanpipe/wanpipe1.conf
    Bringing up loopback interface:                            [  OK  ]
    Bringing up interface eth0:
    Determining IP information for eth0... done.
    Starting auditd:                                           [  OK  ]
    Starting system logger:                                    [  OK  ]
    Loading DAHDI hardware modules:
    wct4xxp:                                                 [  OK  ]
    wcte43x:                                                 [  OK  ]
    wcte12xp:                                                [  OK  ]
    wcte13xp:                                                [  OK  ]
    wct1xxp:                                                 [  OK  ]
    wcte11xp:                                                [  OK  ]
    r1t1:                                                    [  OK  ]
    rxt1:                                                    [  OK  ]
    wctdm24xxp:                                              [  OK  ]
    wcaxx:                                                   [  OK  ]
    wcfxo:                                                   [  OK  ]
    wctdm:                                                   [  OK  ]
    rcbfx:                                                   [  OK  ]
    wcb4xxp:                                                 [  OK  ]
    wctc4xxp:                                                [  OK  ]
    xpp_usb:                                                 [  OK  ]
    D: auto '/sys/bus/dahdi_devices/devices/pci:0000:02:08.0'
    auto-assign /sys/bus/dahdi_devices/devices/pci:0000:02:08.0
    Running dahdi_cfg:                                         [  OK  ]
    Starting system message bus:                               [  OK  ]
    Starting Avahi daemon...                                   [  OK  ]
    Mounting filesystems:                                      [  OK  ]
    Starting acpi daemon:                                      [  OK  ]
    Starting HAL daemon:                                       [  OK  ]
    Retrigger failed udev events                               [  OK  ]
    Starting Queue callback daemon:                            [  OK  ]
    Starting REST applications daemon:                         [  OK  ]
    Starting dnsmasq:                                          [  OK  ]
    Starting sshd:                                             [  OK  ]
    Starting xinetd:                                           [  OK  ]
    Starting ntpd:                                             [  OK  ]
    Starting UPS monitoring:                                   [  OK  ]
    Starting mysqld:                                           [  OK  ]
    Starting postfix:                                          [FAILED]
    Starting httpd: REST Applications module is not licensed.
    Warning: DocumentRoot [/var/www/html/aastra/] does not exist
    [Tue Mar 24 16:22:31 2015] [warn] _default_ VirtualHost overlap on port 80, the first has precedence
    (98)Address already in use: make_sock: could not bind to address [::]:80
    (98)Address already in use: make_sock: could not bind to address 0.0.0.0:82
    no listening sockets available, shutting down
    Unable to open logs
    [FAILED]
    Starting crond:                                            [  OK  ]
    Starting prosody: Started
    Starting fail2ban:                                         [  OK  ]
    Starting jexec servicesStarting Filesystem event daemon (in[  OK  ]
    Fetching FreePBX settings with gen_amp_conf.php..
    STARTING WANROUTER FOR SANGOMA CARDS
    No Wanrouter Cards Installed
    STARTING DAHDI FOR DIGIUM CARDS
    Dahdi Started
    SETTING FILE PERMISSIONS...................Done
    Removing any dangling symlinks
    Dangling symlinks removed
    STARTING ASTERISK
    Asterisk Started
    Stopping fail2ban: REST Applications module is not licensed.
    &gt; ucp-server@ start /var/www/html/admin/modules/ucpnode/node
    &gt; node_modules/forever/bin/forever start -m 1 -a -l $ASTLOGDIR/ucp_forever.log -o $ASTLOGDIR/ucp_out.log -e $ASTLOGDIR/ucp_err.log --uid 'ucp' ind
    ex.js
    warn:    --minUptime not set. Defaulting to: 1000ms
    warn:    --spinSleepTime not set. Your script will exit if it does not stay up for at least 1000ms
    info:    Forever processing file: index.js
    Starting prosody: Prosody is already running with PID 1748
    Starting XMPP Presence State daemon:                       [  OK  ]
    Mar 24 16:30:50 elwood NET[2658]: /sbin/dhclient-script : updated /etc/resolv.conf
    0
    EEEE I3000000032940xf100110303B77500EEEE I400000004294_M8_BL1_10221D113B323EEEE5
    no sdio debug board detected
    TE : 102609
    BT : 11:30:18 Mar 14 2014
    voltage set from 0x18 to 0x24, addr:0x36
    voltage set from 0x18 to 0x2c, addr:0x37
    voltage set from 0x38 to 0x48, addr:0x38
    voltage set from 0x4e to 0x50, addr:0x4c
    voltage set from 0x24 to 0x24, addr:0x4d
    voltage set from 0x30 to 0x30, addr:0x4e
    voltage set from 0x4e to 0x4e, addr:0x4f
    voltage set from 0x24 to 0x24, addr:0x50
    voltage set from 0x28 to 0x28, addr:0x56
    voltage set from 0x00 to 0x00, addr:0x57
    CPU clock is 792MHz
    Aml log : DDR0 - init pass with
    PGSR0 : 0x80000fff
    Aml log : DDR1 - init pass with
    PGSR0 : 0xc0000fff
    DDR clock is 696MHz with 1T mode
    DDR check pass!
    DDR init use : 18071 us
    HHH
    Start load M8 SMP code!
    Load M8 SMP code finished!
    Boot From SPI
    ucl decompress...pass
    0x12345678
    Boot from internal device 1st SPI
    TE : 512897
    System Started
    U-boot-00000-gc0e883b-dirty(m8_k200_v1@uboot) (Mar 14 2014 - 11:30:10)
    clr h-ram
    DRAM:  2 GiB
    relocation Offset is: 6fed4000
    show partition table:
    part: 0, name :       logo, size : 2000000
    part: 1, name :   recovery, size : 2000000
    part: 2, name :       misc, size : 2000000
    part: 3, name :       boot, size : 2000000
    part: 4, name :     system, size : 40000000
    part: 5, name :      cache, size : 20000000
    part: 6, name :       data, size : end
    aml_card_type=0x100
    MMC:   [mmc_register] add mmc dev_num=0, port=1, if_type=6
    [mmc_register] add mmc dev_num=1, port=2, if_type=6
    SDIO Port B: 0, SDIO Port C: 1
    aml_i2c_init
    PMU fault status:
    reg[0x9A] = 0x1d
    [RN5T618]rn5t618_set_gpio, gpio:3, output:0
    [RN5T618]rn5t618_set_gpio, gpio:1, output:0
    [RN5T618] DUMP ALL REGISTERS
    0x00 - 0f: 04 0c 10 00 00 00 00 00   00 01 00 03 9f 00 00 00
    0x10 - 1f: 69 05 00 00 00 0f cc 99   dd 00 00 bf 22 ee dd ee
    0x20 - 2f: 00 00 00 00 00 ff ff ff   0f 00 cc 00 13 03 13 03
    0x30 - 3f: 13 03 00 00 00 00 24 2c   48 00 00 18 18 38 00 00
    0x40 - 4f: 00 00 00 00 1f 30 ff 00   00 00 00 00 50 24 30 4e
    0x50 - 5f: 24 00 00 00 00 00 28 00   4e 24 30 4e 24 00 00 00
    0xb0 - bf: 06 07 00 23 00 21 18 05   02 3b 01 34 01 00 7f ff
    mcli -- wifi_power_init in uboot --
    NAND:  SPI BOOT: boot_device_flag 0
    Nand PHY driver Version: 1.01.001.0003 (c) 2013 Amlogic Inc.
    amlnf_phy_init : amlnf init flag 0
    NAND device id: 2c 64 44 4b a9 0 0 0
    detect NAND device: B revision NAND 8GiB MT29F64G08CBABA
    AML_NAND_NEW_OOB : new oob
    bus_cycle=5, bus_timing=7,system=3.9ns,flash-&gt;T_REA =16,flash-&gt;T_RHOH=15
    NAND CKECK  : arg nbbt: arg_valid= 1, valid_blk_addr = 5, valid_page_addr = 0
    NAND CKECK  : arg ncnf: arg_valid= 1, valid_blk_addr = 8, valid_page_addr = 0
    NAND CKECK  : arg nkey: arg_valid= 1, valid_blk_addr = 4, valid_page_addr = 0
    i=0,register --- nand_key
    nfcache   : offset: 0x000006000000 -0x000024800000 : partitons 1 : single_chip e
    nfcode    : offset: 0x00002a800000 -0x000050000000 : partitons 5 : single_chip e
    nfdata    : offset: 0x00007a800000 -0x000185800000 : partitons 1 : single_chip e
    amlnf_logic_init: START
    amlnf_logic_init:  COMPLETE
    get_boot_device_flag: init_ret 0
    get_boot_device_flag   SPI BOOT:
    nand init success, change the device_boot_flag to 4 : spi+nand
    SPI BOOT,spi_env_relocate_spec : env_relocate_spec 53
    SF: Detected MX25L1605D with page size 256, total 2 MiB
    SPI NOR Flash have write protect!!!
    set_storage_device_flag: store 4
    vpu clk_level in dts: 7
    set vpu clk: 364300000Hz, readback: 364300000Hz(0x700)
    In:    serial
    Out:   serial
    Err:   serial
    Net:   Meson_Ethernet
    init suspend firmware done. (ret:0)
    preboot...
    Video initializing...
    osd_layer_init
    frame buffer address is 0x15100000
    video size is 720 X 576
    video bbp is 24
    LCD screen clear!
    hdmi tx power init
    mode = 4  vic = 21
    mode is: 3
    viu chan = 1
    config HPLL
    video_scale_bitmap src width is 1280, height is 720, dst width is 720, dst heig6
    reboot_mode=charging
    SARADC open channel(0).
    switch_bootmode...
    efuse version is not selected.
    Hit any key to stop autoboot -- :  1 tstc enter
    exit abortboot: 1
    m8_k200_v1#             setenv bootargs 'root=/dev/nfs rootfstype=nfs nfsroot=1'
    m8_k200_v1#
    m8_k200_v1#Read more: http://www.cnx-software.com/2014/05/15/how-to-boot-linux-B
    Unknown command 'Read' - try 'help'
    m8_k200_v1#bootp; bootm
    Amlogic Ethernet Init
    Success: reset mac OK!(0)
    ETH PHY hardware reset OK
    find net phy id=0x2430c54, phyad=0
    set_mac_mode(0)
    final_addr[rx-tx]: 0x7ffee000-0x7ffee600
    Ethernet reset OK
    MAC address is 00:15:18:01:81:31
    duplex
    100m
    BOOTP broadcast 1
    DHCP client bound to address 192.168.0.105
    Using Meson_Ethernet device
    TFTP from server 192.168.0.104; our IP address is 192.168.0.105
    Filename 'boot.img'.
    Load address: 0x12000000
    Loading: T T T #################################################################
    #################################################################
    ################
    done
    Bytes transferred = 11676665 (b22bf9 hex)
    ## ANDROID Format IMAGE
    ## Booting kernel from Legacy Image at 12000000 ...
    Image Name:   Linux-3.10.10
    Image Type:   ARM Linux Kernel Image (lzo compressed)
    Data Size:    7533340 Bytes = 7.2 MiB
    Load Address: 00008000
    Entry Point:  00008000
    Verifying Checksum ... OK
    Ramdisk start addr = 0x12730000, len = 0x3ee800
    Flat device tree start addr = 0x12b1e800, len = 0x43f9 magic=0xedfe0dd0
    Uncompressing Kernel Image ... OK
    EFUSE machid is not set.
    Using machid 0xf81 from environment
    From device tree /memory/ node aml_reserved_end property, for relocate ramdisk 1
    Loading Ramdisk to 05008000, end 053f6800 ... OK
    Loading Device Tree to 05000000, end 050073f8 ... OK
    Starting kernel ...
    root@genericarmv7a:~# [   18.289331@3] ========  temp=32
    I.D.D.A system loaded OK
    starting communication subystem ... OK
    starting GUI ...
    """.components(separatedBy: "\n")
    /// A timer which triggers more text to appear on-screen.
    let startupTextUpdateTimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    /// The part of the bootup text that is currently showing on-screen.
    @State var showingStartupText: [String] = []
    
    // MARK: View Body
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)
                .mask(
                    Image("IDDA logo")
                        .resizable()
                )
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 500)
                .opacity(0.1)
            
            VStack {
                Spacer()
                
                HStack {
                    ScrollView(showsIndicators: false) {
                        ScrollViewReader { scrollViewReader in
                            VStack {
                                Spacer()
                                
                                ForEach(showingStartupText, id: \.self) { eachTextLine in
                                    HStack {
                                        Text(eachTextLine)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.red)
                                            .font(robotoMonoFont(10))
                                            .id(eachTextLine)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .onChange(of: showingStartupText.count) { _ in
                                scrollViewReader.scrollTo(showingStartupText.last)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onReceive(startupTextUpdateTimer) { _ in
            if !startupText.isEmpty {
                showingStartupText.append(startupText.remove(at: 0))
            }
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct BootupView_Previews: PreviewProvider {
    static var previews: some View {
        BootupView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// MARK: Support Views
// Support views go here! :)
