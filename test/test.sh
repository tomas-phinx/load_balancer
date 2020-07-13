#!/bin/sh

for i in $(seq 1 30)
do
	curl -v -F device_id=device_$i -F image=@./cat.jpg http://localhost:8080/upload &
done

wait