as yet unclassified
withEnvironment: anEnvironment do: aBlock
	| oldEnvironment |
	oldEnvironment := environment.
	environment := anEnvironment.
	[ 
		aBlock value
	] ensure: [ environment := oldEnvironment ]