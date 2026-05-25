#pragma once
#include <stdint.h>
#include <stddef.h>

#define VFS_MAX_FILE_SIZE (256 * 1024) // 256 KB hard limit

typedef enum {
    WFDS_FILE_UNKNOWN = 0,
    WFDS_FILE_PER,
    WFDS_FILE_STY,
    WFDS_FILE_DSJS
} WFDSFileType;

typedef struct {
    WFDSFileType type;
    char         path[128];
    uint8_t*     data;
    size_t       size;
    bool         valid;
} VFSBuffer;

bool        vfsInit();
WFDSFileType vfsResolveType(const char* path);
VFSBuffer   vfsLoad(const char* path);
void        vfsFree(VFSBuffer* buf);
