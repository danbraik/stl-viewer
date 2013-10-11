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
with Ada.Sequential_IO;
with Ada.Text_IO; -- Text I/O library
   with Ada.Float_Text_IO; -- Float I/O library
   with Ada.Sequential_IO; -- Sequential I/O library
with Ada.Float_Text_IO;
with Ada.Streams.Stream_IO;
with Interfaces;
use Interfaces;

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


	-- Could raise exception if a word is larger than 128 bytes
	function Get_Next_Word(F : File_Type) return String is
		BufferInput : String(1..128);
		Char : Character;
		Index : Positive := 1;
	begin
		while not End_Of_File(F) loop
			Get_Immediate(F, Char);

			if Char /= Character'Val(32) 
				and Char /= Character'Val(9) 
				and Char /= Character'Val(10) then
				-- don't check index to have performance
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
		F : Ada.Text_IO.File_Type;
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


	procedure Chargement_Bin(Nom_Fichier : String; M : out Maillage) is
        Input_File   : Ada.Streams.Stream_IO.File_Type;
        Input_Stream : Ada.Streams.Stream_IO.Stream_Access;
		F : Ada.Streams.Stream_IO.File_Type;
		NbElt : Unsigned_32;
        Char : Integer_8;
        Index : Positive := 1;
	begin
        Ada.Streams.Stream_IO.Open(Input_File,
            Ada.Streams.Stream_IO.In_File, 
            Nom_Fichier);
        Input_Stream := Ada.Streams.Stream_IO.Stream(Input_File);

		For i in 1..80 loop
		   Integer_8'Read(Input_Stream, Char);
		end loop;

        Unsigned_32'Read(Input_Stream, NbElt);

        M := new Tableau_Facette(1..Integer'Val(NbElt));

        while Index <= M'Last loop
            For c in 1..3 loop
                Float'Read(Input_Stream, M(Index).P1(c));
            end loop;
            For c in 1..3 loop
                Float'Read(Input_Stream, M(Index).P2(c));
            end loop;
            For c in 1..3 loop
                Float'Read(Input_Stream, M(Index).P3(c));
            end loop;

            Index := Index + 1;
        end loop;
		
        Ada.Streams.Stream_IO.Close(Input_File);
	end;


	function GetFileMode(Fname : String) return Natural is
		F : File_Type;
		Res : Natural;
		Buffer : String(1..5);
	begin
		
		Open(F, In_File, Fname);
		For i in Buffer'Range loop
			Get(F, Buffer(i));
		end loop;

		if Buffer = "solid" then
			Res := 0;
		else
			Res := 1;
		end if;
		Close(F);
		return Res;
	end;

	function Chargement(Nom_Fichier : String) return Maillage is
		List : ListTF;
		Iterator : access TFacette;
		M : Maillage;
		Count : Natural;
		Mode : Natural;
	begin
		Mode := GetFileMode(Nom_Fichier);
		if Mode = 0 then -- it is ASCII file
			Put_Line("Chargement ASCII");
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
		elsif Mode = 1 then -- it is binary file
			Put_Line("Chargement binaire");
			Chargement_Bin(Nom_Fichier, M);
		end if;

		return M;
	end;

end;
