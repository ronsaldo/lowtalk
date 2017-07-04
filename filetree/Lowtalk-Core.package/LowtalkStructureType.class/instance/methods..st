accessing
methods: newMethods
	<compileTime>
	newMethods do: [ :method |
		pendingMethods at: method selector put: method
	].
