
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Algebre is

	--voir http://en.wikipedia.org/wiki/3D_projection#Perspective_projection
	function Matrice_Rotations(Angles : Vecteur) return Matrice is
		Rotation : Matrice(1..3, 1..3);
	begin
		-- a faire
        for r in Rotation'Range(1) loop
            for c in Rotation'Range(2) loop
                Rotation(r, c) := 0.0;
            end loop;
        end loop;
        for i in 1..3 loop
            Rotation(i,i) := 1.0;
        end loop;

		return Rotation;
	end;

	function Matrice_Rotations_Inverses(Angles : Vecteur) return Matrice is
		Rotation : Matrice(1..3, 1..3);
	begin
		-- a faire
        for r in Rotation'Range(1) loop
            for c in Rotation'Range(2) loop
                Rotation(r, c) := 0.0;
            end loop;
        end loop;
        for i in 1..3 loop
            Rotation(i,i) := 1.0;
        end loop;
		return Rotation;
	end;

	function "*" (X : Matrice ; Y : Vecteur) return Vecteur is
		Z : Vecteur(X'Range(1));
	begin
	    for r in X'Range(1) loop
            Z(r) := 0.0;
            for c in X'Range(2) loop
                Z(r) := Z(r) + X(r, c) * Y(c);
            end loop;
        end loop;

		return Z;
	end;


	function Projection(A, C, E : Vecteur ; T : Matrice) return Vecteur is
		Resultat : Vecteur(1..3);
        tmp : Float;
        P, D : Vecteur(1..3);
	begin
        P := (  A(1) - C(1), 
                A(2) - C(2),
                A(3) - C(3) + 0.01);

        D := T * P;

        tmp := E(3) / D(3); 
        Resultat(1) := tmp * D(1) - E(1);
        Resultat(2) := tmp * D(2) - E(2);
        Resultat(3) := D(3);

		return Resultat;
	end;

end;
