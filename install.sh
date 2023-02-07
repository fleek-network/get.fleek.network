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
#   e.g. `/var/www/fleek-network/ursa`
# - Pull the `ursa` project repository to the preferred target directory via HTTPS
#   instead of SSH for simplicity
# - Optionally, assist on setting up and securing domain name via SSL/TLS
# - Run the Docker stack
# - Do a health check to confirm the Fleek Network Node is running
#
# Found an issue? Report it here: https://github.com/fleek-network/get.fleek.network

# Default
defaultUrsaHttpsRespository="https://github.com/fleek-network/ursa.git"
defaultMinMemoryBytesRequired=8000000
defaultMinDiskSpaceBytesRequired=10000000

# Dependencies
declare -a dependencies=("sudo" "curl" "tldextract" "whois")

# Style utils
txtPrefixForBold=$(tput bold)
txtPrefixForNormal=$(tput sgr0)

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
  echo "★★★★★★★★★ 👩🏾‍💻 ${txtPrefixForBold}Website ${txtPrefixForNormal}https://fleek.network"
  echo "★★★★★★★★★ 📚 ${txtPrefixForBold}Documentation ${txtPrefixForNormal}https://docs.fleek.network"
  echo "★★★★★★★★★ 💾 ${txtPrefixForBold}Git repository ${txtPrefixForNormal}https://github.com/fleek-network/ursa"
  echo "★★★★★★★★★ 🤖 ${txtPrefixForBold}Discord ${txtPrefixForNormal}https://discord.gg/fleekxyz"
  echo "★★★★★★★★★ 🐤 ${txtPrefixForBold}Twitter ${txtPrefixForNormal}https://twitter.com/fleek_net"
  echo "★★★★★★★★★ 🎨 ${txtPrefixForBold}Ascii art by ${txtPrefixForNormal}https://www.asciiart.eu"
}

requestAuthorizationAndExec() {
  printf -v prompt "\n🤖 %s (y/n)?" "$1"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ "$answerToLc" == [nN] || "$answerToLc" == [nN][oO] ]]; then
    printf "\n\n"

    showErrorMessage "$2"

    exit 1;
  fi

  printf "\n"

  $3
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
  echo "🧙‍♀️ The installer is the assisted process illustrated in our guide ${txtPrefixForBold}Running a Node in a Docker container${txtPrefixForNormal}."
  echo
  echo "If you are happy to have the script assist you in the installaton, there's a certain level of trust that you have to consider, as it instruct commands in your behalf."
  echo "With that considered, we'll ask when dependencies are missing and if happy to proceed with the installation, before commands are executed e.g. installing Git, Docker, or any other required or associated dependencies from third-parties, etc."
  echo
  echo "Our script source is open to everybody and can be verified at https://github.com/fleek-network/get.fleek.network"
  echo
  echo "🤓 One more thing, your system ${txtPrefixForBold}User ${txtPrefixForNormal}should have ${txtPrefixForBold}write permissions ${txtPrefixForNormal}to ${txtPrefixForBold}install applications."
  echo "Also, some advanced users might find better to follow the documentation in our official guides, or borrow from the installation script source code."
  echo "If that's your preference, then go ahead and check our guides at https://docs.fleek.network, or our repository https://github.com/fleek-network/get.fleek.network"

  printf -v prompt "\n\n🤖 Are you happy to continue (y/n)?"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ "$answerToLc" == "n" ]]; then
    echo "🦖 The installation assistant terminates here, as you're required to accept in order to have the assisted installer guide you. If you've changed your mind, try again!"
    echo
    echo "Otherwise, if you'd like to learn a bit more visit our website at https://fleek.network"

    exit 1;
  fi
}

windowsUsersWarning() {
  echo "⚠️ Windows is not supported! We recommend enabling ${txtPrefixForBold}Windows Subsystem Linux (WSL)${txtPrefixForNormal} Ubuntu distro."
  echo
  echo "If you'd like to learn more visit our documentation site at https://docs.fleek.network"
}

