<div align="center" style="padding-bottom: 20px;">
  <img src="./static/img/logo+named.svg?202301091309" width="360px" height="auto"/>
</div>

# Get Fleek Network

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-blue.svg)](https://conventionalcommits.org)

"Get Fleek Network" is an attempt to make our software more accessible. By providing scripts to automate the installation process of our software, we believe that it can help improve the onboarding experience of our users.

### 🤖 Installation

```
curl https://get.fleek.network | bash
```

### 🏠 Local Development

WIP: provide Docker image, and container instructions with bind mount for the "get fleek network" script.

## ✏️ Documentation

Our documentation is available at https://docs.fleek.network/ where you can find guides, and references to help you! We do our best to provide you with the best onboarding experience, but as we keep developing there are a lot of changes and some troubleshooting might be required, and thus important to use our documentation and guides.

## 🧱 Architecture flow

- The domain name `get.fleek.network` should have a CNAME record to the Github pages `fleek-network.github.io`.`
- A Github action prepares and deploys to Github pages, the latest of the assisted install
- The cURL request to `get.fleek.network` responds with the assisted install script
- Uses bash on runtime

## 🙏 Contribution guideline

Create branches from the `main` branch and name it in accordance to **conventional commits** [here](https://www.conventionalcommits.org/en/v1.0.0/), or follow the examples bellow:

```txt
test: 💍 Adding missing tests
feat: 🎸 A new feature
fix: 🐛 A bug fix
chore: 🤖 Build process or auxiliary tool changes
docs: ✏️ Documentation only changes
refactor: 💡 A code change that neither fixes a bug or adds a feature
style: 💄 Markup, white-space, formatting, missing semi-colons...
```

Find more about contributing [here](docs/open-source/contributing.md), please!
