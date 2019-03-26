
def addGroups(gs,stem) {
	def supergroup = GroupFinder.findByName(gs, "etc:midpointGroups", true)
	for (group in stem.childGroups) {
		if (!group.name.endsWith('_includes') &&
		    !group.name.endsWith('_excludes') &&
		    !group.name.endsWith('_systemOfRecord') &&
		    !group.name.endsWith('_systemOfRecordAndIncludes')) {
			println 'Adding: ' + group
			def s = SubjectFinder.findById(group.getId(), 'group', 'g:gsa')
			supergroup.addMember(s, false)
		} else {
			println 'Ignoring: ' + group
		}
	}
}

gs = GrouperSession.startRootSession()

addGroups(gs, StemFinder.findByName(gs, 'ref:affiliation'))
addGroups(gs, StemFinder.findByName(gs, 'ref:dept'))
addGroups(gs, StemFinder.findByName(gs, 'ref:course'))

