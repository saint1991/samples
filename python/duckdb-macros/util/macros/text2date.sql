CREATE OR REPLACE MACRO text2date(str) AS (
    CAST(
        try_strptime(str, [
            '%x',
            '%Y/%m/%d',
            '%Y/%-m/%-d',
            '%Y%m%d',
            '%B %-d, %Y',
            '%b %-d, %Y',
            '%-m/%-d/%Y',
        ]) 
        AS DATE
    )  
);