#!/bin/bash

# <!-- IGNORE: This line is intentional DO NOT MODIFY --><pre><script>document.querySelector('body').firstChild.textContent = '#!/bin/bash'</script>

# "Get Fleek Network" is an attempt to make our software more accessible.
# By providing scripts to automate the installation process of our software,
# we believe that it can help improve the onboarding experience of our users.
#
# Quick install: `curl https://get.fleek.network | bash`
#
# This script automates the process illustrated in our guide "Running a Node in a Docker container"
# advanced users might find better to follow the instructions in the guide
# if that's your preference, go ahead and check our guides https://docs.fleek.network
#
# For the users happy to have the script assist in the installation process of Fleek Network
# and the required dependencies, run the script at your own risk. Part of the project will
# verify if certain dependencies are installed, or needed but it won't try to customise or
# take into consideration your custom environment. If you have a custom environment, then
# is best to follow the instructions providing in our guide, as other wise risk changing
# or overriding your custom setup.
#
# This script will:
# - Check if the system has enough disk space and memory, otherwise warn the user
# - Verify is user is in Docker as Docker in Docker not supported
# - Verify if Git is installed, if not install it
# - It'll do a quick health check to confirm Git is installed correctly 
# - Verify if Docker is installed, if not install it
# - It'll do a quick health check to confirm Docker is installed correctly
# - Request a pathname where to store the Ursa repository, otherwise providing a default,
#   e.g., `$HOME/fleek-network/ursa`
# - Pull the `ursa` project repository to the preferred target directory via HTTPS
#   instead of SSH for simplicity
# - Optionally, assist on setting up and securing domain name via SSL/TLS
# - Run the Docker stack
# - Do a health check to confirm the Fleek Network Node is running
#
# Found an issue? Report it here: https://github.com/fleek-network/get.fleek.network

# Default
defaultUrsaHttpsRespository="https://github.com/fleek-network/ursa.git"
defaultUrsaPath="$HOME/fleek-network/ursa"
defaultUrsaNightlyImage="ghcr.io/fleek-network/ursa:nightly"
defaultDockerFullNodeRelativePath="./docker/full-node"
defaultDockerComposeYmlRelativePath="$defaultDockerFullNodeRelativePath/docker-compose.yml"
defaultMinMemoryBytesRequired=8000000
defaultMinDiskSpaceBytesRequired=10000000

# Installer state
statusComplete="complete"
installationStatus=""

# Installer script dependencies
# e.g. jq as used to iterate the config
declare -a dependencies=("jq")

# Config (json)
config='{
  "dependencies": [
    {
      "name": "Yq - Cli YAML, JSON, XML, CSV",
      "bin": "yq",
      "pkgManager": {
        "arch": {
          "pkg": "go-yq",
          "name": "pacman"
        },
        "debian": {
          "pkg": "yq",
          "name": "snap"
        },
        "ubuntu": {
          "pkg": "yq",
          "name": "snap"
        }
      }
    },
    {
      "name": "Whois - Internet domain name and network number directory service",
      "bin": "whois",
      "pkgManager": {
        "arch": {
          "pkg": "whois",
          "name": "pacman"
        },
        "debian": {
          "pkg": "whois",
          "name": "apt-get"
        },
        "ubuntu": {
          "pkg": "whois",
          "name": "apt-get"
        }
      }
    },
    {
      "name": "tldextract-rs cli - extract tld info from url",
      "bin": "tldextract",
      "pkgManager": {
        "arch": {
          "pkg": "tldextract",
          "name": "pip"
        },
        "debian": {
          "pkg": "tldextract",
          "name": "apt-get"
        },
        "ubuntu": {
          "pkg": "tldextract",
          "name": "apt-get"
        }
      }
    },
    {
      "name": "dig - DNS lookup utility",
      "bin": "dig",
      "pkgManager": {
        "arch": {
          "pkg": "dnsutils",
          "name": "pacman"
        },
        "debian": {
          "pkg": "dnsutils",
          "name": "apt-get"
        },
        "ubuntu": {
          "pkg": "dnsutils",
          "name": "apt-get"
        }
      }
    }
  ]
}'

# Style utils
txtPrefixForBold=$(tput bold)
txtPrefixForNormal=$(tput sgr0)

# Confirm validators
confirmDomainName() {
  local validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

  if whois "$1" | grep -Ei '[Uu]nallocated|returned 0 objects' > /dev/null; then
    return 1
  fi

  [[ $1 =~ $validate ]]
}

confirmIpAddress() {
  local validate="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"

  [[ "$1" =~ $validate ]] && ping -c1 -W1 "$1" > /dev/null
}

confirmEmailAddress() {
  local validate="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"

  [[ "$1" =~ $validate ]]
}

confirm() {
  case $1 in
    [yY])
      echo 0
      ;;
    [yY][eE][sS])
      echo 0
      ;;
    [nN])
      echo 1
      ;;
    [nN][oO])
      echo 1
      ;;
  esac;
}

resetStyles() {
  echo "${txtPrefixForNormal}"
}

exitInstaller() {
  resetStyles
  exit 1;
}

hasCommand() {
  command -v "$1" >/dev/null 2>&1
}

clearScr() {
  printf '\e[H\e[2J'
}

