with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO;
use Ada.Text_IO;
with Algebre;
use Algebre;
with Ada.Characters.Handling;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;


package body STL is

    type TFacette is record
        a,b,c : Vecteur(1..3);
        next : access TFacette;
    end record;
	type Acc_TFacette is access TFacette;

	type ListTF is record
		FirstElt : Acc_TFacette;
		NbElt : Natural;
	end record;



	function Get_Next_Word(F : File_Type) return String is
		BufferInput : String(1..128);
		Char : Character;
		Index : Positive := 1;
	begin
		while not End_Of_File(F) loop
			Get(F, Char);

			if Char /= Character'Val(32) 
				and Char /= Character'Val(9) 
				and Char /= Character'Val(10) then
				BufferInput(Index) := Char;
				Index := Index + 1;
			elsif Index > 1 then
				return BufferInput(1..Index-1);
			end if;
		end loop;
		return BufferInput(1..Index-1);
	end;






	procedure Chargement_ASCII(Nom_Fichier : String; List : out ListTF) is
		type State is 
			(
				Main,
				Vertex_1, -- state where we waiting to read the first vertex
				Vertex_2,
				Vertex_3
				);
		Current : State := Main;
		F : File_Type;
        NouvelleFace : Acc_TFacette;
	begin

		List.FirstElt := null;
		List.NbElt := 0;

		Open(File => F, Mode => In_File, Name => Nom_Fichier);

		while not End_Of_File(F) loop
			declare
				Word : String := Get_Next_Word(F);
			begin
				case Current is
					when Main =>
						if Word= "facet" then 
							Current := Vertex_1;
        					NouvelleFace := new TFacette;
							NouvelleFace.Next := List.FirstElt;
							List.FirstElt := NouvelleFace;
							List.NbElt := List.NbElt + 1;
						end if;
					when Vertex_1 =>
						if Word = "vertex" then
        					NouvelleFace.A := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Vertex_2;
						end if;
					when Vertex_2 =>
						if Word = "vertex" then
        					NouvelleFace.B := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Vertex_3;
						end if;
					when Vertex_3 =>
						if Word = "vertex" then
        					NouvelleFace.C := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Main;
						end if;
				end case;
			end;
		end loop;
		Close (F);
	end;



	function Chargement(Nom_Fichier : String) return Maillage is
		List : ListTF;
		Iterator : access TFacette;
		M : Maillage;
		Count : Natural;
	begin
		Chargement_ASCII(Nom_Fichier, List);
		Count := List.NbElt;
		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		M := new Tableau_Facette(1..Count);

		Iterator := List.FirstElt;
		while Iterator /= null loop
			M(Count).P1 := Iterator.A;
			M(Count).P2 := Iterator.B;
			M(Count).P3 := Iterator.C;

			Count := Count - 1;
			Iterator := Iterator.Next; 
		end loop;

		return M;
	end;

end;
