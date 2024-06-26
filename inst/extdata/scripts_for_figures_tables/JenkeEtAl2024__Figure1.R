#!/usr/bin/env RScript
#contributors=c("Gregory Smith", "Nils Jenke", "Michael Gruenstaeudl")
#email="m_gruenstaeudl@fhsu.edu"
#version="2024.05.26.1500"

# pacman::p_load loads packages if they have been installed 
# and installs if they are missing
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tcltk, tidyverse, ggplot2, ggrepel, ggpubr, optparse, magick, pdftools, grid)

# Select input directory and input files
inDir_data = tk_choose.dir(default="~", caption='Select directory with the .gb and .bam files')
inFn_sampleList = tk_choose.files(caption='Select samples list file in csv-format (e.g., input/JenkeEtAl2024_samples_list.csv)')
inFn_figure1b = tk_choose.files(caption='Select PDF file used for figure 1b (e.g., input/NC_026562_CoverageViz_crop.pdf)')

source("PREP_metadata_extraction_all.R")
source("PREP_coverage_data_assembly.R")
source("PREP_coverage_data_preparation.R")

# FIGURE 1A - evenness outliers
create_figure_1a <- function(cov_data) {
  # manually jitter values
  set.seed(2)
  cov_data <- cov_data %>%
    mutate(jittered_x = jitter(rep(1, n()), amount = 0.2))
  top_outliers <- cov_data %>% 
    slice_min(E_score, n = 13)
  
  # create ggplot
  outlier <- ggplot(cov_data, aes(x = 1, y = E_score)) +
    geom_boxplot(outlier.shape = NA, width = 0.5) +
    geom_point(aes(x = jittered_x), alpha = 0.5, size = 0.75) +
    geom_text_repel(
      data = top_outliers,
      aes(x = jittered_x, y = E_score, label = Accession),
      size = 2,
      color = "red",
      #nudge_x = 0.1,
      #nudge_y = -0.1
    ) +
    theme_minimal() +
    theme(
      plot.margin = unit(c(0.25, 0.25, 0.75, 0), "cm"),
      text = element_text(size = 9)
    ) +
    coord_cartesian(ylim = c(0, 1), 
                    expand = FALSE) +
    labs(x = "Samples", y = "E-score") +
    rremove("x.text")
}

# FIGURE 1B - previously created viz of outlier
create_figure_1b <- function() {
  pdf_img <- image_read_pdf(inFn_figure1b, density = 300)
  img_grob <- rasterGrob(as.raster(pdf_img), width = unit(1, "npc"), height = unit(1, "npc"))
  png_plot <- ggplot() +
    annotation_custom(img_grob) +
    theme_void()
}

# FIGURE 1 - arranged display of evenness outliers and an outlier example
create_figure_1 <- function(cov_data) {
  figure_1a <- create_figure_1a(cov_data)
  figure_1b <- create_figure_1b()

  ggarrange(
    figure_1a,
    figure_1b,
    nrow = 2,
    ncol = 1,
    labels = c("A", "B"),
    font.label = list(size=13),
    label.y = 1.02,
    label.x = -0.02
  )
  ggsave(
    filename = "JenkeEtAl2024_Figure_1.pdf",
    path = "./images",
    device = 'pdf',
    dpi = 700,
    width = 8.5,
    height = 15.5,
    units = ("cm")
  )
}

# Execute commands
metadata_extraction_all()
cov_data <- get_cov_df()
dir.create("images")
create_figure_1(cov_data)