launchAsciiArt() {
  printf "\r\n"

# the cat and ascii art (ART, as `here tag``)
# is intentionally positioned to the most left
# do not change
cat << "ART"
★★★★★★★★★
★★★★★★★★★
★★★★★★★★★

⚡️ The Fleek Network team presents ⚡️

        _..._
      .'     '.     _
    /    .-""-\   _/ \
  .-|   /:.   |  |   |
  |  \  |:.   /.-'-./
  | .-'-;:__.'    =/
  .'=  *=|URSA _.='
  /   _.  |    ;
  ;-.-'|    \   |
/   | \    _\  _\
\__/'._;.  ==' ==\
        \    \   |
        /    /   /
        /-._/-._/
        \   `\  \
          `-._/._/
ART
# 👆 ART (here tag) end positioned to the most left intentionally

  echo
  echo "⭐️ Ursa, a Decentralized Content Delivery Network (DCDN) ⭐️"
  echo
  echo "★★★★★★★★★ 🌍 ${txtPrefixForBold}Website ${txtPrefixForNormal}https://fleek.network"
  echo "★★★★★★★★★ 📚 ${txtPrefixForBold}Documentation ${txtPrefixForNormal}https://docs.fleek.network"
  echo "★★★★★★★★★ 💾 ${txtPrefixForBold}Git repository ${txtPrefixForNormal}https://github.com/fleek-network/ursa"
  echo "★★★★★★★★★ 🤖 ${txtPrefixForBold}Discord ${txtPrefixForNormal}https://discord.gg/fleekxyz"
  echo "★★★★★★★★★ 🐤 ${txtPrefixForBold}Twitter ${txtPrefixForNormal}https://twitter.com/fleek_net"
  echo "★★★★★★★★★ 🎨 ${txtPrefixForBold}Ascii art by ${txtPrefixForNormal}https://www.asciiart.eu"
}


asciiArtNoOSSupport() {
# the cat and ascii art (ART, as `here tag``)
# is intentionally positioned to the most left
# do not change
cat << "ART"
.     .       .  .   . .   .   . .    +  .
  .     .  :     .    .. :. .___---------___.
       .  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
    .  :       .  .  .:../:            . .^  :.:\.
        .   . :: +. :.:/: .   .    .        . . .:\
 .  :    .     . _ :::/:               .  ^ .  . .:\
  .. . .   . - : :.:./.                        .  .:\
  .      .     . :..|:                    .  .  ^. .:|
    .       . : : ..||        .                . . !:|
  .     . . . ::. ::\(                           . :)/
 .   .     : . : .:.|. ######              .#######::|
  :.. .  :-  : .:  ::|.#######           ..########:|
 .  .  .  ..  .  .. :\ ########          :######## :/
  .        .+ :: : -.:\ ########       . ########.:/
    .  .+   . . . . :.:\. #######       #######..:/
      :: . . . . ::.:..:.\           .   .   ..:/
   .   .   .  .. :  -::::.\.       | |     . .:/
      .  :  .  .  .-:.":.::.\             ..:/
 .      -.   . . . .: .:::.:.\.           .:/
.   .   .  :      : ....::_:..:\   ___.  :/
   .   .  .   .:. .. .  .: :.:.:\       :/
     +   .   .   : . ::. :.:. .:.|\  .:/|
     .         +   .  .  ...:: ..|  --.:|
.      . . .   .  .  . ... :..:.."(  ..)"
 .   .       .      :  .   .: ::/  .  .::\
ART
# 👆 ART (here tag) end positioned to the most left intentionally

  echo
  echo "👾 Alien technosignature detected around our stars 👾"
  echo

  sleep 3
}

requestAuthorizationAndExec() {
  printf -v prompt "\n🤖 %s (y/n)?" "$1"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ "$answerToLc" == [nN] || "$answerToLc" == [nN][oO] ]]; then
    printf "\n\n"

    showErrorMessage "$2"

    exitInstaller
  fi

  printf "\n\n"

  $3
}

onExitInstallerTodos() {
  resetStyles
}

onInterruption() {
  # Only show warning message if install NOT complete
  if [[ "$installationStatus" != "$statusComplete" ]]; then
    printf "\r\n"
    echo "😬 Ouch! The installation was interrupted and there might be applications or dependencies lying around! E.g., if the installation has already cloned the Ursa repository to your selected path, then you should clear it manually, etc."
    echo
    echo "If you're finding issues and need support, share your experience in our Discord at https://discord.gg/fleekxyz"

    onExitInstallerTodos
    exit 1
  fi

  onExitInstallerTodos
  exit 0
}

toLowerCase() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

showOkMessage() {
  printf "\r\n✅ %s\n" "$1"  
}

showErrorMessage() {
  printf "\r\n🚩 %s\n" "$1" >&2
}

showHintMessage() {
  printf "\r\n💡 %s\n" "$1"  
}

showDisclaimer() {
  # Display artwork
  launchAsciiArt

  printf "\r\n\n"
  echo "⭐️ The assisted installer follows the steps in our guide ${txtPrefixForBold}Running a Node in a Docker container${txtPrefixForNormal}."
  echo
  echo "If you are happy to have the script assist you in the installaton, there's a certain level of trust that you have to consider, as it instruct commands in your behalf, such as like installing Git, Docker or other third-party related dependencies. With that considered, we'll ask when dependencies are missing and if happy to proceed with the installation, before commands are executed."
  echo
  echo "Our script source is open to everybody and can be verified at https://github.com/fleek-network/get.fleek.network, give it a look 👀."
  echo
  echo "🤓 One more thing, your system ${txtPrefixForBold}User ${txtPrefixForNormal}should have ${txtPrefixForBold}write permissions ${txtPrefixForNormal}to install applications. Also, some advanced users might find better to follow the documentation in our official guides, or borrow from the installation script source code."
  echo "If that's your preference, then go ahead and check our guides at https://docs.fleek.network, or our repository https://github.com/fleek-network/get.fleek.network"

  printf -v prompt "\n\n🤖 Are you happy to continue (y/n)?\nType Y to continue. Otherwise, N to quit!"
  while read -rp "$prompt"$'\n> ' ans; do
    data=$(confirm "$ans")

    [[ ! $data ]] && continue

    if [[ "$data" -eq 1 ]]; then
      echo
      echo "🦖 The installation assistant terminates here, as you're required to accept in order to have the assisted installer guide you. If you've changed your mind, try again!"
      echo
      echo "Otherwise, if you'd like to learn a bit more visit our website at https://fleek.network"
      echo

      exitInstaller
    elif [[ "$data" -eq 0 ]]; then
      break
    fi
  done
}

commonWarningMessage() {
  echo "While we hope to provide support for a wide range of devices and systems in the future, there are countless theories and reported sightings of life from other galaxies that we'll visit first..."
  echo "Information could be declassified by officials as a means of preparing the public for the impending disclosure of the Node presence on Earth, so follow us on Twitter to stay informed https://twitter.com/fleek_net"
  echo
  echo "In any case, check our guides to learn how to run it yourself through Docker or natively for testing. Although, if you are serious about running a Network Node, then you'll need a dedicate machine to run the Node in the long term, which is why Linux server is the recommended and supported choice!"
  echo
  echo "If you'd like to learn more visit our documentation site at https://docs.fleek.network"
}

