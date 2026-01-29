# C2TCascade clustering algorithm for wireless sensor networks

Matlab code for paper Centralized two tier clustering method for wireless sensor networks based on a coupled cascaded fuzzy system

> Yuste-Delgado, A.J., Triviño, A., Diaz-Jimenez, D. et al. Centralized two tier clustering method for wireless sensor networks based on a coupled cascaded fuzzy system. Sci Rep 16, 1871 (2026). [https://doi.org/10.1038/s41598-025-31549-2](https://doi.org/10.1038/s41598-025-31549-2)

# Abstract
Current applications in the Internet of Things generally rely on wireless sensor network deployments that measure and control a restricted area. Most of those applications use sensor nodes powered with batteries, so efficient energy management is required to maximize the lifetime of the network. To tackle this issue, clustering becomes a suitable solution to prolong energy sources, being the selection of the cluster heads crucial for its optimal operation. The application of soft computing techniques (e.g. fuzzy logic) to clustering has improved the wireless network performance significantly. Therefore, this approach proposes a centralized, two-tier clustering method in which there are cluster heads and super cluster heads. This hierarchy is defined based on a sustainability filter and a two-stage cascaded fuzzy system. Initially, the sustainability filter removes unsuitable nodes in the process of selecting the cluster heads. The decision is based on the node residual energy, eliminating those with low battery levels. The remainder nodes use a first fuzzy system where some of them are promoted as cluster heads. Then, for each CH, a second stage is run, which takes as input the output of the first fuzzy system and three other variables to allow the selection of super cluster heads. The findings of the simulation of this approach have demonstrated that cascaded fuzzy systems have the capacity to circumvent issues such as rapid depletion of energy at the node in close proximity to the base station. Additionally, the simulation results of the proposed method demonstrated a substantial enhancement in the lifetime across the various scenarios applied. Furthermore, they have been shown to exhibit a substantial degree of adaptability to varying base station locations.

> Keywords: Wireless sensor network, Internet of things, Clustering algorithm, Energy-efficient management, Fuzzy logic

# License
Open Access: This article is licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License, which permits any non-commercial use, sharing, distribution and reproduction in any medium or format, as long as you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons licence, and indicate if you modified the licensed material. You do not have permission under this licence to share adapted material derived from this article or parts of it. The images or other third party material in this article are included in the article’s Creative Commons licence, unless indicated otherwise in a credit line to the material. If material is not included in the article’s Creative Commons licence and your intended use is not permitted by statutory regulation or exceeds the permitted use, you will need to obtain permission directly from the copyright holder. To view a copy of this licence, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

# Acknowledgements
This research has been funded by the Ministry of Science, Innovation, and Universities, as part of the 2023 call for proposals for grants for proof–of–concept projects under the State Plan for Scientific, Technical, and Innovation Research for the period 2021-2023, within the framework of the Recovery, Transformation, and Resilience Plan, with grant number PDC2023-145863-I00; and by grant M.2 PDC_000756 funded by Consejería de Universidad, Investigación e Innovación and by ERDF Andalusia Program 2021-2027.

# Funding
Open Access funding enabled and organized by, firstly, Microchip4Age project, grant number PDC2023-145863-I00 of the Ministry of Science, Innovation, and Universities. This research has been funded by the Ministry of Science, Innovation, and Universities, as part of the 2023 call for proposals for grants for proof-of-concept projects under the State Plan for Scientific, Technical, and Innovation Research for the period 2021-2023, within the framework of the Recovery, Transformation, and Resilience Plan, with grant number PDC2023-145863-I00, and in addition, by grant M.2 PDC_000756 funded by Consejería de Universidad, Investigación e Innovación and by ERDF Andalusia Program 2021-2027.

# Disclaimer
This software is provided “as is”, without any express or implied warranties. No maintenance, updates, or technical support are provided. Use of the software is entirely at the user’s own risk. In no event shall the developer be held liable for any direct, indirect, incidental, or consequential damages arising from the use of, or inability to use, this software.

# Usage

## FILE: cascada_2_tier_sostenibilidad_mediana.m
It is the main file with the proposed algorithm.

### INPUTS:
- x: Vector with the x-coordinates of the sensors
- y: Vector with the y-coordinates of the sensors
- x_max: Maximum x-coordinate
- y_max: Maximum y-coordinate
- n: Number of nodes in the experiment
- stop: Number of deaths required to reach the end, expressed as a percentage of n
- porcentaje_ch: Percentage of nodes out of the total that will become cluster head
- porcentaje_sch: Percentage of nodes out of the total that will become super cluster head
- EBx: x-coordinate of the base station
- EBy: y-coordinate of the base station
- Eo: initial energy of nodes
- ETX,ERX,Efs,Eamp,EDA: parameters of energy model
- packetSize,controlPacketSize:parameters of communication packets
- Eminima: Minimum energy before a node is considered dead

### OUTPUTS:
- FND: Firts node dies
- HND: Half node die
- LND: Last node die 

## FILE: ch_cascada_1.fis
Fuzzy inference system to select the best CHs.

## FILE: sch_cascada_2.fis
Fuzzy inference system to select the best SCHs.

## FILE:escenario.mat
Coordinates with the location of the sensors.

## FILE:variables_menos_x_y_ebx_eby.mat
All the variables of the energy and communications model necessary to launch experiments are in place; only the position of the sensors and the base station are missing.

## FILE:pruebas_escenarios_centro.m
File that calculates the algorithm's output for 15 different scenarios, with the base station in the center.
