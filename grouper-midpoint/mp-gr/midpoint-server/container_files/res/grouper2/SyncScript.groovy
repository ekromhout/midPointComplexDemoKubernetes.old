/* 
 * ====================
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 * 
 * Copyright 2013 ForgeRock. All rights reserved.
 * 
 * The contents of this file are subject to the terms of the Common Development
 * and Distribution License("CDDL") (the "License").  You may not use this file
 * except in compliance with the License.
 * 
 * You can obtain a copy of the License at
 * http://opensource.org/licenses/cddl1.php
 * See the License for the specific language governing permissions and limitations
 * under the License.
 * 
 * When distributing the Covered Code, include this CDDL Header Notice in each file
 * and include the License file at http://opensource.org/licenses/cddl1.php.
 * If applicable, add the following below this CDDL Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyrighted [year] [name of copyright owner]"
 * ====================
 * Portions Copyrighted 2013 ConnId.
 */
import groovy.sql.Sql
import groovy.sql.DataSet
import com.rabbitmq.client.*

// Parameters:
// The connector sends the following:
// connection: handler to the SQL connection
// objectClass: a String describing the Object class (__ACCOUNT__ / __GROUP__ / other)
// action: a string describing the action ("SYNC" or "GET_LATEST_SYNC_TOKEN" here)
// log: a handler to the Log facility
// options: a handler to the OperationOptions Map (null if action = "GET_LATEST_SYNC_TOKEN")
// token: a handler to an Object representing the sync token (null if action = "GET_LATEST_SYNC_TOKEN")
//
//
// Returns:
// if action = "GET_LATEST_SYNC_TOKEN", it must return an object representing the last known
// sync token for the corresponding ObjectClass
// 
// if action = "SYNC":
// A list of Maps . Each map describing one update:
// Map should look like the following:
//
// [
// "token": <Object> token object (could be Integer, Date, String) , [!! could be null]
// "operation":<String> ("CREATE_OR_UPDATE"|"DELETE")  will always default to CREATE_OR_DELETE ,
// "uid":<String> uid  (uid of the entry) ,
// "previousUid":<String> prevuid (This is for rename ops) ,
// "password":<String> password (optional... allows to pass clear text password if needed),
// "attributes":Map<String,List> of attributes name/values
// ]

def MQ_HOST = 'mq'
def MQ_PORT = 5672
def QUEUE = 'sampleQueue'
def MAX_SQL_IN = 200			// maximum number of subject IDs in one SQL IN clause
def MAX_CHANGED_USERS = 1000		// maximum number of changed users (approximate)
def AUTO_ACKNOWLEDGE = true		// use 'false' only for testing

log.info("Entering "+action+" Script");
def sql = new Sql(connection);

if (action.equalsIgnoreCase("GET_LATEST_SYNC_TOKEN")) {
  return System.currentTimeMillis()
} else if (action.equalsIgnoreCase("SYNC")) {

  factory = new ConnectionFactory()
  factory.host = MQ_HOST
  factory.port = MQ_PORT
  connection = factory.newConnection()
  channel = connection.createChannel()
  println 'RabbitMQ: conn=' + connection + ', channel=' + channel

  result = []
  subjectsChanged = new HashSet()

  for (;;) {
    response = channel.basicGet(QUEUE, AUTO_ACKNOWLEDGE)
    println 'got response: ' + response
    if (response == null) {
      break
    }
    body = response.body
    if (body == null) {
      log.warn('null body in {}', response)
      continue
    }
    text = new String(body)
    println 'Got message:\n' + text

    jsonSlurper = new groovy.json.JsonSlurper()
    msg = jsonSlurper.parseText(text)

    events = msg?.esbEvent
    println 'events = ' + events
    if (events == null || events.isEmpty()) {
      println 'esbEvent is null or empty, getting next message; events = ' + events
      continue
    }

    for (event in events) {
      type = event.eventType
      if (type != 'MEMBERSHIP_ADD' && type != 'MEMBERSHIP_DELETE') {
        println 'event type does not match, getting next message; type = ' + type
        continue
      }
      if (event.sourceId != 'ldap') {
        println 'sourceId does not match, getting next message; sourceId = ' + event.sourceId
        continue
      }

      // the user membership has changed: let's fetch the current status of the user (ConnId requires full 'new state' anyway)
      subjectId = event.subjectId
      if (subjectId == null) {
        println 'subjectId is null, getting next message'
        continue
      }
      println 'subject membership changed: ' + subjectId
      subjectsChanged.add(subjectId)
    }
    if (subjectsChanged.size() >= MAX_CHANGED_USERS) {
      println 'MAX_CHANGED_USERS reached, finishing fetching from MQ'
      break
    }
  }

  println 'subjects changed: ' + subjectsChanged

  for (ids in subjectsChanged.asList().collate(MAX_SQL_IN)) {
    idsIn = '(' + ids.collect { "'" + it + "'" }.join(',') + ')'
    println 'idsIn = ' + idsIn

    sql.eachRow("\
select m.id, m.name, m.subject_id, m.subject_identifier0, m.sort_string0, m.search_string0, m.description, m.subject_source, m.subject_type, group_concat(distinct g.name) as groups \
from \
    grouper_members m \
        left join grouper_memberships_all_v gm on m.id=gm.member_id and gm.owner_id in \
            (select m.subject_id \
                from grouper_memberships gm join grouper_members m on gm.member_id=m.id \
                where gm.owner_id = (select subject_id from grouper_members where name='etc:exportedGroups' and subject_type='group')) \
        left join grouper_groups g on gm.owner_id=g.id \
group by m.id \
having \
        subject_source = 'ldap' and subject_type = 'person' and subject_id IN " + idsIn,
      {result.add(
        [operation:"CREATE_OR_UPDATE",
        token:System.currentTimeMillis(),
        uid:it.id,
        attributes:[
          __UID__:it.id,
          __NAME__:it.subject_id,
          subject_id:it.subject_id,
          subject_identifier0:it.subject_identifier0,
          sort_string0:it.sort_string0,
          search_string0:it.search_string0,
          name:it.name,
          description:it.description,
          group:it.groups?.tokenize(',')]])} )
  }

  channel.close()
  connection.close()

  println 'result is\n' + result

  return result

/*
  def result = [];
  def tstamp = null;
  if (token != null){
    tstamp = new java.sql.Timestamp(token);
  }
  else{
    def today= new Date();
    tstamp = new java.sql.Timestamp(today.time);
  }

  switch ( objectClass ) {
  case "__ACCOUNT__":
    sql.eachRow("select * from Users where timestamp > ${tstamp}",
      {result.add([operation:"CREATE_OR_UPDATE", uid:it.uid, token:it.timestamp.getTime(), 
            attributes:[firstname:it.firstname,fullname:it.fullname, lastname:it.lastname, email:it.email, organization:it.organization]])}
    )
    break;
    
  case "__GROUP__":
    sql.eachRow("select * from Groups where timestamp > ${tstamp}",
      {result.add([operation:"CREATE_OR_UPDATE", uid:it.gid,token:it.timestamp.getTime(), 
            attributes:[gid:it.gid,name:it.name,description:it.description]])}
    );
    break;
  }
    
  log.ok("Sync script: found "+result.size()+" events to sync");
  return result;
*/

}
else {
  log.error("Sync script: action '"+action+"' is not implemented in this script");
  return null;
}
