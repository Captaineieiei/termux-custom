#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 TERMUX ULTRA BEAUTY — ใช้ figlet ทำให้เส้นตรง 100%
#    โดย Captaineieiei — ไม่มีทางเอียงอีกต่อไป!
# =============================================================

clear

# ── ติดตั้ง figlet (ถ้ายังไม่มี) ──
echo "📦 กำลังติดตั้ง figlet เพื่อสร้างข้อความขนาดใหญ่..."
pkg install figlet -y

# ── สร้าง Banner ด้วย figlet (ฟอนต์ monospace) ──
BANNER=$(figlet -f standard "TERMUX" | sed 's/^/  /')

echo ""
echo -e "\033[1;36m$BANNER\033[0m"
echo ""
echo -e "\033[1;33m          ✨ ULTRA BEAUTY ALL-IN-ONE INSTALLER ✨\033[0m"
echo -e "\033[1;32m               โดย Captaineieiei — 100% ของเรา\033[0m"
echo ""

sleep 1

# ── 1. ติดตั้ง Zsh ──
echo -e "\033[1;34m📦 กำลังติดตั้ง Zsh...\033[0m"
pkg update -y && pkg upgrade -y
pkg install zsh curl -y

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

# ── 3. สร้าง .zshrc (ใช้ figlet สำหรับ Startup) ──
echo -e "\033[1;34m✍️ กำลังสร้าง .zshrc พร้อม Startup Banner และปลั๊กอิน...\033[0m"

cat > ~/.zshrc << 'EOFZSHRC'
# =============================================================
# 🔥 .zshrc ULTRA BEAUTY (figlet edition) — โดย Captaineieiei
#    ปลั๊กอิน 3 ตัว, Prompt สวย, Startup Banner จาก figlet
# =============================================================

autoload -U colors && colors
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# ──── ปลั๊กอินที่ 1: Captain Suggest ────
function captain_suggest() {
    local current_buffer="$BUFFER"
    if [[ -z "$current_buffer" ]]; then
        RPROMPT=""
        return
    fi
    local suggestion=$(fc -l 1 | grep -F "$current_buffer" | grep -v "^.*$current_buffer$" | tail -1 | sed 's/^ *[0-9]* *//')
    if [[ -n "$suggestion" ]]; then
        local suffix="${suggestion#$current_buffer}"
        if [[ -n "$suffix" ]]; then
            RPROMPT="%F{13}➜ ${suffix}%f"
        else
            RPROMPT=""
        fi
    else
        RPROMPT=""
    fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw captain_suggest

function accept_suggestion() {
    if [[ -n "$RPROMPT" ]]; then
        local suggestion_text=$(echo "$RPROMPT" | sed 's/.*➜ //' | sed 's/%F.*//')
        BUFFER="$BUFFER$suggestion_text"
        RPROMPT=""
        zle reset-prompt
    fi
}
zle -N accept_suggestion
bindkey '^[[C' accept_suggestion

# ──── ปลั๊กอินที่ 2: Captain Highlight ────
function captain_highlight() {
    local cmd=$(echo "$BUFFER" | awk '{print $1}')
    if [[ -n "$cmd" ]]; then
        if command -v "$cmd" &> /dev/null; then
            region_highlight=("0 $#BUFFER fg=10,bold")
        else
            region_highlight=("0 $#BUFFER fg=9,bold")
        fi
    else
        region_highlight=()
    fi
}
add-zle-hook-widget zle-line-pre-redraw captain_highlight

# ──── ปลั๊กอินที่ 3: Captain Status ────
function captain_status() {
    if [[ $? -ne 0 ]]; then
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

# ──── เวลา ────
time_now() {
    echo "%F{8}%*%f"
}

# ──── พร้อมต์หลัก ────
RPROMPT='$(time_now)'

PROMPT='
[ %F{6}%n@%m%f %F{7}%~%f ]$(git_status)
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

# ──── ฟังก์ชันสภาพอากาศ ────
weather() {
    curl -s "wttr.in/${1:-Bangkok}?m" | head -n 20
}

# ──── STARTUP BANNER (ใช้ figlet สร้างข้อความ) ────
clear

# สร้างข้อความ TERMUX ด้วย figlet (ฟอนต์ standard)
BANNER=$(figlet -f standard "TERMUX" 2>/dev/null | sed 's/^/  /')
if [[ -z "$BANNER" ]]; then
    # ถ้า figlet ไม่ทำงาน ให้ใช้ข้อความธรรมดา
    BANNER="  TERMUX"
fi

echo ""
echo -e "\033[1;36m$BANNER\033[0m"
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
echo -e "   \033[1;32mweather\033[0m = เช็คสภาพอากาศ (กรุงเทพ)"
echo -e "   \033[1;32mclear\033[0m   = ล้างหน้าจอ"
echo ""
EOFZSHRC

# ── 4. ตั้ง Zsh เป็นเชลล์หลัก ──
echo -e "\033[1;34m🔄 กำลังตั้ง Zsh เป็นเชลล์หลัก...\033[0m"
chsh -s zsh

# ── 5. เสร็จสิ้น ──
echo ""
echo -e "\033[1;32m+------------------------------------------------------+\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   🎉 ติดตั้งเสร็จสมบูรณ์! (ใช้ figlet ทำให้ตรง)     |\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   📌 ขั้นตอนต่อไป:                                  |\033[0m"
echo -e "\033[1;32m|   1. พิมพ์ 'exit' แล้ว Enter เพื่อปิดเซสชัน          |\033[0m"
echo -e "\033[1;32m|   2. ปิดแอพ Termux ทิ้ง (ปัดออกจาก Recent Apps)     |\033[0m"
echo -e "\033[1;32m|   3. เปิด Termux ใหม่ — แล้วคุณจะพบกับ:             |\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|      ✅ ธีมสี Tokyo Night                           |\033[0m"
echo -e "\033[1;32m|      ✅ Startup Banner จาก figlet (ตรงเป๊ะ)          |\033[0m"
echo -e "\033[1;32m|      ✅ ปลั๊กอิน 3 ตัว (เขียนเอง 100%)               |\033[0m"
echo -e "\033[1;32m|      ✅ พร้อมต์สวย แสดงเวลา, Git, Exit Code         |\033[0m"
echo -e "\033[1;32m|      ✅ คำสั่งลัด (ll, update, weather, ...)         |\033[0m"
echo -e "\033[1;32m|                                                      |\033[0m"
echo -e "\033[1;32m|   🔥 100% ของเราเอง — ไม่มีของใครปน!                |\033[0m"
echo -e "\033[1;32m+------------------------------------------------------+\033[0m"
echo ""
