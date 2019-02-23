Class {
	#name : #BaselineOfLowtalk,
	#superclass : #BaselineOf,
	#category : #BaselineOfLowtalk
}

{ #category : #baselines }
BaselineOfLowtalk >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec project: #'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
		spec baseline: #'Slovim' with: [ 
				spec
					repository: 'github://ronsaldo/slovim/tonel';
					loads: #('NoLLVM').
		].
		spec baseline: #'Phanide' with: [ 
				spec
					repository: 'github://ronsaldo/phanide/tonel'.
		].
		spec
			package: #'Lowtalk-Core' with: [
				spec requires: #(#'Slovim' #'PetitParser')
			].
		spec
			package: #'Lowtalk-Phanide' with: [
				spec requires: #(#'Lowtalk-Core' #'Phanide')
			].
	].
]
