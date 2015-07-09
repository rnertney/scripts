#!/bin/tcsh

mkdir images
#########################################
if ( $1 == {uboot} ) then
  cd u-boot-xlnx
  echo "***UBOOT BUILD***"
  if ( $2 == {clean} ) then
    bar
    echo "***UBOOT CLEAN***"
    make clean
  endif
  bar2
  make zynq_zc70x_config
  make -j15

  cp u-boot ../images/u-boot.elf

  arm-xilinx-eabi-objdump -h u-boot.elf > dump.txt
  grep text dump.txt
#########################################
else if ( $1 == {linux} ) then
  echo "***LINUX BUILD***"
  cd linux-xlnx
  if ( $2 == {clean} ) then
    bar
    echo "***LINUX CLEAN***"
    make clean
  endif

  bar2
  make ARCH=arm xilinx_zynq_defconfig
  make ARCH=arm UIMAGE_LOADADDR=0x8000 uImage -j15
  cp arch/arm/boot/uImage ../images/
########################################
else
  cd images
  echo "***DEVICETREE BUILD***"
  ../linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb zynq-zc702.dts
endif


##############----UBOOT DEBUG------##############
# get size of .text, put into offset size in SDK
# get VMA, add to "bdinfo" line for  reloc_offset from u-boot
# final box is .text

# repeat above for all sections except debug*

# ADDR/0x10_0000 = 1MB page number
# (ADDR/0x10_0000 * 4) TLB address with ADDR's attributes
#
#
#
#

# rea



