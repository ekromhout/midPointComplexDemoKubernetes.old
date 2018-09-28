CREATE TABLE SIS_PERSONS (
  uid varchar(255) NOT NULL,
  surname varchar(255) default NULL,
  givenName varchar(255) default NULL,
  fullName varchar(255) default NULL,
  department varchar(255) default NULL,
  mail varchar(255) default NULL,
  PRIMARY KEY (uid)
);

CREATE TABLE SIS_AFFILIATIONS (
  uid varchar(255) NOT NULL,
  affiliation varchar(255) NOT NULL,
  PRIMARY KEY (uid, affiliation)
);

INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('jsmith','Smith','Joe','John Smith',NULL,NULL);
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('banderson','Anderson','Bob','Bob Anderson',NULL,NULL);
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('kwhite','White','Karl','Karl White','Law','kwhite@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('kwhite','member');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('kwhite','student');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('whenderson','Henderson','William','William Henderson','Advising','whenderson@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('whenderson','community');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('ddavis','Davis','David','David Davis','Computer Science','ddavis@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('ddavis','staff');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('cmorrison','Morrison','Colin','Colin Morrison','Financial Aid','cmorrison@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('cmorrison','member');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('cmorrison','faculty');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('danderson','Anderson','Donna','Donna Anderson','Account Payable','danderson@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('danderson','member');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('amorrison','Morrison','Ann','Ann Morrison','Law','amorrison@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('amorrison','student');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('amorrison','alum');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('wprice','Price','William','William Price','Account Payable','wprice@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('wprice','community');
INSERT INTO SIS_PERSONS (uid, surname, givenName, fullName, department, mail) VALUES ('mroberts','Roberts','Marie','Marie Roberts','Law','mroberts@example.edu');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('mroberts','student');
INSERT INTO SIS_AFFILIATIONS (uid, affiliation) VALUES ('mroberts','community');
