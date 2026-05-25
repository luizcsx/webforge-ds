#include "vfs.h"
#include <fat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool vfsInit() {
    return fatInitDefault();
}

WFDSFileType vfsResolveType(const char* path) {
    if (!path) return WFDS_FILE_UNKNOWN;

    const char* dot = strrchr(path, '.');
    if (!dot) return WFDS_FILE_UNKNOWN;

    if (strcasecmp(dot, ".per")  == 0) return WFDS_FILE_PER;
    if (strcasecmp(dot, ".sty")  == 0) return WFDS_FILE_STY;
    if (strcasecmp(dot, ".dsjs") == 0) return WFDS_FILE_DSJS;

    return WFDS_FILE_UNKNOWN;
}

VFSBuffer vfsLoad(const char* path) {
    VFSBuffer buf = {};
    buf.valid = false;

    FILE* fp = fopen(path, "rb");
    if (!fp) return buf;

    fseek(fp, 0, SEEK_END);
    long fileSize = ftell(fp);
    rewind(fp);

    if (fileSize <= 0 || fileSize > VFS_MAX_FILE_SIZE) {
        fclose(fp);
        return buf;
    }

    buf.data = (uint8_t*)malloc((size_t)fileSize + 1); // +1 para null-terminator seguro
    if (!buf.data) {
        fclose(fp);
        return buf;
    }

    size_t read = fread(buf.data, 1, (size_t)fileSize, fp);
    fclose(fp);

    if (read != (size_t)fileSize) {
        free(buf.data);
        buf.data = nullptr;
        return buf;
    }

    buf.data[fileSize] = '\0';
    buf.size  = (size_t)fileSize;
    buf.type  = vfsResolveType(path);
    buf.valid = true;
    strncpy(buf.path, path, sizeof(buf.path) - 1);

    return buf;
}

void vfsFree(VFSBuffer* buf) {
    if (buf && buf->data) {
        free(buf->data);
        buf->data  = nullptr;
        buf->size  = 0;
        buf->valid = false;
    }
}
