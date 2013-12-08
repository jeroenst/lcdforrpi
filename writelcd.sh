#!/bin/bash
sudo /usr/domotica/lcd/lcd.py "Welkom `head /tmp/dhcpname`" Huiskamer=`cat /tmp/temperature.xml | grep "<livingroom>" | sed "s/<\/.*//;s/.*>//"` Buiten=`cat /tmp/temperature.xml | grep "<outside>" | sed "s/<\/.*//;s/.*>//"` Power=`cat /tmp/smartmeter.xml | grep "<Electricity_Usage>" | sed "s/<\/.*//;s/.*>//"`W


