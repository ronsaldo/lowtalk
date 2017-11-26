writing
sortClass: class visited: visitedSet available: availableSet sorted: sorted
	(visitedSet includes: class) ifTrue: [ ^ self ].
	visitedSet add: class.
	
	(availableSet includes: class superclass) ifTrue: [ 
		self sortClass: class superclass visited: visitedSet available: availableSet sorted: sorted
	].
 
	sorted add: class