stl-viewer
==========

3D STL viewer (Ensimag project)

Dependecies :

* AdaSDL, http://sourceforge.net/projects/adasdl/

  SDL binding in Ada, follow these instructions
  (https://ensiwiki.ensimag.fr/index.php/Installer_AdaSDL_sur_une_machine_personnelle)

  git clone git://git.code.sf.net/p/adasdl/code adasdl-code
  

To compile :

$ export GPR_PROJECT_PATH="/path/to/adasdl-code/Thin/AdaSDL"
$ gprbuild -gnat05 visualiseur.gpr

To execute :

./visualiseur ./stl/monkey_smooth.stl



<img src="https://raw.github.com/danbraik/stl-viewer/master/screen.png"/>
