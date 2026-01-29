FILE: cascada_2_tier_sostenibilidad_mediana.m
It is the main file with the proposed algorithm.

INPUTS:

-x: Vector with the x-coordinates of the sensors
-y: Vector with the y-coordinates of the sensors

-x_max: Maximum x-coordinate
-y_max: Maximum y-coordinate

-n: Number of nodes in the experiment
-stop: Number of deaths required to reach the end, expressed as a percentage of n

-porcentaje_ch: Percentage of nodes out of the total that will become cluster head
-porcentaje_sch: Percentage of nodes out of the total that will become super cluster head

-EBx: x-coordinate of the base station
-EBy: y-coordinate of the base station

-Eo: initial energy of nodes
-ETX,ERX,Efs,Eamp,EDA: parameters of energy model
-packetSize,controlPacketSize:parameters of communication packets

-Eminima: Minimum energy before a node is considered dead

OUTPUTS:
-FND: Firts node dies
-HND: Half node die
-LND: Last node die 


FILE: ch_cascada_1.fis
Fuzzy inference system to select the best CHs.

FILE: sch_cascada_2.fis
Fuzzy inference system to select the best SCHs.

FILE:escenario.mat
Coordinates with the location of the sensors.

FILE:variables_menos_x_y_ebx_eby.mat
All the variables of the energy and communications model necessary to launch experiments are in place; only the position of the sensors and the base station are missing.


FILE:pruebas_escenarios_centro.m
File that calculates the algorithm's output for 15 different scenarios, with the base station in the center.

