#!/usr/bin/env RScript
#contributors=c("Gregory Smith", "Nils Jenke", "Michael Gruenstaeudl")
#email="m_gruenstaeudl@fhsu.edu"
#version="2024.05.19.1300"

# pacman::p_load loads packages if they have been installed 
# and installs if they are missing
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, rstatix)

# Is the number of regions with significantly reduced coverage significantly
# different in coding versus non-coding regions?
wilcox_coding_data <- function(cov_data) {
  wilcox_df <- cov_data %>%
    select(coding, noncoding) %>%
    pivot_longer(
      cols = everything(), 
      names_to = "sequences", 
      values_to = "low_coverage") %>%
    arrange(sequences) %>%
    remove_cov_outliers("sequences", "low_coverage")
}

# Is evenness of coverage significantly different across different read lengths?
wilcox_length_data <- function(cov_data) {
  wilcox_df <- cov_data %>%
    select(avgLength, E_score) %>%
    filter(!is.na(avgLength)) %>%
    mutate(Readlength = ifelse(avgLength >= 100 & avgLength <= 300,
                               "short",
                               "medium"))
}

# Is the number of regions with significantly reduced coverage significantly
# different across the four partitions of the plastid genome (i.e., LSC, IR, SSC)?
kruskal_regions_data <- function(cov_data) {
  kruskal_df <- cov_data %>%
    select(LSC, IRb, SSC, IRa) %>%
    pivot_longer(
      cols = everything(), 
      names_to = "regions", 
      values_to = "low_coverage") %>%
    arrange(regions) %>%
    remove_cov_outliers("regions", "low_coverage")
}

# Is evenness of coverage significantly different across different assembly software tools?
kruskal_assembly_data <- function(cov_data) {
  kruskal_df <- cov_data %>%
    select("Assembly Method", E_score) %>%
    rename(Assembly = "Assembly Method") %>%
    filter(!is.na(Assembly)) %>%
    group_by(Assembly) %>%
    filter(n() >= 5) %>%
    ungroup() %>%
    remove_cov_outliers("Assembly", "E_score")
}

# Is evenness of coverage significantly different across different sequencing forms?
kruskal_model_data <- function(cov_data) {
  kruskal_df <- cov_data %>%
    select(Model, E_score) %>%
    filter(!is.na(Model)) %>%
    group_by(Model) %>%
    filter(n() >= 5) %>% 
    ungroup() %>%
    remove_cov_outliers("Model", "E_score")
}

# Collect needed data for figures
get_figure_data <- function(cov_data) {
  figure_data <- list(
    wilcox_coding = wilcox_coding_data(cov_data),
    wilcox_length = wilcox_length_data(cov_data),
    kruskal_regions = kruskal_regions_data(cov_data),
    kruskal_assembly = kruskal_assembly_data(cov_data),
    kruskal_model = kruskal_model_data(cov_data)
  )
}

# Kruskal-Wallis test results
get_kruskal_results <- function(figure_data) {
  kruskal_df <- figure_data$kruskal_regions
  kruskal_df2 <- figure_data$kruskal_assembly
  kruskal_df3 <- figure_data$kruskal_model
  
  kruskal_results <-
    rstatix::kruskal_test(kruskal_df[!is.na(kruskal_df$low_coverage), ], low_coverage ~ regions) %>%
    bind_cols(., select(
      rstatix::kruskal_effsize(kruskal_df, low_coverage ~ regions),
      effsize
    )) %>%
    bind_rows(., bind_cols(
      rstatix::kruskal_test(kruskal_df3[!is.na(kruskal_df3$E_score), ], E_score ~ Model),
      select(rstatix::kruskal_effsize(kruskal_df3, E_score ~ Model), effsize)
    )) %>%
    bind_rows(., bind_cols(
      rstatix::kruskal_test(kruskal_df2[!is.na(kruskal_df2$E_score), ], E_score ~ Assembly),
      select(
        rstatix::kruskal_effsize(kruskal_df2, E_score ~ Assembly),
        effsize
      )
    )) %>%
    mutate(variable = c("regions", "assembly", "model")) %>%
    select(variable, n, p, effsize) %>%
    rename(d_c = effsize)
}

# Wilcoxon rank-sum test results
effSize_conv <- function(x) {
  return(2 * x / (sqrt(1 - x ^ 2)))
}

get_wilcox_results <- function(figure_data) {
  wilcox_df <- figure_data$wilcox_coding
  wilcox_df2 <- figure_data$wilcox_length
  
  kruskal_df <- figure_data$kruskal_regions
  kruskal_df2 <- figure_data$kruskal_assembly
  kruskal_df3 <- figure_data$kruskal_model
  
  wilcox_results <-
    rstatix::pairwise_wilcox_test(kruskal_df[!is.na(kruskal_df$low_coverage), ], low_coverage ~ regions, p.adjust.method = "BH") %>%
    bind_cols(., select(
      rstatix::wilcox_effsize(kruskal_df, low_coverage ~ regions),
      effsize
    )) %>%
    bind_rows(., bind_cols(
      rstatix::wilcox_test(wilcox_df[!is.na(wilcox_df$low_coverage), ], low_coverage ~ sequences),
      (select(
        rstatix::wilcox_effsize(wilcox_df, low_coverage ~ sequences),
        effsize
      ))
    )) %>%
    bind_rows(., bind_cols(
      rstatix::pairwise_wilcox_test(kruskal_df3[!is.na(kruskal_df3$E_score), ], E_score ~ Model, p.adjust.method = "BH"),
      (select(
        rstatix::wilcox_effsize(kruskal_df3, E_score ~ Model),
        effsize
      ))
    )) %>%
    bind_rows(., bind_cols(
      rstatix::pairwise_wilcox_test(kruskal_df2[!is.na(kruskal_df2$E_score), ], E_score ~ Assembly, p.adjust.method = "BH"),
      (select(
        rstatix::wilcox_effsize(kruskal_df2, E_score ~ Assembly),
        effsize
      ))
    )) %>%
    bind_rows(., bind_cols(
      rstatix::wilcox_test(wilcox_df2[!is.na(wilcox_df2$E_score), ], E_score ~ Readlength),
      (select(
        rstatix::wilcox_effsize(wilcox_df2, E_score ~ Readlength),
        effsize
      ))
    )) %>%
    mutate(effsize = round(effSize_conv(effsize), 3)) %>%
    rename(variable = .y.) %>%
    select(-p.adj.signif)
}

# Outlier filtering functions
remove_cov_outliers <- function(cov_sum, names, values) {
  cov_sum <- cov_sum %>%
    group_by(!!sym(names)) %>%
    group_modify(~ remove_outliers(.x, values, 3)) %>%
    ungroup()
  return(cov_sum)
}

remove_outliers <- function(df, col_name, k = 1.5) {
  quartile <- quantile(df[[col_name]], probs = c(0.25, 0.75), na.rm = TRUE)
  iqr <- diff(quartile)
  lower_bound <- quartile[1] - k * iqr
  upper_bound <- quartile[2] + k * iqr
  
  col_name_sym <- sym(col_name)
  df <- df %>%
    filter(!!col_name_sym >= lower_bound & !!col_name_sym <= upper_bound)
  return(df)
}
