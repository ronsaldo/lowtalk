private
parseAttributes: anAttributeName
	| attributes color parsedAttributes emphasis |
	attributes := self styleTable detect: [ :el | el first == anAttributeName ] ifNone: [
		self error: 'Missing text style ' , anAttributeName printString
	].
	color := Color colorFrom: attributes second. 
	parsedAttributes := {TextColor color: color}.
	attributes size >= 3 ifTrue: [
		emphasis := attributes third.
		parsedAttributes := parsedAttributes , { TextEmphasis perform: emphasis }
	].

	^ parsedAttributes