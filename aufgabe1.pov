// author:  Julian Fietkaus  

#version 3.7;

//************************************************************************
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"   
#include "woods.inc"



// Verschiedene Kameraperspektiven anbieten                            
#declare Camera_outdoor_front = camera {
                            location  <20 , 50 ,-50.0>
                            look_at   <31, 0 , 31>
                            }
#declare Camera_entry = camera { 
                            location  <35 , 2.5 , -10>
                            look_at   <32, 1 , 2>
                            }
                                                                                                              
#declare Camera_indoor_corner = camera {
                            location  <58 , 7 ,2>
                            look_at   <31, 0 , 31>
                            }
#declare Camera_stand_front = camera {
                            location  <35 , 3 ,35>
                            look_at   <25, 0 , 36>
                            } 
#declare Camera_stand_top = camera {
                            location  <25 , 7 ,35>
                            look_at   <25, 0 , 35>
                            }                           
                            
#declare Camera_stand_sloped = camera { 
                            location  <38 , 4 ,43>
                            look_at   <25, 1 , 35>
                            }

#declare Camera_stand_sloped2 = camera {
                            location  <30, 1.8 , 32>
                            look_at   <19, 0.7 , 40>
                            }                            
                        
#declare Camera_null = camera { 
                            location  <15 , 10 , -15>
                            look_at   <0, 0 , 0>
                            } 

#declare nahaufnahme = camera { angle 30
                            location  <25, 1.5 , 34>
                            look_at   <10, -10 , 140>
                            }
#declare nahaufnahme2 = camera { angle 0
                            location  <26, 1.25 , 36>
                            look_at   <10, 1.25 , 30>
                            }                             
                                                                         
// Kamera auswählen
camera{Camera_stand_front}                                                  
                                                                               

//  *****************   Messehalle      *****************  
//  60x60x8

declare x_start = 1;
declare z_start = 1;      //  Startpunkt Halle
declare y_start = 0;

declare x_size = 60;
declare z_size = 60;     // Größe der Halle
declare height = 8;

declare pos_halle1 = <x_start,y_start,z_start>;     // realtive Hallenposition
declare pos_halle2 = <x_size + 1,height,z_size+1>;
       
           
// **************       Messehalle ( Box - kleinere Box + Eingang )
//  Einzelteile definieren, dann gesamtobjekt definieren                         
declare Messehalle = difference{
    box {pos_halle1,pos_halle2        // Ziegelsteinmuster, hellgraue Steine, dunkle Fugen      
        pigment{brick color rgb<0.1,0.1,0.1> color rgb<0.5,0.5,0.5> brick_size <1, 0.5, 1 > mortar 0.01} }
    box {pos_halle1+<0.2,0,0.2>,pos_halle2-<0.2,0.2,0.2> 
        pigment{brick color rgb<0.1,0.1,0.1> color rgb<0.5,0.5,0.5> brick_size <1, 0.5, 1 > mortar 0.01} }
} 

// Messehalleneingang 
declare Eingang = difference{
    box{<28,0,0.1> <35,3,2> pigment{color Grey} }
    box{<28.2,0,0> <34.8,2.8,2.1> pigment{color Grey} }
}  
    
// Kombination der Objekte Halle und Eingang fuer gesamte Halle    
declare Messhalle_mit_Eingang = 
    union{
        difference{
            object{Messehalle}
            box{<28.2,0,0> <34.8,2.8,2.1> pigment{color Blue}}
        }
        object{Eingang}
        //    Messehallenflur, gefließt
        box {
            pos_halle1+<0.1,0,0.1>,
            pos_halle2-<0.1,7.9,0.1>
            pigment{ checker color rgb<1,1,1> color rgb<0.9,0.9,0.9> } // gefließter Boden
        }  
    }
   
// ************************* Messestand **********************************

                            
// Relative Positionen vom Messestand                  
declare p_front = <30,0,30>;
declare p_top = <20,0,40>;


//  ************  Gegenstände fuer Messestand modellieren *************************
//  in Null modelliert, verschieben an Punkt!

// Tisch mit runden Ecken
declare tisch = union{
intersection{                           // Tisch mit runden Ecken
        box{<0,1.20,0> <2.6,1.25,1> texture{T_Wood12 pigment{scale 0.5}}}
        cylinder{<1.3,1,0.5>, <1.3,1.5,0.5>, 1.3 }
    }
    union{                              // Tischbeine als Prisma
        prism{ 0.00, 1.21, 4 <0.3, 0.4>,<0.3, 0.6>,<0.5,0.5>,<0.3, 0.4> 
            pigment{color rgb<0.2,0.2,0.2>}}   
        prism{ 0.00, 1.21, 4 <2.3, 0.4>,<2.3, 0.6>,<2.1,0.5>,<2.3, 0.4> 
            pigment{color rgb<0.2,0.2,0.2>}}
    }
}


