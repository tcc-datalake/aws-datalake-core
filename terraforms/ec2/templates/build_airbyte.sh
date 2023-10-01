#!/bin/bash
sudo curl -sSL https://get.docker.com/ | sudo sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mkdir airbyte && cd airbyte
sudo wget https://raw.githubusercontent.com/airbytehq/airbyte/master/run-ab-platform.sh
sudo chmod +x run-ab-platform.sh
sudo ./run-ab-platform.sh -b