as yet unclassified
applyStyle: styleName on: aText
	| attributes |
	attributes := self class attributesFor: styleName.
	attributes do: [ :attr |
		aText addAttribute: attr from: start to: stop
	].