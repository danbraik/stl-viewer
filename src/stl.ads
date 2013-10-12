with Algebre;
use Algebre;

package STL is

	-- nous avons besoin de stocker un ensemble de facettes
	-- il nous faut donc definir les quelques structures suivantes
	type Facette is record
		-- Px are the vertices and N the normal
		P1, P2, P3, N : Vecteur(1..3);
	end record;

	type Tableau_Facette is array(positive range<>) of Facette;

	type Maillage is access Tableau_Facette;

	-- Load a STL file (ASCII or binary format)
	-- raise an exception if the file does not exist
	-- or in case of I/O failure
	function Chargement(Nom_Fichier : String) return Maillage;

end;
