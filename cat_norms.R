library(here)
setwd(here())
library(tidyverse)
library(docxtractr)

## Reading in the data ----

cues <- read_csv("cues.csv", show_col_type = F)

test <- read_docx("13428_2020_1454_MOESM1_ESM.docx")

tbls <- docx_extract_all_tbls(test)

for (ii in 1:nrow(cues)){
  print(ii)
  set_cue <- cues$Cue[ii]
  print(set_cue)
  
  temp_tbl <- tbls[[ii]]
  
  ## Setting the column names ----
  
  true_col_names <- c("Response", "All.data_Total","All.data_First","All.data_Rank.SD","YA_Total","YA_First","YA_Rank.SD","MA_Total","MA_First","MA_Rank.SD","OA_Total","OA_First","OA_Rank.SD")
  
  colnames(temp_tbl) <- true_col_names
  
  temp_tbl <- temp_tbl[-1,]
  
  ## Splitting SD column
  
  temp_tbl$All.data_Rank <- temp_tbl$All.data_Rank.SD |> 
    substr(1, 4)
  
  temp_tbl$All.data_Rank.SD <- temp_tbl$All.data_Rank.SD |> 
    substr(7, 10)
  
  temp_tbl$YA_Rank <- temp_tbl$YA_Rank.SD |> 
    substr(1, 4)
  
  temp_tbl$YA_Rank.SD <- temp_tbl$YA_Rank.SD |> 
    substr(7, 10)
  
  temp_tbl$MA_Rank <- temp_tbl$MA_Rank.SD |> 
    substr(1, 4)
  
  temp_tbl$MA_Rank.SD <- temp_tbl$MA_Rank.SD |> 
    substr(7, 10)
  
  temp_tbl$OA_Rank <- temp_tbl$OA_Rank.SD |> 
    substr(1, 4)
  
  temp_tbl$OA_Rank.SD <- temp_tbl$OA_Rank.SD |> 
    substr(7, 10)
  
  ## Imputation ----
  
  temp_tbl[temp_tbl == "-" | temp_tbl == ""] <- "-1"
  
  ## Cues ----
  
  cue_col <- rep(set_cue, length.out = nrow(temp_tbl))
  
  temp_tbl$Cue <- cue_col
  
  temp_tbl <- select(temp_tbl, c("Cue","Response", "All.data_Total","All.data_First","All.data_Rank","All.data_Rank.SD","YA_Total","YA_First","YA_Rank", "YA_Rank.SD","MA_Total","MA_First","MA_Rank","MA_Rank.SD","OA_Total","OA_First", "OA_Rank","OA_Rank.SD"))
  
  if (ii == 1){
    full_table <- temp_tbl
  } else {
    full_table <- rbind(full_table, temp_tbl)
  }
  
}

write_csv(full_table, "castro_cat_norms.csv")
