#!/bin/bash
# 一键创建训练监控环境
SESSION="train"

# 如果会话已存在，直接连接
tmux has-session -t $SESSION 2>/dev/null && { tmux attach -t $SESSION; exit 0; }

# 创建会话，第一个窗口命名为 "main"
tmux new-session -d -s $SESSION -n main

# 窗口 1: 主工作区（左边编辑，右边终端）
tmux split-window -h -t $SESSION:1
tmux send-keys -t $SESSION:1.1 'cd ~/test' Enter

# 窗口 2: GPU 监控
tmux new-window -t $SESSION -n gpu
tmux send-keys -t $SESSION:2 'watch -n 1 nvidia-smi' Enter

# 窗口 3: 日志监控（左右两个面板看不同日志）
tmux new-window -t $SESSION -n logs
tmux split-window -h -t $SESSION:3

# TODO(human): 在这里添加你的自定义命令

# 回到第一个窗口，连接
tmux select-window -t $SESSION:1
tmux attach -t $SESSION
