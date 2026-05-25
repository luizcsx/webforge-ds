#pragma once
#include "vfs.h"

typedef struct {
    bool  success;
    char  errorMsg[128];
    void* ast;
} ParseResult;

ParseResult parserDispatch(const VFSBuffer* buf);

ParseResult parserPER (const VFSBuffer* buf);
ParseResult parserSTY (const VFSBuffer* buf);
ParseResult parseDSJS (const VFSBuffer* buf);
