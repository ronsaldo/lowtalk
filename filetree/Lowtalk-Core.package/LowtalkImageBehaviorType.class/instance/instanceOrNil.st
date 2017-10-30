accessing
instanceOrNil
	^ self isMetaClass ifTrue: [ classObject baseClass asLowtalkTypeWith: compiler ] ifFalse: [ nil ]