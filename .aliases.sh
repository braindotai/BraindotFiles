wrapper(){
    start=$(date +%s)
    $@
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Job\
 completed \"$(echo $@)\" -> Took $(($(date +%s) - start)) seconds to finish."
}

# python aliases
alias ipy='clear && ipython'
alias py='clear && python3.9'
alias pyi='python3.9 -m pip install'
alias pyinc='python3.9 -m pip install --no-cache-dir'
alias pyup='python3.9 -m pip install --upgrade'
alias pyun='python3.9 -m pip uninstall'
alias pyupip='python3.9 -m pip install --upgrade pip'
alias pyvenv='source venv/bin/activate'

# kitty aliases
alias imshow='kitty +kitten icat'
alias ssh='kitten ssh'

# system aliases
alias pwd='pwd && pwd | xclip -sel clipboard'
alias open='xdg-open .'
alias dropcache='echo 3 | sudo tee /proc/sys/vm/drop_caches'
alias zshreload='source ~/.zshrc'

# internet aliases
alias yt-video="wrapper yt-dlp -o '~/Videos/YouTube/%(title)s.%(ext)s' "
alias yt-audio="wrapper yt-dlp --extract-audio --audio-format mp3 -o '~/Music/YouTube/%(title)s.%(ext)s' "