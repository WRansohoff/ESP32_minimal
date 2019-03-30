# Overview

This is an example 'bare metal' ESP32 project which does not use the ESP-IDF libraries.

But for now, I think that it does rely on the ESP-IDF's way of loading code from Flash; you should flash an ESP-IDF project with the default 'single app' partition table before trying to run this program.

You also need to format the resulting binary image first with `esptool` before uploading it:

`esptool --chip esp32 elf2image --flash_mode="dio" --flash_freq "40m" --flash_size "4MB" -o main.bin main.elf`

And you'll also need to use `esptool` to upload the program to your chip (replace `/dev/TTYUSB0` with whatever port your ESP32 enumerates as):

`esptool --chip esp32 --port /dev/ttyUSB0 --baud 115200 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 main.bin`

So this technically might not count as a 'bare metal' example with so many ESP-IDF dependencies, but it's a first step towards learning what goes on under the hood in ESP-IDF.

The '.cfg' files are from Espressif's port of OpenOCD, and the 'gdbinit' script is just a quick way to start a debugging session. This program doesn't have any external indications that it is working, so you'll need to step through it in a debugger if you want to verify that the system booted and the test variable is actually incrementing.
