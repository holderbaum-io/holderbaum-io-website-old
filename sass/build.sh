#!/bin/bash

function compile_stylesheets {
  vendor/wt compile sass/main.scss --build=static/css --style="nested"
}

compile_stylesheets

while true;
do 
  inotifywait -e move_self,modify sass/*
  compile_stylesheets
done
