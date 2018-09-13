gs = GrouperSession.startRootSession();
#addRootStem("basis", "basis");
addRootStem("ref", "ref");
#addRootStem("bundle", "bundle");
#addRootStem("app", "app");
#addRootStem("org", "org");
#testStem = addRootStem("test", "test");

addStem("ref", "course", "course")

#addGroup("etc","coursesLoader", "coursesLoader");
#groupAddType("etc:coursesLoader", "grouperLoader");
#setGroupAttr("etc:coursesLoader", "grouperLoaderDbName", "grouper");
#setGroupAttr("etc:coursesLoader", "grouperLoaderType", "SQL_GROUP_LIST");
#setGroupAttr("etc:coursesLoader", "grouperLoaderScheduleType", "CRON");
#setGroupAttr("etc:coursesLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
#setGroupAttr("etc:coursesLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
#setGroupAttr("etc:coursesLoader", "grouperLoaderQuery", "select distinct id as SUBJECT_IDENTIFIER, 'ldap' as SUBJECT_SOURCE_ID, CONCAT('ref:course:', courseID) as GROUP_NAME from SIS_Courses");

addStem("ref", "affiliation", "affiliation")
#folder = StemFinder.findByName(gs, "ref:affiliation");
#AttributeAssign attributeAssign = folder.getAttributeDelegate().addAttribute(RuleUtils.ruleAttributeDefName()).getAttributeAssign();
#AttributeValueDelegate attributeValueDelegate = attributeAssign.getAttributeValueDelegate();
#attributeValueDelegate.assignValue(RuleUtils.ruleActAsSubjectSourceIdName(), "g:isa");
#attributeValueDelegate.assignValue(RuleUtils.ruleActAsSubjectIdName(), "GrouperSystem");
#attributeValueDelegate.assignValue(RuleUtils.ruleCheckTypeName(), RuleCheckType.groupCreate.name());
#attributeValueDelegate.assignValue(RuleUtils.ruleCheckStemScopeName(), Stem.Scope.SUB.name());
#attributeValueDelegate.assignValue(RuleUtils.ruleThenElName(),'${ruleElUtils.assignGroupPrivilege(groupId, "g:gsa", groupId, null, "read")}');

group = new GroupSave(gs).assignName("etc:affiliationLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUPS_FROM_ATTRIBUTES");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(eduPersonAffiliation=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=People,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uid");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupAttributeName(), "eduPersonAffiliation");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
#attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${subjectAttributes["subjectId"]}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupNameExpressionName(), 'ref:affiliation:${groupAttribute}_systemOfRecord');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupDisplayNameExpressionName(), '${groupAttribute} system of record');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupTypesName(), "addIncludeExclude");

group = new GroupSave(gs).assignName("etc:deptLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUPS_FROM_ATTRIBUTES");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(businessCategory=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=People,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uid");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupAttributeName(), "businessCategory");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
#attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${subjectAttributes["subjectId"]}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupNameExpressionName(), 'ref:dept:${groupAttribute}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupDisplayNameExpressionName(), '${groupAttribute}');

group = new GroupSave(gs).assignName("etc:coursesLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUP_LIST");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=Courses,ou=Groups,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uniqueMember");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapExtraAttributesName(), "cn");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupNameExpressionName(), 'ref:course:${groupAttributes["cn"]}');

group = GroupFinder.findByName(gs, "etc:sysadmingroup", true);
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=sysadmingroup)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=Groups,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uniqueMember");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");


#addGroup("bundle", "default_services", "default_services");
#addGroup("bundle", "student_services", "student_services");
#addGroup("bundle", "employee_services", "employee_services");

#addStem("ref", "student", "student");
#addStem("ref:student", "class", "class");
#addGroup("ref:student:class", "freshmen", "freshmen");
#addGroup("ref:student:class", "sophomore", "sophomore");
#addGroup("ref:student:class", "junior", "junior");
#addGroup("ref:student:class", "senior", "senior");
#addGroup("ref:student:class", "graduate", "graduate");
#addGroup("ref:student:class", "doctorate", "doctorate");

#addGroup("ref:student", "finaid", "finaid");
#addStem("ref:student", "athlete", "athlete");
#addGroup("ref:student:athlete", "baseball", "baseball");
#addGroup("ref:student:athlete", "basketball", "basketball");
#addGroup("ref:student:athlete", "football", "football");
#addGroup("ref:student:athlete", "soccer", "soccer");
#addGroup("ref:student:athlete", "volleyball", "volleyball");