windowsUsersWarning() {
  asciiArtNoOSSupport
  echo "⚠️ Windows is not supported by our installer! We recommend linux Server edition, such as Ubuntu or Debian."
  echo "If not, enable ${txtPrefixForBold}Windows Subsystem Linux (WSL)${txtPrefixForNormal} and install Ubuntu or Debian."
  echo
  commonWarningMessage
}

macOsUsersWarning() {
  asciiArtNoOSSupport
  echo "⚠️ MacOS is not supported by our installer! We recommend linux Server edition, such as Ubuntu or Debian."
  echo
  echo "The macOS is a graphical OS, and as of 21 April 2022, Apple has discontinued macOS Server."
  echo
  commonWarningMessage
}

getJQPropertyValue() {
  echo "${1}" | base64 --decode | jq -r "${2}"
}

installGit() {
  os=$(identifyOS)

  if [[ "$os" == "linux" ]]; then
    distro=$(identifyDistro)

    if [[ "$distro" == "ubuntu" ]] || [[ "$distro" == "debian" ]]; then
      sudo apt-get install git
    elif [[ "$distro" =~ "arch"  ]]; then
      sudo pacman -Syu git
    else
      showErrorMessage "Oops! Your operating system ($os, $distro) is not supported yet by our install script, to install on your own read our guides at https://docs.fleek.network"

      exitInstaller
    fi
  else
    showErrorMessage "Oops! Your operating system ($os) is not supported yet by our install script, to install on your own read our guides at https://docs.fleek.network"

    exitInstaller
  fi
}

identifyOS() {
  unameOut="$(uname -s)"

  case "${unameOut}" in
      Linux*)     os=Linux;;
      Darwin*)    os=Mac;;
      CYGWIN*)    os=Cygwin;;
      MINGW*)     os=MinGw;;
      *)          os="UNKNOWN:${unameOut}"
  esac

  osToLc=$(toLowerCase "$os")

  echo "$osToLc"
}

isOSSupported() {
  if [[ "$1" == "cygwin" ]] || [[ "$1" == "mingw" ]]; then
    printf "\n"

    windowsUsersWarning

    exitInstaller
  fi

  if [[ "$1" == "mac" ]]; then
    printf "\n"

    macOsUsersWarning

    exitInstaller
  fi

  if [[ "$1" == "ubuntu" ]]; then
    currVersion=$(lsb_release -r -s | tr -d '.')

    if [[ "$currVersion" -lt "2204" ]]; then
      echo
      echo "👹 Oops! You'll need Ubuntu 22.04 at least."
      echo

      exitInstaller
    fi
  fi

  if [[ "$1" == "debian" ]]; then
    currVersion=$(lsb_release -r -s | tr -d '.')

    if [[ "$currVersion" -lt "11" ]]; then
      echo
      echo "👹 Oops! You'll need Debian 11 at least."
      echo

      exitInstaller
    fi
  fi
}

identifyDistro() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo "$ID"

    exit 0
  fi
  
  uname
}

checkSystemHasRecommendedResources() {
  mem=$(awk '/^MemTotal:/{print $2}' /proc/meminfo);
  partDiskSpace=$(df --output=avail -B 1 "$PWD" |tail -n 1)

  if [[ ("$mem" -lt "$defaultMinMemoryBytesRequired") ]] || [[ ( "$partDiskSpace" -lt "$defaultMinDiskSpaceBytesRequired" ) ]]; then
    echo "😬 Oh no! We're afraid that you need at least 8 GB of RAM and 10 GB of available disk space."
    echo
    printf -v prompt "\n\n🤖 Are you sure you want to continue (y/n)?"
    read -r -p "$prompt"$'\n> ' answer

    if [[ "$answer" == [nN] || "$answer" == [nN][oO] ]]; then
      exitInstaller
    fi

    echo "😅 Alright, let's try that but your system definitely seem to be below our recommendations, don't expect it to work correctly..."

    sleep 5

    return 0
  fi
  
  showOkMessage "Great! Your system has enough resources (disk space and memory)"
}

checkIfGitInstalled() {
  if ! hasCommand git; then
    echo "😅 Oops! Git is required and was not found!"
    echo

    requestAuthorizationAndExec \
      "We can start the installation process for you, are you happy to proceed" \
      "You need to have git installed to clone the Fleek Network Ursa repository." \
      installGit

    if [[ "$?" = 1 ]]; then
      showErrorMessage "Oops! Failed to install git."

      exitInstaller
    fi
  fi

  showOkMessage "Nice! Git is installed!"
}

gitHealthCheck() {
  if ! hasCommand git; then
    showErrorMessage "Oops! For some odd reason, git doesn't seem to be installed!"

    exitInstaller
  fi
}

installDocker() {
  os=$(identifyOS)

  if [[ "$os" == "linux" ]]; then
    distro=$(identifyDistro)

    if [[ "$distro" == "ubuntu" ]]; then
      sudo apt-get update
      sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update

      sudo apt-get install \
          docker-ce \
          docker-ce-cli \
          containerd.io \
          docker-compose-plugin \
          docker-compose

      # https://docs.docker.com/build/buildkit/
      sudo mkdir -p /etc/docker
      sudo bash -c 'echo "{
        \"features\": {
          \"buildkit\" : true
          }
        }" > /etc/docker/daemon.json'
    elif [[ "$distro" == "debian" ]]; then
      sudo apt-get update
      sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        dnsutils

      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      sudo apt-get update

      sudo apt-get install \
          docker-ce \
          docker-ce-cli \
          containerd.io \
          docker-compose-plugin \
          docker-compose

      # https://docs.docker.com/build/buildkit/
      sudo mkdir -p /etc/docker
      sudo bash -c 'echo "{
        \"features\": {
          \"buildkit\" : true
          }
        }" > /etc/docker/daemon.json'
    elif [[ "$distro" =~ "arch" ]]; then
      sudo pacman -Syu gnome-terminal docker docker-compose

      sudo systemctl enable docker.service

      latestKernel=$(pacman -Q linux)
      currentKernel=$(uname -r)

      if [[ "$latestKernel" != "$currentKernel" ]]; then
        echo "✋ We just found that you need to reboot!"
        echo "The reason is that you have a pending kernel upgrade as your system is $currentKernel and pacman's query has $latestKernel"
        echo
        echo "If docker fails to start, then is very likely that is related to this."
        echo "Our suggestion is to reboot your system first, and only afterwards run the installer."
        echo

        read -rp "Press ENTER to continue... "
      fi
    else
      showErrorMessage "Oops! Your Linux distro is not supported yet by our install script, you can also contribute and help us provide support by opening a PR in https://github.com/fleek-network/get.fleek.network, otherwise to install on your own read our guides at https://docs.fleek.network"

      exitInstaller
    fi
  else
    showErrorMessage "Oops! Your operating system is not supported yet, to install on your own read our guides at https://docs.fleek.network"

    exitInstaller
  fi
}

