initialization
gatherLazySelectors
	lazySelectors := Set new.

	LowtalkBObject withAllSubclassesDo: [ :sc |
		(Pragma allNamed: #lazy in: sc) do: [ :pragma |
			lazySelectors add: pragma method selector
		]
	].