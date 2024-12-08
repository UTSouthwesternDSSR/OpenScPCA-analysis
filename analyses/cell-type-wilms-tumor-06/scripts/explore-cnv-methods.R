# Define path -------------------------------------------------------------------
# The base path for the OpenScPCA repository, found by its (hidden) .git directory
repository_base <- rprojroot::find_root(rprojroot::is_git_root)
# The path to this module
module_base <- file.path(repository_base, "analyses", "cell-type-wilms-tumor-06")

# paths to the notebook templates and outputs directory
notebook_template_dir <- file.path(module_base, "notebook_template")
notebook_output_dir <- file.path(module_base, "notebook")

# We run copyKAT and infercnv for a subselection of samples selected in "04_annotation_Across_Samples_exploration.Rmd" with and without healthy cells as reference

for (sample_id in c("SCPCS000179",
                    "SCPCS000184",
                    "SCPCS000194", 
                    "SCPCS000205",
                    "SCPCS000208")){
  
  ##############################################################################
  #################################`copykat`  ##################################
  ##############################################################################
  
  # We run and explore copykat using euclidian distance parameter and normal cell as reference
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "05_copyKAT.R"), " --sample_id ", sample_id, " --n_core ", 32, " --distance ", "euclidean", " --use_reference ", "ref"))
  
  # We run and explore copykat using spearman distance parameter and normal cell as reference
  
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "05_copyKAT.R"), " --sample_id ", sample_id, " --n_core ", 32, " --distance ", "spearman", " --use_reference ", "ref"))

  # We run and explore copykat using euclidian distance parameter and without normal cell as reference
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "05_copyKAT.R"), " --sample_id ", sample_id, " --n_core ", 32, " --distance ", "euclidean", " --use_reference ", "noref"))
  
  # We run and explore copykat using spearman distance parameter and without normal cell as reference
  
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "05_copyKAT.R"), " --sample_id ", sample_id, " --n_core ", 32, " --distance ", "spearman", " --use_reference ", "noref"))
  
  # We explore `copykat` result rendering one notebook per sample tested
  
  rmarkdown::render(input = file.path(notebook_template_dir, "05_copykat_exploration.Rmd"),
                    params = list(sample_id = sample_id, seed = 12345),
                    output_format = "html_document",
                    output_file = paste0("05_copykat_exploration_", sample_id,".html"),
                    output_dir = file.path(notebook_output_dir, sample_id))
  
  ##############################################################################
  #################################`infercnv`  #################################
  ##############################################################################
      
  # We run and explore infercnv using immune cells as reference and no HMM model
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "immune", " --HMM ", "no"))

  # We run and explore infercnv using endothelial cells as reference and no HMM model
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "endothelium", " --HMM ", "no"))

  # We run and explore infercnv using no normal reference and no HMM model
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "none", " --HMM ", "no"))
  
  # We run and explore infercnv using both endothelial and immune cells as reference and no HMM model
  
  system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "both", " --HMM ", "no"))
  
  # We run and explore infercnv using both endothelial and immune cells as reference and i3 HMM model
  
   system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "both", " --HMM ", "i3"))

  # We run and explore infercnv using both endothelial and immune cells as reference and i6 HMM model
  
   system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "both", " --HMM ", "i6")) 
   
   # We run and explore infercnv using both endothelial and immune cells from all non-treated Wilms tumor patients as reference and i3 HMM model
   system(command = glue::glue("Rscript ", file.path(module_base,"scripts", "06_infercnv.R"), " --sample_id ", sample_id, " --reference ", "pull", " --HMM ", "i3"))   
   
  rmarkdown::render(input = file.path(notebook_template_dir, "06_cnv_infercnv_exploration.Rmd"),
                  params = list(sample_id = sample_id, seed = 12345),
                  output_format = "html_document",
                  output_file = paste0("06_infercnv_exploration_", sample_id,".html"),
                  output_dir = file.path(notebook_output_dir, sample_id))

}

 
    
    
    
  
  
  