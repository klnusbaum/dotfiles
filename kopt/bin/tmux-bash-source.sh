#!/usr/bin/env bash

tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' \
	| xargs -I PANE tmux send-keys -t PANE 'source ~/.bash_profile' Enter
