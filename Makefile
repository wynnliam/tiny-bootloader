SRC=bootloader.asm
OUT=boot.com

ASM=nasm
FLG=-f bin $(SRC) -o $(OUT)

RUN=bochs -f bochsrc.txt

.phony: clean

all: $(SRC)
	$(ASM) $(FLG)

run: $(OUT)
	$(RUN)

clean:
	rm boot.com bochsout.txt bx_enh_dbg.ini
