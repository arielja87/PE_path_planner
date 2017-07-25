# PE_path_planner
A Matlab project for planning pursuit-evasion paths in planar simply connected polygonal environments

A demonstration of the planner is compiled in PEpaths.exe file in the Downloads folder, where there are also several example environments.
Valid environments are a vertical list of points (x,y) that when read top to bottom, define a polygon counter-clockwise. This polygon must be non-self-intersecting and contain no holes. The program runs best when the lengths of the edges of the environment polygon are within an order of magnitude of 1 unit.

The Matlab Runtime 2015a (8.5) necessary to run PEpath.exe can be found here: https://www.mathworks.com/products/compiler/mcr.html.

This project made extensive use of the planar visibility library at https://github.com/karlobermeyer/VisiLibity1.

Thanks to Professor Roberto Tron at Boston University College of Engineering
