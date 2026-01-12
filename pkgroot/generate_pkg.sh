#!/usr/bin/env bash
set -e

export OO_PS4_TOOLCHAIN=/opt/OpenOrbis/PS4Toolchain

rm -f airpsx.elf
rm -f eboot.bin
rm -f IV0000-BREW00082_00-GRAPHICSEX000000.pkg
rm -f project.gp4

cd ..

haxelib run hxwell build cpp -hxml orbis.hxml -export Export/orbis

mv airpsx.elf pkgroot/airpsx.elf

cd pkgroot



# Dotnet globalization fix (OpenOrbis toolchain için gerekli)
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1


# ================================
#  ORTAM KONTROLLERİ
# ================================
if [ -z "$OO_PS4_TOOLCHAIN" ]; then
    echo "HATA: OO_PS4_TOOLCHAIN tanımlı değil!"
    exit 1
fi

# ================================
#  AYARLAR (düzenle)
# ================================

ELF_FILE="airpsx.elf"

PROJECT_DIR="$(pwd)"
PKG_ROOT="$PROJECT_DIR"
GP4_FILE="$PROJECT_DIR/project.gp4"

TITLE="My Homebrew"
TITLE_ID="BREW00082"
VERSION="01.00"
CONTENT_ID="IV0000-BREW00082_00-GRAPHICSEX000000"   # 36 karakter
PASSCODE="00000000000000000000000000000000"         # 32 hex

# PkgTool.Core pkg_build, CONTENT_ID'e göre isimlendiriyor:
OUTPUT_PKG="$PROJECT_DIR/${CONTENT_ID}.pkg"

# Araçlar
CREATE_FSELF="$OO_PS4_TOOLCHAIN/bin/linux/create-fself"
CREATE_GP4="$OO_PS4_TOOLCHAIN/bin/linux/create-gp4"
PKGTOOL_CORE="$OO_PS4_TOOLCHAIN/bin/linux/PkgTool.Core"

# ================================
echo "==> ELF → eboot.bin → SFO → package.conf → GP4 → PKG"
# ================================

[ -f "$ELF_FILE" ] || { echo "HATA: ELF bulunamadı! ($ELF_FILE)"; exit 1; }

#rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/sce_sys"

# ================================
#  1) ELF → EBOOT.BIN
# ================================
echo "[1/5] ELF → eboot.bin"
"$CREATE_FSELF" -in="$ELF_FILE" -eboot="$PKG_ROOT/eboot.bin"
# Örnek alternatif:
# "$CREATE_FSELF" -in "$ELF_FILE" -eboot "$PKG_ROOT/eboot.bin" --paid 0x3800000000000011
echo "  ✔ eboot.bin oluşturuldu."


# ================================
#  2) param.sfo üret
# ================================
echo "[2/5] param.sfo üretiliyor..."

SFO="$PKG_ROOT/sce_sys/param.sfo"

# SFO oluştur
"$PKGTOOL_CORE" sfo_new "$SFO"

# Parametreler (OpenOrbis örnekleriyle uyumlu)
# Not: Integer alanlar DECIMAL veriliyor.
"$PKGTOOL_CORE" sfo_setentry "$SFO" APP_TYPE            --type Integer --maxsize 4  --value 1
"$PKGTOOL_CORE" sfo_setentry "$SFO" APP_VER             --type Utf8    --maxsize 8  --value "$VERSION"
"$PKGTOOL_CORE" sfo_setentry "$SFO" ATTRIBUTE           --type Integer --maxsize 4  --value 0      # 0x80000
"$PKGTOOL_CORE" sfo_setentry "$SFO" CATEGORY            --type Utf8    --maxsize 4  --value "gd"
"$PKGTOOL_CORE" sfo_setentry "$SFO" CONTENT_ID          --type Utf8    --maxsize 48 --value "$CONTENT_ID"
"$PKGTOOL_CORE" sfo_setentry "$SFO" DOWNLOAD_DATA_SIZE  --type Integer --maxsize 4  --value 0
"$PKGTOOL_CORE" sfo_setentry "$SFO" SYSTEM_VER          --type Integer --maxsize 4  --value 0    # 0x3500000
"$PKGTOOL_CORE" sfo_setentry "$SFO" TITLE               --type Utf8    --maxsize 128 --value "$TITLE"
"$PKGTOOL_CORE" sfo_setentry "$SFO" TITLE_ID            --type Utf8    --maxsize 12  --value "$TITLE_ID"
"$PKGTOOL_CORE" sfo_setentry "$SFO" VERSION             --type Utf8    --maxsize 8  --value "$VERSION"

echo "  ✔ param.sfo hazır."


# ================================
#  3) package.conf oluştur
# ================================
echo "[3/5] package.conf oluşturuluyor..."

PACKAGE_CONF="$PKG_ROOT/sce_sys/package.conf"

cat > "$PACKAGE_CONF" <<EOF
[Package]
passcode = $PASSCODE
EOF

echo "  ✔ package.conf hazır."


# ================================
#  4) GP4 OLUŞTUR
# ================================
echo "[4/5] GP4 oluşturuluyor..."

"$CREATE_GP4" \
    -out "$GP4_FILE" \
    --content-id="$CONTENT_ID" \
    --files "eboot.bin sce_sys/about/right.sprx sce_sys/param.sfo sce_sys/icon0.png sce_module/libc.prx sce_module/libSceFios2.prx"

echo "✔ GP4 oluşturuldu → $GP4_FILE"


# ================================
#  5) PKG OLUŞTUR
# ================================
echo "[5/5] PKG oluşturuluyor..."

# PkgTool.Core: pkg_build <input_project.gp4> <output_directory>
"$PKGTOOL_CORE" pkg_build "$GP4_FILE" "$PROJECT_DIR"

echo "=========================================="
if [ -f "$OUTPUT_PKG" ]; then
    echo " ✔ PKG hazır:"
    echo "   $OUTPUT_PKG"
else
    echo " ✔ PKG hazır, ama isim/konum CONTENT_ID'den farklı olabilir."
    echo "   Çıktı dizini: $PROJECT_DIR"
    echo "   Buradaki *.pkg dosyalarına bak:"
    ls -1 "$PROJECT_DIR"/*.pkg 2>/dev/null || echo "   (Hiç .pkg bulunamadı, hata var demektir.)"
fi
echo "=========================================="