checkIfDockerInstalled() {
  if ! hasCommand docker || ! hasCommand docker-compose; then
    printf "😅 Oops! Docker is required and was not found!\n"

    requestAuthorizationAndExec \
      "We can start the installation process for you, are you happy to proceed" \
      "You need to have Docker installed to run the Fleek Network Ursa repository container stack!" \
      installDocker

    if [[ "$?" = 1 ]]; then
      showErrorMessage "Oops! Failed to install docker."

      exitInstaller
    fi
  fi

  showOkMessage "Awesome! Docker is installed!"
}

dockerHealthCheck() {
  if ! hasCommand docker-compose; then
    showErrorMessage "Oops! For some odd reason, docker-compose doesn't seem to be installed!"

    exitInstaller
  fi

  expectedMessage="Hello from Docker"
  res=$(docker run -i --log-driver=none -a stdout hello-world)

  if ! echo "$res" | grep "$expectedMessage" &> /dev/null; then
    showErrorMessage "Oops! The docker daemon should create a container for the hello-world image \
    and output a message, but failed! Check if you are connected to the internet, docker is installed \
    correctly, or the docker hub might be down, etc."

    exitInstaller
  fi

  showOkMessage "Docker health-check passed!"
}

requestPathnameForUrsaRepository() {
  defaultPath="$defaultUrsaPath"
  selectedPath=$defaultPath

  printf -v prompt "\n🤖 We'll save the Ursa source code in the recommended path ${txtPrefixForBold}%s${txtPrefixForNormal}. If you don't have a reason to change the location, stick to the default, keep it easy! \n\nAre you happy to proceed?\nType Y, or press ENTER to continue. Otherwise, N to change it!" "$defaultPath"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ ! "$answerToLc" == "" && "$answerToLc" == [nN] || "$answerToLc" == [nN][oO] ]]; then
    printf -v prompt "\n🙋‍♀️ What path would you like to store the repository?"
    read -r -p "$prompt"$'\n> ' answer
  fi

  if [[ -d "$selectedPath" ]]; then
    showErrorMessage "Oops! The $selectedPath already exists, ensure that the directory is cleared before trying again."

    read -r -p "Press ENTER to retry..." answer

    requestPathnameForUrsaRepository
  fi

  if ! mkdir -p "$selectedPath"; then
    showErrorMessage "Oops! Failed to create the directory $selectedPath, make sure you have the right permissions."

    exitInstaller
  fi

  echo "$selectedPath"
}

cloneUrsaRepositoryToPath() {
  if ! git clone $defaultUrsaHttpsRespository "$1"; then
    showErrorMessage "Oops! Failed to clone the Ursa repository ($defaultUrsaHttpsRespository)"

    exitInstaller
  fi

  showOkMessage "The Ursa repository located at $defaultUrsaHttpsRespository was cloned to $ursaPath!"

  printf "\r\n"
}

restartDockerStack() {
  echo "🤖 The Docker Stack is going to restart. Be patient, please!"
  echo

  # TODO: Use health check instead
  sleep 10
  sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" stop

  showOkMessage "The Docker Stack will now going to start. Be patient, please!"

  # TODO: Use health check instead
  sleep 10
  sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" up -d

  showOkMessage "Great! The Docker Stack has restarted."

  sleep 3
}

showDockerStackLog() {
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"
  echo
  echo "🥳 Great! We have ${txtPrefixForBold}completed${txtPrefixForNormal} the installation!"
  echo
  echo "The Stack should be running now and you can show or hide the log output at anytime."
  echo
  echo "Our Stack logs can be quite verbose, as it shows WARNINGS, INFO, ERRORS, etc."
  echo "It's important to understand what they mean by simply reading our Node Health-check guide"
  echo "https://docs.fleek.network/guides/Network%20nodes/fleek-network-node-health-check-guide"
  echo
  echo "Here are some handy commands to show or hide the logs"
  echo
  echo "  - If you have the Stack running and want to show the logs:"
  echo
  echo "    ${txtPrefixForBold}docker-compose -f ./docker/full-node/docker-compose.yml logs -f${txtPrefixForNormal}"
  echo
  echo "  - Terminate by sending the interrupt signal (SIGNIT) to Docker using the hotkey:"
  echo
  echo "    ${txtPrefixForBold}Ctrl-c${txtPrefixForNormal}"
  echo
  echo "You can Stop or Start the Docker Stack at anytime, for that change the directory to the location where the source code of Ursa is stored (default is $defaultUrsaPath)."
  echo "For example, if you accepted the installation recommendation that is ~/fleek-network/ursa"
  echo
  echo "Then after, run the following commands, to either Start (up) or Stop (down)"
  echo
  echo "  - Start the Docker Stack"
  echo
  echo "    ${txtPrefixForBold}docker-compose -f ./docker/full-node/docker-compose.yml up${txtPrefixForNormal}"
  echo
  echo "  - Stop the Docker Stack"
  echo
  echo "    ${txtPrefixForBold}docker-compose -f ./docker/full-node/docker-compose.yml down${txtPrefixForNormal}"
  echo
  echo "🥹 Seems a lot? All the commands and much more are available in our documentation site!"
  # The extra white space between ✏️ and start of text is intentional and used for alignment
  echo "🤓 Learn how to maintain your Node by visiting our documentation at https://docs.fleek.network"
  echo "🌈 Got feedback? Find our ${txtPrefixForBold}Discord ${txtPrefixForNormal}at https://discord.gg/fleekxyz and ${txtPrefixForBold}Twitter ${txtPrefixForNormal}at https://twitter.com/fleek_net"
  echo
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"

  printf -v prompt "\n🙋‍♀️ Want to see the output for the Docker Stack? Bear in mind that the Network Node Docker Stack is currently running as a background process, displaying logs messages is optional!\nType Y or press ENTER to confirm. Otherwise, type SKIP!"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ "$answerToLc" == [sS][kK][iI][pP] ]]; then
    printf "\r\n"

    echo "🚀 We've now completed the installation process, thanks for your support!"
    echo "🤗 Remember to visit our website ${txtPrefixForBold}https://fleek.network${txtPrefixForNormal} to find documentation, our Discord, Twitter and more to stay updated!"
    echo

    onExitInstallerTodos
    
    exit 0;
  fi

  # whitespace to improve   
  printf "\r\n"
  
  echo "👋 Hey! Just a quick hint!"
  echo
  echo "The Stack Logs can be quite long and verbose, but ${txtPrefixForBold}it's normal!"
  echo
  echo "If that keeps you awake at night, or if you find something interesting present in the Logs, feel free to talk about it in our Discord 🙏"
  echo
  echo "In any case, you'll find that most Log messages ${txtPrefixForBold}can be ignored ${txtPrefixForNormal}at this time."

  read -r -p "Press ENTER to continue... " answer

  sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" logs -f
}

