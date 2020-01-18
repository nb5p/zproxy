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
  - shell http_proxy
  - shell https_proxy
  - shell all_proxy
  - git http_proxy
  - git https_proxy
- Mirror
  - pip3
  - npm

## Usage

- Set shell proxy `zproxy shell on`
- Set shell proxy `zproxy git on`
- Set pip3 mirror `zproxy pip on`
- Set npm mirror `zproxy npm on`

## Config

The default configuration directory is `$HOME/.config/zproxy/config.zsh`.

The name of the configuration file is `config.zsh`.

<details>
  <summary>This is an example configuration file (click to expand)</summary>

```shell
typeset -A surge=( ["http"]=6152 ["socks"]=6153 )
typeset -A clash=( ["http"]=7890 ["socks"]=7891 )
typeset -A taobao=( ["npm"]='https://registry.npm.taobao.org' )
typeset -A tuna=( ["pip"]='https://pypi.tuna.tsinghua.edu.cn/simple' )

shell=( surge clash )
git=( surge clash )
npm=( taobao )
pip=( tuna )
```
</details>

## License
The application is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).