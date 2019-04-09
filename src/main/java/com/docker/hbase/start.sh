#!/bin/bash


docker run -it --name hbase -p 50070:50070 hbase /init.sh -bash

