<div align="center" style="padding-bottom: 20px;">
  <img src="./static/img/repo-banner.png?202309051803" width="auto" height="auto"/>
</div>

# Get Fleek Network

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-blue.svg)](https://conventionalcommits.org)

"Get Fleek Network" is an attempt to make our software more accessible. By providing scripts to automate the installation process of our software, we believe that it can help improve the onboarding experience of our users.

### ⚠️ Disclaimer

The practice of "piped installers" has become widespread in recent years, as development teams try to help the users by providing an easy installation process, but that has security risks.

💡 A "pipe installer" is a term used to describe `curl get.example.com/script.sh | bash`, which is a `curl` request that pipes a file that it gets from a remote location into the bash interpreter which is used to allow you to interact with your operating system. You can find these "pipe installers" in [Rust](https://www.rust-lang.org/learn/get-started), [Docker](https://get.docker.com/), etc; although they all are written differently and for different purposes and intent.

We try to reduce this risk by reducing the number of operations by informing and requesting permission from the user, which has to provide consent.

As a user, you are strongly advised to follow our [Introductory Guides](https://docs.fleek.network) instead. Otherwise, run the "pipe installer" at your own risk! 

All things considered, we advise you to read the source code which is publicly available in the [repository](https://github.com/fleek-network/get.fleek.network) to understand the process and make a decision of your own, about whether you find it safe to run the assisted installer or not.

👍 Alternatively, you may find the installation script that is provided as a good reference to follow on your own.

If you have any questions or feedback, find us on [Discord](https://discord.gg/fleekxyz).

### 🤖 Requirements

- Bash >= 4.2

### 👋 Running the assisted installer

Open a new terminal window, and connect to a [supported](https://docs.fleek.network/docs/node/requirements/) Linux server.

```
curl https://get.fleek.network | bash
```

Learn more about the assisted installer [here](https://docs.fleek.network/docs/node/overview/)

## ✏️ Documentation

Our documentation is available at https://docs.fleek.network/ where you can find guides, and references to help you! We do our best to provide you with the best onboarding experience, but as we keep developing there are a lot of changes and some troubleshooting might be required, and thus important to use our documentation and guides.

## 🧱 Architecture flow

- The domain name `get.fleek.network` should have a CNAME record to the Github pages `fleek-network.github.io`.`
- A Github action prepares and deploys to Github pages, the latest of the assisted install
- The cURL request to `get.fleek.network` responds with the assisted install script
- Uses bash on runtime

## 🙏 Contribution guideline

Create branches from the `main` branch and name it in accordance with **conventional commits**** [here](https://www.conventionalcommits.org/en/v1.0.0/), or follow the examples below:

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
