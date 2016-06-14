--------------------------------------------------
-- NAME: get_settings.sql
-- AUTHOR: Joaquin Menchaca
-- CREATED: 2016-04-24
--
-- PURPOSE: query settings from global.db
-- DEPENDENCIES:
--  * SQLite3
-- INSTRUCTIONS:
--  sqlite3 global.db ".read get_settings.sql"
--------------------------------------------------
.mode column
.headers on

.print 'Print list of hostnames'
.print '==============================================='
SELECT hostname, ipaddr FROM hosts;
.print ''
.print 'Print System that is the default primary system'
.print '==============================================='
SELECT hostname FROM hosts WHERE defaults = 1;
.print ''
.print 'Print Forwarder configurations'
.print '==============================================='
SELECT H.hostname, guest, host FROM ports AS P JOIN hosts AS H ON P.hostname=H.hostname;
