#!/bin/bash

./caffe.bin train -solver=./asdf_solver.prototxt -gpu=0 -snapshot=./asdf_iter_80000.solverstate

