System.out.println("************** t260.gsh starting **************");

gs = GrouperSession.startRootSession()

midpointGroups = GroupFinder.findByName(gs, 'etc:midpointGroups')

new GroupSave(gs).assignName("midpoint:alum").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:alum').addMember(SubjectFinder.findByIdentifier('ref:affiliation:alum', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:alum', 'group', 'g:gsa'), false)

new GroupSave(gs).assignName("midpoint:community").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:community').addMember(SubjectFinder.findByIdentifier('ref:affiliation:community', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:community', 'group', 'g:gsa'), false)

new GroupSave(gs).assignName("midpoint:faculty").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:faculty').addMember(SubjectFinder.findByIdentifier('ref:affiliation:faculty', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:faculty', 'group', 'g:gsa'), false)

new GroupSave(gs).assignName("midpoint:member").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:member').addMember(SubjectFinder.findByIdentifier('ref:affiliation:member', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:member', 'group', 'g:gsa'), false)

new GroupSave(gs).assignName("midpoint:staff").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:staff').addMember(SubjectFinder.findByIdentifier('ref:affiliation:staff', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:staff', 'group', 'g:gsa'), false)

new GroupSave(gs).assignName("midpoint:student").assignCreateParentStemsIfNotExist(true).save()
GroupFinder.findByName(gs, 'midpoint:student').addMember(SubjectFinder.findByIdentifier('ref:affiliation:student', 'group', 'g:gsa'), false)
midpointGroups.addMember(SubjectFinder.findByIdentifier('midpoint:student', 'group', 'g:gsa'), false)

System.out.println("************** t260.gsh done **************");
