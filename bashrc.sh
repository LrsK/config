# Added by $HOME/config/setup.sh
if [ -d $HOME/.zshrc.d ]; then
	for x in $HOME/.zshrc.d/*; do
		test -f "$x" || continue
		test -x "$x" || continue
		. "$x"
	done
fi
