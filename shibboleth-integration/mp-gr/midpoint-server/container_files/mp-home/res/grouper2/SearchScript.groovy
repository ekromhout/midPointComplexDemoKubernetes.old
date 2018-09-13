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
import groovy.sql.Sql;
import groovy.sql.DataSet;

// Parameters:
// The connector sends the following:
// connection: handler to the SQL connection
// objectClass: a String describing the Object class (__ACCOUNT__ / __GROUP__ / other)
// action: a string describing the action ("SEARCH" here)
// log: a handler to the Log facility
// options: a handler to the OperationOptions Map
// query: a handler to the Query Map
//
// The Query map describes the filter used.
//
// query = [ operation: "CONTAINS", left: attribute, right: "value", not: true/false ]
// query = [ operation: "ENDSWITH", left: attribute, right: "value", not: true/false ]
// query = [ operation: "STARTSWITH", left: attribute, right: "value", not: true/false ]
// query = [ operation: "EQUALS", left: attribute, right: "value", not: true/false ]
// query = [ operation: "GREATERTHAN", left: attribute, right: "value", not: true/false ]
// query = [ operation: "GREATERTHANOREQUAL", left: attribute, right: "value", not: true/false ]
// query = [ operation: "LESSTHAN", left: attribute, right: "value", not: true/false ]
// query = [ operation: "LESSTHANOREQUAL", left: attribute, right: "value", not: true/false ]
// query = null : then we assume we fetch everything
//
// AND and OR filter just embed a left/right couple of queries.
// query = [ operation: "AND", left: query1, right: query2 ]
// query = [ operation: "OR", left: query1, right: query2 ]
//
// Returns: A list of Maps. Each map describing one row.
// !!!! Each Map must contain a '__UID__' and '__NAME__' attribute.
// This is required to build a ConnectorObject.

log.info("Entering "+action+" Script");

def sql = new Sql(connection);
def result = []
def where = "";

switch ( objectClass ) {
    case "__ACCOUNT__":
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
        subject_source = 'ldap' and subject_type = 'person'",
    {result.add(
      [__UID__:it.id, 
      __NAME__:it.subject_id, 
      subject_id:it.subject_id, 
      subject_identifier0:it.subject_identifier0, 
      sort_string0:it.sort_string0, 
      search_string0:it.search_string0, 
      name:it.name, 
      description:it.description, 
      group:it.groups?.tokenize(',')])} );
    break

    case "__GROUP__":
    sql.eachRow("SELECT id, name, display_name, extension, display_extension, description, type_of_group FROM grouper_groups WHERE id in \
		    (select m.subject_id \
		        from grouper_memberships gm join grouper_members m on gm.member_id=m.id \
                            where gm.owner_id = (select subject_id from grouper_members where name='etc:exportedGroups' and subject_type='group'))", 
      {result.add([
	__UID__:it.id, 
	__NAME__:it.name, 
	displayName:it.display_name, 
        extension:it.extension,
	displayExtension:it.display_extension,
	description:it.description,
	type:it.type_of_group])} );
    break

/*
    case "organization":
    sql.eachRow("SELECT * FROM Organizations" + where, {result.add([__UID__:it.name, __NAME__:it.name, description:it.description])} );
    break	*/

    default:
    result;
}

return result;
