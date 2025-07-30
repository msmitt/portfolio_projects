## this document contains useful examples of different ggplot2 functions
## setup the environment (Palmer Penguins dataset)
library(ggplot2)
library(palmerpenguins)

data(penguins)
View(penguins)

## basic scatterplot
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g))

## add colour via species
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species))

## utilize different shapes for the species
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = species))

## add size
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g,
                           color = species, shape = species, size = species))

## basic plot using alpha for dense plots
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, alpha = species))

## making every point purple without relation to a variable, so we add it outside aes' mapping
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g), color = "purple")

## smooth line graph
ggplot(data = penguins) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g))

## smooth line grap, then add the scatterpoints
ggplot(data = penguins) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping=aes(x = flipper_length_mm, y = body_mass_g, color = species))

## separate trend smooth lines for species
ggplot(data = penguins) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g, linetype = species, color = species))

## Jittering to help offset 'overplotting'
ggplot(data = penguins) +
  geom_jitter(mapping = aes(x = flipper_length_mm, y = body_mass_g))

## bar chart for the diamonds dataset. we do not give a Y since R automatically checks for the bar plot
ggplot(data = diamonds) +
  geom_bar(mapping=aes(x=cut))

## add color to the bar chart via cut
ggplot(data = diamonds) +
  geom_bar(mapping=aes(x = cut, color = cut))

## add color to the bar chart via cut using fill
ggplot(data = diamonds) +
  geom_bar(mapping=aes(x = cut, fill = cut))

## mapping fill to another variable will create a stacked bar chart
ggplot(data = diamonds) +
  geom_bar(mapping=aes(x = cut, fill = clarity))

## create a barchart with rotated labels
ggplot(data = hotel_bookings) +
  geom_bar(mapping = aes(x = distribution_channel)) +
  facet_wrap(~deposit_type) +
  theme(axis.text.x = element_text(angle = 45))

## The `facet_grid` function does something similar. The main difference is that `facet_grid` will include plots even if they are empty.
ggplot(data = hotel_bookings) +
  geom_bar(mapping = aes(x = distribution_channel)) +
  facet_grid(~deposit_type) +
  theme(axis.text.x = element_text(angle = 45))
  
  ## add colour via species and a title
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length")

## add a subtitle and caption
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length", subtitle = "Sample of Three Penguins Species",ata
  caption = "Data collected by Dr. Kristin G")

## annotate (x and y specify the location)
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length", subtitle = "Sample of Three Penguins Species",ata
  caption = "Data collected by Dr. Kristin G") +
  annotate("text", x=220, y=3500, label = "The Gentoos are the largest")

## annotate, add color and change font
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length", subtitle = "Sample of Three Penguins Species",
  caption = "Data collected by Dr. Kristin G") +
  annotate("text", x=220, y=3500, label = "The Gentoos are the largest", color = grey), fontface = "bold", size = 4.5, angle = 25)

## store plot as variable and annotate
p<- ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length", subtitle = "Sample of Three Penguins Species",ata
  caption = "Data collected by Dr. Kristin G")

p + annotate("text", x = 220, y = 3500, label = "The Gentoos are the largest"

## Saving and Exporting
library(ggplot2)
library(palmerpenguins)

ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins: Body Mass vs. Flipper Length", subtitle = "Sample of Three Penguins Species",
       caption = "Data collected by Dr. Kristin G") 

## Export button to save the above

## ggsave()

ggsave("Three Penguin Species.png")