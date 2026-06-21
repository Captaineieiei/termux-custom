#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 Termux Ultra Beauty — โดย Captaineieiei
#    ปลั๊กอินสุดสวย เขียนเอง ไม่พึ่งใคร!
# =============================================================

clear

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   ██████╗ █████╗ ██████╗ ████████╗ █████╗ ██╗███╗   ██╗  ║"
echo "║   ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║████╗  ██║  ║"
echo "║   ██████╔╝███████║██████╔╝   ██║   ███████║██║██╔██╗ ██║  ║"
echo "║   ██╔═══╝ ██╔══██║██╔═══╝    ██║   ██╔══██║██║██║╚██╗██║  ║"
echo "║   ██║     ██║  ██║██║        ██║   ██║  ██║██║██║ ╚████║  ║"
echo "║   ╚═╝     ╚═╝  ╚═╝╚═╝        ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝  ║"
echo "║                                                          ║"
echo "║       ✨ ULTRA BEAUTY ZSH CONFIG ✨                      ║"
echo "║            โดย Captaineieiei — 100% ของเรา              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

sleep 1

# ── 1. ติดตั้ง Zsh ──
echo "📦 กำลังติดตั้ง Zsh..."
pkg update -y && pkg upgrade -y
pkg install zsh curl -y

# ── 2. สร้างไฟล์ .zshrc ฉบับสวยเลิศ ──
echo "✍️ กำลังสร้าง .zshrc พร้อมปลั๊กอินสุดสวย..."

cat > ~/.zshrc << 'EOF'
# =============================================================
# 🔥 ULTRA BEAUTY .zshrc — โดย Captaineieiei
#    ปลั๊กอินสวยๆ เขียนเอง 100% (ไม่โคลนของใคร!)
# =============================================================

# ── ตั้งค่าสีและ Unicode ──
autoload -U colors && colors
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 1: Captain Suggest (แนะนำคำสั่งแบบ Ultra)
# ─────────────────────────────────────────────────────────────
# ทำงาน: แสดงคำแนะนำล่าสุดเป็นสีชมพูม่วง พร้อมลูกศรชี้
#        กดปุ่ม → (Right Arrow) เพื่อเติมคำแนะนำ

function captain_suggest() {
    # ดึงบรรทัดที่กำลังพิมพ์
    local current_buffer="$BUFFER"
    
    # ถ้ายังไม่พิมพ์อะไร ให้เคลียร์คำแนะนำ
    if [[ -z "$current_buffer" ]]; then
        RPROMPT=""
        return
    fi

    # ค้นหาคำสั่งล่าสุดที่ขึ้นต้นด้วยสิ่งที่พิมพ์ (ไม่รวมคำสั่งเดิม)
    local suggestion=$(fc -l 1 | grep -F "$current_buffer" | grep -v "^.*$current_buffer$" | tail -1 | sed 's/^ *[0-9]* *//')

    # ถ้าเจอคำแนะนำ
    if [[ -n "$suggestion" ]]; then
        # ตัดส่วนที่เหลือหลังจากที่พิมพ์ออกมา
        local suffix="${suggestion#$current_buffer}"
        if [[ -n "$suffix" ]]; then
            # แสดงด้วยสีม่วงชมพู (color 13) + ไอคอนลูกศร
            RPROMPT="%F{13}❯ ${suffix}%f"
        else
            RPROMPT=""
        fi
    else
        RPROMPT=""
    fi
}

# เรียกใช้ทุกครั้งที่พิมพ์
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw captain_suggest

# ฟังก์ชันเติมคำแนะนำด้วยปุ่มลูกศรขวา
function accept_suggestion() {
    if [[ -n "$RPROMPT" ]]; then
        # ดึงเฉพาะข้อความคำแนะนำ (ตัดสีและไอคอน)
        local suggestion_text=$(echo "$RPROMPT" | sed 's/.*❯ //' | sed 's/%F.*//')
        BUFFER="$BUFFER$suggestion_text"
        RPROMPT=""
        zle reset-prompt
    fi
}
zle -N accept_suggestion
bindkey '^[[C' accept_suggestion   # Right Arrow

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 2: Captain Highlight (ไฮไลท์แบบ Ultra)
# ─────────────────────────────────────────────────────────────
# ทำงาน: ถูกต้อง → เขียวมรกต + ✅, ผิด → แดงเลือด + ❌

function captain_highlight() {
    # ดึงคำสั่งแรก (ไม่เอาตัวเลือก)
    local cmd=$(echo "$BUFFER" | awk '{print $1}')
    
    # ถ้ามีคำสั่งและไม่ใช่ช่องว่าง
    if [[ -n "$cmd" ]]; then
        # ใช้ command -v เช็คว่ามีจริงไหม
        if command -v "$cmd" &> /dev/null; then
            # ✅ มีอยู่จริง: ใช้สีเขียวสด (color 10) + ไอคอน
            region_highlight=("0 $#BUFFER fg=10,bold")
            # แสดงสถานะด้านซ้าย (ไม่ต้องเพิ่ม RPROMPT เพราะ Suggest ใช้อยู่)
        else
            # ❌ ไม่มี: ใช้สีแดงสด (color 9) + ไอคอน
            region_highlight=("0 $#BUFFER fg=9,bold")
        fi
    else
        # ล้างไฮไลท์ถ้าไม่มีคำสั่ง
        region_highlight=()
    fi
}

