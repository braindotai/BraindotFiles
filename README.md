# __@braindotai dots__


- fonts
```
mkdir -p ~/.local/share/fonts
cp fonts/*ttf ~/.local/share/fonts/
fc-cache -f -v
```

- zsh and p10k

```
cp zsh/zshrc ~/.zshrc
cp zsh/p10k.zsh ~/.p10k.zsh
```

- kitty terminal

```
mkdir -p ~/.config/kitty
cp -r kitty/* ~/.config/kitty/
```
