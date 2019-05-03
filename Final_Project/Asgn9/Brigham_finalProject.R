#This script represents my code for the final project in Comp Bio Spring 2019. -Laurel Brigham
#I've commented out install.packages and adonis because they take a very long time to run. Please feel free
#to uncomment



########################
###read in packages#####
########################

#install.packages("FD")
library(FD)

#install.packages("ggplot2")
library(ggplot2)

#install.packages("tidyr")
library(tidyr)

#install.packages("dplyr")
library(dplyr)

#install.packages("lme4")
library(lme4)

#install.packages("car")
library(car)

#install.packages("forcats")
library(forcats)

#install.packages("codyn")
library(codyn)

#install.packages("lsmeans")
library(lsmeans)

#install.packages("vegan")
library(vegan)

#install.packages("MASS")
library(MASS)


####################
###read in data#####
####################

##traits##
trait_data <- read.csv("/Users/laurelbrigham/Documents/CU_Boulder/Research/CODOM/NWT_Traits_SpeciesMeans_20161026.csv")

##composition##
#set the na nvalues because they're not typical
na_values = c(".","na")

#read in species comp and give Na info
codom_spcomp <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/Research/CODOM/2018_plantData/updates_Jane/21AprilNWT_CoDom_SpComp_data_L0.csv',header=T, na = na_values)

#remove date because it has a lot of missing values and is redundant (year is also a column)
codom_spcomp$date <- NULL

#because this data file was spaced in a strange way, I need to use complete.cases to both remove NAs 
#and get rid of the spaced lines
codom_spcomp <- codom_spcomp[complete.cases(codom_spcomp[1:ncol(codom_spcomp)]),]
#1126 values, as expected

#want to take out bare, lichen, litter, moss, rock columns because I do not want to include them in analyses
codom_spcomp <- subset(codom_spcomp, select = -c(bare, lichen, litter, moss, rock))

##############
###tidy data###
##############

#look at the structure to make sure values were read in properly
str(codom_spcomp)
#site should be a factor
#all plant abundance columns should contain numeric values

#make all species comp data numeric
codom_spcomp[,7:ncol(codom_spcomp)] <- as.numeric(as.character(unlist(codom_spcomp[,7:ncol(codom_spcomp)])))
#source for unlist code https://csgillespie.github.io/efficientR/dplyr.html

#making site a factor
codom_spcomp$site <- as.factor(codom_spcomp$site)

#LTER site not important (experiment is all at NWT)
codom_spcomp$LTER_site <- NULL 

#break up plot into its components to get treatment columns
#make a function because I'll do this frequently
split_col <- function(x){
  #need characters for strsplit
  x$plot <- as.character(x$plot)
  #plot plot into it's components
  codom_split_func <- do.call(rbind, strsplit(x$plot, ""))
  #make the columns into a data frame
  codom_split_func <- as.data.frame(codom_split_func)
  #name the columns according to treatment
  colnames(codom_split_func) <- c("codom", "removal", "addition")
  #bind the expanded treatment with the original df
  x <- cbind(codom_split_func, x)
  #get rid of the codom (C) column because it adds no useful info
  x$codom <- NULL
  x
}

codom_spcomp <- split_col(codom_spcomp)


#for reference, C stands for "Co-dominant" (the name of the experiment)
#the removal treatment has an A for Geum removal, a D for Deschampsia removal, or a B for random biomass removal
#the addition treatment has an N for nitrogren addition or an X for no N addition, there was also a 
#carbon addition for a short while that we won't be using in these analyses


#subset to get rid of the C addition which was discontinued and not part of the current analysis
# remove random biomass remnoval as well, not part of the current analysis
codom_spcomp <- subset(codom_spcomp, addition != "C" )
codom_spcomp <- subset(codom_spcomp, removal != "B" )
codom_spcomp <- droplevels(codom_spcomp)


#Geum and Des should be replaced with NA for those plots whose treatment was removal of that species
#make a new df that will have NAs
sp_comp_g_d_sub <- codom_spcomp

#create logicals
noGeum <- sp_comp_g_d_sub$plot == "CAX" | sp_comp_g_d_sub$plot == "CAN"
noDes <- sp_comp_g_d_sub$plot == "CDX" | sp_comp_g_d_sub$plot == "CDN"

