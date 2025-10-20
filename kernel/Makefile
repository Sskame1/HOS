# Цели по умолчанию
all: os.img

# Сборка загрузочного сектора
boot.bin: boot.nasm
	nasm -f bin boot.nasm -o boot.bin

# Сборка ядра
kernel.bin: kernel.nasm
	nasm -f bin kernel.nasm -o kernel.bin

# Создание образа дискеты
os.img: boot.bin kernel.bin
	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=boot.bin of=os.img bs=512 count=1 conv=notrunc
	dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

# Запуск в QEMU
run: os.img
	qemu-system-x86_64 -fda os.img

# Очистка
clean:
	rm -f *.bin *.img

.PHONY: all run clean