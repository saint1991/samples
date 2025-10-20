#include <stdio.h>

#include "postgres.h"
#include "fmgr.h"
// #include "utils/datetime.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(error_safe_boolin);

Datum error_safe_boolin(PG_FUNCTION_ARGS) {
    const char *in_str = PG_GETARG_CSTRING(0);
    const char *str;
    size_t len;
    bool result;

    str = in_str;
    while (isspace((unsigned char) *str)) {
        str++;
    }

    len = strlen(str);
    while (len > 0 && isspace((unsigned char) str[len - 1])) {
        len--;
    }

    if (parse_bool_with_len(str, len, &result)) {
        PG_RETURN_BOOL(result);
    }
    
    PG_RETURN_NULL();
}
