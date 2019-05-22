System.out.println("************** demo.gsh starting...");

gs = GrouperSession.startRootSession();

addStem("", "app", "app")
addStem("", "basis", "basis")
addStem("", "bundle", "bundle")
addStem("", "org", "org")
addStem("", "test", "test")
addStem("", "midpoint", "midpoint")

addRootStem("ref", "ref")
addStem("ref", "course", "course")
addStem("ref", "affiliation", "affiliation")

group = new GroupSave(gs).assignName("etc:affiliationLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUPS_FROM_ATTRIBUTES");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(eduPersonAffiliation=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=People");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uid");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupAttributeName(), "eduPersonAffiliation");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
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
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=People");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uid");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupAttributeName(), "businessCategory");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupNameExpressionName(), 'ref:dept:${groupAttribute}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupDisplayNameExpressionName(), '${groupAttribute}');

group = new GroupSave(gs).assignName("etc:coursesLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUP_LIST");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=Courses,ou=Groups");
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
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=midpoint,ou=Groups");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "ldap");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uniqueMember");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");

midpointGroupsGroup = new GroupSave(gs).assignName("etc:midpointGroups").assignCreateParentStemsIfNotExist(true).save();

testGroup = new GroupSave(gs).assignName("midpoint:test").assignCreateParentStemsIfNotExist(true).save();
chess = new GroupSave(gs).assignName("app:mailinglist:chess").assignCreateParentStemsIfNotExist(true).save()
idmfans = new GroupSave(gs).assignName("app:mailinglist:idm-fans").assignCreateParentStemsIfNotExist(true).save()
cs = new GroupSave(gs).assignName("app:cs").assignCreateParentStemsIfNotExist(true).save()
volunteers = new GroupSave(gs).assignName("test:volunteers").assignCreateParentStemsIfNotExist(true).save()

midpointGroupsGroup.addMember(SubjectFinder.findById(testGroup.getId(), 'group', 'g:gsa'), false)
midpointGroupsGroup.addMember(SubjectFinder.findById(chess.getId(), 'group', 'g:gsa'), false)
midpointGroupsGroup.addMember(SubjectFinder.findById(idmfans.getId(), 'group', 'g:gsa'), false)
midpointGroupsGroup.addMember(SubjectFinder.findById(cs.getId(), 'group', 'g:gsa'), false)
midpointGroupsGroup.addMember(SubjectFinder.findById(volunteers.getId(), 'group', 'g:gsa'), false)

