CREATE TABLE SIS_COURSES (
  uid varchar(255) NOT NULL,
  surname varchar(255) default NULL,
  givenName varchar(255) default NULL,
  courseId varchar(255) default NULL,
  PRIMARY KEY (uid, courseId)
);

INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('kwhite','White','Karl','CS252');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('kwhite','White','Karl','ACCT201');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('kwhite','White','Karl','SCI404');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('kwhite','White','Karl','MATH100');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('whenderson','Henderson','William','ACCT101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('ddavis','Davis','David','CS251');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('ddavis','Davis','David','MATH100');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('cmorrison','Morrison','Colin','ACCT101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('cmorrison','Morrison','Colin','CS251');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('cmorrison','Morrison','Colin','MATH101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('cmorrison','Morrison','Colin','ACCT201');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('danderson','Anderson','Donna','SCI123');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('danderson','Anderson','Donna','ACCT201');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('danderson','Anderson','Donna','MATH100');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('amorrison','Morrison','Ann','CS251');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('amorrison','Morrison','Ann','ACCT101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('amorrison','Morrison','Ann','MATH101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('wprice','Price','William','MATH100');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('wprice','Price','William','SCI404');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('mroberts','Roberts','Marie','SCI123');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('mroberts','Roberts','Marie','ACCT101');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('mroberts','Roberts','Marie','CS251');
INSERT INTO SIS_COURSES (uid, surname, givenName, courseId) VALUES ('mroberts','Roberts','Marie','MATH101');