#addStem("ref", "employee", "employee");
#addGroup("ref:employee", "fulltime", "fulltime");
#addGroup("ref:employee", "parttime", "parttime");
#addGroup("ref:employee", "tenured", "tenured");
#addGroup("ref:employee", "emeritus", "emeritus");

#addStem("ref", "alumni", "alumni");

#addStem("ref", "role", "role");
#addGroup("ref:role", "president", "president");
#addGroup("ref:role", "provost", "provost");
#addGroup("ref:role", "deptSecretary", "deptSecretary");
#addGroup("ref:role", "dean", "dean");
#addGroup("ref:role", "director", "director");
#addGroup("ref:role", "custodian", "custodian");
#addGroup("ref:role", "deptChair", "deptChair");
#addGroup("ref:role", "faculty", "faculty");
#addGroup("ref:role", "programmer", "programmer");
#addGroup("ref:role", "programSpecialist", "programSpecialist");
#addGroup("ref:role", "recruiter", "recruiter");
#addGroup("ref:role", "coach", "coach");
#addGroup("ref:role", "vicePresident", "vicePresident");

#addMember("bundle:student_services", "ref:student:class:freshmen");
#addMember("bundle:student_services", "ref:student:class:sophomore");
#addMember("bundle:student_services", "ref:student:class:junior");
#addMember("bundle:student_services", "ref:student:class:senior");
#addMember("bundle:student_services", "ref:student:class:graduate");
#addMember("bundle:student_services", "ref:student:class:doctorate");

#addStem("org", "admissions", "admissions");
#addStem("org:admissions", "etc", "etc");
#addGroup("org:admissions:etc", "admissions_admin", "admissions_admin");
#grantPriv("org:admissions", "org:admissions:etc:admissions_admin", NamingPrivilege.STEM);
#addStem("org:admissions", "ref", "ref");
#addStem("org:admissions", "app", "app");

#addStem("org", "bursar", "bursar");
#addStem("org:bursar", "etc", "etc");
#addGroup("org:bursar:etc", "bursar_admin", "bursar_admin");
#grantPriv("org:bursar", "org:bursar:etc:bursar_admin", NamingPrivilege.STEM);
#addStem("org:bursar", "ref", "ref");
#addStem("org:bursar", "app", "app");

#addStem("org", "business", "business");
#addStem("org:business", "etc", "etc");
#addGroup("org:business:etc", "business_admin", "business_admin");
#grantPriv("org:business", "org:business:etc:business_admin", NamingPrivilege.STEM);
#addStem("org:business", "ref", "ref");
#addStem("org:business", "app", "app");

#addStem("org", "computerscience", "computerscience");
#addStem("org:computerscience", "etc", "etc");
#addGroup("org:computerscience:etc", "computerscience_admin", "computerscience_admin");
#grantPriv("org:computerscience", "org:computerscience:etc:computerscience_admin", NamingPrivilege.STEM);
#addStem("org:computerscience", "ref", "ref");
#addStem("org:computerscience", "app", "app");

#addStem("org", "education", "education");
#addStem("org:education", "etc", "etc");
#addGroup("org:education:etc", "education_admin", "education_admin");
#grantPriv("org:education", "org:education:etc:education_admin", NamingPrivilege.STEM);
#addStem("org:education", "ref", "ref");
#addStem("org:education", "app", "app");

#addStem("org", "psychology", "psychology");
#addStem("org:psychology", "etc", "etc");
#addGroup("org:psychology:etc", "psychology_admin", "psychology_admin");
#grantPriv("org:psychology", "org:psychology:etc:psychology_admin", NamingPrivilege.STEM);
#addStem("org:psychology", "ref", "ref");
#addStem("org:psychology", "app", "app");

#addStem("org", "physicaleducation", "physicaleducation");
#addStem("org:physicaleducation", "etc", "etc");
#addGroup("org:physicaleducation:etc", "physicaleducation_admin", "physicaleducation_admin");
#grantPriv("org:physicaleducation", "org:physicaleducation:etc:physicaleducation_admin", NamingPrivilege.STEM);
#addStem("org:physicaleducation", "ref", "ref");
#2addStem("org:physicaleducation", "app", "app");

#addStem("org", "humanresources", "humanresources");
#addStem("org:humanresources", "etc", "etc");
#addGroup("org:humanresources:etc", "humanresources_admin", "humanresources_admin");
#grantPriv("org:humanresources", "org:humanresources:etc:humanresources_admin", NamingPrivilege.STEM);
#addStem("org:humanresources", "ref", "ref");
#addStem("org:humanresources", "app", "app");



