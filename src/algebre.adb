
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Algebre is

	-- Init the matrix rotation
	-- A is associated with the X angle, etc.
	procedure GetRotationMatrix(A, B, C : out Matrice; X, Y, Z : Float) is
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
	end;

	--voir http://en.wikipedia.org/wiki/3D_projection#Perspective_projection
	function Matrice_Rotations(Angles : Vecteur) return Matrice is
		A : Matrice(1..3, 1..3);
		B : Matrice(1..3, 1..3);
		C : Matrice(1..3, 1..3);
		X : Float := Angles(1);
		Y : Float := Angles(2);
		Z : Float := Angles(3);
	begin
		GetRotationMatrix(A, B, C, X, Y, Z);
		return A*B*C;
	end;

	function Matrice_Rotations_Inverses(Angles : Vecteur) return Matrice is
		A : Matrice(1..3, 1..3);
		B : Matrice(1..3, 1..3);
		C : Matrice(1..3, 1..3);
		X : Float := Angles(1);
		Y : Float := Angles(2);
		Z : Float := Angles(3);
	begin
		GetRotationMatrix(A, B, C, X, Y, Z);
		return C*B*A; 
	end;


	-- Matrix product
	-- A's column number must be equal to B's row number
    function "*" (A, B : Matrice) return Matrice is
        Z : Matrice(A'Range(1), B'Range(2));
    begin
	    for r in Z'Range(1) loop
            for c in Z'Range(2) loop
                Z(r,c) := 0.0;
				-- suppose A'Range(2) == B'Range(1)
                for i in A'Range(2) loop
                    Z(r,c) := Z(r,c) + A(r, i) * B(i, c);
                end loop;
            end loop;
        end loop;

		return Z;
    end;

	-- Matrix and vector product
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


	-- Calculates coordinates relative to the camera
	-- return a 3D vector, Z indicates the distance 
	-- 	 between the point and the camera
	function Projection(A, C, E : Vecteur ; T : Matrice) return Vecteur is
		Resultat : Vecteur(1..3);
        tmp : Float;
        P, D : Vecteur(1..3);
	begin
		-- calculates point coo relative the camera center
        P := (  A(1) - C(1), 
                A(2) - C(2),
                A(3) - C(3) );

		-- calc point coo in the camera system
        D := T * P;

		-- prevent div by 0
		if D(3) /= 0.0 then
    	    tmp := E(3) / D(3); 
			Resultat(1) := tmp * D(1) - E(1);
			Resultat(2) := tmp * D(2) - E(2);
		end if;
		Resultat(3) := D(3);

		return Resultat;
	end;

end;
