library(shiny)
library(rMaps)
library(rCharts)
library(ggmap)
library(markdown)

shinyUI(navbarPage(title = "R User Groups Around the World",
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## HTML Layout Settings
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   ## Use a customized bootstrap theme
                   theme = 'bootstrap.css',
                   collapsable = TRUE,
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "About"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                      
                   tabPanel("About", includeMarkdown("doc/intro.md")),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Maps"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                      
                   navbarMenu("Maps",
                              tabPanel("All R User Groups (140)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_all', 'leaflet')),
                              tabPanel("Europe (49)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_europe', 'leaflet')),
                              tabPanel("United States (49)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_usa', 'leaflet')),
                              tabPanel("--------------------"),
                              tabPanel("Asia (20)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_asia', 'leaflet')),
                              tabPanel("North America (56)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_n_america', 'leaflet')),
                              tabPanel("Middle East / Africa (4)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_mea', 'leaflet')),
                              tabPanel("Oceania (7)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_oceania', 'leaflet')),
                              tabPanel("South / Central America (4)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_sc_america', 'leaflet')),
                              tabPanel("--------------------"),
                              tabPanel("Australia (5)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_australia', 'leaflet')),
                              tabPanel("Canada (7)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_canada', 'leaflet')),
                              tabPanel("Germany (9)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_germany', 'leaflet')),
                              tabPanel("India (5)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_india', 'leaflet')),
                              tabPanel("Japan (5)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_japan', 'leaflet')),
                              tabPanel("United Kingdom (8)",
                                       tags$style('.leaflet {height: 600px;}'),
                                       showOutput('map_uk', 'leaflet'))
                              
                   ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Data"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   navbarMenu("Data", 
                              tabPanel("Data (Original)",
                                       HTML("<h3>Original RUGs Data from Revolution Analytics</h3>"),
                                       downloadButton('dl_ori', 'Download CSV'),
                                       HTML("<p> <br></p>"),
                                       dataTableOutput("data_original")
                              ),
                              tabPanel("Data (Modified)",
                                       HTML("<h3>Modified RUGs Data with Lat/Lon Info</h3>"),
                                       downloadButton('dl_mod', 'Download CSV'),
                                       HTML("<p> <br></p>"),
                                       dataTableOutput("data_modified")
                              )
                   ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "More"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   navbarMenu("More", 
                              tabPanel("Code", includeMarkdown("doc/code.md")),
                              tabPanel("Contact", includeMarkdown("doc/contact.md"))
                   )

))