initLetsEncrypt() {
  email="$1"
  domain="$2"

  if [[ -z "$1" || -z "$2" ]]; then
    showErrorMessage "Gosh, this is embarrassing! We're missing arguments to initialise the Lets Encrypt call. If this issue persists, report it to our Discord channel, please! 🙏"

    exitInstaller
  fi

  rsa_key_size=4096
  base_path=./docker/full-node
  config_path="$defaultDockerComposeYmlRelativePath"
  data_path="$defaultDockerFullNodeRelativePath/data/certbot"
  staging=0

  # TODO: Move this checkup much earlier, in the init of installer
  # Do we have the required files, if not interrupt the process?
  if [[ ! -d "$base_path" || ! "$(ls -A $base_path)" ]]; then
    showErrorMessage "Oops! Missing required files, this might be due to changes in our main Ursa repository! Help us improve by letting us know in our Discord channel 🙏"

    exitInstaller
  fi

  if [[ ! -e "$data_path/conf/options-ssl-nginx.conf" || ! -e "$data_path/conf/ssl-dhparams.pem" ]]; then
    echo
    echo "🤖 Downloading recommended TLS parameters..."
    echo

    mkdir -p "$data_path/conf"

    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
    echo
  fi

  echo
  echo "🤖 We'll now create dummy certificates for the domain $domain, be patient 🙏 please..."
  echo

  path="/etc/letsencrypt/live/$domain"
  mkdir -p "$data_path/conf/live/$domain"

  if ! docker-compose -f "$config_path" \
    run --rm --entrypoint "\
    openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
      -keyout '$path/privkey.pem' \
      -out '$path/fullchain.pem' \
      -subj '/CN=localhost'" certbot; then    
    showErrorMessage "Oops! Failed to create dummy certificate for domain"

    exitInstaller
  fi

  echo
  echo "🤖 Starting Nginx, please be patient 🙏"
  echo

  if ! docker-compose -f "$config_path" up --force-recreate -d nginx; then
    showErrorMessage "Oops! Failed to start nginx..."

    exitInstaller
  fi
  
  echo
  echo "🤖 Deleting dummy certificate for $domain..."
  echo

  if ! docker-compose -f "$config_path" \
    run --rm --entrypoint "\
    rm -Rf /etc/letsencrypt/live/$domain && \
    rm -Rf /etc/letsencrypt/archive/$domain && \
    rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot; then

    showErrorMessage "Oops! Failed to delete dummy certificates for $domain..."

    exitInstaller
  fi

  echo
  echo "🤖 Requesting the Let's Encrypt certificates for $domain..."
  echo

  # Enable staging mode if needed
  if [ $staging != "0" ]; then staging_arg="--staging"; fi

  if ! docker-compose -f "$config_path" run --rm --entrypoint "\
    certbot certonly --webroot -w /var/www/certbot \
      $staging_arg \
      --email $email \
      --domain $domain \
      --rsa-key-size $rsa_key_size \
      --agree-tos -n \
      --force-renewal" certbot; then
    showErrorMessage "Oops! Failed to create the SSL/TLS certificates, your domain name hasn't been secured yet. Check our guide to troubleshoot https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    printf -v prompt "\n💡 We recommend to try again, as some temporary issues might have occurred.\n\n🙋‍♀️ Would you like to retry securing the domain?\nType Y, or press ENTER to continue. Otherwise N, to quit!"
    read -r -p "$prompt"$'\n> ' answer

    answerToLc=$(toLowerCase "$answer")

    if [[ "$answerToLc" == "" || "$answerToLc" == [yY] || "$answerToLc" == [yY][eE][sS] ]]; then    
      echo
      echo "💡 If the issues persists then it might be related to the DNS, that you might want to update."
      echo "In most Linux Operating systems, these DNS servers are specified in the file /etc/resolv.conf"
      echo "this file contains at least one nameserver line that defines the DNS server."
      echo
      echo "🤖 We're going to restart the Docker Stack..."
      echo
      sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" down      
      sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" start

      initLetsEncrypt "$email" "$domain"
    fi

    sudo docker-compose -f "$defaultDockerComposeYmlRelativePath" down

    exitInstaller
  fi

  echo
  echo "🤖 Reloading nginx ..."
  echo

  docker-compose -f "$config_path" exec nginx nginx -s reload

  showOkMessage "Great! You have now secured your server with SSL/TLS."
}

