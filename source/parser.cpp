#include "parser.h"
#include <string.h>

ParseResult parserDispatch(const VFSBuffer* buf) {
    ParseResult result = {};
    result.success = false;

    if (!buf || !buf->valid) {
        strncpy(result.errorMsg, "Invalid or unloaded VFSBuffer.",
                sizeof(result.errorMsg) - 1);
        return result;
    }

    switch (buf->type) {
        case WFDS_FILE_PER:  return parserPER(buf);
        case WFDS_FILE_STY:  return parserSTY(buf);
        case WFDS_FILE_DSJS: return parseDSJS(buf);
        default:
            strncpy(result.errorMsg, "Unknown file type.",
                    sizeof(result.errorMsg) - 1);
            return result;
    }
}
