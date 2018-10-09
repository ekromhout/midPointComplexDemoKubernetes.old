System.out.println("************** t420.gsh starting **************");

gs = GrouperSession.startRootSession()

alumIncludes = GroupFinder.findByName(gs, 'ref:affiliation:alum_includes')
testGroup = GroupFinder.findByName(gs, 'etc:testGroup')
kwhite = SubjectFinder.findById('kwhite', 'person', 'ldap')
wprice = SubjectFinder.findById('wprice', 'person', 'ldap')
testGroup.addMember(kwhite, false)
alumIncludes.deleteMember(wprice, false)

System.out.println("************** t420.gsh done **************");
