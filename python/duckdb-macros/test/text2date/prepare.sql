CREATE TABLE t2dt (i INTEGER, value VARCHAR);

INSERT INTO t2dt VALUES 
    (1, '1999-01-08'), -- ISO 8601
    (2, '1999-01-18'), -- ISO 8601
    (3, '1991/11/22'), 
    (4, '2021/5/12'),
    (5, '2024/10/1'),
    (6, '19990108'),
    (7, 'January 8, 1999'),
    (8, 'Nov 29, 1991'),
    (9, '1/8/1999'),
    (10, '1/18/1999'), -- text2date MACRO supports formats above
    (11, '01/02/03'),  -- PG incompatible result
    (12, '990108'),
    (13, '1999.008'),
    (14, 'J2451187'),
    (15, 'January 8, 99 BC'),
    (16, '1999-Jan-08'),
    (17, '08-Jan-99'),
    (18, '08-Jan-1999'),
    (19, 'Jan-08-99'),
    (20, 'Jan-08-1999'),
    (21, '1999 Jan 08'),
    (22, '08 Jan 99'),
    (23, '08 Jan 1999'),
    (24, 'Jan 08 99'),
    (25, 'Jan 08 1999'),
    (26, '1999 08 Jan'),
    (27, '08-01-99'),
    (28, '08-01-1999'),
    (29, '01-08-99'),
    (30, '01-08-1999'),
    (31, '1999 01 08'),
    (32, '08 01 99'),
    (33, '08 01 1999'),
    (34, '01 08 99'),
    (35, '01 08 1999'),
    (36, '1999 08 01'),
    (37, '99 08 01'), -- PG invalid
    (38, '18/1/1999'), -- PG invalid
    (39, '99-Jan-08'), -- PG invalid
    (40, '99-08-Jan'), -- PG invalid
    (41, '1999-08-Jan'), -- PG invalid
    (42, '99 Jan 08'), -- PG invalid
    (43, '99 08 Jan'), -- PG invalid
    (44, '99-01-08'), -- PG invalid
    (45, '99-08-01'), -- PG invalid
    (46, '99 01 08') -- PG invalid
    ;
