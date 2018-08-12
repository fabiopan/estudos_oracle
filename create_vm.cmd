echo off
rem *********************************************
rem referência https://www.virtualbox.org/manual/
rem *********************************************

set name=vm-italia02
set prefix=italia
set path_iso_so=%userprofile%\Downloads\V46135-01.iso
set path_vms=%userprofile%\VirtualBox VMs
set path_hd=%path_vms%\%name%\vmhd.vdi
set bridge_adapter="Dell Wireless 1705 802.11b|g|n (2.4GHZ)"
set intnet_name=racpriv

echo Criando Maquina Virtual
vboxmanage createvm --name %name% --ostype "Linux_64" --basefolder "%path_vms%" --register

echo Atribuindo Memoria
vboxmanage modifyvm %name% --memory 8192 --vram 16 --rtcuseutc on

echo Habilitando USB/Mouse
vboxmanage modifyvm %name% --usb on --mouse usbtablet
vboxmanage modifyvm %name% --mouse usbtablet

echo Criando Controladoras de Discos
vboxmanage storagectl %name% --name "IDE" --add ide --controller PIIX4
vboxmanage storagectl %name% --name "SATA" --add sata --controller IntelAHCI

echo Criando Discos
vboxmanage createhd --filename "%path_hd%" --size 95488 --format VDI 
rem vboxmanage createhd --filename "%path_vms%storage\dsk_%prefix%_data_001.vdi" --size 32768 --format VDI --variant Standard
rem vboxmanage createhd --filename "%path_vms%storage\dsk_%prefix%_fra_001.vdi" --size 8192 --format VDI --variant Standard
rem vboxmanage createhd --filename "%path_vms%storage\dsk_%prefix%_arch_001.vdi" --size 2048 --format VDI --variant Standard
rem vboxmanage createhd --filename "%path_vms%storage\dsk_%prefix%_redo_001.vdi" --size 2048 --format VDI --variant Standard

echo Atribuindo Discos
vboxmanage storageattach %name% --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "%path_iso_so%"
vboxmanage storageattach %name% --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%path_hd%"
rem vboxmanage storageattach %name% --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium emptydrive
rem vboxmanage storageattach %name% --storagectl "SATA" --port 1 --device 0 --type hdd --medium "C:\Users\Pan\VMs\storage\dsk_%prefix%_data_001.vdi" --mtype normal
rem vboxmanage storageattach %name% --storagectl "SATA" --port 2 --device 0 --type hdd --medium "C:\Users\Pan\VMs\storage\dsk_%prefix%_fra_001.vdi" --mtype normal
rem vboxmanage storageattach %name% --storagectl "SATA" --port 3 --device 0 --type hdd --medium "C:\Users\Pan\VMs\storage\dsk_%prefix%_arch_001.vdi" --mtype normal
rem vboxmanage storageattach %name% --storagectl "SATA" --port 4 --device 0 --type hdd --medium "C:\Users\Pan\VMs\storage\dsk_%prefix%_redo_001.vdi" --mtype normal

rem ******* se precisar remover os discos **********
rem vboxmanage showvminfo %name% | find "UUID"
rem vboxmanage storageattach %name% --storagectl "SATA" --port 1 --device 0 --medium none
rem vboxmanage storageattach %name% --storagectl "SATA" --port 2 --device 0 --medium none
rem vboxmanage storageattach %name% --storagectl "SATA" --port 3 --device 0 --medium none
rem vboxmanage storageattach %name% --storagectl "SATA" --port 4 --device 0 --medium none
rem vboxmanage closemedium disk 973adf6c-7316-4a38-9272-08b5da787afb --delete
rem vboxmanage closemedium disk 2314aef1-f653-4e00-a24a-b2753a417a3e --delete
rem vboxmanage closemedium disk 21420926-44f5-4ee8-a1d6-148789a53514 --delete
rem vboxmanage closemedium disk 407abd3b-6997-4939-995f-80543f7191ef --delete

echo Atribuindo Interfaces de Rede
vboxmanage modifyvm %name% --nic1 bridged --bridgeadapter1 %bridge_adapter%
vboxmanage modifyvm %name% --nic2 intnet --intnet2 "%intnet_name%"
rem vboxmanage natnetwork add --netname natnet1 --network "192.168.15.0/24" --enable --dhcp on
rem vboxmanage modifyvm %name% --nic2 hostonly --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter"

echo Definido Sequencia de Boot
vboxmanage modifyvm %name% --boot1 dvd
vboxmanage modifyvm %name% --boot2 disk
vboxmanage modifyvm %name% --boot3 none

echo Executar Maquina Virtual
vboxmanage startvm %name%

rem vboxmanage unregistervm %name% [--delete]

echo Maquina Virtual Criada com Sucesso.
pause