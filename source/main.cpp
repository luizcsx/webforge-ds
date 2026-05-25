#include <nds.h>
#include <stdio.h>
#include "vfs.h"
#include "parser.h"

int main(void) {
    videoSetMode(MODE_0_2D);
    vramSetBankA(VRAM_A_MAIN_BG);
    consoleInit(NULL, 1, BgType_Text4bpp, BgSize_T_256x256, 0, 1, true, true);

    printf("=== WebForge DS ===\n");

    if (!vfsInit()) {
        printf("[ERR] VFS: SD init failed.\n");
    } else {
        printf("[SYS] VFS: Ready.\n");

        VFSBuffer buf = vfsLoad("nitro:/index.per");
        if (buf.valid) {
            printf("[VFS] Loaded %d bytes [%d]\n", buf.size, buf.type);
            ParseResult res = parserDispatch(&buf);
            printf("[PAR] %s\n", res.success ? "OK" : res.errorMsg);
            vfsFree(&buf);
        }
    }

    while (1) {
        scanKeys();
        if (keysDown() & KEY_START) break;
        swiWaitForVBlank();
    }
    return 0;
}
