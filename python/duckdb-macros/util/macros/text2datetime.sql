CREATE OR REPLACE MACRO text2datetime_py(str) AS (
    try_strptime_ignoring_tz(str, [
        '%Y-%m-%d',
        '%Y-%m-%d %H:%M:%S',
        '%Y-%m-%dT%H:%M:%S',
        '%Y-%m-%d %H:%M:%S%z',
        '%Y-%m-%d %H:%M:%S %z',
        '%Y%m%d %H%M%S %z',
        '%Y-%m-%d %H:%M:%S %Z'
    ])
);

CREATE OR REPLACE MACRO text2datetime(str) AS (
    coalesce(
        try_strptime(
            regexp_extract(
                trim(str), 
                '(.+(\d\d:\d\d:\d\d|\d{6})(\.\d{1,6})*)( *([+-]\d{2}(:\d{2})*|[+-]\d{4}|Z|[A-Za-z_/]+)$)*',
                1
            ),
            [
                '%Y-%m-%d',
                '%x %X',
                '%xT%X',
                '%Y%m%d%H%M%S',
                '%Y%m%d%H%M%S.%f'
            ]
        ),
        TRY_CAST(str AS TIMESTAMP)
    )
);