#banner=addStem("app", "banner", "banner");
#addStem("app:banner", "etc", "etc");
#addGroup("app:banner:etc", "banner_admin", "banner_admin");
#grantPriv("app:banner", "app:banner:etc:banner_admin", NamingPrivilege.STEM);
#addGroup("app:banner", "banner_user_allow", "banner_user_allow");
#addGroup("app:banner", "banner_user_deny", "banner_user_deny");
#addGroup("app:banner", "banner_user", "banner_user");
#addComposite("app:banner:banner_user", CompositeType.UNION, "app:banner:banner_user_allow", "app:banner:banner_user_deny")

#portal = addStem("app", "portal", "portal");
#addStem("app:portal", "etc", "etc");
#addGroup("app:portal:etc", "portal_admin", "portal_admin");
#grantPriv("app:portal", "app:portal:etc:portal_admin", NamingPrivilege.STEM);
#addGroup("app:portal", "portal_user_allow", "portal_user_allow");
#addGroup("app:portal", "portal_user_deny", "portal_user_deny");
#addGroup("app:portal", "portal_user", "portal_user");
#addComposite("app:portal:portal_user", CompositeType.UNION, "app:portal:portal_user_allow", "app:portal:portal_user_deny")

#addStem("app", "vpn", "vpn");
#addStem("app:vpn", "etc", "etc");
#addGroup("app:vpn:etc", "vpn_admin", "vpn_admin");
#grantPriv("app:vpn", "app:vpn:etc:vpn_admin", NamingPrivilege.STEM);
#addGroup("app:vpn", "vpn_user_allow", "vpn_user_allow");
#addGroup("app:vpn", "vpn_user_deny", "vpn_user_deny");
#addGroup("app:vpn", "vpn_user", "vpn_user");
#addComposite("app:vpn:vpn_user", CompositeType.UNION, "app:vpn:vpn_user_allow", "app:vpn:vpn_user_deny")


## Setup some user favorites
#subject = SubjectFinder.findById("banderson");
#group = GroupFinder.findByName(gs, "etc:sysadmingroup", true);
#GrouperUserDataApi.favoriteGroupAdd("etc:grouperUi:grouperUiUserData", subject, group);
#
#stem = StemFinder.findByName(gs, "org:computerscience", true);
#GrouperUserDataApi.favoriteStemAdd("etc:grouperUi:grouperUiUserData", subject, stem);


##Set up service definitions
#AttributeDef appServiceDef = new AttributeDefSave(gs).assignCreateParentStemsIfNotExist(true).assignAttributeDefType(AttributeDefType.service).assignName("etc:apps:appsServiceDefinition").assignToStem(true).save();
# 
#AttributeDefName appService = new AttributeDefNameSave(gs, appServiceDef).assignCreateParentStemsIfNotExist(true).assignName("etc:apps:appsService").assignDisplayExtension("Central IT production Apps").save();
#
#banner.getAttributeDelegate().assignAttribute(appService);
#portal.getAttributeDelegate().assignAttribute(appService);
#
#addMember("app:banner:banner_user_allow", "banderson");


## Auto create the PSPNG attributes
#edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_groupOfUniqueNames");
#
#
#AttributeDef pspngAttributeDef = AttributeDefFinder.findByName("etc:pspng:provision_to_def", true);
#AttributeDefName pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
#AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
#
##Assign the PSPNG attribute for the standard groups
#attributeAssignSave.assignAttributeDefName(pspngAttribute);
#attributeAssignSave.assignOwnerStem(testStem);
#attributeAssignSave.addValue("pspng_groupOfUniqueNames");
#attributeAssignSave.save();
#
##Assign the PSPNG attribute for the entitlements
#AttributeAssignSave attributeAssignSave2 = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
#attributeAssignSave2.assignAttributeDefName(pspngAttribute);
#attributeAssignSave2.assignOwnerGroup(GroupFinder.findByName(gs, "app:vpn:vpn_user", true));
#attributeAssignSave2.addValue("pspng_entitlements");
#attributeAssignSave2.save();
#
#attributeAssignSave2 = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
#attributeAssignSave2.assignAttributeDefName(pspngAttribute);
#attributeAssignSave2.assignOwnerGroup(GroupFinder.findByName(gs, "app:banner:banner_user", true));
#attributeAssignSave2.addValue("pspng_entitlements");
#attributeAssignSave2.save();
