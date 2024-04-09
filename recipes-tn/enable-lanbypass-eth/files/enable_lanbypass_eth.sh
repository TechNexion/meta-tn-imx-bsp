#!/bin/bash

generate_clock () {
	while true
	do
		gpioset ${1} ${2}=0
		sleep 0.2
		gpioset ${1} ${2}=1
		sleep 0.2
	done
}

GPIO_CHIP=$(gpiofind "LANBYPASS_gen_clock"| cut -d ' ' -f 1)
GPIO_NUM=$(gpiofind "LANBYPASS_gen_clock"| cut -d ' ' -f 2)

generate_clock ${GPIO_CHIP} ${GPIO_NUM} &

sleep 5
