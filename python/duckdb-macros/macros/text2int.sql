CREATE OR REPLACE MACRO text2int(str) AS (
    TRY_CAST(
        array_to_string(
            regexp_extract_all(
                translate(
                    nfc_normalize(
                        trim(concat_ws('.', string_split(str, '.')[1], array_to_string(string_split(str, '.')[2:], '')))
                    ),
                    '０１２３４５６７８９', 
                    '0123456789'
                ),
                '(^[\+\-]|[0-9\.])'
            ),
            ''
        )
        AS INT64
    ) 
);
