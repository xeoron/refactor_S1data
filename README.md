# refactor_S1data
=====

Refactor Sentinel 1 export and spit out 2 files for LocalAD and AzureAD devices only

Usage: ./refactorS1data.pl S1_export.csv

Tweak as needed: 

Domain Groups are targeted for refactoring data from S1 csv export
	
	localAd is called "IN"  <-- yours might be different
	azureAD is called "WORKGROUP"  <-- yours might be different

Hardcoded exported filenames for refactored data

	localAD files are called "_localAD.csv"
	azureAD files are called "_intune.csv"

Targeting things to strip out of each line is now easier. Edit the Strip array vaiable

	@strip = ("X");   #  Example of adding more/changing the list to cycle through ("x", "y", "z")
