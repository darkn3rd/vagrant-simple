--------------------------------------------------
-- NAME: global.sql
-- AUTHOR: Joaquin Menchaca
-- CREATED: 2016-04-24
--
-- PURPOSE: create settings in sqlite3 database
-- DEPENDENCIES:
--  * SQLite3
-- INSTRUCTIONS:
--  sqlite3 global.db ".read global.sql"
--------------------------------------------------

PRAGMA foreign_keys = ON;

-- hosts table w/ optional defaults
CREATE TABLE hosts(
  hostname TEXT PRIMARY KEY,
  ipaddr TEXT NOT NULL,
  defaults INTEGER
);

-- ports table - one host to many port mappings
CREATE TABLE ports(
  guest    INTEGER NOT NULL,
  host     INTEGER NOT NULL,
  hostname TEXT,
  PRIMARY KEY(guest,host),
  FOREIGN KEY(hostname) REFERENCES hosts(hostname)
);

-- data 
INSERT INTO hosts VALUES ('client', '192.168.53.53',NULL);
INSERT INTO hosts VALUES ('master', '192.168.53.54',1);
INSERT INTO hosts VALUES ('slave1', '192.168.53.55',NULL);
INSERT INTO hosts VALUES ('slave2', '192.168.53.56',NULL);

INSERT INTO ports VALUES ('80', '8080', 'master');
INSERT INTO ports VALUES ('3306', '13306', 'master');
