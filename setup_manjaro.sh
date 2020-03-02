#!/bin/bash

# https://manjaro.org/download/official/gnome/

sudo pacman-mirrors -c China
sudo pacman -Sc
sudo pacman -Syyu

sudo pacman -S net-tools


