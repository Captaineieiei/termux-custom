#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
#  สคริปต์ติดตั้งธีม Termux ส่วนตัวของฉัน
#  รันด้วย: bash install.sh
# ==========================================

echo "🔥 กำลังติดตั้งธีม Termux ส่วนตัว..."

# 1. สร้างโฟลเดอร์ .termux (ถ้ายังไม่มี)
mkdir -p ~/.termux

# 2. ดาวน์โหลดไฟล์ธีมจาก GitHub ของคุณมาใช้
#    (เปลี่ยน URL ข้างล่างให้เป็นลิงก์ RAW ของไฟล์ termux.properties ในเรโพคุณ)
echo "📥 ดาวน์โหลดไฟล์ตั้งค่าสี..."
curl -fsSL https://raw.githubusercontent.com/ชื่อคุณ/termux-custom/main/termux.properties -o ~/.termux/termux.properties

# 3. โหลดการตั้งค่าใหม่
termux-reload-settings

# 4. (Optional) ติดตั้ง Zsh + Oh My Zsh ถ้าอยากได้พรอมต์สวยกว่าเดิม
read -p "🤔 อยากติดตั้ง Zsh + Powerlevel10k ด้วยไหม? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 กำลังติดตั้ง git, zsh, curl..."
    pkg install git zsh curl -y

    echo "📦 กำลังติดตั้ง Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

    echo "📦 กำลังติดตั้ง Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

    echo "📦 กำลังติดตั้งปลั๊กอินเสริม..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

    echo "🔄 ตั้ง Zsh เป็นเชลล์หลัก..."
    chsh -s zsh
fi

echo "✅ เสร็จเรียบร้อย! กรุณาปิด Termux แล้วเปิดใหม่ (หรือเปิดแท็บใหม่) เพื่อดูผลลัพธ์!"
echo "💡 ถ้าติดตั้ง Zsh ให้พิมพ์ 'zsh' เพื่อเริ่มใช้งาน หรือปิดแล้วเปิดใหม่เลย"