// Posterhalter   
declare poster = union{
    box{<0,1.3,-0.5><0.01,2.3,0.5> texture{T_Wood12}}          // Plakatfläche
    // Standfoto, wird über x-y Fläche aufgetragen, erst dann rotieren!
    box{<0,0,0><1,1,0>  texture { pigment { image_map { png "texture1"}}}  rotate<0,-90,0> translate<0.02,1.3,-0.5>} 
    union{  
        cylinder{ <0,0,0>,<0,1.5,0>,0.01 pigment{ color Black}}  // Ständer
        cylinder{ <0,0,0>,<0,0.01,0>,0.2 texture{T_Wood12}}      // Standfuß
    }
}

// Spotlight, von der Decke hängend
declare lampe = union{  // Spotlight, Hallendecke 8m, bis auf 2.50 runter
    cylinder{<0,3,0>,<0,8,0>,0.005 pigment{color Black}}
    difference{ // innerer, außerer Kegel für Lampe
        cone { <0,3,0>,0.05, <0,2.9,0>, 0.09 pigment{ color Gray}} 
        cone { <0,2.95,0>,0.05, <0,2.89,0>, 0.06 pigment{ color Gray}}
    }
    light_source{<0,2.94,0> color White} // Lichtquelle einsetzen:
}

// **********************   USB 3 anschluss + Ausschneideform  ********************
// Abmessungen aus der Grafik (siehe Doku)
declare usb_pos = <0,1,0>;
declare usb_port = union {
    difference{
        box{usb_pos usb_pos+<0.014,0.0065,0.03> pigment{color Grey}}
        box{usb_pos+<0.001,0.001,-0.001> usb_pos+<0.013,0.0055,0.02> pigment{color Grey}}
    }
    union{ // Aufsteckelement, auf dem die Pins liegen   
        box{usb_pos+<0.001,0.001,0.001> usb_pos+<0.013,0.0023,0.02> pigment{color rgb<0.4,0.5,1>}}
    
        // + 4 Metallpins, mit abstand + 0.001 und groesse 0.001
        box{usb_pos+<0.002,0.002,0.001> usb_pos+<0.003,0.0025,0.02> texture{Chrome_Metal}}
        box{usb_pos+<0.005,0.002,0.001> usb_pos+<0.006,0.0025,0.02> texture{Chrome_Metal}}
        box{usb_pos+<0.008,0.002,0.001> usb_pos+<0.009,0.0025,0.02> texture{Chrome_Metal}}
        box{usb_pos+<0.011,0.002,0.001> usb_pos+<0.012,0.0025,0.02> texture{Chrome_Metal}}
    }  
}
 
// Ausschneideform usb-port 
declare usb_cutout = box{usb_pos usb_pos+<0.014,0.0065,0.03> pigment{color Grey}}


// ******************************  Kartenleser **********************************
// 56 x 30 x 20, hier mal alle Positionsdaten relativ --> wesentlich angenehmer zu programmieren
// da so keine absoluten Positionsdaten berechnet werden müssen, sondern nur Größenangaben!
declare reader_pos = <0,1,0>;
declare reader_end = reader_pos+<0.069,0.02,0.03>;
declare sd_1_pos = reader_pos+<0.007,0.011,0>;
declare sd_2_pos = sd_1_pos + <0.03,0,0>;
declare sd3_pos = sd_1_pos-<0,0.006,0>;

declare card_reader = difference{ 
    difference{ // box - kleine box um schmalen Rahmen zu erzeugen
         box{reader_pos reader_end pigment{color Grey}}
         box{reader_pos+<0.002,0.002,-0.01> reader_end-<0.002,0.002,0.028> pigment{color White}}       // Rahmenbreite
    }

    union{
         // SD Karte Slot : 25x3x30 --> Etwas größer, aber nicht so tief wie SD-Karte groß ist.
         box{sd_1_pos sd_1_pos+<0.024,0.003,0.028> pigment{color rgb<0.4,0.5,1>}}
         box{sd_2_pos sd_2_pos+<0.024,0.003,0.028> pigment{color rgb<0.4,0.5,1>}}

         // langer Kartenslot, frei erfunden 2,.. x SD Karten Größe
         box{sd3_pos sd3_pos+<0.024*2+2*0.003,0.003,0.028> pigment{color rgb<0.4,0.5,1>}}
    }
}


// Ausschneideform Kartenleser
declare card_reader_cutout = box{reader_pos reader_end pigment{color Grey}}


 
// ***********************   Mediabox   ********************************
declare box_start = <0,1,0>;
declare foot1 = box_start+<0.08,-0.01,0.05>;    // relative Fußposition
declare foot2 = foot1+<-2*0.08+0.4,0,0>;        // relative Fußposition 2