installMandatory() {
  hasCommand "$1" && return 0

  printf -v prompt "\n\n🤖 We need to install %s, is that ok (y/n)?\nType Y to continue. Otherwise, N to exit!" "$1"
  while read -rp "$prompt"$'\n> ' answer; do
    data=$(confirm "$answer")

    [[ ! $data ]] && continue

    if [[ "$data" -eq 1 ]]; then
      showErrorMessage "Oops! The $1 is required to be installed."
      exitInstaller
    elif [[ "$data" -eq 0 ]]; then
      break
    fi
  done

  if [[ "$os" == "linux" ]]; then
    distro=$(identifyDistro)
    if [[ "$distro" == "ubuntu" ]] || [[ "$distro" == "debian" ]]; then
      if ! sudo apt update || ! sudo apt-get install "$1"; then
        exitInstaller
      fi
    elif [[ "$distro" =~ "arch"  ]]; then
      ! sudo pacman -Syu "$1" && exitInstaller
    else
      echo "👹 Oh gosh! We're currently not providing support for $distro."
      echo "If you find this to be a bug and we provide support to your OS, report it on our discord channel please 🙏!"
      echo

      exitInstaller
    fi
  fi

  echo "os $os, distro $distro"

  showOkMessage "Installed $1"

  # Add some space after the msg
  printf "\r\n"

  return 0
}

verifyDepsOrInstall() {
  os="$1"
  name="$2"
  bin="$3"
  pkgManager="$4"

  hasCommand "$bin" && return 0

  printf -v prompt "\n\n🤖 We need to install %s, is that ok (y/n)?\nType Y to continue. Otherwise, N to exit!" "$bin"
  while read -rp "$prompt"$'\n> ' answer; do
    data=$(confirm "$answer")

    [[ ! $data ]] && continue

    if [[ "$data" -eq 1 ]]; then
      showErrorMessage "Oops! The $1 is required to be installed."
      exitInstaller
    elif [[ "$data" -eq 0 ]]; then
      break
    fi
  done

  if [[ "$ans" == "" ]]; then
    echo "😅 We need a Yes or a No, just to make sure you're happy to proceed."
    
    read -r -p "Press ENTER to try again..."

    verifyDepsOrInstall "$os" "$name" "$bin" "$pkgManager"
  fi

  if [[ "$os" == "linux" ]]; then
    distro=$(identifyDistro)
    pkgManager=$(echo "$pkgManager" | jq ".$distro")
    pkgManagerName=$(echo "$pkgManager" | jq -r ".name")
    pkg=$(echo "$pkgManager" | jq -r ".pkg")

    if [[ $pkgManager =~ "null" || $pkgManagerName =~ "null" || $pkg =~ "null" ]]; then
      echo "💩 Oh no! Sorry, the installer configuration file is missing some values!"
      echo "LOG: pkgm ($pkgManager), pkgmn ($pkgManagerName), pkg ($pkg)"
      echo
      echo "Help us improve by reporting this issue in our discord channel https://discord.gg/fleekxyz"
      echo "Thanks a lot for your support 🙏"
      echo

      exitInstaller
    fi

    if [[ "$distro" == "ubuntu" || "$distro" == "debian" ]]; then
      if [[ $pkgManagerName == "snap" ]]; then
        if ! hasCommand "snap"; then
          sudo apt-get install snapd
        fi

        if ! sudo snap install "$pkg"; then
          exitInstaller
        fi

        showOkMessage "Installed ($name) via snap"

        # ensure snap is in the PATH and pkgs
        source /etc/profile.d/apps-bin-path.sh

        return 0
      fi

      if ! sudo apt update || ! sudo apt-get install "$pkg"; then
        exitInstaller
      fi

      showOkMessage "Installed ($name) via apt-get"

      return 0
    elif [[ "$distro" =~ "arch"  ]]; then
      if [[ $pkgManagerName == "pip" ]]; then
        if ! hasCommand pip; then 
          sudo pacman --noconfirm -Syu python-pip
        fi

        pip install tldextract==3.4.0

        return 0
      fi

      ! sudo pacman --noconfirm -Syu "$pkg" && exitInstaller

      showOkMessage "Installed ($name) via pacman"
    fi
  fi
}

extactDomainName() {
  name=$(tldextract "$1" | cut -d " " -f 2)
  tld=$(tldextract "$1" | cut -d " " -f 3)

  domain="$name.$tld"

  echo "$domain"
}

