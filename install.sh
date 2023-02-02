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

hasCommand() {
  command -v "$1" >/dev/null 2>&1
}

requestAuthorizationAndExec() {
    read -r -p "🤖 $1 [y/n]? " answer

    answerToLc=$(toLowerCase "$answer")

    if [ "$answerToLc" != "y" ]; then
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
    printf "✅ %s\n\n" "$1"  
}

showErrorMessage() {
    printf "🚩 %s\n\n" "$1" >&2
}

showHintMessage() {
    printf "💡 %s\n\n" "$1"  
}

windowsUsersWarning() {
    printf "⚠️ Windows is not supported, we recommend to install the Ubuntu distro on \
    Windows Subsystem Linux (WSL). Read our docs to learn more https://docs.fleek.network\n\n"
}

shouldHaveHomebrewInstalled() {
  if ! hasCommand brew; then
    printf "😅 Oops! Homebrew package manager for MacOS is recommended and was not found!\n"

    requestAuthorizationAndExec \
      "We can start the installation process for you, are you happy to proceed" \
      "You need to have Homebrew package manager installed on MacOS, as we recommend it to install applications such as Git. You can install it on your own by visiting the Git website https://git-scm.com/ before proceeding..." \
      installHomebrew

    if [[ "$?" = 1 ]]; then
      showErrorMessage "Oops! Failed to install Homebrew."

      exit 1
    fi
  fi

  showOkMessage "Homebrew package manager is installed! [skipping]"
}

installHomebrew() {
  os=$(identifyOS)

  # TODO: Show message and prompt,that the user have to have permissions to install

  if [ "$os" != "mac" ]; then
    showErrorMessage "Oops! For some odd reason this function was called from the wrong context, as it should only be called for MacOS!"    

    exit 1
  fi  

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

installGit() {
  os=$(identifyOS)

  # TODO: Show message and prompt,that the user have to have permissions to install

  if [ "$os" == "mac" ]; then
    shouldHaveHomebrewInstalled

    brew install git
  elif [ "$os" == "linux" ]; then
    distro=$(identifyDistro)

    if [ "$distro" == "ubuntu" ] || [ "$distro" == "debian" ]; then
      sudo apt-get install git
    elif [ "$os" == "alpine" ]; then
      sudo apk add git
    elif [ "$os" == "arch" ]; then
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

  if [ "$osToLc" == "cygwin" ] || [ "$osToLc" == "mingw" ]; then
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
  # TODO: Check if system has recommended resources (disk space and memory)
  showOkMessage "Your system has enough resources (disk space and memory)"
}

checkIfGitInstalled() {
  if ! hasCommand git; then
    printf "😅 Oops! Git is required and was not found!\n"

    requestAuthorizationAndExec \
      "We can start the installation process for you, are you happy to proceed" \
      "You need to have git installed to clone the Fleek Network Ursa repository." \
      installGit

    if [[ "$?" = 1 ]]; then
      showErrorMessage "Oops! Failed to install git."

      exit 1
    fi
  fi

  showOkMessage "Git is installed! [skipping]"
}

gitHealthCheck() {
    if ! hasCommand git; then
      showErrorMessage "Oops! For some odd reason, git doesn't seem to be installed!"

      exit 1
    fi
}

installDocker() {
  os=$(identifyOS)

  # TODO: Show message and prompt,that the user have to have permissions to install

  if [ "$os" == "mac" ]; then
    shouldHaveHomebrewInstalled

    brew install docker
  elif [ "$os" == "linux" ]; then
    distro=$(identifyDistro)

    if [ "$distro" == "ubuntu" ] || [ "$distro" == "debian" ]; then
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

      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

      # https://docs.docker.com/build/buildkit/
      sudo mkdir -p /etc/docker
      sudo bash -c 'echo "{
        \"features\": {
          \"buildkit\" : true
          }
        }" > /etc/docker/daemon.json'
    elif [ "$os" == "alpine" ]; then
      sudo apk add --update docker openrc
    elif [ "$os" == "arch" ]; then
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

  showOkMessage "Docker is installed! [skipping]"
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

    read -r -p "🤖 The Ursa repository is going to be saved in the recommended path \"$defaultPath\", would you like to change the location [y/n]? " answer

    answerToLc=$(toLowerCase "$answer")

    if [ "$answerToLc" = "y" ]; then
      # Obs: the extra white space at the end is intentional and for user presentation
      read -r -p "🙋‍♀️ What path would you like to store the repository?  " selectedPath
    fi

    if [ -d "$selectedPath" ]; then
      showErrorMessage "Oops! The $selectedPath already exists, ensure that the directory is cleared before proceeding!"

      exit 1
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

  showOkMessage "The Ursa repository located at $defaultUrsaHttpsRespository was cloned to $ursaPath! [skipping]"
}

runDockerStack() {
  read -r -p "🙋‍♀️ You can now run a Node via Docker, would you like to start it now [y/n]? " answer

  answerToLc=$(toLowerCase "$answer")

  if [ "$answerToLc" = "n" ]; then
    showHintMessage "When you wish to start the Fleek Network Node, open the directory $1 \
    and run the command \"docker-compose -f docker/full-node/docker-compose.yml up\". If you'd like \
    to learn more about how to run and maintain the Node, visit our guides at https://docs.fleek.network"

    exit 0
  fi

  if ! cd "$1"; then
    showErrorMessage "Oops! Failed to change directory to $1"

    exit 1
  fi

  COMPOSE_DOCKER_CLI_BUILD=1 sudo docker-compose -f docker/full-node/docker-compose.yml up
}

