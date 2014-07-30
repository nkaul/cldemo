#!/bin/bash

if [[ $# -ne 1 ]]; then 
  echo "$(basename $0) ldif_file" >&2 
  exit 1
fi

file=$1

la='/usr/bin/ldapadd -D cn=admin,dc=lab,dc=local -c -w CumulusLinux! -x -f'
ld='/usr/bin/ldapdelete -D cn=admin,dc=lab,dc=local -c -w CumulusLinux! -x'

dc="dc=lab,dc=local"

for i in {1..10}
do
   $ld "uid=cldemo${i},ou=users,${dc}"
done

$ld "ou=users,${dc}"
$ld "cn=cldemo,ou=groups,${dc}"
$ld "ou=groups,${dc}"
$ld "${dc}"

$la $file

exit 0

