library(tidyverse)

folder_name <- list.dirs(path = ".", full.names = FALSE, recursive = FALSE) |>
  str_subset("^VM2")
folder_path <- file.path(folder_name)
files <- list.files(path = folder_path, pattern = "\\.tab$", full.names = TRUE)

demo_file <- files[str_detect(files, "DEMOGRAPHIC\\.tab$")]
vote_file <- files[str_detect(files, "VOTEHISTORY\\.tab$")]

demo_d <- read_tsv(demo_file)
vote_d <- read_tsv(vote_file)

missing_vote <- vote_d |> 
  summarise(across(everything(), ~all(is.na(.)))) |> 
  pivot_longer(
    cols = everything(), names_to = "column_name",
    values_to = "all_missing") |> 
  filter(all_missing == TRUE)

missing_demo <- demo_d |> 
  summarise(across(everything(), ~all(is.na(.)))) |> 
  pivot_longer(
    cols = everything(), names_to = "column_name",
    values_to = "all_missing") |> 
  filter(all_missing == TRUE)

out_file_name_vote <- paste0("AllMissingCols-",folder_name,"-Vote.csv")
out_file_name_demo <- paste0("AllMissingCols-",folder_name,"-Demo.csv")


write_csv(missing_vote, file = file.path("parsed", out_file_name_vote))
write_csv(missing_demo, file = file.path("parsed", out_file_name_demo))

#at the end delete that whole folder
unlink(folder_path, recursive = TRUE, force = TRUE)
