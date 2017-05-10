accessing
pragma
	^ super pragma ==> [ :list |
		LowtalkASTPragma new
			position: list first;
			selector: list second selector;
			arguments: list second arguments;
			yourself
	]