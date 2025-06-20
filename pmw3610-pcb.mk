# Makefile for zmk
#
# Install:
#   1. cd PATH/TO/zmk/app
#   2. ln -s PATH/TO/pmw3610-pcb.mk ./Makefile
#
# Usage:
#   1. cd PATH/TO/zmk/app
#   2. make 

SHIELD = pmw3610-pcb
BOARD = seeeduino_xiao_ble
DRV_NAME = XIAO
KBD_PID = 615e					# product id

# abs path to this makefile
mkpath = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: build flash info

flash: build info
	@echo '::'
	@echo -n ':: Flashing: '
	@find $$(pwd) -name *.uf2 | xargs ls -l | cut -d ' ' -f 6-
	@echo -n '::           '
	@find $$(pwd) -name *.uf2 | xargs file -b | cut -d ',' -f 1,2
	@echo ':: DOUBLE CLICK RESET BUTTON ON XIAO!!'
	@until mount | grep --quiet ${DRV_NAME}; do echo -n '.'; sleep 1; done; echo
	@-west flash 2> /dev/null
	@sleep 1
	@echo -n ':: '
	@timeout 5s sh -c "until grep --ignore-case --fixed-strings '${SHIELD}' /proc/bus/input/devices | cut -d ' ' -f 2-; do sleep 1; done"
	@cyme | grep ${KBD_PID}
	@echo ':: done flashing.'

build: info
	[ -z $${ZEPHYR_BASE} ] && west zephyr-export
	[ ! -d ${mkpath}/zmk-modules/zmk-pmw3610-driver ] && git clone https://github.com/badjeff/zmk-pmw3610-driver.git ${mkpath}/zmk-modules/zmk-pmw3610-driver
	west build  --pristine \
	            --board ${BOARD} \
	            --  -DSHIELD=${SHIELD} \
	                -DZMK_CONFIG='${mkpath}/config' \
	                -DZMK_EXTRA_MODULES='${mkpath}/zmk-modules/zmk-pmw3610-driver'
	@echo -n ':: '
	@find $$(pwd) -name *.uf2 | xargs ls -l | cut -d ' ' -f 6-

info:
	@echo -n ':: Reading: '
	@find $$(pwd) -maxdepth 1 -name $(firstword $(MAKEFILE_LIST)) | xargs ls -l | cut -d ' ' -f 8-
	@echo '::   Board:   '${BOARD}
	@echo '::   Shield:  '${SHIELD}
	@echo '::   KBD_PID: '${KBD_PID}
	@echo ' '$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

