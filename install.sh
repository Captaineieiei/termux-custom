#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 TERMUX ULTRA BEAUTY — All-in-One Installer (FIXED)
#    โดย Captaineieiei — ใช้ pkg แทน apt เพื่อความเสถียร
# =============================================================

clear

# ── อนิเมชั่นเปิดตัว ──
echo -e "\033[1;36m🔧 กำลังติดตั้ง ULTRA BEAUTY (โหมดอัตโนมัติ)...\033[0m"
echo ""

for i in {1..10}; do
    echo -ne "\033[1;32m["
    for j in $(seq 1 $i); do
        echo -ne "█"
    done
    for j in $(seq $i 9); do
        echo -ne "░"
    done
    echo -ne "] $((i*10))%\033[0m\r"
    sleep 0.2
done

echo ""
echo -e "\033[1;32m✅ พร้อมติดตั้ง!\033[0m"
sleep 0.5

# ── 1. อัปเดตและติดตั้งแพ็คเกจด้วย pkg (ไม่ต้องใช้ apt) ──
echo -e "\033[1;34m📦 กำลังอัปเดตและติดตั้ง figlet, zsh, curl...\033[0m"
pkg update -y
pkg install -y figlet zsh curl

# ── ตรวจสอบว่าติดตั้ง zsh สำเร็จ ──
if ! command -v zsh &> /dev/null; then
    echo -e "\033[1;31m❌ ติดตั้ง zsh ไม่สำเร็จ! กรุณาตรวจสอบการเชื่อมต่อเน็ตแล้วรันใหม่\033[0m"
    exit 1
fi

# ── 2. ตั้งค่า termux.properties ──
echo -e "\033[1;34m🎨 กำลังสร้างไฟล์ตั้งค่าสี...\033[0m"
mkdir -p ~/.termux
cat > ~/.termux/termux.properties << 'EOFPROP'
background=#1a1b26
foreground=#c0caf5
cursor_color=#f7768e
color0=#15161e
color1=#f7768e
color2=#9ece6a
color3=#e0af68
color4=#7aa2f7
color5=#bb9af7
color6=#7dcfff
color7=#a9b1d6
color8=#414868
color9=#f7768e
color10=#9ece6a
color11=#e0af68
color12=#7aa2f7
color13=#bb9af7
color14=#7dcfff
color15=#c0caf5
font=DejaVu Sans Mono
fullscreen=true
hide-soft-keyboard-on-startup=true
terminal-transcript-rows=5000
EOFPROP
termux-reload-settings
echo -e "\033[1;32m✅ ตั้งค่าสีและฟอนต์เรียบร้อย!\033[0m"

# ── 3. สร้าง .zshrc ──
echo -e "\033[1;34m✍️ กำลังสร้าง .zshrc...\033[0m"

cat > ~/.zshrc << 'EOFZSHRC'
# =============================================================
# 🔥 .zshrc ULTRA BEAUTY — โดย Captaineieiei (FIXED)
# =============================================================

