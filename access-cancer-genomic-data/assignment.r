#preferred = c('cgdsr')
#installed = preferred %in% installed.packages()[, 'Package']
#if (length(preferred[!installed]) >=1)
#install.packages(preferred[!installed], dep = T)
#print('Required libraries have been installed ')
#install.packages('cgdsr')
library('cgdsr')
gene_list = commandArgs(trailingOnly=T)
gene_list = c("TP53","NF1")

# Create CGDS object
mycgds = CGDS("http://www.cbioportal.org/public-portal/")

# Get available case lists (collection of samples) for a given cancer study in our case 
# Glioblastoma(TCGA)=gbm_tcga                                       
mycancerstudy = getCancerStudies(mycgds)[6,1]

#All Tumors=gbm_tcga_all(total=577)                                 
mycaselist = getCaseLists(mycgds,mycancerstudy)[2,1]

# Get available genetic profiles
mutation_geneticprofile = getGeneticProfiles(mycgds,mycancerstudy)[11,1]
cna_geneticprofile = getGeneticProfiles(mycgds,mycancerstudy)[3,1]

# Get data slices for a specified list of genes, genetic profile and case list
mutation_data = getProfileData(mycgds,gene_list,mutation_geneticprofile,mycaselist)

# vector is character in mode, so of course it's "not a number". That last element got interpreted as 
# the string "NaN". Using is.nan will only make sense if the vector is numeric. 
#If you want to make a value missing in a character vector, then use (without any quotes), NA_character_
mutation_data[mutation_data =="NaN"] <- NA_character_
cna_data = getProfileData(mycgds,gene_list,cna_geneticprofile,mycaselist)
cna_data[cna_data =="NaN"] <- NA_character_

# Check whether the genes in the given gene list are available in the selected study
no_list = gene_list[gene_list %in% colnames(mutation_data)]
no_gene = setdiff(gene_list,no_list) 
x = paste(no_gene,collapse=",")
if(length(no_gene) >= 1) {
  print(paste(x,"gene(s) is/are not available for this study",sep=" "))
  cmd0 <- paste("echo","'\n'",x,"gene[s] is/are not available for this study",">/dev/tty",sep=" ")
  system(cmd0)
}

new_gene_list = c(no_list)

calcualtions <- function(gene) {
  i=which(gene == colnames(mutation_data))
  mutation = (sum(complete.cases(mutation_data[,i]))/length(rownames(mutation_data)))*100
  mutation= round(mutation, digits = 0)
  print(paste(colnames(mutation_data)[i],"is mutated in",mutation,"% of all cases",sep=" "))
  cmd1 <- paste("echo","'\n'",colnames(mutation_data)[i],"is mutated in",mutation,"% of all cases", ">/dev/tty",sep=" ")
  system(cmd1)
  copy_number_altered = length(rownames(cna_data)) - (sum(cna_data[,i]=="0",na.rm = TRUE) + sum(!complete.cases(cna_data[,i])))
  cna = copy_number_altered/length(rownames(cna_data))*100
  cna= round(cna, digits = 0)
  print(paste(colnames(mutation_data)[i],"copy number altered",cna,"% of all cases",sep=" "))
  cmd2 <- paste("echo", colnames(cna_data)[i],"is copy number altered",cna,"% of all cases", ">/dev/tty",sep=" ")
  system(cmd2)
  any_alternation = data.frame(mutation = mutation_data[,i],cna = cna_data[,i])
  any_alternation[any_alternation == 0] <- NA
  total = any_alternation[apply(any_alternation, 1, function(y) !all(is.na(y))),]
  length_of_any_alternation = length(total[,1])
  percent_of_any_alternation = (length_of_any_alternation/length(rownames(mutation_data)))*100
  percent_of_any_alternation = round(percent_of_any_alternation, digits = 0)
  print(paste("Total % of cases where", colnames(mutation_data)[i],"is altered by either mutation or copy number alteration:",percent_of_any_alternation,"% of all cases.",sep=" "))
  cmd3 <- paste("echo", "Total % of cases where", colnames(mutation_data)[i],"is altered by either mutation or copy number alteration:",percent_of_any_alternation,"% of all cases.", ">/dev/tty",sep=" ")
  system(cmd3)
}

# sapply is more efficient than 'for' loop
sapply(new_gene_list,calcualtions) 

# Complete gene set calculation
if(length(new_gene_list) > 1){
  geneset_mut = mutation_data[,new_gene_list]
  #any_alternation[any_alternation == 0] <- NA
  total = geneset_mut[apply(geneset_mut, 1, function(y) !all(is.na(y))),]
  length_of_geneset_mut = length(total[,1])
  percent_of_geneset_mut = (length_of_geneset_mut/length(rownames(mutation_data)))*100
  percent_of_geneset_mut = round(percent_of_geneset_mut, digits = 0)
  print(paste("The gene set is mutated", percent_of_geneset_mut,"% of all cases.",sep=" "))
  cmd4 <- paste("echo","'\n'","The gene set is mutated", percent_of_geneset_mut,"% of all cases.", ">/dev/tty",sep=" ")
  system(cmd4)
  geneset_alt = cna_data[,new_gene_list]
  geneset_alt[geneset_alt == 0] <- NA
  total = geneset_alt[apply(geneset_alt, 1, function(y) !all(is.na(y))),]
  length_of_geneset_alt = length(total[,1])
  percent_of_geneset_alt = (length_of_geneset_alt/length(rownames(cna_data)))*100
  percent_of_geneset_alt = round(percent_of_geneset_alt, digits = 0)
  print(paste("The gene set is altered", percent_of_geneset_alt,"% of all cases.",sep=" "))
  cmd5 <- paste("echo","The gene set is altered", percent_of_geneset_alt,"% of all cases.", ">/dev/tty",sep=" ")
  system(cmd5)
}


