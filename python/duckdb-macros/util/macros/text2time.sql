CREATE OR REPLACE MACRO text2time(str) AS (
    try_strptime(str, [
        '%H:%M:%S',
        '%H:%M:%S.%f',
        '%H:%M:%S %z',
    ])
);