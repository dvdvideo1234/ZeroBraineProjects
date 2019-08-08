﻿return function(sTool, sLimit) local tSet = {} -- French
  tSet["tool."..sTool..".1"             ] = "Assemble une piste segmente"
  tSet["tool."..sTool..".left"          ] = "Creer/aligner une piece. Maintenez SHIFT pour empiler"
  tSet["tool."..sTool..".right"         ] = "Changer de point de rassemblement. Maintenez SHIFT pour le verso (Rapide: ALT + MOLETTE")
  tSet["tool."..sTool..".right_use"     ] = "Ouvrir le menu des pieces utilises frequemment"
  tSet["tool."..sTool..".reload"        ] = "Retirer une piece. Maintenez SHIFT pour selectionner une ancre"
  tSet["tool."..sTool..".desc"          ] = "Assemble une piste auquel les vehicules peuvent rouler dessus"
  tSet["tool."..sTool..".name"          ] = "Assembleur a piste"
  tSet["tool."..sTool..".phytype"       ] = "Selectionnez une des proprietes physiques dans la liste"
  tSet["tool."..sTool..".phytype_def"   ] = "<Selectionner un TYPE de materiau de surface>"
  tSet["tool."..sTool..".phyname"       ] = "Selectionnez une des noms de proprietes physiques a utiliser lorsque qu'une piste sera creee. Ceci va affecter la friction de la surface"
  tSet["tool."..sTool..".phyname_def"   ] = "<Selectionner un NOM de materiau de surface>"
  tSet["tool."..sTool..".bgskids"       ] = "Cette ensemble de code est delimite par une virgule pour chaque Bodygroup/Skin IDs > ENTREE pour accepter, TAB pour copier depuis la trace"
  tSet["tool."..sTool..".bgskids_def"   ] = "Ecrivez le code de selection ici. Par exemple 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "A quel point la piece creee sera lourd"
  tSet["tool."..sTool..".mass_con"      ] = "Masse de la piece:"
  tSet["tool."..sTool..".model"         ] = "Selectionner le modele de la piece a utiliser"
  tSet["tool."..sTool..".model_con"     ] = "Selectionnez une piece pour commencer/continuer votre piste avec en etendant un type et en cliquant sur un n?ud"
  tSet["tool."..sTool..".activrad"      ] = "Distance minimum necessaire pour selectionner un point actif"
  tSet["tool."..sTool..".activrad_con"  ] = "Rayon actif:"
  tSet["tool."..sTool..".stackcnt"      ] = "Nombre maximum de pieces a creer pendant l'empilement"
  tSet["tool."..sTool..".stackcnt_con"  ] = "Nombre de pieces:"
  tSet["tool."..sTool..".angsnap"       ] = "Aligner la premiere piece creee sur ce degre"
  tSet["tool."..sTool..".angsnap_con"   ] = "Alignement angulaire:"
  tSet["tool."..sTool..".resetvars"     ] = "Cliquez pour reinitialiser les valeurs supplementaires"
  tSet["tool."..sTool..".resetvars_con" ] = "V Reinitialiser les variables V"
  tSet["tool."..sTool..".nextpic"       ] = "Decalage angulaire supplementaire sur la position initial du tangage"
  tSet["tool."..sTool..".nextpic_con"   ] = "Angle du tangage:"
  tSet["tool."..sTool..".nextyaw"       ] = "Decalage angulaire supplementaire sur la position initial du lacet"
  tSet["tool."..sTool..".nextyaw_con"   ] = "Angle du lacet:"
  tSet["tool."..sTool..".nextrol"       ] = "Decalage angulaire supplementaire sur la position initial du roulis"
  tSet["tool."..sTool..".nextrol_con"   ] = "Angle du roulis:"
  tSet["tool."..sTool..".nextx"         ] = "Decalage lineaire supplementaire sur la position initial de X"
  tSet["tool."..sTool..".nextx_con"     ] = "Decalage en X:"
  tSet["tool."..sTool..".nexty"         ] = "Decalage lineaire supplementaire sur la position initial de Y"
  tSet["tool."..sTool..".nexty_con"     ] = "Decalage en Y:"
  tSet["tool."..sTool..".nextz"         ] = "Decalage lineaire supplementaire sur la position initial de Z"
  tSet["tool."..sTool..".nextz_con"     ] = "Decalage en Z:"
  tSet["tool."..sTool..".gravity"       ] = "Controle la gravite sur la piece creee"
  tSet["tool."..sTool..".gravity_con"   ] = "Appliquer la gravite sur la piece"
  tSet["tool."..sTool..".weld"          ] = "Creer une soudure entre les pieces/ancres"
  tSet["tool."..sTool..".weld_con"      ] = "Souder"
  tSet["tool."..sTool..".forcelim"      ] = "Force necessaire pour casser la soudure"
  tSet["tool."..sTool..".forcelim_con"  ] = "Limite de force:"
  tSet["tool."..sTool..".ignphysgn"     ] = "Ignore la saisie du pistolet physiques sur la piece creee/alignee/empile"
  tSet["tool."..sTool..".ignphysgn_con" ] = "Ignorer le pistolet physiques"
  tSet["tool."..sTool..".nocollide"     ] = "Faire en sorte que les pieces/ancres ne puissent jamais entrer en collision"
  tSet["tool."..sTool..".nocollide_con" ] = "Pas de collisions"
  tSet["tool."..sTool..".freeze"        ] = "La piece qui sera creee sera dans un etat gele"
  tSet["tool."..sTool..".freeze_con"    ] = "Geler des la creation"
  tSet["tool."..sTool..".igntype"       ] = "Faire ignorer a l'outil les differents types de piece des l'alignement/empilement"
  tSet["tool."..sTool..".igntype_con"   ] = "Ignorer le type de piste"
  tSet["tool."..sTool..".spnflat"       ] = "La prochaine piece sera creee/alignee/empile horizontalement"
  tSet["tool."..sTool..".spnflat_con"   ] = "Creer horizontalement"
  tSet["tool."..sTool..".spawncn"       ] = "Creer la piece vers le centre sinon la creer relativement vers le point active choisi"
  tSet["tool."..sTool..".spawncn_con"   ] = "Partir du centre"
  tSet["tool."..sTool..".surfsnap"      ] = "Aligne la piece vers la surface auquel le joueur vise actuellement"
  tSet["tool."..sTool..".surfsnap_con"  ] = "Aligner vers la surface trace"
  tSet["tool."..sTool..".appangfst"     ] = "Appliquer les decalages angulaires seulement sur la premiere piece"
  tSet["tool."..sTool..".appangfst_con" ] = "Appliquer angulaire en premier"
  tSet["tool."..sTool..".applinfst"     ] = "Appliquer les decalages lineaires seulement sur la premiere piece"
  tSet["tool."..sTool..".applinfst_con" ] = "Appliquer lineaire en premier"
  tSet["tool."..sTool..".adviser"       ] = "Montrer le conseiller de position/angle de l'outil"
  tSet["tool."..sTool..".adviser_con"   ] = "Montrer le conseiller"
  tSet["tool."..sTool..".pntasist"      ] = "Montrer l'assistant d'alignement de l'outil"
  tSet["tool."..sTool..".pntasist_con"  ] = "Montrer l'assistant"
  tSet["tool."..sTool..".ghostcnt"      ] = "Montrer un apercu de la pièces compter active"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "Activer compter l'aperçu de l'outil"
  tSet["tool."..sTool..".engunsnap"     ] = "Controle l'alignement quand la piece est tombee par le pistolet physique d'un joueur"
  tSet["tool."..sTool..".engunsnap_con" ] = "Activer l'alignement par pistolet physique"
  tSet["tool."..sTool..".workmode"      ] = "Modifiez cette option pour utiliser differents modes de travail"
  tSet["tool."..sTool..".workmode_1"    ] = "General creer/aligner pieces"
  tSet["tool."..sTool..".workmode_2"    ] = "Intersection de point actif"
  tSet["tool."..sTool..".pn_export"     ] = "Cliquer pour exporter la base de donnees client dans un fichier"
  tSet["tool."..sTool..".pn_export_lb"  ] = "Exporter"
  tSet["tool."..sTool..".pn_routine"    ] = "La liste de vos pieces de pistes utilises frequemment"
  tSet["tool."..sTool..".pn_routine_hd" ] = "Pieces frequents par: "
  tSet["tool."..sTool..".pn_display"    ] = "Le modele de votre piece de piste est affiche ici"
  tSet["tool."..sTool..".pn_pattern"    ] = "Ecrire un modele ici et appuyer sur ENTREE pour effectuer une recherche"
  tSet["tool."..sTool..".pn_srchcol"    ] = "Choisir la liste de colonne auquel vous voulez effectuer une recherche sur"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "<Recherche>"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "Modele"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "Type"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "Nom"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb" ] = "Articles de routine"
  tSet["tool."..sTool..".pn_routine_lb1"] = "Utilise"
  tSet["tool."..sTool..".pn_routine_lb2"] = "Fin"
  tSet["tool."..sTool..".pn_routine_lb3"] = "Type"
  tSet["tool."..sTool..".pn_routine_lb4"] = "Nom"
  tSet["tool."..sTool..".pn_display_lb" ] = "Affichage piece"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "Ecrire modele"
  tSet["Cleanup_"..sLimit               ] = "Pieces de piste assemblees"
  tSet["Cleaned_"..sLimit               ] = "Pistes nettoyees"
  tSet["SBoxLimit_"..sLimit             ] = "Vous avez atteint la limite des pistes creees!"
return tSet end