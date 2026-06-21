#!/data/data/com.termux/files/usr/bin/bash

# =============================================================
# 🚀 Termux Ultimate Beautifier
#    โดย Captaineieiei
#    ทำให้ Termux ของคุณสวยแบบมืออาชีพ (เส้นตรงเป๊ะ)
# =============================================================

clear

# ── กรอบ ASCII Art (แบบธรรมดา รับรองเส้นตรง) ──
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗ |"
echo "|   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝ |"
echo "|      ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝  |"
echo "|      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗  |"
echo "|      ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗ |"
echo "|      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝ |"
echo "|                                                      |"
echo "|         ✨ Termux Custom Theme Installer ✨          |"
echo "|               โดย Captaineieiei                     |"
echo "+------------------------------------------------------+"
echo ""

sleep 1

echo "🔥 เริ่มติดตั้งธีมและเครื่องมือ Termux แบบจัดเต็ม..."
echo ""

# ── 1. สร้างโฟลเดอร์ .termux ──
mkdir -p ~/.termux

# ── 2. เขียนไฟล์ termux.properties (ธีมระดับพรีเมียม) ──
echo "📝 กำลังสร้างไฟล์ตั้งค่าสี..."

cat > ~/.termux/termux.properties << 'EOF'
# =====================================================
# 🎨 Termux Premium Theme — Captaineieiei Edition
#    สีสันพรีเมียม สบายตา ดูมีระดับ
# =====================================================

# ── พื้นหลังและตัวอักษร ──
background=#1a1b26          # สีน้ำเงินเข้ม (Tokyo Night)
foreground=#c0caf5          # สีขาวอมฟ้า อ่านง่าย
cursor_color=#f7768e        # สีชมพูสด เคอร์เซอร์โดดเด่น

# ── 16 สีหลัก (Tokyo Night Palette) ──
color0=#15161e              # ดำ
color1=#f7768e              # แดงอมชมพู
color2=#9ece6a              # เขียวสด
color3=#e0af68              # เหลืองทอง
color4=#7aa2f7              # ฟ้าใส
color5=#bb9af7              # ม่วงอ่อน
color6=#7dcfff              # ฟ้าคราม
color7=#a9b1d6              # เทาอ่อน
color8=#414868              # เทาเข้ม
color9=#f7768e              # แดง
color10=#9ece6a             # เขียว
color11=#e0af68             # เหลือง
color12=#7aa2f7             # ฟ้า
color13=#bb9af7             # ม่วง
color14=#7dcfff             # ฟ้าคราม
color15=#c0caf5             # ขาว

# ── ฟอนต์และขนาด ──
font=DejaVu Sans Mono
font-size=16

# ── เปิดเต็มจอ ──
fullscreen=true

# ── ซ่อนแป้นพิมพ์ตอนเปิด ──
hide-soft-keyboard-on-startup=true

# ── ปรับขนาดประวัติคำสั่ง ──
terminal-transcript-rows=5000
EOF

# ── 3. โหลดการตั้งค่า ──
termux-reload-settings
echo "✅ ตั้งค่าสีและฟอนต์เรียบร้อย!"

# ── 4. สร้าง alias และฟังก์ชันเพิ่มความเท่ ──
echo "⚙️ กำลังเพิ่มคำสั่งลัด (Alias)..."

cat >> ~/.bashrc << 'EOF'

# =====================================================
# 🚀 Custom Aliases — โดย Captaineieiei
# =====================================================

# ── คำสั่งลัดพื้นฐาน ──
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── คำสั่งลัดสำหรับ Termux ──
alias update='pkg update && pkg upgrade -y'
alias install='pkg install'
alias remove='pkg uninstall'
alias search='pkg search'

# ── คำสั่งลัดสุดเท่ ──
alias neofetch='pkg install neofetch -y && neofetch'
alias htop='pkg install htop -y && htop'

# ── ฟังก์ชันเช็คสภาพอากาศ ──
weather() {
    curl -s "wttr.in/${1:-Bangkok}?m" | head -n 20
}

# ── ฟังก์ชันบอกเวลา ──
time() {
    date +"%A, %d %B %Y — %H:%M:%S"
}

# ── ข้อความต้อนรับเมื่อเปิด Termux ──
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🚀 ยินดีต้อนรับกลับมา! พร้อมใช้งานแล้วครับ!        |"
echo "|   📅 $(date +"%A, %d %B %Y")                         |"
echo "|   🕒 เวลา: $(date +"%H:%M:%S")                       |"
echo "|                                                      |"
echo "|   💡 พิมพ์ 'll' เพื่อดูไฟล์                           |"
echo "|   💡 พิมพ์ 'weather' เพื่อดูสภาพอากาศ                |"
echo "|   💡 พิมพ์ 'time' เพื่อดูเวลา                        |"
echo "+------------------------------------------------------+"
echo ""
EOF

echo "✅ เพิ่ม Aliases และฟังก์ชันเรียบร้อย!"

# ── 5. ถามติดตั้ง Zsh + Powerlevel10k (แบบสวยจัด) ──
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🎯 อยากติดตั้ง Zsh + Powerlevel10k (พรอมต์สุดเท่)?  |"
echo "|                                                      |"
echo "|   📌 ข้อดี:                                          |"
echo "|   - พรอมต์แสดงเวลา, โฟลเดอร์, สถานะ Git             |"
echo "|   - แนะนำคำสั่งอัตโนมัติ (Autosuggestions)            |"
echo "|   - ไฮไลท์สีคำสั่ง (Syntax Highlighting)              |"
echo "|   - ดูโปรแรงเหมือนแฮ็กเกอร์!                         |"
echo "|                                                      |"
echo "+------------------------------------------------------+"
echo ""
read -p "🔥 ติดตั้ง Zsh + Powerlevel10k เลยไหม? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📦 กำลังติดตั้งเครื่องมือที่จำเป็น..."
    pkg update -y && pkg upgrade -y
    pkg install git zsh curl -y

    echo "📦 กำลังติดตั้ง Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

    echo "📦 กำลังติดตั้ง Powerlevel10k (พรอมต์ทรงพลัง)..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

    echo "📦 กำลังติดตั้งปลั๊กอินเสริม..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

    echo "🔄 ตั้ง Zsh เป็นเชลล์หลัก..."
    chsh -s zsh

    echo "✅ ติดตั้ง Zsh + Powerlevel10k เสร็จเรียบร้อย!"
else
    echo "⏭️ ข้ามการติดตั้ง Zsh (ใช้ Bash เดิม)"
fi

# ── 6. เสร็จสิ้น ──
echo ""
echo "+------------------------------------------------------+"
echo "|                                                      |"
echo "|   🎉 ติดตั้งเสร็จสมบูรณ์!                            |"
echo "|                                                      |"
echo "|   📌 ขั้นตอนต่อไป:                                  |"
echo "|   1. พิมพ์ 'exit' แล้วกด Enter เพื่อปิดเซสชัน       |"
echo "|   2. ปิดแอพ Termux ทิ้ง (ปัดออกจาก Recent Apps)     |"
echo "|   3. เปิด Termux ใหม่ — สีสวยและ Aliases พร้อมใช้!  |"
echo "|                                                      |"
echo "|   💡 ถ้าติดตั้ง Zsh แล้ว เปิด Termux ใหม่เลย         |"
echo "|      มันจะใช้ Zsh อัตโนมัติ                          |"
echo "|                                                      |"
echo "|   🔥 สร้างโดย Captaineieiei                         |"
echo "+------------------------------------------------------+"
echo ""
