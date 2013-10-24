with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Algebre; use Algebre;
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
with Interfaces; use Interfaces;
with Algebre; use Algebre;
with Ada.Unchecked_Deallocation;

package body STL is

	-- Node of a linked list
	-- Contains a face and an access to the next Node	
	type TFacette;
    type Acc_TFacette is access TFacette;

    type TFacette is record
		face : Facette;
        next : Acc_TFacette;
    end record;

	-- Linked List of face
	type ListTF is record
		-- Access to the first element
		FirstElt : Acc_TFacette;
		-- Number of element into the list
		NbElt : Natural;
	end record;


    -- Deallocate useless node
    procedure FreeTFacette is new Ada.Unchecked_Deallocation(TFacette, Acc_TFacette);

	-- Complete face data : compute the normal
	procedure FinalizeFace(face : in out Facette) is
	begin
		-- * is the cross product
		face.N := (face.P2 - face.P1) * (face.P3 - face.P1);
		normalize(face.N);
	end;


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






	procedure Chargement_ASCII(Nom_Fichier : String; M : out Maillage) is
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
		List : ListTF;
		Iterator, OldIt : Acc_TFacette;
		Count : Natural;
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
						end if;
					when Vertex_1 =>
						if Word = "vertex" then
        					NouvelleFace.face.P1 := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Vertex_2;
                        elsif Word = "endfacet" then -- malformed face
                            raise Data_Error;
						end if;
					when Vertex_2 =>
						if Word = "vertex" then
        					NouvelleFace.face.P2 := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Vertex_3;
                        elsif Word = "endfacet" then -- malformed face
                            raise Data_Error;
						end if;
					when Vertex_3 =>
						if Word = "vertex" then
        					NouvelleFace.face.P3 := (
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)),
								Float'Value(Get_Next_Word(F)));
							Current := Main;
							FinalizeFace(NouvelleFace.face);
							NouvelleFace.Next := List.FirstElt;
							List.FirstElt := NouvelleFace;
							List.NbElt := List.NbElt + 1;
                        elsif Word = "endfacet" then -- malformed face
                            raise Data_Error;
						end if;
				end case;
            exception
                when Data_Error =>
					Current := Main;
                    Put_Line(Standard_Error, 
                        "STL file is malformed : found invalid face");
			end;
		end loop;
		Close (F);

		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		Count := List.NbElt;
		begin
	        M := new Tableau_Facette(1..Count);
		exception
			when Storage_Error => 
				M := null;
				Put_Line(Standard_Error, "Error when loading file : not enough memory.");
				return;
		end;

		Iterator := List.FirstElt;
		while Iterator /= null loop
			M(Count) := Iterator.face;

			Count := Count - 1;
            OldIt := Iterator;
			Iterator := Iterator.Next;
            FreeTFacette(OldIt);
		end loop;

	end;


	procedure Chargement_Bin(Nom_Fichier : String; M : out Maillage) is
        Input_File   : Ada.Streams.Stream_IO.File_Type;
        Input_Stream : Ada.Streams.Stream_IO.Stream_Access;
		F : Ada.Streams.Stream_IO.File_Type;
		NbElt : Unsigned_32;
        Char : Integer_8;
        Index : Positive := 1;
        TmpF : Float;
        I16 : Integer_16;
	begin
        Ada.Streams.Stream_IO.Open(Input_File,
            Ada.Streams.Stream_IO.In_File, 
            Nom_Fichier);
        Input_Stream := Ada.Streams.Stream_IO.Stream(Input_File);

		begin
			-- read header
			For i in 1..80 loop
		   	   Integer_8'Read(Input_Stream, Char);
			end loop;

			-- read number of faces
        	Unsigned_32'Read(Input_Stream, NbElt);
	        M := new Tableau_Facette(1..Integer'Val(NbElt));

        	while Index <= M'Last loop
            	-- read normal vector
            	For c in 1..3 loop
                	Float'Read(Input_Stream, TmpF);
            	end loop;
            	-- read vertex 1
            	For c in 1..3 loop
                	Float'Read(Input_Stream, M(Index).P1(c));
            	end loop;
            	-- read vertex 2
            	For c in 1..3 loop
                	Float'Read(Input_Stream, M(Index).P2(c));
            	end loop;
            	-- read vertex 3
            	For c in 1..3 loop
                	Float'Read(Input_Stream, M(Index).P3(c));
            	end loop;
            	-- read byte count
            	Integer_16'Read(Input_Stream, I16);

				FinalizeFace(M(Index));
            	Index := Index + 1;
        	end loop;
		exception
			when Storage_Error => 
				M := null;
				Put_Line(Standard_Error, "Error when loading file : not enough memory.");
			when End_Error => 
				M := null;
				Put_Line(Standard_Error, "Error when loading file : file is too short.");
			when others => 
				M := null;
				Put_Line(Standard_Error, "Error when loading file : unknown error.");
		end;
		
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
		M : Maillage := null;
		Mode : Natural;
	begin
		Mode := GetFileMode(Nom_Fichier);
		if Mode = 0 then -- it is ASCII file
			Put_Line("STL file : ASCII format.");
			Chargement_ASCII(Nom_Fichier, M);
		elsif Mode = 1 then -- it is binary file
			Put_Line("STL file : binary format.");
			Chargement_Bin(Nom_Fichier, M);
		end if;

		-- check if M is null
		-- if it is, create an empty array
		if M = null then
			M := new Tableau_Facette(1..0);
		end if;

		Put_Line(Integer'Image(M'Length) & " faces loaded.");
		New_Line;

		return M;
	end;

end;
