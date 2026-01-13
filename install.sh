
#!/bin/bash

# Install Haxe
apt update
apt install sudo software-properties-common -y
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib

# Install SDK dependencies
apt install bash clang-15 lld-15 socat cmake meson pkg-config wget unzip git -y

# Install SDK
DEFAULT_SDK_PATH="/opt/ps5-payload-sdk"
installSDK="true"
if [[ -d "$DEFAULT_SDK_PATH" ]]; then
  installSDK="null"
  while [ "$installSDK" == "null" ]
  do
     echo "It looks like you seem to have the PS5 SDK installed, would you like to refresh the installation? (y/n)"
     read wantRefreshSDK

     if [ "$wantRefreshSDK" == "y" ]; then
       installSDK="true"
     elif [ "$wantRefreshSDK" == "n" ]; then
       installSDK="false"
     else
       echo "Invalid input, please try again."
     fi
  done
else
  echo "SDK is not installed."
fi

if [[ "$installSDK" == "true" ]]; then
    # Remove SDK
    rm -r $DEFAULT_SDK_PATH

    # Install Latest SDK
    wget -P /opt https://github.com/ps5-payload-dev/sdk/releases/latest/download/ps5-payload-sdk.zip
    sudo unzip -d /opt /opt/ps5-payload-sdk.zip
fi

# Install Haxe Libraries
haxelib git crypto https://github.com/HaxeFoundation/crypto
haxelib git haxe-crypto https://github.com/barisyild/haxe-crypto
haxelib git hxvm-lua https://github.com/kevinresol/hxvm-lua
haxelib git linc_lua https://github.com/kevinresol/linc_lua
haxelib install haxe-concurrent 5.1.4
haxelib install hscript 2.6.0
haxelib install rulescript 0.2.0
haxelib install uuid

# Install HXCPP
mkdir -p ~/haxelib/hxcpp
if [ ! -d "$HOME/haxelib/hxcpp/ps5-payload" ]; then
  git clone https://github.com/barisyild/hxcpp/ --branch ps5-payload ~/haxelib/hxcpp/ps5-payload
  echo ps5-payload > ~/haxelib/hxcpp/.current
else
  cd ~/haxelib/hxcpp/ps5-payload/ && git pull
fi
cd ~/haxelib/hxcpp/ps5-payload/tools/hxcpp/ && haxe compile.hxml
