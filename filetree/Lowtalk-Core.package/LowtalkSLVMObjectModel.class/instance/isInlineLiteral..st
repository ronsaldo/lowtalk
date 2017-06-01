testing
isInlineLiteral: literal
	| literalClass |
	literalClass := literal class.
	(literalClass includesBehavior: Boolean) ifTrue: [ ^ true].
	(literalClass includesBehavior: Float) ifTrue: [ ^ self isSmallFloat: literal ].
	(literalClass includesBehavior: Integer) ifTrue: [ ^ self isSmallInteger: literal ].
	(literalClass includesBehavior: UndefinedObject) ifTrue: [ ^ true].
	^ false