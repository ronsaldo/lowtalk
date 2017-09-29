*Lowtalk-IDE
gtInspectorLowtalkIn: composite
	<gtInspectorPresentationOrder: 0>
	(#('ltk' 'lowtalk') includes: self extension)
		ifFalse: [ ^ self ].
	
	^ composite custom: (GLMRubricHighlightedTextPresentation new
		title: 'Lowtalk';
		font: StandardFonts codeFont;
		editingMode: [ : rubPresentation |
			GLMHighlighterTextRubEditingMode withStylerDecorator: (
				LowtalkHighlighterTextDecorator 
					inPresentation: rubPresentation
					fileReference: self)];
		display: [ self readStreamDo: #contents ];
		act: [:rub | 
			self 
				ensureDelete; 
				writeStreamDo: [ :s | s nextPutAll: rub text asString withUnixLineEndings ]] 
			icon: GLMUIThemeExtraIcons glamorousSave 
			on: $s
			entitled: 'Save')