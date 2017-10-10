accessing
superclass
	"Allow retrieving the super class"
	(superclass isNil and: [classObject isNotNil]) ifTrue: [ 
		superclass := classObject superclass ifNotNil: [ :sc | sc asLowtalkTypeWith: compiler ]
	].
	^ super superclass