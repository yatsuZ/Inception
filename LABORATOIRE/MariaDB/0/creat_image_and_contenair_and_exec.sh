#!/bin/sh

docker build -t image_test .
if [ $? -eq 0 ]; then
    exit 1
fi


echo "Vouloir manipuler directement la vm ? (y/n)"
read go_in
echo "run en detache ? (y/n)"
read answer

if [ "$answer" = "y" ]; then
	docker run -d --name contenair_test image_test
	if ["$go_in" = "y"]; then
		docker exec -it contenair_test sh sh
	fi
else
	if ["$go_in" = "y"]; then
		docker run -it --name contenair_test image_test
	else
		docker run --name contenair_test image_test
	fi
fi
