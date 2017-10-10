methods
category: categoryName methods: newMethods
	<compileTime>
	newMethods do: [ :method |
		pendingMethods at: method selector put: method.
		organization at: method put: categoryName
	].