declare mediabox_no_ports = 
union{    
    intersection{
        box{box_start box_start+<0.40,0.12,0.27> 
            texture { Polished_Brass  normal { bumps 0.1 scale 0.08 } finish{metallic} } }
        // Lautsprecher, abgerundet 
        sphere{box_start+<0.20,0.06,0.135> 0.20 pigment{color rgb<0.08,0.08,0.08>} }      
        // weitere abrundungen der Kanten entlang der x-Achse
        cylinder{<0,1.06,0.135><0.4,1.06,0.135> 0.145
            texture { Polished_Brass  normal { bumps 0.1 scale 0.08 } finish{metallic} } }
    
    } 
    union{
        cylinder{box_start+<0.3,0.10,0.25> box_start+<0.3,0.25,0.25> 0.002 }       // Antenne
        cylinder{box_start+<0.32,0.10,0.25> box_start+<0.32,0.30,0.25> 0.002 }     // Antenne 2
        
        // zylindrische Füße 5 höhe x 2 durchmesser, relativ
        cylinder{foot1 foot1+<0,0.05,0> 0.02 pigment{color Black}}
        cylinder{foot1+<0,0,0.27-2*0.05> foot1+<0,0.05,0.27-2*0.05> 0.02 pigment{color Black}}
        cylinder{foot2 foot2+<0,0.05,0> 0.02 pigment{color Black}}
        cylinder{foot2+<0,0,0.27-2*0.05> foot2+<0,0.05,0.27-2*0.05> 0.02 pigment{color Black}}
    }
}

// Vorlage um alle Einbauschächte auszuschneiden
declare port_cutout = union{
object{usb_cutout translate<0.12,0.055,-0.001>}
object{usb_cutout translate<0.15,0.055,-0.001>}
object{usb_cutout translate<0.18,0.055,-0.001>}
object{card_reader_cutout translate<0.12,0.029,-0.001>}}

// Alle Einbauschächte belegen
declare port_buildin = union{
object{usb_port translate<0.12,0.055,0>}
object{usb_port translate<0.15,0.055,0>}
object{usb_port translate<0.18,0.055,0>}
object{card_reader translate<0.12,0.029,0>}
// Zusätzlich kleinen Bildschrim hinzufügen
box{box_start+<0.12,0.068,-0.0005> box_start+<0.28,0.105,0.02> pigment{color rgb<0,0.3,0.9>}}
}

// Mediabox besteht dann aus Box ohne Schnittstellen + Einbauschächte + Geräte
declare mediabox = union{
    object{port_buildin}
    difference{
        object{mediabox_no_ports}
        object{port_cutout}
    }
}




// ************************************ Inszeniere Szene  ***************************************

    

light_source{<1500,2500,-2500> color White}    // Sonne
//light_source{pos_halle1+<x_size/2,height-1,z_size/2> color White}
sky_sphere{ pigment{ color rgb<0,0.2,0.9> }}

// grüne Ebene, outdoor
plane { y, 0 pigment {color rgb <0.2,0.8,0.2>}} 

object{Messhalle_mit_Eingang}

// Podest für Messestand
box {p_front p_top+<0,0.2,0> texture{T_Wood3} }  

// Roter Teppich bis zum Messestand
box {<30,0,1>,<31,0.15,40> pigment{color Red} } 

// Tische diagonal auf Fläche stellen, stehen im Boden ^^
object{tisch rotate <0,125,0> translate p_front+<-5,0,7>}
object{tisch rotate <0,110,0> translate p_front+<-7,0,4>}
object{tisch rotate <0,145,0> translate p_front+<-2,0,9.3>}

// Posterhalter aufstellen
//object{poster rotate<0,2,0> translate p_front+<-8.5,0.2,1>}  
object{poster rotate<0,20,0> translate p_front+<-7.5,0.2,5>}
object{poster rotate<0,43,0> translate p_front+<-5,0.2,8.5>}   

// Mediabox aufstellen, Tischhöhe: 1.25 + 0.05 Fußhöhe von der Mediabox
object{mediabox rotate <0,125-180,0> translate p_front+<-5.3,0.25+0.005,5.4>}
object{mediabox rotate <0,110-180-3,0> translate p_front+<-6.8,0.25+0.005,2.4>}
object{mediabox rotate <0,145-180,0> translate p_front+<-2.8,0.25+0.005,7.9>} 

//object{lampe translate p_front+<-5.3,0.25+0.005,5.4>}
object{lampe translate p_front+<-6.0,0.25+1,4.2>}
object{lampe translate p_front+<-4.5,0.25+1,6.9>}











