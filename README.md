# ZMK sample project for pmw3610-pcb

This project is for checking [pmw3610-pcb](https://github.com/hidsh/pmw3610-pcb).

- board: seeeduino_xiao_ble (XIAO nRF52840)
- shield: pmw3610-pcb
- modules: https://github.com/badjeff/zmk-pmw3610-driver

## Connection to XIAO nRF52840

![schematic](img/connection-xiao-nrf.png)

## Tested environment

- Arch Linux
- ZMK Firmware (Native setup)

## Local Build
### Prerequisites
- ZMK [Native Setup](https://zmk.dev/docs/development/local-toolchain/setup/native)
- [cyme](https://github.com/tuna-f1sh/cyme) (for flashing firmware)

### Setup
```
# clone this repo
cd ~/Downloads
git clone git@github.com:hidsh/zmk-pmw3610-pcb.git

# cd to your `zmk/app` folder
cd PATH/TO/zmk/app

# create a symlink from makefile
ln -s ~/Downloads/zmk-pmw3610-pcb/pmw3610-pcb.mk ./Makefile
```

### Build
```
# just `make` to build/flash firmware
make
```
As above, I prefer building in the `app` folder to [Building from zmk-config Folder](https://zmk.dev/docs/development/local-toolchain/build-flash?build-opts=addonMcu#building-from-zmk-config-folder). 
