with Algebre; use Algebre;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure Test_algebre is
    X : Matrice(1..3,1..3); 
    Y : Vecteur(1..3);
    Z : Vecteur(1..3);

    A, B : Matrice(1..3,1..3);
begin
    for r in X'Range(1) loop
        for c in X'Range(2) loop
            X(r,c) := 0.0;
        end loop;
    end loop;


    X(1,1) := 1.0;
    X(1,2) := 1.0;

    Y := (1.0, 1.0, 1.0);

    Z := X*Y;

  --  For i in Z'Range loop
  --      Put(Z(i));New_Line;
  --  end loop;


    for r in A'Range(1) loop
        for c in A'Range(2) loop
            A(r,c) := 0.0;
        end loop;
    end loop;

    for r in B'Range(1) loop
        for c in B'Range(2) loop
            B(r,c) := 0.0;
        end loop;
    end loop;

    for i in 1..3 loop
        A(i,i):=1.0;
        B(i,i):=1.0;
    end loop;


    X := A * B;


--    for r in X'Range(1) loop
--        for c in X'Range(2) loop
     --       Put(X(r,c));
--        end loop;
     --   New_Line;
--    end loop;



	Y := (1.0, 0.0,0.0);
	Z := Matrice_Rotations ((1=>3.1415/2.0,2=>03.1415/2.0,3=>0.0))   * Y;
    For i in Z'Range loop
        Put(Z(i));New_Line;
    end loop;

	Z := Matrice_Rotations_Inverses ((1=>3.1415/2.0,2=>03.1415/2.0,3=>0.0))   * Y;
    For i in Z'Range loop
        Put(Z(i));New_Line;
    end loop;

end;
