#include "parser.h"
#include <string.h>

ParseResult parseDSJS(const VFSBuffer* buf) {
    ParseResult result = {};
    result.ast = nullptr;

    if (!buf || !buf->valid || buf->size == 0) {
        strncpy(result.errorMsg, "[DSJS] Invalid buffer.", sizeof(result.errorMsg) - 1);
        result.success = false;
        return result;
    }

    result.success = true;
    return result;
}
