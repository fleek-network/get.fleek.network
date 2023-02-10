#!/bin/bash

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
        "macos": {
          "pkg": "yq",
          "name": "homebrew"
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
        "macos": {
          "pkg": "whois",
          "name": "homebrew"
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
        "macos": {
          "pkg": "tldextract",
          "name": "homebrew"
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
        "macos": {
          "pkg": "dig",
          "name": "homebrew"
        },
        "ubuntu": {
          "pkg": "dnsutils",
          "name": "apt-get"
        }
      }
    }
  ]
}'

getJQPropertyValue() {
  echo "${1}" | base64 --decode | jq -r "${2}"
}

for dep in $(echo "${config}" | jq -r '.dependencies[] | @base64'); do
  name=$(getJQPropertyValue "$dep" ".name")
  bin=$(getJQPropertyValue "$dep" ".bin")
  pkgManager=$(getJQPropertyValue "$dep" ".pkgManager")

  echo "$os" "$name" "$bin" "$pkgManager"
done