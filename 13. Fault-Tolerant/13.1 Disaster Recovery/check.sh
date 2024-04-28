#!/bin/bash

nc -zv localhost 80 1> /dev/null 2>&1 && test -f /var/www/html/index.html