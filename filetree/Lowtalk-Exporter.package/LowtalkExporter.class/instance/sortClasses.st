writing
sortClasses
	| visitedSet availableSet sorted |
	visitedSet := IdentitySet new.
	availableSet := IdentitySet newFrom: classes.
	sorted := OrderedCollection new.
	classes sort: [ :a :b | a name < b name ].
	classes do: [ :cls | self sortClass: cls visited: visitedSet available: availableSet sorted: sorted ].
	classes := sorted