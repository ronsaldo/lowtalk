as yet unclassified
highlightText: aStringOrText
	| highlighted |
	self parse: aStringOrText.
	
	highlighted := aStringOrText asText.
	self commands do: [ :command | command executeOn: highlighted inPresentation: nil relativeToFileReference: nil ].
	^ highlighted