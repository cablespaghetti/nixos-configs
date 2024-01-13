#!/bin/bash
nixos-rebuild --flake .#$(hostname) switch
