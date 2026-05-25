#include "parser.h"
#include <string.h>

ParseResult parserPER(const VFSBuffer* buf) {
    ParseResult result = {};
    result.ast = nullptr;

    if (!buf || !buf->valid || buf->size == 0) {
        strncpy(result.errorMsg, "[PER] Invalid buffer.", sizeof(result.errorMsg) - 1);
        result.success = false;
        return result;
    }

    if (buf->size >= 4 && strncmp((const char*)buf->data, ".PER", 4) == 0) {
        result.success = true;
    } else {
        result.success = true;
    }

    return result;
}
