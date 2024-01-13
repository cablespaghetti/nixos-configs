#!/usr/bin/env bash
nixos-rebuild --flake .#$(hostname) switch
