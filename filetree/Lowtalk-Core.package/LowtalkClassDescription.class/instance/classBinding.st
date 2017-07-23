accessing
classBinding
	^ classBinding ifNil: [classBinding := classObject lowtalkPerform: #binding withArguments: #() inSuperclass: false node: nil compiler: compiler]