shouldHaveHomebrewInstalled() {
  if ! hasCommand brew; then
    showErrorMessage "Oops! Homebrew package manager for MacOS is required but not found!"

    printf "\r\n"

    requestAuthorizationAndExec \
      "We can start the installation process for you, are you happy to proceed" \
      "You need to have Homebrew package manager installed on MacOS, as we recommend it to install applications such as Git. You can install it on your own by visiting the Git website https://git-scm.com/ before proceeding..." \
      installHomebrew

    if [[ "$?" = 1 ]]; then
      showErrorMessage "Oops! Failed to install Homebrew."

      exit 1
    fi
  fi

  showOkMessage "[Skipping] Homebrew package manager is installed!"
}

installHomebrew() {
  os=$(identifyOS)

  if [[ "$os" != "mac" ]]; then
    showErrorMessage "Oops! For some odd reason this function was called from the wrong context, as it should only be called for MacOS!"    

    exit 1
  fi  

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

installGit() {
  os=$(identifyOS)

  if [[ "$os" == "mac" ]]; then
    shouldHaveHomebrewInstalled

    brew install git
  elif [[ "$os" == "linux" ]]; then
    distro=$(identifyDistro)

    if [[ "$distro" == "ubuntu" ]] || [[ "$distro" == "debian" ]]; then
      sudo apt-get install git
    elif [[ "$os" == "alpine" ]]; then
      sudo apk add git
    elif [[ "$os" == "arch" ]]; then
      sudo pacman -S git
    else
      showErrorMessage "Oops! Your operating system is not supported yet by our install script, to install on your own read our guides at https://docs.fleek.network"

      exit 1
    fi
  else
    showErrorMessage "Oops! Your operating system is not supported yet by our install script, to install on your own read our guides at https://docs.fleek.network"

    exit 1
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

  if [[ "$osToLc" == "cygwin" ]] || [[ "$osToLc" == "mingw" ]]; then
    printf "\n"

    windowsUsersWarning

    exit 1
  fi

  echo "$osToLc"
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
    printf -v prompt "\n\n🤖 Do you want to continue (y/n)?"
    read -r -p "$prompt"$'\n> ' answer

    answerToLc=$(toLowerCase "$answer")

    if [[ "$answerToLc" == "n" ]]; then
      exit 1;
    fi
  else
    showOkMessage "Great! Your system has enough resources (disk space and memory)"
  fi
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

      exit 1
    fi
  fi

  showOkMessage "Nice! Git is installed!"
}

gitHealthCheck() {
  if ! hasCommand git; then
    showErrorMessage "Oops! For some odd reason, git doesn't seem to be installed!"

    exit 1
  fi
}

installDocker() {
  os=$(identifyOS)

  if [[ "$os" == "mac" ]]; then
    shouldHaveHomebrewInstalled

    brew install docker
  elif [[ "$os" == "linux" ]]; then
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
    elif [[ "$distro" == "alpine" ]]; then
      sudo apk add --update docker openrc
    elif [[ "$distro" == "arch" ]]; then
      sudo pacman -S docker
    else
      showErrorMessage "Oops! Your operating system is not supported yet by our install script, to install on your own read our guides at https://docs.fleek.network"

      exit 1
    fi
  else
    showErrorMessage "Oops! Your operating system is not supported yet, to install on your own read our guides at https://docs.fleek.network"

    exit 1
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

      exit 1
    fi
  fi

  showOkMessage "Awesome! Docker is installed!"
}

dockerHealthCheck() {
  if ! hasCommand docker-compose; then
    showErrorMessage "Oops! For some odd reason, docker-compose doesn't seem to be installed!"

    exit 1
  fi

  expectedMessage="Hello from Docker"
  res=$(docker run -i --log-driver=none -a stdout hello-world)

  if ! echo "$res" | grep "$expectedMessage" &> /dev/null; then
    showErrorMessage "Oops! The docker daemon should create a container for the hello-world image \
    and output a message, but failed! Check if you are connected to the internet, docker is installed \
    correctly, or the docker hub might be down, etc."

    exit 1
  fi

  showOkMessage "Docker health-check passed! [skipping]"
}

requestPathnameForUrsaRepository() {
  defaultPath="$HOME/www/fleek-network/ursa"
  selectedPath=$defaultPath

  printf -v prompt "\n🤖 We'll save the Ursa source code in the recommended path %s\n\nIs the location ok?\n\Type Y, or press ENTER to continue. Otherwise, N to change it!" "$defaultPath"
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

    exit 1
  fi

  echo "$selectedPath"
}

cloneUrsaRepositoryToPath() {
  if ! git clone $defaultUrsaHttpsRespository "$1"; then
    showErrorMessage "Oops! Failed to clone the Ursa repository ($defaultUrsaHttpsRespository)"

    exit 1
  fi

  showOkMessage "The Ursa repository located at $defaultUrsaHttpsRespository was cloned to $ursaPath!"
}

restartDockerStack() {
  showOkMessage "The Docker Stack is going restart. Be patient, please!"

  # TODO: Use health check instead
  sleep 10
  sudo docker-compose -f ./docker/full-node/docker-compose.yml stop

  showOkMessage "The Docker Stack will now going to start. Be patient, please!"

  # TODO: Use health check instead
  sleep 10
  sudo docker-compose -f ./docker/full-node/docker-compose.yml up -d

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
  echo "    docker-compose -f ./docker/full-node/docker-compose.yml logs -f"
  echo
  echo "  - Terminate by sending the interrupt signal (SIGNIT) to Docker using the hotkey:"
  echo
  echo "    Ctrl-c"
  echo
  echo "You can Stop or Start the Docker Stack at anytime, for that change the directory to the location where the source code of Ursa is stored (default is \$HOME/www/fleek-network/ursa)."
  echo "For example, if you accepted the installation recommendation that is ~/www/fleek-network/ursa"
  echo
  echo "Then after, run the following commands, to either Start (up) or Stop (down)"
  echo
  echo "  - Start the Docker Stack"
  echo
  echo "    docker-compose -f ./docker/full-node/docker-compose.yml up"
  echo
  echo "  - Stop the Docker Stack"
  echo
  echo "    docker-compose -f ./docker/full-node/docker-compose.yml down"
  echo
  echo "👋 Seems a lot? All the commands and much more are available in our documentation site!"
  # The extra white space between ✏️ and start of text is intentional and used for alignment
  echo "🤓 Learn how to maintain your Node by visiting our documentation at https://docs.fleek.network"
  echo "🌈 Got feedback? Find our ${txtPrefixForBold}Discord ${txtPrefixForNormal}at https://discord.gg/fleekxyz and ${txtPrefixForBold}Twitter ${txtPrefixForNormal}at https://twitter.com/fleek_net"
  echo
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"
  echo "★★★★★★★★★"

  printf -v prompt "\n🙋‍♀️ Want to see the output for the Docker Stack?\n\Type Y or press ENTER to confirm. Otherwise, N to make changes!"
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ "$answerToLc" == [nN] ]]; then
    printf "\r\n"

    showOkMessage "We've now completed the installation process, thank you!"

    exit 0;
  fi
  
  echo "👋 Hey! Just a quick hint!"
  echo
  echo "The Stack Logs can be quite long and verbose, but ${txtPrefixForBold}it's normal!"
  echo
  echo "If that keeps you awake at night, or if you find something interesting present in the Logs, feel free to talk about it in our Discord 🙏"
  echo
  echo "In any case, you'll find that most Log messages ${txtPrefixForBold}can be ignored ${txtPrefixForNormal}at this time."

  read -r -p "Press ENTER to continue... " answer

  sudo docker-compose -f ./docker/full-node/docker-compose.yml logs -f
}

