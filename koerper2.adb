--  @File: koerper2.adb
--
--  @Project: Programmieruebungen, Uebungsblatt 6
--  @Version: 1
--  @Created: 01. 12. 2011
--  @Author: Marcel Schneider
--
-------------------------------------------------------------------------------
--
--  @Procedure: Koerper2
--


with Ada.Text_IO;
with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
use Ada.Text_IO;
procedure Koerper2 is
   subtype Mass is Float;
   type Koerper_Art is (Wuerfel, Kugel, Zylinder, Kegel); 
   type Koerper (Typ : Koerper_Art) is record 
      case Typ is
         when Wuerfel =>
            Seitenlaenge : Mass;
         when Kugel =>
            Radius : Mass;
         when Zylinder | Kegel => 
               Radius_Grundflaeche : Mass; 
               Hoehe : Mass;
      end case;
   end record;
   
   --  @Procedure: Put 
   --
   --  Gibt die Daten eines Koerpers aus.
   --
   --  @Parameter: 
   --   + k: der Koerper.
   --  
   procedure Put (k : Koerper) is
   begin
      case k.Typ is
         when Wuerfel =>
            Put ("Wuerfel: ");
            Put ("Seitenlaenge =" & Mass'Image (k.Seitenlaenge));
         when Kugel =>
            Put ("Kugel: ");
            Put ("Radius =" & Mass'Image (k.Radius));
         when Zylinder | Kegel =>
            if k.Typ = Zylinder then
               Put ("Zylinder: ");
            else 
               Put ("Kugel: ");
            end if;
            Put ("Radius Grundflaeche =" & Mass'Image (k.Radius_Grundflaeche));
            Put (" Hoehe =" & Mass'Image (k.Hoehe));
      end case;
   end Put;
   
   --  @Function: Koerper_Volumen 
   --
   --  Berechnet des Volumen eines Koerpers
   --
   --  @Parameter: 
   --   + k: der Koerper.
   --  
   --  @Return: Das Volumen des Koerpers.
   --  
   function Koerper_Volumen (k : Koerper) return Mass is
   begin
      case k.Typ is
         when Wuerfel =>
            return k.Seitenlaenge * k.Seitenlaenge * k.Seitenlaenge;
         when Kugel =>
            return 4.0 / 3.0 * Ada.Numerics.Pi 
                             * k.Radius * k.Radius * k.Radius;
         when Zylinder =>
            return k.Hoehe * Ada.Numerics.Pi 
                           * k.Radius_Grundflaeche * k.Radius_Grundflaeche;
         when Kegel =>
            return 1.0 / 3.0 * k.Hoehe * Ada.Numerics.Pi 
                             * k.Radius_Grundflaeche * k.Radius_Grundflaeche;
      end case;
   end Koerper_Volumen;
   
   --  @Function: Koerper_Oberflaeche 
   --
   --  Berechner die Oberflaeche eines Koerpers.
   --
   --  @Parameter: 
   --   + k: der Koerper.
   --  
   --  @Return: Die Oberflaeche des Koerpers.
   --  
   function Koerper_Oberflaeche (k : Koerper) return Mass is
   begin
      case k.Typ is
         when Wuerfel =>
            return k.Seitenlaenge * k.Seitenlaenge * 6.0;
         when Kugel =>
            return 4.0 * Ada.Numerics.Pi * k.Radius * k.Radius;
         when Zylinder =>
            return 2.0 * k.Radius_Grundflaeche 
                       * (k.Hoehe * Ada.Numerics.Pi 
                        + k.Radius_Grundflaeche * Ada.Numerics.Pi);
         when Kegel =>
            return k.Radius_Grundflaeche * k.Radius_Grundflaeche 
                  * Ada.Numerics.Pi 
                  * (k.Radius_Grundflaeche 
                     + Sqrt (k.Radius_Grundflaeche * k.Radius_Grundflaeche
                           + k.Hoehe * k.Hoehe));
      end case;
   end Koerper_Oberflaeche;
         
   
begin
   null;
      
end Koerper2;

--  kate: indent-width 3; indent-mode normal; dynamic-word-wrap on; 
--  kate: line-numbers on; space-indent on; mixed-indent off;