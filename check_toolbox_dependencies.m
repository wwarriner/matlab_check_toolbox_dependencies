%{
Copyright 2019 William Warriner
Licensed under the The Unlicense (https://unlicense.org/)

check_toolbox_dependencies
MATLAB's built-in toolbox dependency check function returns the set of toolboxes
required for a list of files.
 - What if you have a client who can't afford every toolbox, and wants to know
  what functionality is available in a compiled executable?
 - What if you want to figure out which function is has a specific toolbox as a
  function?
 - What if you've forgotten what toolboxes you've used in each function?

The `check_toolbox_dependencies()` function in this repository will return a
table of dependencies for all the files in a user-supplied folder, over a 
user-supplied extension. The default folder is `pwd()` and the default extension
is `.m`. By default the function operates recursively using dir glob, but if the
user does not want this, the third positional argument should be `false`.

Becaue the function must call `dependencies.toolboxDependencyAnalysis()` once
for every file, the function can take some time to run. If you have any
suggestions on how to speed this up, please let me know!
%}
function dep_tab = check_toolbox_dependencies(folder, ext, recursive)

if nargin < 1
    folder = pwd();
end

if nargin < 2
    ext = ".m";
end

if nargin < 3
    recursive = true;
end

if recursive
    subfolder = "**";
else
    subfolder = "";
end
exts = "*" + ext;
glob = fullfile(folder, subfolder, exts);

files = struct2table(dir(glob));
count = height(files);

deps = strings(count, 1);
deps(:) = missing;
for i = 1 : 2
    dep = dependencies.toolboxDependencyAnalysis(files(i, :).name);
    dep = string(dep);
    deps(i, 1:numel(dep)) = matlab.lang.makeValidName(dep);
end
deps(ismissing(deps)) = "";

unique_deps = unique(deps);
unique_deps(unique_deps == "") = [];
dep_count = numel(unique_deps);

dep_tab = array2table( ...
    false(count, numel(unique_deps)), ...
    "variablenames", unique_deps ...
    );
for i = 1 : count
    for j = 1 : dep_count
        if any(deps(i, :) == unique_deps(j))
            dep_tab{i, j} = true;
        end
    end
end
dep_tab = [ files.name files.folder dep_tab ];
dep_tab.Properties.VariableNames(1:2) = files.Properties.VariableNames(1:2);

end

