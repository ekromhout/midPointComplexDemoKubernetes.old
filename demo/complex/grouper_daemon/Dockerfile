FROM tier/grouper:2.3.0-a109-u47-w12-p21

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>"

# This is to allow running gsh on this container interactively

ENTRYPOINT []

CMD bash -c "while ! curl -s grouper_data:3306 > /dev/null; do echo waiting for mysql on grouper_data to start; sleep 3; done; \
             while ! curl -s ldap://directory:389 > /dev/null; do echo waiting for ldap on directory to start; sleep 3; done; \
             /usr/local/bin/entrypoint.sh daemon"
