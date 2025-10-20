CREATE OR REPLACE FUNCTION error_safe_boolin(TEXT) RETURNS TEXT
AS '/usr/lib/postgresql/16/lib/error_safe.so'
LANGUAGE C 
IMMUTABLE PARALLEL SAFE;