#use logicals to replace the appropriate values with NA
sp_comp_g_d_sub$GEUROS[noGeum] <- NA
sp_comp_g_d_sub$DESCAE[noDes] <- NA
str(sp_comp_g_d_sub)

#unite plot and site to get the unique reps for lme models
sp_comp_g_d_sub <- unite(sp_comp_g_d_sub, "ID", c("site", "plot"), sep = "_", remove = F)

#need to make year a number in terms of start date (eg. year 1,2,3) because lmer complains about scale otherwise
sp_comp_g_d_sub$year <- as.numeric(as.factor(sp_comp_g_d_sub$year))

##separate the species abundance data from the data on site/plot (metadata)
#meta data
codom_metaData <- sp_comp_g_d_sub[,1:7]
str(codom_metaData)
#separate out for only species
sp_comp_g_d_sub_num <- sp_comp_g_d_sub[,8:ncol(sp_comp_g_d_sub)]
str(sp_comp_g_d_sub_num)

#calculate richness and include na.rm = T so that NA values aren't included
richness <- rowSums(sp_comp_g_d_sub_num > 0, na.rm = T)

#add this value to the df
codom_metaData$richness_NA <- richness


#############
##ALL YEARS##
#############

#############
##Richness##
#############

#run an lmer with time as continuous
rich_lmer <- lmer(richness_NA ~ removal * addition * year + (1|site/ID), data = codom_metaData)

#check assumptions
shapiro.test(resid(rich_lmer)) #   normal
leveneTest(resid(rich_lmer) ~ interaction(removal, addition, year), data = codom_metaData) # meets assumption

#stats
Anova(rich_lmer)



######################
##Community structure##
######################

#convert to rel abund
species_g_d_relabund <- decostand(sp_comp_g_d_sub_num, "total", na.rm = T)

#dissim matrix
bray_sp <- vegdist(species_g_d_relabund, "bray")

#WARNING: the permanovas take a very long time to run so I commented them out

#permanova that needs to be run several times with the variables in different orders to assure the correct significances
#perm_comp_time <- adonis(bray_sp ~ addition * removal * year, data = codom_metaData, strata = codom_metaData$Site , permutations = 999, method = "bray")

#model with terms reversed
#perm_comp_time_a <- adonis(bray_sp ~ year * removal * addition, data = codom_metaData, strata = codom_metaData$Site , permutations = 999, method = "bray")
#same significances

#perm_comp_time_b <- adonis(bray_sp ~ year * removal * addition, data = codom_metaData, strata = codom_metaData$Site , permutations = 999, method = "bray")
#same significances

#the effect of addition on comm comp changed over time, but not the effect of removal

#betadisper to see if signicance is due to differences in the spatial median or dispersion
betadisp_add <- betadisper(bray_sp,codom_metaData$addition,type = "centroid")
anova(betadisp_add)
#signifcant, meaning we can't know if its's a difference in the spatial median or dispersion

betadisp_rem <- betadisper(bray_sp,codom_metaData$removal,type= "centroid")
anova(betadisp_rem)
#signifcant, meaning we can't know if its's a difference in the spatial median or dispersion




######################
##Temporal diversity##
######################

####tidy data for use with codyn package

#make the df long for codyn
sp_comp_g_d_sub_long <- gather(sp_comp_g_d_sub, species, abundance, 8:ncol(sp_comp_g_d_sub), factor_key=TRUE)
str(sp_comp_g_d_sub_long)

####rate change######

#for stats on slope
rate_change_NA <- rate_change(sp_comp_g_d_sub_long, "year", "species", "abundance", "ID")
str(rate_change_NA)

#for plotting 
rate_change_NA_plot <- rate_change_interval(sp_comp_g_d_sub_long, "year", "species", "abundance", "ID")
str(rate_change_NA_plot)

#need to add treatment columns to this new df with 5696 rows
#separate ID to get plot
rate_change_NA_plot <- separate(rate_change_NA_plot, "ID", c("Site", "plot"), sep = "_")

#use function
rate_change_NA_plot <- split_col(rate_change_NA_plot)

##run lmer on the rate change data##

#rate change ony has 42 rows because it's aggregated and looks at a property over time
#so I don't want to merge it with my overall meta data file
# create a new meta data file that's aggregated over time
codom_meta_42 <- unique(codom_metaData[c("ID", "site", "plot")])


#need to get treatment for this 42 row dataset
codom_meta_42 <- split_col(codom_meta_42)