verifyUserHasDomain() {
  printf -v prompt "\nDo you have the domain settings ready (y/n)?\nType Y, or press ENTER to confirm."
  read -r -p "$prompt"$'\n> ' ans

  if [[ ! "$ans" == "" && "$ans" == [nN] || "$ans" == [nN][oO] ]]; then
    printf "\n"

    showErrorMessage "Oops! You need a domain name and have the DNS A Record type answer with the server IP address. If you'd like to learn more about it check our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    read -r -p "Press ENTER to continue and try again..."

    verifyUserHasDomain
  fi

  # Domain name handling (start)
  printf -v prompt "\n💡 Provide us your domain name without http:// or https:// e.g., www.example.com or my-node.fleek.network\n\nTell us, what's the domain name?"
  while read -rp "$prompt"$'\n> ' ans; do
    if confirmDomainName "$ans"; then
      userDomainName="$ans"
      break
    fi

    echo "💩 Uh oh! Provide a valid domain name, please..."
  done

  # Ip address handling (start)
  ERROR_IP_ADDRESS_NOT_AVAILABLE="ERROR_IP_ADDRESS_NOT_AVAILABLE"
  detectedIpAddress=$(curl --silent ifconfig.me || curl --silent icanhazip.com || echo "$ERROR_IP_ADDRESS_NOT_AVAILABLE")

  printf -v prompt "\n💡 Provide us the IP address of the machine where you are installing the Node. We've noticed that this machine public IP address is ${txtPrefixForBold}%s ${txtPrefixForNormal}(we'll use it as the default)\n\nLet us know, what's the IP address the domain answers with?\n\nPress ENTER to accept default, or type the IP Address" "$detectedIpAddress"
  while read -rp "$prompt"$'\n> ' ans; do
    if confirmIpAddress "$ans"; then
      serverIpAddress="$ans"
      break
    elif [[ "$ans" == "" ]]; then
      break
    fi

    echo "💩 Uh oh! Provide a valid ip address, please..."
  done

  # Declare detected ip address as default server ip address
  serverIpAddress=${ans:="$detectedIpAddress"}

  if [[ $serverIpAddress = "$ERROR_IP_ADDRESS_NOT_AVAILABLE" ]]; then
    showErrorMessage "Oops! This is embarrassing, but we failed to discover the default IP Address ($ERROR_IP_ADDRESS_NOT_AVAILABLE)"

    exitInstaller
  fi

  # given a name and an ip address, test whether there is a record for name pointing to address
  if ! dig "$userDomainName" +nostats +nocomments +nocmd | tr -d '\t' | grep "A$serverIpAddress" >/dev/null 2>&1 ; then
    showErrorMessage "Oops! The domain name $userDomainName doesn't have a DNS record type A pointing to the ip address $serverIpAddress. Of course, if you've just made the changes, you might need to wait for the DNS settings to propagate. Learn how to setup your domain DNS Records by checking our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    read -r -p "Press ENTER to continue and try again..."

    verifyUserHasDomain
  fi

  # Email handling (start)
  printf -v prompt "💡 Provide us with a valid email address that you have access to,\nrest ensured that we'll not contact you, but its required by Let's Encrypt (Certificate Authority)\n\nIf you'd like to know more about the Let's Encrypt organisation\nvisit their website at https://letsencrypt.org/\n\nTell us, what's your email address?"
  while read -rp "$prompt"$'\n> ' ans; do
    if confirmEmailAddress "$ans"; then
      emailAddress=$(toLowerCase "$ans")
      break
    fi

    echo "💩 Uh oh! Provide a valid email address, please..."
  done

  printf -v prompt "\n🤖 Here are the details you have provided, make sure the information is correct.\n\nDomain name:      %s\nIP Address:     %s\nEmail address:      %s\n\nIs this correct (y/n)?\nType Y or Yes to confirm. Otherwise, N or No to make changes!" "$userDomainName" "$serverIpAddress" "$emailAddress"
  while read -rp "$prompt"$'\n> ' ans; do
    case $ans in
      [yY])
        break
        ;;
      [yY][eE][sS])
        break
        ;;
      [nN])
        verifyUserHasDomain
        break
        ;;
      [nN][oO])
        verifyUserHasDomain
        break
        ;;
    esac;
  done;

  shouldRedo=$(toLowerCase "$answer")

  if [[ "$shouldRedo" == [nN] || "$shouldRedo" == [nN][oO] ]]; then
    verifyUserHasDomain
  fi

  echo "$userDomainName;$emailAddress"

  exit 0
}

replaceNginxConfFileForHttp() {
  echo "
    proxy_cache_path /cache keys_zone=nodecache:100m levels=1:2 inactive=31536000s max_size=10g use_temp_path=off;

    server {
        listen 80;
        listen [::]:80;
        server_name $1;

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }

        location /stub_status {
          stub_status;
        }

        proxy_redirect          off;
        client_max_body_size    10m;
        client_body_buffer_size 128k;
        proxy_connect_timeout   90;
        proxy_send_timeout      90;
        proxy_read_timeout      90;
        proxy_buffers           32 128k;

        location / {
          add_header content-type  application/vnd.ipld.raw;
          add_header content-type  application/vnd.ipld.car;
          add_header content-type  application/octet-stream;
          add_header cache-control public,max-age=31536000,immutable;

          proxy_cache nodecache;
          proxy_cache_valid 200 31536000s;
          add_header X-Proxy-Cache \$upstream_cache_status;
          proxy_cache_methods GET HEAD POST;
          proxy_cache_key \"\$request_uri|\$request_body\";
          client_max_body_size 1G;

          proxy_pass http://ursa:4069;
        }
    }
  " > "$defaultDockerFullNodeRelativePath"/data/nginx/http.conf
}

replaceNginxConfFileForHttps() {
  echo "
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name $1;

        server_tokens off;

        # SSL code
        ssl_certificate /etc/letsencrypt/live/$1/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$1/privkey.pem;

        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

        location /stub_status {
          stub_status;
        }

        location / {
          add_header content-type  application/vnd.ipld.raw;
          add_header content-type  application/vnd.ipld.car;
          add_header content-type  application/octet-stream;
          add_header cache-control public,max-age=31536000,immutable;

          proxy_cache nodecache;
          proxy_cache_valid 200 31536000s;
          add_header X-Proxy-Cache \$upstream_cache_status;
          proxy_cache_methods GET HEAD POST;
          proxy_cache_key \"\$request_uri|\$request_body\";
          client_max_body_size 1G;


          proxy_pass http://ursa:4069;
        }
    }
  " > "$defaultDockerFullNodeRelativePath"/data/nginx/https.conf
}

setupSSLTLS() {
  echo "⚠️ You're ${txtPrefixForBold}required ${txtPrefixForNormal}to have a Domain name point to your server IP address."
  echo
  echo "Visit your domain name registrar's dashboard, or create a new domain, update the A record to have the hostname answer with the server IP address!"
  echo
  # The extra white space between the 🫡 and text is intentional for spacing
  echo "🫡  Make sure you complete this step before proceeding, as we'll verify it!"
  echo "Also, this is important to secure the server communications with SSL/TLS. Take your time!"
  echo
  echo "🙏 If you'd like to learn more about this, check our guide ${txtPrefixForBold}How to secure${txtPrefixForNormal} a Network Node https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"
  printf "\n"

  trimData=$(verifyUserHasDomain | xargs)

  userDomainName=$(echo "$trimData" | cut -d ";" -f 1)
  emailAddress=$(echo "$trimData" | cut -d ";" -f 2)

  if ! rm "$defaultDockerFullNodeRelativePath"/data/nginx/app.conf; then
    showErrorMessage "Oops! Failed to clear the nginx default config. Help us improve, report it in our discord channel 🙏"

    exitInstaller
  fi

  if ! replaceNginxConfFileForHttp "$userDomainName"; then
    showErrorMessage "Oops! Failed to update the http server_name directive in the Nginx reverse proxy with your domain name $userDomainName. Help us improve! Report to us in our Discord channel 🙏"

    exitInstaller
  fi

  chmod +x "$defaultDockerFullNodeRelativePath"/init-letsencrypt.sh

  showOkMessage "Updated the file permissions for Lets Encrypt initialisation script (set +x)!"

  # Intentional, used to provide space after msg
  echo

  # start stack in bg, as lets encrypt will need the nginx to validate
  COMPOSE_DOCKER_CLI_BUILD=1 sudo docker compose -f "$defaultDockerComposeYmlRelativePath" up -d

  # TODO: add health check in the docker compose file

  if ! initLetsEncrypt "$emailAddress" "$userDomainName"; then
    exitInstaller
  fi

  printf "\n"

  if ! replaceNginxConfFileForHttps "$userDomainName"; then
    showErrorMessage "Oops! Failed to update the https server_name directive in the Nginx reverse proxy with your domain name $userDomainName. Help us improve! Report to us in our Discord channel 🙏"

    exitInstaller
  fi
}

