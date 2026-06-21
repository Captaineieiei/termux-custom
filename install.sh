#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 Termux Ultra Beauty (ASCII Edition)
#    โดย Captaineieiei — เส้นตรงเป๊ะ 100%
# =============================================================

clear

echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|    ██████╗ █████╗ ██████╗ ████████╗ █████╗ ██╗███╗  |"
echo "|    ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║████╗ |"
echo "|    ██████╔╝███████║██████╔╝   ██║   ███████║██║██╔██╗|"
echo "|    ██╔═══╝ ██╔══██║██╔═══╝    ██║   ██╔══██║██║██║╚██╗|"
echo "|    ██║     ██║  ██║██║        ██║   ██║  ██║██║██║ ╚═╝|"
echo "|    ╚═╝     ╚═╝  ╚═╝╚═╝        ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝   |"
echo "|                                                      |"
echo "|         ✨ ULTRA BEAUTY ZSH CONFIG ✨                |"
echo "|          โดย Captaineieiei — 100% ของเรา            |"
echo "+------------------------------------------------------+"
echo ""

sleep 1

# ── 1. ติดตั้ง Zsh ──
echo "📦 กำลังติดตั้ง Zsh..."
pkg update -y && pkg upgrade -y
pkg install zsh curl -y

# ── 2. สร้างไฟล์ .zshrc ฉบับสวยเลิศ (ไร้กรอบพิเศษ) ──
echo "✍️ กำลังสร้าง .zshrc พร้อมปลั๊กอินสุดสวย..."

cat > ~/.zshrc << 'EOF'
# =============================================================
# 🔥 ULTRA BEAUTY .zshrc — โดย Captaineieiei
#    ปลั๊กอินสวยๆ เขียนเอง 100% (เส้นตรงเป๊ะ!)
# =============================================================

# ── ตั้งค่าสีและ Unicode ──
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
            RPROMPT="%F{13}-> ${suffix}%f"
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
        local suggestion_text=$(echo "$RPROMPT" | sed 's/.*-> //' | sed 's/%F.*//')
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
# 🧠 ปลั๊กอินที่ 3: Captain Status (Exit Code)
# ─────────────────────────────────────────────────────────────
function captain_status() {
    if [[ $? -ne 0 ]]; then
        echo "%F{9}[FAIL]%f"
    else
        echo "%F{10}[OK]%f"
    fi
}

# ─────────────────────────────────────────────────────────────
# 🌿 ฟังก์ชัน Git (แบบมีสี)
# ─────────────────────────────────────────────────────────────
git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

git_status() {
    local branch=$(git_branch)
    if [[ -n "$branch" ]]; then
        if [[ -n $(git status -s 2>/dev/null) ]]; then
            echo " %F{11}[%F{14}$branch%F{11}*]%f"
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
# 🎨 พร้อมต์หลัก (สวยแบบไม่มีกรอบพิเศษ)
# ─────────────────────────────────────────────────────────────
RPROMPT='$(time_now)'

PROMPT='
[ %F{6}%n@%m%f %F{7}%~%f ]$(git_status)
%F{2}-->%f $(captain_status) '

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

# ─────────────────────────────────────────────────────────────
# 🌦️ ฟังก์ชันเช็คสภาพอากาศ
# ─────────────────────────────────────────────────────────────
weather() {
    curl -s "wttr.in/${1:-Bangkok}?m" | head -n 20
}

# ─────────────────────────────────────────────────────────────
# 🎉 ข้อความต้อนรับ (เส้นตรงเป๊ะ!)
# ─────────────────────────────────────────────────────────────
clear
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🚀 ยินดีต้อนรับสู่ Termux ของ Captaineieiei!       |"
echo "|   📅 $(date +"%A, %d %B %Y")                         |"
echo "|   🕒 $(date +"%H:%M:%S")                             |"
echo "|                                                      |"
echo "|   ✨ ปลั๊กอินของเราเอง:                              |"
echo "|      - พิมพ์แล้วเห็นสีเขียว (มี) / แดง (ไม่มี)        |"
echo "|      - กด -> (ลูกศรขวา) เพื่อเติมคำแนะนำ            |"
echo "|      - แสดงสถานะ Git และ Exit Code                  |"
echo "|                                                      |"
echo "|   🔥 100% ของเราเอง — ไม่มีของใครปน!                |"
echo "+------------------------------------------------------+"
echo ""
EOF

# ── 3. ตั้ง Zsh เป็นเชลล์หลัก ──
echo "🔄 กำลังตั้ง Zsh เป็นเชลล์หลัก..."
chsh -s zsh

# ── 4. เสร็จสิ้น ──
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🎉 ติดตั้ง Zsh + ปลั๊กอินสุดสวยเสร็จสมบูรณ์!       |"
echo "|                                                      |"
echo "|   📌 ขั้นตอนต่อไป:                                  |"
echo "|   1. พิมพ์ 'exit' แล้ว Enter เพื่อปิดเซสชัน          |"
echo "|   2. ปิดแอพ Termux ทิ้ง (ปัดออกจาก Recent Apps)     |"
echo "|   3. เปิด Termux ใหม่ — แล้วคุณจะพบกับความสวยงาม!   |"
echo "|                                                      |"
echo "|   🧠 ฟีเจอร์ใหม่ (เส้นตรงเป๊ะ):                     |"
echo "|      ✅ Captain Suggest (ม่วง ->)                   |"
echo "|      ✅ Captain Highlight (เขียว/แดง)               |"
echo "|      ✅ แสดง Exit Code ([OK]/[FAIL])               |"
echo "|      ✅ แสดงเวลาและ Git แบบมือโปร                   |"
echo "|                                                      |"
echo "|   📝 แก้ไขเพิ่มเติมได้ที่ ~/.zshrc                   |"
echo "+------------------------------------------------------+"
echo ""
