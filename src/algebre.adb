
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Algebre is

	--voir http://en.wikipedia.org/wiki/3D_projection#Perspective_projection
	function Matrice_Rotations(Angles : Vecteur) return Matrice is
		Rotation : Matrice(1..3, 1..3);
		A : Matrice(1..3, 1..3);
		B : Matrice(1..3, 1..3);
		C : Matrice(1..3, 1..3);
		X : Float := Angles(1);
		Y : Float := Angles(2);
		Z : Float := Angles(3);
	begin

		A := ((Cos(Z), -Sin(Z), 0.0),
			  (Sin(Z), Cos(Z), 0.0),
			  (0.0, 0.0, 1.0));

		B := ((Cos(Y), 0.0, Sin(Y)),
			   (0.0, 1.0, 0.0),
			   (-Sin(Y), 0.0, cos(Y)));

		C := ((1.0, 0.0, 0.0),
			  (0.0, cos(X), -sin(X)),
			  (0.0, sin(X), cos(X)));

		Rotation := A*(B*C);
		return Rotation;
	end;

	function Matrice_Rotations_Inverses(Angles : Vecteur) return Matrice is
		Rotation : Matrice(1..3, 1..3);
		A : Matrice(1..3, 1..3);
		B : Matrice(1..3, 1..3);
		C : Matrice(1..3, 1..3);
		X : Float := Angles(1);
		Y : Float := Angles(2);
		Z : Float := Angles(3);
	begin
		A := ((Cos(Z), -Sin(Z), 0.0),
			  (Sin(Z), Cos(Z), 0.0),
			  (0.0, 0.0, 1.0));

		B := ((Cos(Y), 0.0, Sin(Y)),
			   (0.0, 1.0, 0.0),
			   (-Sin(Y), 0.0, cos(Y)));

		C := ((1.0, 0.0, 0.0),
			  (0.0, cos(X), -sin(X)),
			  (0.0, sin(X), cos(X)));

		Rotation := C*(B*A);
		return Rotation;
	end;


    function "*" (A, B : Matrice) return Matrice is
        Z : Matrice(A'Range(1), B'Range(2));
    begin
	    for r in Z'Range(1) loop
            for c in Z'Range(2) loop
                Z(r,c) := 0.0;
                for i in Z'Range(2) loop
                    Z(r,c) := Z(r,c) + A(r, i) * B(i, c);
                end loop;
            end loop;
        end loop;

		return Z;
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
                A(3) - C(3) );

        D := T * P;

        tmp := E(3) / D(3); 
        Resultat(1) := tmp * D(1) - E(1);
        Resultat(2) := tmp * D(2) - E(2);
        Resultat(3) := D(3);

		return Resultat;
	end;

end;
