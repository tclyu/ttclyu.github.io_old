# Homebrew
## Official Site
https://brew.sh
## Install on MacOS
```bash
rm -fr $(brew --repo homebrew/core)  # because you can't `brew untap homebrew/core`
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```
#### How To Fix Permission Issue?
https://stackoverflow.com/questions/44195496/homebrew-could-not-symlink-usr-local-share-man-man7-is-not-writable
```bash
cd /usr/local && sudo chown -R $(whoami) bin etc include lib sbin share var Frameworks
```

