all: validate

fmt:
	terraform fmt *.tf 

validate: 
	terraform fmt -check=true -diff=true
	terraform validate -check-variables=false .
