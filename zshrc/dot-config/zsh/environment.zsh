path+=(/usr/local/bin)
path+=("$HOME/.docker/bin")
path=("$HOME/Projects/99designs/99dev/bin" $path)
path=("$HOME/.opencode/bin" $path)

export PATH
export EDITOR="nvim"
export VISUAL="nvim"

export NVM_DIR="$HOME/.nvm"

nvm_prefix="$(brew --prefix)/opt/nvm"
[ -s "$nvm_prefix/nvm.sh" ] && source "$nvm_prefix/nvm.sh"
[ -s "$nvm_prefix/etc/bash_completion.d/nvm" ] && source "$nvm_prefix/etc/bash_completion.d/nvm"
unset nvm_prefix

export GOPRIVATE=github.com/99designs,gitlab.com/vistaprint-org/99designs,go.99designs.dev,gitlab.com/vistaprint-org/expert-services
export PICO_SDK_PATH="$HOME/pico-sdk"
