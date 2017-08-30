baselines
baseline: spec
	<baseline>

	spec for: #common do: [
		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
		spec project: 'Slovim' with: [ 
				spec
					className: #ConfigurationOfSlovim;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/Slovim/main/'.
		].
		spec
			package: 'Lowtalk-Core' with: [
				spec requires: #('Slovim' 'PetitParser')
			]
	].