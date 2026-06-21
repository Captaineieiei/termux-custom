#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 TERMUX ULTRA BEAUTY — Typewriter Edition
#    โดย Captaineieiei — ข้อความพิมพ์ทีละตัวเหมือนดีด!
# =============================================================

# ── ฟังก์ชันพิมพ์ทีละตัว ──
typewriter() {
    local text="$1"
    local delay="${2:-0.05}"  # ดีเลย์ 0.05 วินาที
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# ── ฟังก์ชันแสดงกรอบข้อความ ──
print_box() {
    local msg="$1"
    local len=${#msg}
    local border=$(printf '%*s' "$((len+4))" | tr ' ' '─')
    echo -e "\033[1;36m┌─${border}─┐\033[0m"
    echo -e "\033[1;36m│  \033[1;37m${msg}\033[1;36m  │\033[0m"
    echo -e "\033[1;36m└─${border}─┘\033[0m"
}

clear

# ── อนิเมชั่นเปิดตัว ──
echo -e "\033[1;33m"
figlet -f big "TERMUX" 2>/dev/null || figlet -f standard "TERMUX" 2>/dev/null
echo -e "\033[0m"

typewriter "          ✨ ULTRA BEAUTY INSTALLER ✨" 0.06
typewriter "               โดย Captaineieiei" 0.06
echo ""

sleep 0.5

# ── อนิเมชั่นโหลด ──
typewriter "⏳ กำลังเตรียมระบบ..." 0.05
for i in {1..20}; do
    echo -ne "\033[1;32m█\033[0m"
    sleep 0.05
done
echo -e " \033[1;32m100%\033[0m"
echo ""

sleep 0.3

# ── เริ่มติดตั้ง ──
print_box "📦 ติดตั้งแพ็กเกจที่จำเป็น"
echo ""

# ── ตั้งค่า apt ให้เงียบ ──
export DEBIAN_FRONTEND=noninteractive

# ── ติดตั้ง figlet, zsh, curl ──
typewriter "▶ กำลังอัปเดตระบบ..." 0.05
apt update -y > /dev/null 2>&1
echo -e "\033[1;32m✅ อัปเดตสำเร็จ\033[0m"

typewriter "▶ กำลังติดตั้ง figlet, zsh, curl..." 0.05
apt install -y -o Dpkg::Options::="--force-confold" figlet zsh curl > /dev/null 2>&1
echo -e "\033[1;32m✅ ติดตั้งสำเร็จ\033[0m"

# ── ตรวจสอบ zsh ──
if ! command -v zsh &> /dev/null; then
    echo -e "\033[1;31m❌ ติดตั้ง zsh ไม่สำเร็จ!\033[0m"
    exit 1
fi

# ── ตั้งค่า termux.properties ──
print_box "🎨 ตั้งค่าสีและฟอนต์"
mkdir -p ~/.termux
cat > ~/.termux/termux.properties << 'EOFPROP'
# Tokyo Night Theme
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
echo -e "\033[1;32m✅ ตั้งค่าเรียบร้อย\033[0m"

# ── สร้าง .zshrc ──
print_box "✍️  สร้างไฟล์ .zshrc"
cat > ~/.zshrc << 'EOFZSHRC'
# =============================================================
# 🔥 .zshrc ULTRA BEAUTY — Typewriter Edition
# =============================================================

autoload -U colors && colors
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt PROMPT_SP

# ── ฟังก์ชันพิมพ์ทีละตัว (ใช้ในตอนเปิด) ──
typewriter() {
    local text="$1"
    local delay="${2:-0.04}"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

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

# ──── Captain Status ────
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

# ──── STARTUP BANNER (Typewriter Effect) ────
if [[ -z "$TERMUX_STARTUP" ]]; then
    export TERMUX_STARTUP=1
    clear
    figlet -f standard "TERMUX" 2>/dev/null | sed 's/^/  /'
    echo ""
    typewriter "          ✨ WELCOME BACK, CAPTAIN! ✨" 0.06
    echo ""
    typewriter "📅  วันที่: $(date +"%A, %d %B %Y")" 0.04
    typewriter "🕒  เวลา: $(date +"%H:%M:%S")" 0.04
    typewriter "👤  ผู้ใช้: $(whoami)" 0.04
    echo ""
    typewriter "💡  คำสั่งลัด:" 0.05
    typewriter "   ll      = ดูไฟล์ทั้งหมด" 0.04
    typewriter "   update  = อัปเดตระบบ" 0.04
    typewriter "   ..      = ย้อนกลับ 1 โฟลเดอร์" 0.04
    typewriter "   weather = เช็คสภาพอากาศ" 0.04
    typewriter "   clear   = ล้างหน้าจอ" 0.04
    echo ""
fi
EOFZSHRC
echo -e "\033[1;32m✅ สร้าง .zshrc สำเร็จ\033[0m"

# ── ตั้ง Zsh เป็นเชลล์หลัก ──
print_box "🔄 ตั้ง Zsh เป็นเชลล์หลัก"
chsh -s zsh
echo -e "\033[1;32m✅ เปลี่ยนเชลล์สำเร็จ\033[0m"

# ── เสร็จสิ้น ──
echo ""
echo -e "\033[1;32m┌──────────────────────────────────────────────────────┐\033[0m"
echo -e "\033[1;32m│                                                      │\033[0m"
typewriter "│   🎉  ติดตั้งเสร็จสมบูรณ์!                           │" 0.05
typewriter "│   ✅  ระบบพร้อมใช้งาน 100%                          │" 0.05
typewriter "│   ✅  กำลังเปลี่ยนไปใช้ Zsh ทันที                    │" 0.05
echo -e "\033[1;32m│                                                      │\033[0m"
typewriter "│   🔥  คราวนี้ข้อความพิมพ์ทีละตัว!                   │" 0.05
echo -e "\033[1;32m└──────────────────────────────────────────────────────┘\033[0m"
echo ""

exec zsh
