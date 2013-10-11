with Dessin; use Dessin;
with Ligne; use Ligne;
with STL ; use STL;
with Algebre ; use Algebre;

with Scene;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;


package body Frame is

	procedure Calcul_Image is
        P : array (1..3) of Vecteur(1..3);
	begin
		-- a faire : calcul des projections, affichage des triangles
        --
        
        for IdF in 1..Scene.Nombre_De_Facettes loop
            Scene.Projection_Facette(IdF, P(1), P(2), P(3));
            
           if P(1)(3) > 0.0 or else P(2)(3) > 0.0 or else P(3)(3) > 0.0 then 

for i in 1..3 loop
   Put( P(i)(1) );  Put(P(i)(2));Put(P(i)(3));New_Line;
end loop;

            Ligne.Tracer_Segment(P(1)(1), P(1)(2), 
                                 P(2)(1), P(2)(2));

            Ligne.Tracer_Segment(P(2)(1), P(2)(2), 
                                 P(3)(1), P(3)(2));
            Ligne.Tracer_Segment(P(3)(1), P(3)(2), 
                                 P(1)(1), P(1)(2));
           end if;

        end loop;
        
	end;

end Frame;
