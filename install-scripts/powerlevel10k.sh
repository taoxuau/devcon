#!/usr/bin/env bash
#
# install and configure powerlevel10k
#  - install powerlevel10k
#  - use .p10k.zsh from $P10KZSH (default = https://raw.githubusercontent.com/taoxuau/devcon/master/p10k.zsh)
#  - install gitstatusd manually to prevent "fetching gitstatusd" message
#
P10KHEADER=$(cat <<'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
EOF
)

P10KFOOTER=$(cat <<'EOF'
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
)

set -ex \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
  && sed -i -e 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc \
  && curl -o ~/.p10k.zsh "$P10KZSH" \
  && echo "$P10KHEADER"$'\n' | cat - ~/.zshrc > /tmp/myzshrc && mv /tmp/myzshrc ~/.zshrc \
  && echo $'\n'"$P10KFOOTER" >> ~/.zshrc \
  && ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f
