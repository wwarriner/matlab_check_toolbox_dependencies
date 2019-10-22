# Check Toolbox Dependencies
MATLAB's built-in toolbox dependency check function returns the set of toolboxes required for a list of files.
What if you have a client who can't afford every toolbox, and wants to know what functionality is available?
What if you want to figure out which function is has a specific toolbox as a function?
What if you've forgotten what toolboxes you've used in each function?

The `check_toolbox_dependencies()` function in this repository will return a table of dependencies for all the files in a user-supplied folder, over a user-supplied extension. The default folder is `pwd()` and the default extension is `.m`. By default the function operates recursively using dir glob, but if the user does not want this, the third positional argument should be `false`.

Because the function must call `dependencies.toolboxDependencyAnalysis()` once for every file, the function can take some time to run. If you have any suggestions on how to speed this up, please let me know!