verifyDepsOrInstall() {
  if ! hasCommand "$1"; then
    apt-get update
    apt-get install "$1" -y

    showOkMessage "Installed sudo!"
  fi
}

verifyUserHasDomain() {
  printf "\n\n"

  read -r -p "🤖 Do you have a domain name and DNS A Record type pointing to your server IP Address? " answer

  answerToLc=$(toLowerCase "$answer")

  if [ "$answerToLc" != "y" ]; then
    printf "\n\n"

    showErrorMessage "Oops! You need a domain name and have the DNS A Record type pointing to your server IP Address. If you'd like to learn more about it check our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    verifyUserHasDomain
  fi

  read -r -p "🤖 What's the domain name? " answer

  userDomainName=$(toLowerCase "$answer")

  if [ "$userDomainName" = "" ]; then
    printf "\n\n"

    showErrorMessage "Oops! You failed to provide a domain name. If you'd like to learn more read our guide at https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    verifyUserHasDomain
  fi

  read -r -p "🤖 What's the server IP Address the domain is pointing to? " answer

  serverIpAddress=$(toLowerCase "$answer")

  # given a name and an ip address, test whether there is a record for name pointing to address
  if ! dig "$userDomainName" +nostats +nocomments +nocmd | tr -d '\t' | grep "A$serverIpAddress"; then
    showErrorMessage "Oops! The domain name $userDomainName doesn't have a DNS record type A pointing to the ip address $serverIpAddress. Learn how to setup your domain DNS Records by checking our guide https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

    verifyUserHasDomain
  fi

  read -r -p "🤖 What's your email address? " answer

  emailAddress=$(toLowerCase "$answer")

  if [ "$emailAddress" = "" ]; then
    showErrorMessage "Oops! You have failed to provide an email address"

    verifyUserHasDomain
  fi

  read -r -p "
    🤖 This is the details we got from you!
    ---------------------------------------

    Domain name:      $userDomainName
    IP Address:       $serverIpAddress
    Email address:    $emailAddress

    Would you like to make changes [y/n]?
  " answer

  shouldRedo=$(toLowerCase "$answer")

  if [[ "$shouldRedo" = "" ]] || [[ "$shouldRedo" = "y" ]]; then
    verifyUserHasDomain
  fi

  echo "$userDomainName;$emailAddress"
}

setupSSLTLS() {
  printf "%s\n\n" "⚠️ You should secure your Node with SSL/TLS, a domain name is required! \
    Visit our guides to learn how to secure your \
    Node https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls 🙏"

  data=$(verifyUserHasDomain)

  userDomainName=$(echo "$data" | cut -d ";" -f 1)
  emailAddress=$(echo "$data" | cut -d ";" -f 2)

  if ! sed -E "s/server_name .*;/server_name $userDomainName;/g" ./docker/full-node/data/nginx/app.conf; then
    showErrorMessage "Oops! Failed to update the server_name directive in the Nginx reverse proxy with your domain name $userDomainName. Help us improve! Report to us in our Discord channel 🙏"

    exit 1
  fi

  if ! sed -i "s/live\/ursa.earth/live\/$userDomainName/g" docker/full-node/data/nginx/app.conf; then
    showErrorMessage "Oops! Failed to update the location for the TLS certificates. Help us improve! Report to us in our Discord channel 🙏"

    exit 1
  fi

  chmod +x docker/full-node/init-letsencrypt.sh

  showOkMessage "Updated file permissions for Lets Encrypt"

  (
    if ! cd docker/full-node; then
      showErrorMessage "Oops! Failed to open the directory for the docker configuration files. Help us improve! Report to us in our Discord channel 🙏"

      exit 1
    fi

    if ! EMAIL="$emailAddress" DOMAINS="$userDomainName" ./init-letsencrypt.sh | grep 'Successfully received certificate'; then
      showErrorMessage "Oops! Failed to create the SSL/TLS certificates, your domain name hasn't been secured yet. Check our guide to troubleshoot https://docs.fleek.network/guides/Network%20nodes/fleek-network-securing-a-node-with-ssl-tls"

      exit 1
    fi

    showOkMessage "Great! You have now secured your server with SSL/TLS."
  )
}

(
  exec < /dev/tty;

  # Identity the OS
  os=$(identifyOS)

  # Check if system has recommended resources (disk space and memory)
  checkSystemHasRecommendedResources "$os"

  # Check if has sudo (for testing in Docker mainly)
  verifyDepsOrInstall sudo

  # We start by verifying if git is installed, if not request to install
  checkIfGitInstalled "$os"

  gitHealthCheck

  # Verify if Docker is installed, if not install it
  checkIfDockerInstalled "$os"

  # Request a pathname where to store the Ursa repository, otherwise provide a default
  ursaPath=$(requestPathnameForUrsaRepository)

  # Check if directory does not exit or empty
  if [[ "$(ls -A "$ursaPath" >/dev/null 2>&1)" ]]; then
    printf "\n\n😅 %s" "Have you run the installation before? The directory $ursaPath is not empty and we'll skip the installation.\n\n"

    exit 1
  fi

  # Pull the `ursa` project repository to the preferred target directory via HTTPS
  cloneUrsaRepositoryToPath "$ursaPath"

  showOkMessage "The installation process has completed!"

  # Optional, check if user would like to setup SSL/TLS
  setupSSLTLS

  # Run the Docker Stack
  runDockerStack "$ursaPath"

  exit;
)