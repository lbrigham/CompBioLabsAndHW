# ->Nitrogen Deposition in the Front Range, Colorado <-


## Introduction
Communities across the globe are experiencing ecological presses, such as nitrogen (N) deposition (Vitousek et al. 1997; Dentener et al. 2006), that are causing shifts in community structure and function (Collins et al., 1998; Suding et al., 2008). Community response to N deposition may be mediated by the response of the dominant species; dominant species have a disproportionate influence on the community through species interactions and control over nutrient dynamics (Hillebrand 2008).

My driving question for this project is: How does removal of a dominant species alter community response to nitrogen addition?


## Summary of Data to be Analyzed
### Goals of original study that produced the data
This study was initiated by Katie Suding in 2002 as the effects of N deposition in alpine ecosystems were becoming apparent. While several studies around this time were examining the effects of N deposition on plant community compositional shifts and alterations in richness and diversity, the species-specific roles of dominants in altering community response had not been well-studied.

The study system, moist meadow communities at Niwot Ridge on the Front Range of Colorado, is co-dominated by two species that cycle N differently. One species, *Geum rossii* is a slow N cycler that produces recalcitrant litter (high carbon (C):N). The other species, *Deschampsia cespitosa*, is a fast N cycler with more labile litter (low C:N ratio). Therefore, it was expected that community response to N addition would vary based on the abundance of these co-dominant species. For example, with *G. rossii* removal and N addition, N retention of the community should decline and perhaps lead to a community shift that compensates for this increased N availability.

The study consists of six treatments: N addition and no species removals, N addition and *G. rossii* removal, N addition and *D. cespitosa* removal, no N addition and no species removals, no N addition and *G. rossii* removal, and no N addition and *D. cespitosa* removal. These six treatments are replicated across seven moist meadow communities at Niwot Ridge.

### Brief description of methodology that produced the data
The data that I will be working with are species relative abundances collected from all 42 plots sampled annually across 16 years. Species composition was determined at peak growing season using a point-intercept method where presence was recorded at 100 points within a 1 m x 1 m grid at intervals of 10 cm. Following this, the plot was visually scanned for species that were present but not included within the 100 hits and given a value of 0.5 (0.5 % cover) if detected. The relative abundance of a species was calculated as the proportion of all hits in plot that contained that species. This data represents community composition of our plots.

### Type of data in this data set
Format:
* Wide dataframe with columns for site information and columns for all species
Size:
* 197 KB
* 1127 rows and 71 columns
Inconsistencies or potential issues:
* Missing values are coded both as periods and "na"


## Detailed Description of Analysis to be Done and Challenges Involved
For my data analysis, I will analyze temporal diversity trends and overall treatment effects on community composition and richness. For long-term studies, analyzing metrics such as community composition and richness alone do not provide information on how the community responds to treatment over time. Hence, I will examine temporal diversity with the aid of a package in R developed by Lauren Hallett in 2016 (Hallett et al. 2016; 'codyn'). Using this package, I will determine the rate of change of the community composition over time, which elucidates the direction and rate of community shifts with treatment. As a next step, if I see differences in the degree and rate of community change, I plan on using trait data collected by Marko Spasojevic and deposited on the TRY database (< http://mspaso.wixsite.com/traitecology/trait-data>) to understand the functional shifts in community compositon.

The potential challeges are primarily statistical in nature though there are inconsistencies mentioned in the above section. Two treatments involve removing two species within the community, and this results in zeros for the abundance of these species. Since these zeros are experimentally driven, I will need to deal with these values appropriately before calculating values, such as richness. From a statistical stand point, these data have both a blocking factor (the seven sites) and repeated measures. I will need to run mixed-effects models with block and plot as random factors. Additionally, since these data are temporal and I expect the communities to change over time, time will need to be included in my models in an effort to meet the assumption of homogeneity of variance. Finally, because the data is long-term there is a higher chance that the data is not normal, meaning that I must enter the into the realm of generalized linear mixed effects models with which I am unfamiliar.


## References
Collins, S.L., Knapp, A.K., Briggs, J.M., Blair, J.M. & Steinauer, E.M. (1998). Modulation of diversity by
grazing and mowing in native tallgrass prairie. Science, 280(5364): 745-747. <https://doi.org/10.1126/science.280.5364.745>

Dentener, F., Drevet, J., Lamarque, J. F., Bey, I., Eickhout, B., Fiore, A. M., Hauglustaine, D., Horowitz, L.W., Krol, M., Kulshrestha, U.C. & Lawrence, M. (2006). Nitrogen and sulfur deposition on regional and global scales: a multimodel evaluation. Global biogeochemical cycles, 20(4):GB4003. <https://doi.org/10.1029/2005GB002672>

Hallett, L. M., Jones, S. K., MacDonald, A. A. M., Jones, M. B., Flynn, D. F., Ripplinger, J., Slaughter, P., Gries, C., & Collins, S. L. (2016). CODYN: an R package of community dynamics metrics. Methods in Ecology and Evolution, 7(10): 1146-1151. <https://doi.org/10.1111/2041-210X.12569>

Hillebrand H, Bennett DM, Cadotte MW (2008). Consequences of dominance: a review of evenness effects on local and regional ecosystem processes. Ecology 89:1510–1520. <https://doi.org/10.1890/07-1053.1>

Suding, K. N., Ashton, I. W., Bechtold, H., Bowman, W. D., Mobley, M. L., & Winkleman, R. (2008). Plant and microbe contribution to community resilience in a directionally changing environment. Ecological Monographs, 78(3): 313-329. <https://doi.org/10.1890/07-1092.1>

Vitousek, P.M., Aber, J.D., Howarth, R.W., Likens, G.E., Matson, P.A., Schindler, D.W., Schlesinger, W.H., Tilman, D.G., (1997). Human alteration of the global nitrogen cycle: sources and consequences. Ecolical Applications, 7: 737–750. <https://doi.org/10.1890/1051-0761(1997)007[0737:HAOTGN]2.0.CO;2>