autoload -U colors && colors
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# ──── Captain Suggest ────
function captain_suggest() {
    local current_buffer="$BUFFER"
    local len=${#current_buffer}
    if [[ $len -lt 2 ]] || [[ "$current_buffer" =~ ^[[:space:]]+$ ]]; then
        RPROMPT=""
        _captain_suggestion=""
        return
    fi
    local suggestion=$(fc -l -n 1 | grep -F "$current_buffer" | grep -v "^${current_buffer}\$" | tail -1)
    if [[ -n "$suggestion" ]] && [[ "$suggestion" == "$current_buffer"* ]]; then
        local suffix="${suggestion#$current_buffer}"
        if [[ -n "$suffix" ]]; then
            _captain_suggestion="$suffix"
            RPROMPT="%F{13}➜ ${suffix}%f"
            return
        fi
    fi
    RPROMPT=""
    _captain_suggestion=""
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw captain_suggest

function accept_suggestion() {
    if [[ -n "$_captain_suggestion" ]]; then
        BUFFER="$BUFFER$_captain_suggestion"
        RPROMPT=""
        _captain_suggestion=""
        zle reset-prompt
    fi
}
zle -N accept_suggestion
bindkey '^[[C' accept_suggestion

# ──── Captain Highlight ────
function captain_highlight() {
    local buffer="$BUFFER"
    if [[ -z "$buffer" ]]; then
        region_highlight=()
        return
    fi
    local cmd=$(echo "$buffer" | awk '{print $1}')
    if [[ -n "$cmd" ]]; then
        local len=${#cmd}
        if command -v "$cmd" &> /dev/null; then
            region_highlight=("0 $len fg=10,bold")
        else
            region_highlight=("0 $len fg=9,bold")
        fi
    else
        region_highlight=()
    fi
}
add-zle-hook-widget zle-line-pre-redraw captain_highlight

# ──── Captain Status (FIXED: เก็บ exit code จริง) ────
_LAST_EXIT_CODE=0
function _capture_exit_code() {
    _LAST_EXIT_CODE=$?
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _capture_exit_code

function captain_status() {
    if [[ $_LAST_EXIT_CODE -ne 0 ]]; then
        echo "%F{9}[✘ FAIL]%f"
    else
        echo "%F{10}[✔ OK]%f"
    fi
}

# ──── Git ────
git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}
git_status() {
    local branch=$(git_branch)
    if [[ -n "$branch" ]]; then
        if [[ -n $(git status -s 2>/dev/null) ]]; then
            echo " %F{11}[%F{14}$branch%F{11}✦]%f"
        else
            echo " %F{10}[%F{14}$branch%F{10}]%f"
        fi
    fi
}

# ──── Prompt ────
PROMPT='
[ %F{6}%n@%m%f %F{7}%~%f ]$(git_status) %F{8}%*%f
%F{2}➜%f $(captain_status) '

# ──── Aliases ────
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias cls='clear'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias update='pkg update && pkg upgrade -y'
alias install='pkg install'
alias remove='pkg uninstall'
alias nano='nano -c'

# ──── Weather ────
weather() {
    curl -s "wttr.in/${1:-Bangkok}?m" | head -n 20
}

# ──── EXIT MESSAGE ────
function _captain_farewell() {
    echo ""
    echo -e "\033[1;35m+------------------------------------------------------+\033[0m"
    echo -e "\033[1;35m|                                                      |\033[0m"
    echo -e "\033[1;35m|   👋 ขอบคุณที่ใช้ TERMUX ULTRA, CAPTAIN!             |\033[0m"
    echo -e "\033[1;35m|                                                      |\033[0m"
    echo -e "\033[1;33m|   🕒 ออกเมื่อ: $(date +"%H:%M:%S")                          |\033[0m"
    echo -e "\033[1;35m|                                                      |\033[0m"
    echo -e "\033[1;35m|   ✨ แล้วพบกันใหม่ครับ!                              |\033[0m"
    echo -e "\033[1;35m+------------------------------------------------------+\033[0m"
    echo ""
}
add-zsh-hook zshexit _captain_farewell

# ──── STARTUP BANNER (เฉพาะครั้งแรก) ────
if [[ -z "$TERMUX_STARTUP" ]]; then
    export TERMUX_STARTUP=1
    clear
    echo -e "\033[1;36m🚀 กำลังโหลด TERMUX ULTRA...\033[0m"
    sleep 0.2
    figlet -f standard "TERMUX" 2>/dev/null | sed 's/^/  /'
    echo ""
    echo -e "\033[1;33m          ✨ WELCOME BACK, CAPTAIN! ✨\033[0m"
    echo ""
    echo -e "\033[1;34m📅  วันที่:\033[0m \033[1;37m$(date +"%A, %d %B %Y")\033[0m"
    echo -e "\033[1;34m🕒  เวลา:\033[0m \033[1;37m$(date +"%H:%M:%S")\033[0m"
    echo -e "\033[1;34m👤  ผู้ใช้:\033[0m \033[1;37m$(whoami)\033[0m"
    echo ""
    echo -e "\033[1;32m💡  คำสั่งลัด:\033[0m"
    echo -e "   \033[1;32mll\033[0m      = ดูไฟล์ทั้งหมด"
    echo -e "   \033[1;32mupdate\033[0m  = อัปเดตระบบ"
    echo -e "   \033[1;32m..\033[0m      = ย้อนกลับ 1 โฟลเดอร์"
    echo -e "   \033[1;32mweather\033[0m = เช็คสภาพอากาศ"
    echo -e "   \033[1;32mclear\033[0m   = ล้างหน้าจอ"
    echo ""
fi
EOFZSHRC

# ── 4. ตั้ง Zsh เป็นเชลล์หลัก ──
echo -e "\033[1;34m🔄 กำลังตั้ง Zsh เป็นเชลล์หลัก...\033[0m"
chsh -s zsh

# ── 5. เสร็จสิ้น ──
echo ""
echo -e "\033[1;32m+------------------------------------------------------+\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   🎉 ติดตั้งเสร็จสมบูรณ์!                            |\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   ✅ ใช้ pkg แทน apt (เสถียรกว่า)                   |\033[0m"
echo -e "\033[1;32m|   ✅ Fixed: captain_status exit code ถูกต้องแล้ว    |\033[0m"
echo -e "\033[1;32m|   ✅ Added: ข้อความตอน exit shell                   |\033[0m"
echo -e "\033[1;32m|   ✅ กำลังเปลี่ยนไปใช้ Zsh ทันที!                   |\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   🔥 100% ของเราเอง — ไม่ต้องออกแล้วเปิดใหม่!       |\033[0m"
echo -e "\033[1;32m+------------------------------------------------------+\033[0m"
echo ""

# ── 🔥 สำคัญ: เปลี่ยนไปใช้ Zsh ทันที ──
exec zsh
