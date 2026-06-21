#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 TERMUX ULTRA BEAUTY — รวมทุกอย่างไว้ในที่เดียว
#    โดย Captaineieiei — 100% ของเรา ไม่มีของใครปน!
# =============================================================

clear

echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗ |"
echo "|  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝ |"
echo "|     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝  |"
echo "|     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗  |"
echo "|     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗ |"
echo "|     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝ |"
echo "|                                                      |"
echo "|      ✨ ULTRA BEAUTY ALL-IN-ONE INSTALLER ✨         |"
echo "|        โดย Captaineieiei — 100% ของเราเอง           |"
echo "+------------------------------------------------------+"
echo ""

sleep 1

# ─────────────────────────────────────────────────────────────
# ส่วนที่ 1: ติดตั้ง Zsh
# ─────────────────────────────────────────────────────────────
echo "📦 กำลังติดตั้ง Zsh..."
pkg update -y && pkg upgrade -y
pkg install zsh curl -y

# ─────────────────────────────────────────────────────────────
# ส่วนที่ 2: ตั้งค่าไฟล์ termux.properties (สีสัน)
# ─────────────────────────────────────────────────────────────
echo "🎨 กำลังสร้างไฟล์ตั้งค่าสี..."
mkdir -p ~/.termux
cat > ~/.termux/termux.properties << 'EOFPROP'
# =====================================================
# 🎨 Termux Premium Theme — Captaineieiei Edition
# =====================================================
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
echo "✅ ตั้งค่าสีและฟอนต์เรียบร้อย!"

# ─────────────────────────────────────────────────────────────
# ส่วนที่ 3: สร้าง .zshrc (พร้อมทุกอย่าง)
# ─────────────────────────────────────────────────────────────
echo "✍️ กำลังสร้าง .zshrc พร้อม Startup Banner และปลั๊กอิน..."

cat > ~/.zshrc << 'EOFZSHRC'
# =============================================================
# 🔥 .zshrc ULTRA BEAUTY — โดย Captaineieiei
#    ปลั๊กอิน 3 ตัว, Prompt สวย, Startup Banner, Aliases
# =============================================================

# ── พื้นฐาน ──
autoload -U colors && colors
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 1: Captain Suggest (แนะนำคำสั่ง)
# ─────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 2: Captain Highlight (ไฮไลท์คำสั่ง)
# ─────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 3: Captain Status (ตรวจสอบ Exit Code)
# ─────────────────────────────────────────────────────────────
function captain_status() {
    if [[ $? -ne 0 ]]; then
        echo "%F{9}[✘ FAIL]%f"
    else
        echo "%F{10}[✔ OK]%f"
    fi
}

# ─────────────────────────────────────────────────────────────
# 🌿 ฟังก์ชัน Git (แสดง branch และสถานะ)
# ─────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────
# ⏰ ฟังก์ชันเวลา (แสดงทางขวา)
# ─────────────────────────────────────────────────────────────
time_now() {
    echo "%F{8}%*%f"
}

# ─────────────────────────────────────────────────────────────
# 🎨 พร้อมต์หลัก (สวย มือโปร เส้นตรง)
# ─────────────────────────────────────────────────────────────
RPROMPT='$(time_now)'

PROMPT='
[ %F{6}%n@%m%f %F{7}%~%f ]$(git_status)
%F{2}➜%f $(captain_status) '

# ─────────────────────────────────────────────────────────────
# ⚡ คำสั่งลัด (Aliases)
# ─────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────
# 🌦️ ฟังก์ชันเช็คสภาพอากาศ
# ─────────────────────────────────────────────────────────────
weather() {
    curl -s "wttr.in/${1:-Bangkok}?m" | head -n 20
}

# ─────────────────────────────────────────────────────────────
# 🎉 STARTUP BANNER — ข้อความต้อนรับตอนเปิดแอพ (สวยมาก!)
# ─────────────────────────────────────────────────────────────
clear
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   ______ _          _   _          _   _  __ _      |"
echo "|  |__  / | |        | | | |        | | | |/ _| |     |"
echo "|    / /| | | ___  __| | | |_ ___   | |_| | |_| |     |"
echo "|   / / | | |/ _ \/ _\` | | __/ _ \  |  _  |  _| |     |"
echo "|  / /__| | |  __/ (_| | | || (_) | | | | | | | |     |"
echo "| /_____|_|_|\___|\__,_|  \__\___/  |_| |_|_| |_|     |"
echo "|                                                      |"
echo "|  ✨ WELCOME BACK, CAPTAIN! TERMUX พร้อมใช้งานแล้ว!   |"
echo "|                                                      |"
echo "+------------------------------------------------------+"
echo ""
echo "📅  วันที่: $(date +"%A, %d %B %Y")"
echo "🕒  เวลา: $(date +"%H:%M:%S")"
echo "👤  ผู้ใช้: $(whoami)"
echo ""
echo "💡  คำสั่งลัดประจำเครื่อง:"
echo "   ll        = ดูไฟล์ทั้งหมด"
echo "   update    = อัปเดตระบบ"
echo "   ..        = ย้อนกลับ 1 โฟลเดอร์"
echo "   weather   = เช็คสภาพอากาศ (ค่าเริ่มต้นกรุงเทพ)"
echo "   clear     = ล้างหน้าจอ"
echo ""
EOFZSHRC

# ─────────────────────────────────────────────────────────────
# ส่วนที่ 4: ตั้ง Zsh เป็นเชลล์หลัก
# ─────────────────────────────────────────────────────────────
echo "🔄 กำลังตั้ง Zsh เป็นเชลล์หลัก..."
chsh -s zsh

# ─────────────────────────────────────────────────────────────
# ส่วนที่ 5: เสร็จสิ้น
# ─────────────────────────────────────────────────────────────
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🎉 ติดตั้งสำเร็จ! ทุกอย่างรวมอยู่ในที่เดียวแล้ว!   |"
echo "|                                                      |"
echo "|   📌 ขั้นตอนต่อไป (ทำตามนี้ให้ครบ):                  |"
echo "|   1. พิมพ์ 'exit' แล้ว Enter เพื่อปิดเซสชัน          |"
echo "|   2. ปิดแอพ Termux ทิ้ง (ปัดออกจาก Recent Apps)     |"
echo "|   3. เปิด Termux ใหม่ — แล้วคุณจะพบกับ:             |"
echo "|                                                      |"
echo "|      ✅ ธีมสีสวย (Tokyo Night)                       |"
echo "|      ✅ Startup Banner สุดอลังการ                    |"
echo "|      ✅ ปลั๊กอิน 3 ตัว (เขียนเอง 100%)               |"
echo "|      ✅ พร้อมต์สวย แสดงเวลา, Git, Exit Code         |"
echo "|      ✅ คำสั่งลัด (ll, update, weather, ...)         |"
echo "|                                                      |"
echo "|   🔥 100% ของเราเอง — ไม่มีของใครปน!                |"
echo "+------------------------------------------------------+"
echo ""
