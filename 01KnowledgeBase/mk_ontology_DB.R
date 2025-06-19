library(readxl)
library(dplyr)
library(stringr)
library(data.table)

ontology <- read_excel("D:/code-R/1/Plant_Ontology-2024.xlsx", sheet = 1)
ontology <- ontology[,c(4,5,8)]
colnames(ontology) <- c("Trait_id","Trait","Category")
unique(ontology$Category)
# 去掉前后空格
ontology <- ontology %>% mutate(across(everything(), ~str_trim(.)))
# 性状词条全部改成小写
ontology <- ontology %>% mutate(Trait=str_to_lower(Trait)) %>% distinct() # 1668个非冗余的性状词条，分属于10个大类
# 确保是非冗余的
length(unique(ontology$Trait))

tmp <- read.csv("D:/code-R/1/Categories.txt",sep = "\t",header = T)
ontology <- ontology %>% left_join(tmp, by = "Category")
ontology <- ontology %>% mutate(across(everything(), ~str_trim(.)))
ontology <- ontology %>% distinct()
write.table(ontology, "D:/code-R/1/My_OntologyDB-2024.txt",sep = "\t", row.names = F, col.names = T, quote = F)
