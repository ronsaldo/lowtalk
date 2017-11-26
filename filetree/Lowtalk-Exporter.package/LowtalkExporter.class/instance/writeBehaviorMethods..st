writing
writeBehaviorMethods: behavior
	| organization protocol |
	organization := behavior organization.
	organization categoriesSorted reject: [ :cat | (cat beginsWith: '+') or: [cat = '-- all --']] thenDo: [ :cat |
		protocol := organization protocolNamed: cat.
		protocol methods ifNotEmpty: [
			out << behavior name << ' category: ' << cat printString << ' methods: {'; lf.
			protocol methods asArray sorted doWithIndex: [:selector :index |
				index > 1 ifTrue: [ out lf ].
				self writeMethod: (behavior methodDict at: selector)
			].
			out << '}.';lf; lf
		].
	]