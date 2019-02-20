# RSTOOLS - response surface utilities for Matlab

This toolbox contains some utility functions for classical design of experiments and response surface analysis. 

The two main functions are:

	reg   - linear regression
	rsreg - quadratic response surface regression

Both the functions have same options but different defaults. The regression functions return "rsreg" object, with the following methods defined:

	parameters
	residuals
	predicted
	r2
	cook
	resplot
	normalplot
	quadplot
	cana
	gradpath

There are some examples in the `examples` directory.

The code has been used for teaching statistical design of experiments and it is provided as is with no warranties or promises about its usability. The code uses some files from DATANA toolbox by kind permission of ProfMath Ltd. Comments and suggestions for improvement are welcome.