#add the rate change to the metadata file
codom_meta_42$rate_change_NA <- rate_change_NA$rate_change
str(codom_meta_42)

#now that dep and ind variables are in the same df at the correct resolution, we can run our models

#model
rate_change_lm <- lm(rate_change_NA ~ removal * addition, data = codom_meta_42)

#check assumptions
shapiro.test(resid(rate_change_lm)) #not normal

#take the log to try to achieve normality
min(codom_meta_42$rate_change_NA) #add 1.2364305 to make min 1
log_rate_change_lm <- lm(log10(rate_change_NA + 1.2364305) ~ removal * addition, data = codom_meta_42)

#check assumptions again
shapiro.test(resid(log_rate_change_lm)) #normal
leveneTest(resid(log_rate_change_lm) ~ interaction(removal, addition), data = codom_meta_42) #yes

#stats on slope
Anova(log_rate_change_lm) 

#addition led to a faster rate of change (larger numbers) that led to greater dissimilarity (directional change--pos
# slopes) over time

#look at the drivers of the interaction
lsmeans(log_rate_change_lm, pairwise ~ removal * addition, adjust = "tukey")

#when N is added, the rate of change is greater when there is no removal or the removal of deschampsia. 


####rate change figure##
#create labels for the facet_wrap
addition.labs <- c("N Addition", "Control")
names(addition.labs) <- c("N", "X")

#create a plot
ggplot(rate_change_NA_plot, aes(x = interval, y = distance, color = removal)) +
  geom_smooth(method = "lm") +
  labs(y = "Euclidean Distance", x = "Time Interval (Years)", color = "Removal") +
  facet_wrap(~addition, labeller = labeller(addition = addition.labs)) +
  scale_color_manual(labels = c(~italic("Geum"), ~italic("Deschampsia"), " Control"), values = c("darkgoldenrod1", "chartreuse4", "dodgerblue4")) 

#labeller: http://www.sthda.com/english/articles/32-r-graphics-essentials/127-ggplot-facet-quick-reference/#change-facet-labels
#colors: http://sape.inf.usi.ch/quick-reference/ggplot2/colour

#look at Euclidean distance in final year to see if those are also different
rate_change_NA_plot_toSub <- rate_change_NA_plot
rate_change_NA_plot_toSub$interval <- as.factor(rate_change_NA_plot_toSub$interval)
str(rate_change_NA_plot_toSub)

#subset
rate_change_NA_plot_16 <- subset(rate_change_NA_plot_toSub, interval == "16")
rate_change_NA_plot_16 <- droplevels(rate_change_NA_plot_16)

#model
euc_16 <- lm(distance ~ removal * addition, data = rate_change_NA_plot_16)

#check assumptions
shapiro.test(resid(euc_16)) #normal
leveneTest(resid(euc_16) ~ interaction(removal, addition), data = rate_change_NA_plot_16) #yes

#stats
Anova(euc_16)
#by the final year, only the addition treatment had an effect on the degree of dissimilarity
lsmeans(euc_16, pairwise ~ removal * addition, adjust = "tukey")
#D,N - D,X  36.140162 9.043638 35   3.996  0.0040
#X,N - X,X  34.327238 9.043638 35   3.796  0.0068

#no difference between A,N - D,N and A,N - X,N, suggesting only the RATE differed between removal treatments under N+



#########
##Traits##
#########

##tidy the data##
#there are two columns at the end that have no values, remove
trait_data <- trait_data[,-c(13,14)]

#get only the trait data that we have species for
trait_data_codom <- subset(trait_data, Spp_code %in% sp_comp_g_d_sub_long$species)
str(trait_data_codom)
#gives me traits for 38 species

#how many species do I have in total?
length(unique(sp_comp_g_d_sub_long$species)) #60

##see if these 38 species make up the majority of the community

#make rel abund df long and then take mean of each species
species_g_d_relabund_long <- gather(species_g_d_relabund, "species", "abundance", factor_key=TRUE)

species_g_d_relabund_mean <- aggregate(abundance ~ species, data = species_g_d_relabund_long, mean)

#should give me the proportion of all communities sampled that a given species makes up 
species_g_d_relabund_mean$proportion <- (species_g_d_relabund_mean$abundance/sum(species_g_d_relabund_mean$abundance))*100
sum(species_g_d_relabund_mean$proportion)   #adds to 100 as it should

