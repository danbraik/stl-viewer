with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;
use Ada.Text_IO;

package body Scene is

	R : Float := 5.0; -- coordonnee Z initiale de la camera
	Rho : Float := 0.0; -- rotation autour de X
	Theta : Float := 0.0; -- rotation autour de Y
	Phi : Float := 0.0; -- rotation autour de Z

	E : Vecteur(1..3) := (-400.0, -300.0, 400.0); -- position du spectateur
	T : Matrice(1..3, 1..3); -- matrice de rotation
	T2 : Matrice(1..3, 1..3); -- matrice de rotation

	M : Maillage;

	procedure Modification_Matrice_Rotation is
	begin
		T := Matrice_Rotations ((1 => -Rho, 2 => -Theta, 3 => -Phi));
		T2 := Matrice_Rotations_Inverses ((1 => Rho, 2 => Theta, 3 => Phi));
	end Modification_Matrice_Rotation;


	function Position_Camera return Vecteur is
		Position : Vecteur(1..3);
        Base : Vecteur(1..3);
	begin
        Base := (0.0, 0.0, -R+0.001);
        Position := T * Base;
		--Position := Base;
		return Position;
	end;


	procedure Projection_Facette(Index_Facette : Positive ; P1, P2, P3 : out Vecteur) is
        f : Facette;
        PosCam : Vecteur := Position_Camera;
	begin
		-- a faire
        f := M(Index_Facette);

        P1 := Projection(f.P1, PosCam, E, T2);
        P2 := Projection(f.P2, PosCam, E, T2);
        P3 := Projection(f.P3, PosCam, E, T2);
	end;


	procedure Ajout_Maillage(MIn : Maillage) is
	begin
		M := MIn;
		null;
	end;


	function Nombre_De_Facettes return Natural is
		N : Natural;
	begin
		-- a faire
		return M'Length;
	end;


	procedure Modification_Coordonnee_Camera(Index : Positive ; Increment : Float) is
	begin
		-- a faire
        case Index is
            when 1 => R := R + Increment;
            when 2 => Rho := Rho + Increment;
            when 3 => Theta := Theta + Increment;
            when 4 => Phi := Phi + Increment;
            when others => null;
        end case;

        Modification_Matrice_Rotation;
	end;

begin
	--initialisation de la matrice de rotation au lancement du programme
	Modification_Matrice_Rotation;
end;
