#include <nds.h>
#include <fat.h>
#include <stdio.h>

void systemCoreInit() {
    bool storageReady = fatInitDefault();

    videoSetMode(MODE_0_2D);
    vramSetBankA(VRAM_A_MAIN_BG);
    consoleInit(NULL, 1, BgType_Text4bpp, BgSize_T_256x256, 0, 1, true, true);

    printf("================================\n");
    printf("           WebForge DS          \n");
    printf("================================\n");
    
    if (storageReady) {
        printf("[SYS] VFS File System: LINKED.\n");
    } else {
        printf("[ERR] VFS Storage IO: FAILED.\n");
    }
    
    printf("Kernel State: Ready.\n\n");
}

int main(void) {
  systemCoreInit();

    while(1) {
        scanKeys();
        uint32 keys = keysDown();
        
        if (keys & KEY_START) {
            break;
        }

        swiWaitForVBlank();
    }

    return 0;
}
