initialization
initialize
	super initialize.
	
	Keywords := Set newFrom: #(
		"Standard Smalltalk keywords"
		self super #'nil' #'true' #'false'
		thisContext
		
		"Lowtalk keywords"
		let
	)