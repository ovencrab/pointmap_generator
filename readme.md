# Point Map generator

This matlab script generates a random 3d point map which roughly estimates the structure of a random film of spherical particles of a certain radius (termed AM particles). The pointmap can be used to render a 3D visualisation in a cad software such as Autodesk Inventor or Solidworks. Since the script was designed to visualise Li-ion electrodes, a secondary pointmap of carbon black particles (termed CB particles) can be generated on the surface of the AM particles. Some reasonably complex electrode compositions can be generated, such as discrete layers of different AM particles, graded composition of AM particles or graded composition of CB particles. The main limitation of the script is that the AM particles have to have the same radius even if there are two or more types.

## Installation

Clone the repository using git, or just download as a zip.

~~~
git clone https://github.com/ovencrab/pointmap_generator
~~~

## Description

The Matlab script consists of one main script and 5 functions (AM co-ordinate generation, CB co-ordinate generation and others for separating co-ordinates into certain distributions i.e. grading of AM or CB). ​When run, the script will output x, y and z coordinates to 1 or several *.xlsx* files.

Main parameters:​
- Electrode dimensions (x, y and z)​
- Target solid volume fraction​
- Active material particle radius​
- Carbon black radius
- Number of carbon black particles per AM particle​

Grading parameters:​
- Bins for AM​ particles
- Bins for CB​ particles
- Distribution of AM and/or CB particles per bin​

There is also a separate layering function, but this has been made redundent by the grading functionality.

## Usage (Part 1: Matlab)

1. Open *plot_electrode.m* with Matlab.
2. Choose either:
   1. `load_parameters = 1` to load saved parameters from a .mat file
   2. `load_parameters = 0` to use the modifiable parameters within the *Parameters* sub-section of the script.
3. Run the script within Matlab.
   1. Coordinates will be saved in *.xlsx* files in the script folder.
   2. The output will be visualised as shown below.

![point_maps_matlab](/assets/point_maps_matlab.png)

Note: the settings `plot_am` and `plot_cb` control the output visualisation in Matlab. If plotting over 1000 CB particles, `plot_cb = 0` is recommended.