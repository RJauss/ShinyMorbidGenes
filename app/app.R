library(shiny)
library(tidyverse)
library(DBI)
library(config)
library(pool)
library(RMariaDB)
library(DT)

# UI ----

ui <- fluidPage(
    # App title ----
    titlePanel("MorbidGenes Panel - v2023-01.1"),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Choose dataset ----
            #selectInput("dataset", "Choose a dataset:",
            #            choices = c("rock", "pressure", "cars")),
            
            # Button
            downloadButton("downloadData", "Download")
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            
            DT::dataTableOutput("tbl")
            
        )
    )
        
    
        
)

# Define server logic ----
server <- function(input, output, session) {
    # get config ====
    dw <- config::get("morbidgenes_db")
    # get pool DB ====
    pool <- dbPool(
        drv = RMariaDB::MariaDB(),
        dbname = dw$dbname,
        host = dw$host,
        user = dw$user,
        password = dw$password,
        server = dw$server,
        port = dw$port
    )
    
    morbidgenes_db_panel_current_table <- pool %>% 
        tbl("view_panel_current") %>% 
        select(symbol, hgnc_id, ClinVarPathogenic, Phenotype_MIM, HGMD_pathogenic, 
               PanelApp, SysNDD, GenCC, mg_score)
    morbidgenes_db_panel_current_table = as_tibble(morbidgenes_db_panel_current_table) %>%
        mutate_at(vars(3:9), as.integer)
    
    
    output$tbl <- DT::renderDataTable({
    #    conn <- dbConnect(
    #        drv = RMySQL::MySQL(),
    #        dbname = "shinydemo",
     ##       host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
     #       username = "guest",
     #       password = "guest")
     #   on.exit(dbDisconnect(conn), add = TRUE)
     #   dbGetQuery(conn, paste0(
     #       "SELECT * FROM City LIMIT ", input$nrows, ";"))
        morbidgenes_db_panel_current_table
        
    })
    
    output$downloadData <- downloadHandler(
        #filename = function() {
        #    paste(input$dataset, ".csv", sep = "")
        #},
        filename = "Test.csv", 
        #content = function(file) {
        #    write.csv(datasetInput(), file, row.names = FALSE)
        #}
        content = function(file){
            write.csv(morbidgenes_db_panel_current_table, file)}
    )
}
# Run the app ----
shinyApp(ui = ui, server = server)