# เรียกใช้ Captain Highlight ทุกครั้งที่พิมพ์
add-zle-hook-widget zle-line-pre-redraw captain_highlight

# ─────────────────────────────────────────────────────────────
# 🧠 ปลั๊กอินที่ 3: Captain Status (เช็ค Exit Code สวยๆ)
# ─────────────────────────────────────────────────────────────
# ทำงาน: ถ้าคำสั่งก่อนหน้าล้มเหลว (exit code != 0) จะแสดง 🚨 หน้า Prompt

function captain_status() {
    if [[ $? -ne 0 ]]; then
        echo "%F{9}🚨 %f"
    else
        echo "%F{10}✅ %f"
    fi
}

# ─────────────────────────────────────────────────────────────
# 🌿 ฟังก์ชัน Git (สวยแบบมีไอคอนและสี)
# ─────────────────────────────────────────────────────────────
git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

git_status() {
    local branch=$(git_branch)
    if [[ -n "$branch" ]]; then
        # เช็คว่า repo นี้มีไฟล์เปลี่ยนแปลงไหม
        if [[ -n $(git status -s 2>/dev/null) ]]; then
            echo " %F{11}🌿 %F{14}$branch%F{11}✦%f"   # ✦ = มีการเปลี่ยนแปลง
        else
            echo " %F{10}🌿 %F{14}$branch%f"          # ธรรมดา (clean)
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
# 🎨 พร้อมต์หลัก (เทพที่สุด!)
# ─────────────────────────────────────────────────────────────
# ใช้ RPROMPT สำหรับเวลา
RPROMPT='$(time_now)'

# Prompt แบบ 2 บรรทัด พร้อมไอคอน
PROMPT='
%F{8}╭─%F{6}%n@%m%F{8} %F{7}%~%F{8} $(git_status)
%F{8}╰─%F{2}%Bλ%b%F{8} $(captain_status)%f '

# ─────────────────────────────────────────────────────────────
# ⚡ คำสั่งลัด (Aliases) สุดเท่
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
# 🎉 ข้อความต้อนรับ (สวยมาก!)
# ─────────────────────────────────────────────────────────────
clear
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   🚀  ยินดีต้อนรับสู่ Termux สุดเท่ของ Captaineieiei     ║"
echo "║   📅  $(date +"%A, %d %B %Y")                         ║"
echo "║   🕒  $(date +"%H:%M:%S")                               ║"
echo "║                                                          ║"
echo "║   ✨ ปลั๊กอินของเราเอง (Ultra Beauty):                   ║"
echo "║      ● พิมพ์คำสั่ง → สีเขียว (มี) / แดง (ไม่มี)          ║"
echo "║      ● กด → (ลูกศรขวา) เพื่อเติมคำแนะนำอัตโนมัติ        ║"
echo "║      ● แสดงสถานะ Git พร้อมไอคอน 🌿                     ║"
echo "║      ● แสดงเวลาแบบเรียลไทม์ทางขวา                       ║"
echo "║                                                          ║"
echo "║   🔥 100% ของเราเอง — ไม่มีของใครปน!                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
EOF

# ── 3. ตั้ง Zsh เป็นเชลล์หลัก ──
echo "🔄 กำลังตั้ง Zsh เป็นเชลล์หลัก..."
chsh -s zsh

# ── 4. เสร็จสิ้น ──
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   🎉 ติดตั้ง Zsh + ปลั๊กอินสุดสวยเสร็จสมบูรณ์!          ║"
echo "║                                                          ║"
echo "║   📌 ขั้นตอนต่อไป:                                      ║"
echo "║   1. พิมพ์ 'exit' แล้ว Enter เพื่อปิดเซสชัน              ║"
echo "║   2. ปิดแอพ Termux ทิ้ง (ปัดออกจาก Recent Apps)         ║"
echo "║   3. เปิด Termux ใหม่ — แล้วคุณจะพบกับความสวยงาม!      ║"
echo "║                                                          ║"
echo "║   🧠 ฟีเจอร์ใหม่ที่สวยมาก:                              ║"
echo "║      ✅ Captain Suggest แบบมีสีม่วงพร้อมลูกศร            ║"
echo "║      ✅ Captain Highlight แบบมี ✅ / ❌                  ║"
echo "║      ✅ แสดง Exit Code ถ้าคำสั่งพัง 🚨                  ║"
echo "║      ✅ แสดงเวลาและ Git แบบมือโปร                       ║"
echo "║                                                          ║"
echo "║   📝 แก้ไขเพิ่มเติมได้ที่ ~/.zshrc                       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
