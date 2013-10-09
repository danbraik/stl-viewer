
with Ada.Text_IO;
use Ada.Text_IO;
with Algebre;
use Algebre;

package body STL is

    type TFacette is record
        a,b,c : Vecteur(1..3);
        next : access TFacette;
    end record;

    function Nombre_Facettes(Nom_Fichier : String) return Natural is
		F : File_Type;
		Nb : Natural := 0;
    begin
		Open(File => F, Mode => In_File, Name => Nom_Fichier);
		-- a faire : compter les facettes (p.ex. chercher les "endloop")...
		Close(F);
		return Nb;
    end;

	function Chargement_ASCII(Nom_Fichier : String) return Maillage is
		Nb_Facettes : Natural;
		M : Maillage;
		F : File_Type;
        NouvelleFace : access TFacette;
	begin
		Nb_Facettes := Nombre_Facettes(Nom_Fichier);
		-- une fois qu'on a le nombre de facettes on connait la taille du maillage
		M := new Tableau_Facette(1..Nb_Facettes);
		-- on ouvre de nouveau le fichier pour parcourir les facettes
		-- et remplir le maillage
		Open(File => F, Mode => In_File, Name => Nom_Fichier);
		-- a faire...
        
        NouvelleFace := new TFacette;
        NouvelleFace.A := (0.0,0.0,0.0);

		Close (F);
		return M;
	end;

end;