changeDirectoryToPathOrFailure() {
  local name=$1
  local targetPath=$2

  if [[ -z "$name" || -z "$targetPath" ]]; then
    showErrorMessage "Oops! Failed to change directory after cloning the repository. Help us improve! Report to us in our Discord channel 🙏"

    exitInstaller
  fi

  if [[ $(pwd) != "$targetPath" ]]; then
    if ! cd "$targetPath"; then
      showErrorMessage "Oops! Our apologies but we've failed to change directory to $name. Help us improve by reporting it to us in our Discord channel 🙏"

      exitInstaller
    fi
  fi
}

onNightlyPreference() {
  echo
  echo "✋ When running the Stack, Docker will have to build the Ursa image from source."
  echo "💡 Our recommendation is to use our Nightly build, as otherwise the image build process can be quite long 😴!"
  echo
  echo "In the future, you can check our documentation and guides to learn how to update this when required."
  echo

  printf -v prompt "\n\n🤖 Are you happy to use the Nightly build (y/n)?\nType Y to accept. Otherwise, N to build from source!"
  while read -rp "$prompt"$'\n> ' ans; do
    data=$(confirm "$ans")

    [[ ! $data ]] && continue

    if [[ "$data" -eq 1 ]]; then
      echo
      echo "🦀 Ok! Rembember, the Ursa image may take some time to build depending on your machine..."
      echo

      break
    elif [[ "$data" -eq 0 ]]; then
      yq -ie 'del(.services.ursa.build)' "$defaultDockerComposeYmlRelativePath" >/dev/null 2>&1
      yq -i ".services.ursa.image = \"$defaultUrsaNightlyImage\"" "$defaultDockerComposeYmlRelativePath" >/dev/null 2>&1

      if ! yq '.services.ursa.image' "$defaultDockerComposeYmlRelativePath" | grep -q "$defaultUrsaNightlyImage" || ! yq '.services.ursa.build' "$defaultDockerComposeYmlRelativePath" | grep -qE "null|no matches found"; then
        echo
        echo "💩 Uh oh! For some reason we failed to change the docker compose yaml to use nightly instead."
        echo "Our apologies but this shouldn't happen! Let us improve by reporting this issue to our discord https://discord.gg/fleekxyz, please 🙏"
        echo

        exitInstaller
      fi

      break
    fi
  done
}

(
  # stdin to keyboard
  exec < /dev/tty;

  # SIGINT listener
  trap onInterruption INT

  # Identity the OS
  os=$(identifyOS)

  isOSSupported "$os"

  # Show disclaimer
  showDisclaimer

  # Had space after disclaimer
  printf "\r\n"

  # Check if system has recommended resources (disk space and memory)
  checkSystemHasRecommendedResources "$os"

  # Check if has dependencies installed
  for dep in "${dependencies[@]}"
  do
    installMandatory "$dep"
  done

  for dep in $(echo "${config}" | jq -r '.dependencies[] | @base64'); do
    name=$(getJQPropertyValue "$dep" ".name")
    bin=$(getJQPropertyValue "$dep" ".bin")
    pkgManager=$(getJQPropertyValue "$dep" ".pkgManager")

    verifyDepsOrInstall "$os" "$name" "$bin" "$pkgManager"
  done

  # We start by verifying if git is installed, if not request to install
  checkIfGitInstalled "$os"

  gitHealthCheck

  # Verify if Docker is installed, if not install it
  checkIfDockerInstalled "$os"

  # Request a pathname where to store the Ursa repository, otherwise provide a default
  ursaPath=$(requestPathnameForUrsaRepository)

  # Check if directory does not exit or empty
  if [[ "$(ls -A "$ursaPath" >/dev/null 2>&1)" ]]; then
    echo
    echo "😅 Gosh! Have you run the installation before?!"
    echo
    echo "The directory $ursaPath is not empty and we'll have to skip the installation, as we don't want to do any overrides."
    echo "If you are stuck on this, clear the desired location before retrying"
    echo "e.g., if you chose to install in the default $defaultUrsaPath clear it, as the assisted installer does not do deletes."

    exitInstaller
  fi

  # Pull the `ursa` project repository to the preferred target directory via HTTPS
  cloneUrsaRepositoryToPath "$ursaPath"
  changeDirectoryToPathOrFailure "Ursa" "$ursaPath"

  # Await a few seconds to let the user read...
  sleep 5

  # Recommend the Nightly build to speed up onboarding
  onNightlyPreference

  # Add some space after the "nightly" request
  printf "\r\n"

  # Optional, check if user would like to setup SSL/TLS
  setupSSLTLS

  showOkMessage "The installation process has completed!"

  # Add some space after the "complete" message
  printf "\r\n"
  
  # Await a few seconds to let the user read...
  sleep 5

  # Restart docker
  restartDockerStack

  # Set installation has complet
  installationStatus="$statusComplete"

  # Add some space after the "docker stack restart" message
  printf "\r\n"

  # Show the logs
  showDockerStackLog
  
  resetStyles
  exit;
)