#these are the species included in the traits database
HaveTraits <- subset(species_g_d_relabund_mean, (species %in% trait_data$Spp_code))
length(unique(HaveTraits$species)) #leaves me with 38 as it should

#sum the proportion
sum(HaveTraits$proportion)
#these species make up 99.18079% of community composition

#these aren't included in the traits database
NoTraits <- subset(species_g_d_relabund_mean, !(species %in% trait_data$Spp_code))
length(unique(NoTraits$species)) #leaves me with 22 as it should

#sum the proportion
sum(NoTraits$proportion)
#these species make up 0.8192088% of community composition
#hence, I have sufficient trait coverage to continue

#traits I will look at:
#chlorophyll content because it's correlated with tissue N
#surface leaf area (SLA) because it indicates growth rate and photosynthetic capacity
#height because it's often allometrically related to biomass and 
  #is a good indicator of competitive ability

#######
##CWM##
#######

#calculate community-weighted means (CWM) for the traits
#functcomp needs a matrix of traits and species abundances

#make trait df
#trait matrix
trait_matrix <- trait_data_codom[,c(3,4,6,8)]

#species need to be in the same order, so I'll alphabetize both
trait_matrix <- arrange(trait_matrix, Spp_code)

#drop levels bc some species still showing up
trait_matrix <- droplevels(trait_matrix)

#turn species into rownames
rownames(trait_matrix) <- trait_matrix[,1]

#remove sppcode columns
trait_matrix <- trait_matrix[,-c(1)]

#col to row: https://stackoverflow.com/questions/5555408/convert-the-values-in-a-column-into-row-names-in-an-existing-data-frame-in-r

#now make matrix of spp abund (raw)
spp_matrix_long <- subset(sp_comp_g_d_sub_long, (species %in% trait_data$Spp_code))
spp_matrix_long <- droplevels(spp_matrix_long)
str(spp_matrix_long)

#make a uniqe variable by merging ID and time 
spp_matrix_long <- unite(spp_matrix_long, "ID_year", c("ID", "year"), sep = "_", remove = F)

#make wide per req
spp_matrix <- spread(spp_matrix_long, species, abundance)

#get rid of metadata, except plot
spp_matrix <- spp_matrix[,c(4, 9:ncol(spp_matrix))]
str(spp_matrix)

#make plot rownames
rownames(spp_matrix) <- spp_matrix[,1]

#remove sppcode columns
spp_matrix <- spp_matrix[,-c(1)]

#make into a matrix
spp_matrix <- as.matrix(spp_matrix)

#species abund matrix must have same # of col as rows in trait matrix
ncol(spp_matrix) #38
nrow(trait_matrix) #38
#good, they match

#run CWM command
CWM <- functcomp(trait_matrix, spp_matrix)
#this was run with raw abundances, but you get the same answers for rel abundances

#add in year_ID
CWM$ID_year <- rownames(CWM)

#separate ID_year to get plot input for function
CWM <- separate(CWM, "ID_year", c("site", "plot", "year"), sep = "_")
str(CWM)

#use function to get treatment
CWM <- split_col(CWM)

#create ID and ID_year once more because they're necessary input below
CWM <- unite(CWM, "ID", c("site", "plot"), sep = "_", remove = F)
CWM <- unite(CWM, "ID_year", c("ID", "year"), sep = "_", remove = F)
CWM$year <- as.numeric(CWM$year)
str(CWM)



#############
##ALL YEARS##
#############

#chlorophyll
chloro_lmer <- lmer(ChloroCont ~ removal * addition * year + (1|site/ID), data = CWM)
shapiro.test(resid(chloro_lmer)) #   not normal
leveneTest(resid(chloro_lmer) ~ interaction(removal, addition, year), data = codom_metaData) # meets assumption

#no success with transformations, try glmer

#glmer
chloro_glmer <- glmmPQL(ChloroCont ~ removal *  addition * year, random = list(site = ~1, ID = ~1), family = Gamma, data = CWM)
#similar results between gamma and inverse guassian

#stats
Anova(chloro_glmer)
lsmeans(chloro_glmer, pairwise~ addition * removal, adjust = "tukey")


#SLA
SLA_glmer <- glmmPQL(SLA ~ removal *  addition * year, random = list(site = ~1, ID = ~1), family = Gamma, data = CWM)

#stats
Anova(SLA_glmer)
lsmeans(SLA_glmer, pairwise ~ removal , adjust = "tukey")
