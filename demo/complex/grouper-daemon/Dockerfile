FROM tier/grouper:latest

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>"

# JUST FOR TESTING - REMOVE BEFORE RELEASE
RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/US/Central /etc/localtime \
 && date

CMD ["daemon"]
