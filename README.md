# zproxy

## Installation

### oh-my-zsh

Firstly, clone this repository in oh-my-zsh's plugins directory.

```shell
git clone https://github.com/nb5p/zproxy.git ~/.oh-my-zsh/custom/plugins/zproxy
```

Secondly, activate the plugin in `~/.zshrc`. Enable it by adding zsh-proxy to the plugins array.

```shell
plugins=( zsh-proxy )
```

### zplug
After you setup zplug, write this line in your `~/.zshrc`:

```
zplug "nb5p/zproxy"
```

and, install.

```
$ zplug install
```

## Supported

- Proxy
  - http_proxy
  - https_proxy
  - all_proxy
- Mirror
  - pip3
  - npm

## Usage

- Set shell proxy `zproxy shell on`
- Set pip3 mirror `zproxy pip on`
- Set npm mirror `zproxy npm on`

## Config [WIP]

The default configuration directory is `$HOME/.config/zproxy/config.zsh`.

The name of the configuration file is `config.zsh`.

## License
The application is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).