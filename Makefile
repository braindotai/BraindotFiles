install:
	@mkdir -p ~/.local/share/fonts
	@cp fonts/*ttf ~/.local/share/fonts/
	@fc-cache -f -v
	@git clone https://github.com/braindotai/BraindotFiles ~/BraindotFiles && stow ~/BraindotFiles