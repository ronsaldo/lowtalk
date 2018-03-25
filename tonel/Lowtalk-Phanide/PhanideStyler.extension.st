Extension { #name : #PhanideStyler }

{ #category : #'*Lowtalk-Phanide' }
PhanideStyler class >> lowtalk [
	<styler>
	^ self styler: 'Lowtalk' extensions: #(ltk lowtalk) commandHighlighter: LowtalkSyntaxHighlighter
]
