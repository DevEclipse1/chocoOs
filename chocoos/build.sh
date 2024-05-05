SRC=src
BLD=build

mkdir -p $BLD
nasm $SRC/boot.asm -f bin -o $BLD/boot.bin
mkdir -p $BLD
nasm $SRC/kernel.asm -f bin -o $BLD/kernel.bin

rm $BLD/choco.img
touch $BLD/choco.img

dd if=/dev/zero of=$BLD/choco.img bs=512 count=2880
mkfs.fat -F 12 -n "CHOCO" $BLD/choco.img
dd if=$BLD/boot.bin of=$BLD/choco.img conv=notrunc
mcopy -i $BLD/choco.img $BLD/kernel.bin "::kernel.bin"

qemu-system-x86_64 $BLD/choco.img
