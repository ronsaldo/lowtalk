#!/bin/bash

wget -O- get.pharo.org/61+vm | bash

./pharo-ui Pharo.image st scripts/loadImage.st