initLetsEncrypt() {
  if ! cd ./docker/full-node; then
    showErrorMessage "Oops! Failed to open the directory for the docker configuration files. Help us improve! Report to us in our Discord channel 🙏"

    exit 1
  fi

  if ! EMAIL="$1" DOMAINS="$2" ./init-letsencrypt.sh; then
    showErrorMessage "Oops! Failed to create the SSL/TLS certificates, your domain name hasn't been secured yet. Check our guide to troubleshoot https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    cd ../../

    printf -v prompt "\n💡 We recommend to try again, as some temporary issues might have occurred.\n\n🙋‍♀️ Would you like to retry securing the domain?\n\Type Y, or press ENTER to continue. Otherwise N, to quit!"
    read -r -p "$prompt"$'\n> ' answer

    answerToLc=$(toLowerCase "$answer")

    if [[ "$answerToLc" == "" || "$answerToLc" == [yY] || "$answerToLc" == [yY][eE][sS] ]]; then    
      initLetsEncrypt "$EMAIL" "$DOMAINS"
    fi

    sudo docker-compose -f ./docker/full-node/docker-compose.yml down

    exit 1
  fi

  cd ../../

  showOkMessage "Great! You have now secured your server with SSL/TLS."
}

verifyDepsOrInstall() {
  if ! hasCommand "$1"; then
    apt-get update
    apt-get install "$1" -y

    showOkMessage "Installed $1"
  fi
}

