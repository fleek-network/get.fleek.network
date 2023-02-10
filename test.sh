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

# for row in $(echo "${config}" | jq -r '.dependencies[] | @base64'); do
#     _jq() {
#      echo ${row} | base64 --decode | jq -r "${1}"
#     }
    
#    echo $(_jq '.name')
   

#     name=$(echo "$conf" | jq -r '.name')
#     bin=$(echo "$conf" | jq -r '.bin')
#     pkgManager=$(echo "$conf" | jq '.pkgManager')

#     # verifyDepsOrInstall "$os" "$name" "$bin" "$pkgManager"

#     echo "[debug] name ($name), bin ($bin), pkgManager ($pkgManager)"
# done

readarray -t deps < <(jq -r '.dependencies[]' "$config")

for conf in $deps; do
    name=$(echo "$conf" | jq -r '.name')
    bin=$(echo "$conf" | jq -r '.bin')
    pkgManager=$(echo "$conf" | jq '.pkgManager')

    echo "[debug] name ($name), bin ($bin), pkgManager ($pkgManager)"
done