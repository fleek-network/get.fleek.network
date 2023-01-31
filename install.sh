#!/bin/bash
# WARNING: REQUIRES /bin/bash
#
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
# - Verify if Git is installed, if not install it
# - It'll do a quick health check to confirm Git is installed correctly 
# - Verify if Docker is installed, if not install it
# - It'll do a quick health check to confirm Docker is installed correctly
# - Request a pathname where to store the Ursa repository, otherwise providing a default,
#   e.g. `/var/www/fleek-network/ursa`
# - Pull the `ursa` project repository to the preferred target directory via HTTPS
#   instead of SSH for simplicity
# - Optionally, assist on setting up and securing domain name via SSL/TLS
# - Do a health check to confirm the Fleek Network Node is running
#
# Found an issue? Report it here: https://github.com/fleek-network/get.fleek.network
