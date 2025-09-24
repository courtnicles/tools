args = commandArgs(TRUE)
filepath = args[1]

library(tidyverse)
library(ggpubr)  # add line break
library(reshape2)  # melt 
library(agricolae)  # LSD, Tukey Tests
library(ggforce)  # comparison circles
library(cowplot, warn.conflicts = FALSE)  # plot grid

lm_eqn <- function(df){
  m <- lm(y ~ x, df);
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(unname(coef(m)[1]), digits = 2),
                        b = format(unname(coef(m)[2]), digits = 2),
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}

make_yield_metric_plot <- function(df, ylimits, reagent, tune,formula_coords,font_size = 12, plot_title) {
  
  df_lm <- df %>%
    select(`Mean lifetime (min)`,`Pores Survival %`)
  
  colnames(df_lm) <- c("x", "y")
  
  ggplot(data = df, aes(x = `Mean lifetime (min)`, y = `Pores Survival %`)) +
    geom_point(size = 2, alpha = 0.75) +
#    geom_line(linetype = "dashed") +
    geom_text(x = formula_coords[1], y = formula_coords[2], label = lm_eqn(df_lm), parse = TRUE) +
    #    geom_jitter(size = 1, alpha = 0.25, width = 0.05) +
    geom_smooth(method = "lm", formula = y ~ poly(x, 2, raw = TRUE), se = TRUE, color = "blue") +
    labs(title = plot_title) +
    theme(
      axis.text.y = element_text(size = font_size),
      axis.text.x = element_text(
        size = font_size,
        angle = 0,
        hjust = 1
      ),
      axis.title = element_text(size = font_size, face = "bold"),
      legend.text = element_text(size = font_size)
    ) +
    guides(fill = guide_legend(override.aes = list(alpha = 1))) 
#    scale_x_continuous(breaks = seq(min(df$`Mean lifetime (min)`), max(df$`Mean lifetime (min)`), by = 1)) +
#    scale_y_continuous(limits = ylimits,
#                       breaks = seq(ylimits[1], ylimits[2], by = tune)) #+
  #    annotate("text", x = Inf, y = Inf, label = as.character(as.expression(eq)), parse = TRUE, hjust = 1.1, vjust = 2, size = 3.5) +
  #    annotate("text", x = Inf, y = Inf, label = as.character(as.expression(r2)), parse = TRUE, hjust = 1.1, vjust = 3.5, size = 3.5)
}


filepath <- "/Users/nguyec27/Documents/Experiments/Lifetime/joined.csv"

i <- tail(str_locate_all(filepath, "/")[[1]][, 1], n = 1)
folder <- str_sub(filepath, 1, i)
cat("\n", paste("Folder with CSV (where plots are saved)", folder, "\n\n"))
filename <- str_sub(filepath, i + 1)
cat(paste("Plots will be saved in", folder, "\n\n"))

save_image <- function(image_name, plot) {
  ggsave(
    filename = paste(folder, image_name, sep = ""),
    plot,
    width = 7,
    height = 7,
    dpi = 150
  )
}

df <- read_csv(filepath, col_names = TRUE, show_col_types = FALSE)

lifetime_vs_pore_survival <- make_yield_metric_plot(df, ylimits = c(0, 100), 
                                    reagent = 'Mean lifetime (min)',
                                    tune = 0.05,
                                    formula_coords = c(190,40),
                                    plot_title = "Mean lifetime (min) vs Pore Survival %")
save_image("lifetime_vs_pore_survival.png", lifetime_vs_pore_survival)