extactDomainName() {
  name=$(tldextract "$1" | cut -d " " -f 2)
  tld=$(tldextract "$1" | cut -d " " -f 3)

  domain="$name.$tld"

  echo "$domain"
}

# TODO: Recursion needs to be tested for each of the fn
# TODO: ENTER key needs to be tested along Y, post N and recursion
verifyUserHasDomain() {
  printf -v prompt "\nDo you have the domain settings ready (y/n)?\n\Type Y, or press ENTER to confirm."
  read -r -p "$prompt"$'\n> ' answer

  answerToLc=$(toLowerCase "$answer")

  if [[ ! "$answerToLc" == "" && "$answerToLc" == [nN] || "$answerToLc" == [nN][oO] ]]; then
    printf "\n"

    showErrorMessage "Oops! You need a domain name and have the DNS A Record type answer with the server IP address. If you'd like to learn more about it check our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    printf -v prompt "\nPress ENTER to continue and try again..."
    read -r -p "$prompt"$'\n> ' answer

    verifyUserHasDomain
  fi

  printf -v prompt "\n💡 Provide us your domain name without http:// or https:// e.g. www.example.com or my-node.fleek.network\n\nTell us, what's the domain name?"
  read -r -p "$prompt"$'\n> ' answer

  userDomainName=$(toLowerCase "$answer")

  domainOnly=$(extactDomainName "$userDomainName")

  if ! whois "$domainOnly" | grep "$domainOnly" >/dev/null 2>&1; then
    showErrorMessage "Oops! Doesn't seem like a valid domain, might want to try typing the domain again..."

    sleep 8
    verifyUserHasDomain
  fi

  if [[ "$userDomainName" = "" ]]; then
    showErrorMessage "Oops! You failed to provide a domain name. If you'd like to learn more read our guide at https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    sleep 8
    verifyUserHasDomain
  fi

  detectedIpAddress=$(curl --silent ifconfig.me || curl --silent icanhazip.com || echo "ERROR_IP_ADDRESS_NOT_AVAILABLE")

  printf -v prompt "\n💡 Provide us the IP address of the machine where you are installing\nor running the Node e.g. 142.250.180.14 or 91.198.174.192\n\nTip: Seems that this machine IP address is %s\n\nLet us know, what's the IP address the domain answers with (default: %s)?\n\nPress ENTER to accept default, or type the IP Address" "$detectedIpAddress" "$detectedIpAddress"
  read -r -p "$prompt"$'\n> ' answer

  answer=${answer:=detectedIpAddress}

  serverIpAddress=$(toLowerCase "$answer")

  if [[ ! $serverIpAddress =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    showErrorMessage "Oops! Is the IP address you've provided correct? Try that again..."

    sleep 3
    verifyUserHasDomain
  fi

  # given a name and an ip address, test whether there is a record for name pointing to address
  if ! dig "$userDomainName" +nostats +nocomments +nocmd | tr -d '\t' | grep "A$serverIpAddress" >/dev/null 2>&1 ; then
    showErrorMessage "Oops! The domain name $userDomainName doesn't have a DNS record type A pointing to the ip address $serverIpAddress. Learn how to setup your domain DNS Records by checking our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    sleep 3
    verifyUserHasDomain
  fi

  printf -v prompt "\n💡 Provide us with a valid email address that you have access to,\nrest ensured that we'll not contact you, but its required by Let's Encrypt (Certificate Authority)\n\nIf you'd like to know more about the Let's Encrypt organisation\nvisit their website at https://letsencrypt.org/\n\nTell us, what's your email address?"
  read -r -p "$prompt"$'\n> ' answer

  emailAddress=$(toLowerCase "$answer")

  if [[ ! "$emailAddress" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then
    showErrorMessage "Oops! Is the email address you've provided correct? Try that again..."

    sleep 3
    verifyUserHasDomain
  fi

  printf -v prompt "\n🤖 Here are the details you have provided, make sure the information is correct.\n\nDomain name:      %s\nIP Address:      %s\nEmail address:    %s\n\nIs this correct (y/n)?\n\nPress Y or ENTER to confirm. Otherwise, N to make changes!" "$userDomainName" "$serverIpAddress" "$emailAddress"
  read -r -p "$prompt"$'\n> ' answer

  shouldRedo=$(toLowerCase "$answer")

  if [[ "$shouldRedo" == "n" ]]; then
    verifyUserHasDomain
  fi

  echo "$userDomainName;$emailAddress"
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
  " > ./docker/full-node/data/nginx/http.conf
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
  " > ./docker/full-node/data/nginx/https.conf
}

setupSSLTLS() {
  echo "⚠️ You're ${txtPrefixForBold}required ${txtPrefixForNormal}to have a Domain name point to your server IP address."
  echo
  echo "Visit your domain name registrar's dashboard, or create a new domain, update the A record to have the hostname answer with the server IP address!"
  echo
  echo "Before proceeding, you have to do this step, as we'll verify!"
  echo "Also, this is important to secure the server communications with SSL/TLS."
  echo
  echo "🙏 If you'd like to learn more about this, check our guide \"How to secure a Network Node\" https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"
  printf "\n"

  trimData=$(verifyUserHasDomain | xargs)

  userDomainName=$(echo "$trimData" | cut -d ";" -f 1)
  emailAddress=$(echo "$trimData" | cut -d ";" -f 2)

  if ! cd "$1"; then
    showErrorMessage "Oops! This is embarasssing! Failed to change to ursa directory. Help us improve, report it in our discord channel 🙏"

    exit 1
  fi

  if ! rm ./docker/full-node/data/nginx/app.conf; then
    showErrorMessage "Oops! Failed to clear the nginx default config. Help us improve, report it in our discord channel 🙏"

    exit 1
  fi

  if ! replaceNginxConfFileForHttp "$userDomainName"; then
    showErrorMessage "Oops! Failed to update the http server_name directive in the Nginx reverse proxy with your domain name $userDomainName. Help us improve! Report to us in our Discord channel 🙏"

    exit 1
  fi

  chmod +x ./docker/full-node/init-letsencrypt.sh

  showOkMessage "Updated file permissions (set +x) for Lets Encrypt!"

  # Intentional, used to provide space after msg
  echo

  # start stack in bg, as lets encrypt will need the nginx to validate
  COMPOSE_DOCKER_CLI_BUILD=1 sudo docker compose -f ./docker/full-node/docker-compose.yml up -d

  # TODO: add health check in the docker compose file
  while ! curl --silent http://127.0.0.1/ping | grep --quiet "pong"; do
    echo "🙏 Awaiting for Ursa and Nginx! Be patient..."
    sleep 3
  done

  if ! initLetsEncrypt "$emailAddress" "$userDomainName"; then
    exit 1
  fi

  printf "\n"

  if ! replaceNginxConfFileForHttps "$userDomainName"; then
    showErrorMessage "Oops! Failed to update the https server_name directive in the Nginx reverse proxy with your domain name $userDomainName. Help us improve! Report to us in our Discord channel 🙏"

    exit 1
  fi
}

(
  exec < /dev/tty;

  # Identity the OS
  os=$(identifyOS)

  # Show disclaimer
  showDisclaimer

  # Check if system has recommended resources (disk space and memory)
  checkSystemHasRecommendedResources "$os"

  # Check if has dependencies installed
  for dep in "${dependencies[@]}"
  do
    verifyDepsOrInstall "$dep"
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
    echo "😅 Gosh! Have you run the installation before?!"
    echo "The directory $ursaPath is not empty and we'll have to skip the installation, as we don't want to do any overrides."
    echo "If you are stuck on this, clear the desired location before retrying"
    echo "e.g. if you chose to install in the default \$HOME/www/fleek-network/ursa clear it, as the assisted installer does not do deletes."

    exit 1
  fi

  # Pull the `ursa` project repository to the preferred target directory via HTTPS
  cloneUrsaRepositoryToPath "$ursaPath"

  # Await a few seconds to let the user read...
  sleep 5

  # Optional, check if user would like to setup SSL/TLS
  setupSSLTLS "$ursaPath"

  showOkMessage "The installation process has completed!"
  
  # Await a few seconds to let the user read...
  sleep 5

  # Restart docker
  restartDockerStack

  # Show the logs
  showDockerStackLog
  
  exit;
)