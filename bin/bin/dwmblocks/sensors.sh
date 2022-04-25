#!/usr/bin/env bash

echo " $(sensors | awk '/^temp1:/{print $2}')"
