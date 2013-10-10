with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;

with Scene;

package body Frame is

	procedure Calcul_Image is
        P : array (1..3) of Vecteur(1..2);
	begin
		-- a faire : calcul des projections, affichage des triangles
        --
        
        for IdF in 1..Scene.Nombre_De_Facettes loop
            Scene.Projection_Facette(IdF, P(1), P(2), P(3));
            Ligne.Tracer_Segment(P(1)(1), P(1)(2), 
                                 P(2)(1), P(2)(2));
            Ligne.Tracer_Segment(P(2)(1), P(2)(2), 
                                 P(3)(1), P(3)(2));
            Ligne.Tracer_Segment(P(3)(1), P(3)(2), 
                                 P(1)(1), P(1)(2));

        end loop;
        
	end;

end Frame;
