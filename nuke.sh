#!/bin/bash

# File
nukecontrol=/var/lock/piban

# Give a notice
esc=$'\033'
echo "$esc[0;47;30mQueued nuke of $esc[36m$1$esc[30m at `date`.$esc[0m" | tee -a /tmp/nuke.log

# Work within a critical section
(
  # Gain an exclusive lock
  flock -x 152

  # Give notice
  echo "$esc[0;47;30mNuking $esc[36m$1$esc[30m.$esc[0m" | tee -a /tmp/nuke.log
  gpio -g mode 17 out
  gpio -g write 17 1

  # Start the search for bad blocks
  badblocks -ws -o "/var/log/badblocks-`date +%Y%m%dT%H%M%S`.log" "$1" >> /tmp/nuke.log 2>&1

  # Start wiping the disk
  echo "$esc[0;47;30mWiping $esc[36m$1$esc[30m. Progress will only display when fully completed.$esc[0m" | tee -a /tmp/nuke.log
  nwipe --autonuke --nogui --nowait "$1" >> /tmp/nuke.log 2>&1

  # Safety measure
  sync

  # Kill it
  udisks --detach $1

  # Cut the LED
  gpio -g write 17 0

  # Update again
  echo "$esc[0;47;30mFinished with $esc[36m$1$esc[30m at `date`.$esc[0m" | tee -a /tmp/nuke.log
) 152>$nukecontrol
