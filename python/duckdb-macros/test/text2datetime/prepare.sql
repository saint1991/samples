CREATE TABLE t2ts (i INTEGER, value VARCHAR);

INSERT INTO t2ts VALUES 
  -- ISO 8601 format
  (1, '1997-01-02'),
  (2, '1997-01-02 03:04:05'),
  (3, '2001-09-22T18:19:20'),
  (4, '1997-02-10 17:32:01-08'),
  (5, '1997-02-10 17:32:01-0800'),
  (6, '1997-02-10 17:32:01 -08:00'),
  (7, '19970210173201 -0800'),
  (8, '1997-06-10 17:32:01 -07:00'),
  (0, '19970210'),
  
  -- POSIX format (note that the timezone abbrev is just decoration here)
  (9, '2000-03-15 08:14:01 JST'),
  (10, '2000-03-15 13:14:02 GMT-1'),
  (11, '2000-03-15 12:14:03 GMT-2'),
  (12, '2000-03-15 03:14:04 PST+8'),
  (13, '2000-03-15 02:14:05 MST+7:00'),
  (14, '-infinity'),
  (15, 'infinity'),
  (16, 'epoch'), -- text2datetime MACRO compatible above

  (17, 'today'),
  (18, 'yesterday'),
  (19, 'tomorrow'),
  -- time zone should be ignored by this data type
  (20, 'tomorrow EST'),
  (21, 'tomorrow zulu'),
  (22, 'Mon Feb 10 17:32:01 1997 PST'),
  (23, 'Mon Feb 10 17:32:01.000001 1997 PST'),
  (24, 'Mon Feb 10 17:32:01.999999 1997 PST'),
  (25, 'Mon Feb 10 17:32:01.4 1997 PST'),
  (26, 'Mon Feb 10 17:32:01.5 1997 PST'),
  (27, 'Mon Feb 10 17:32:01.6 1997 PST'),
  (28, 'Feb 10 17:32:01 1997 -0800'),
  (29, 'Feb 10 17:32:01 1997'),
  (30, 'Feb 10 5:32PM 1997'),
  (31, '1997/02/10 17:32:01-0800'),
  (32, '1997-02-10 17:32:01 PST'),
  (33, 'Feb-10-1997 17:32:01 PST'),
  (34, '02-10-1997 17:32:01 PST'),
  (35, '19970210 173201 PST'),
  (36, '1997.041 17:32:01 UTC'),
  (37, '19970210 173201 America/New_York'),
  (38, '4714-11-24 00:00:00 BC'),
  (39, '294276-12-31 23:59:59'),
  -- this fails (even though TZ is a no-op, we still look it up)
  (40, '19970710 173201 America/Does_not_exist'),
  (41, '4714-11-23 23:59:59 BC'),
  (42, '294277-01-01 00:00:00')
  ;
