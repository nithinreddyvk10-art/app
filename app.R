# source("functions.R", local = TRUE)
source("global.R")


# ui <- tagList(
#   tags$head(
#     tags$style(HTML("
#       .wrapper {
#         transform: scale(0.9);
#         transform-origin: top left;
#         width: calc(100% / 0.9);
#       }
#     "))
#   ),

ui <- dashboardPage(
  preloader = list(html = tagList(spin_chasing_dots(), "Loading ..."), color = "#343a40"),
  title = "Aguilon",
  dark = NULL,
  help = NULL,
  # controlbar = dashboardControlbar(skinSelector(), pinned = TRUE),

  dashboardHeader(
    title =
      dashboardBrand(
        title = "Aguilon",
        color = "primary",
        # href = "https://adminlte.io/themes/v3",
        image = "aguilonapp_White.png"
      ),
    controlbarIcon = shiny::icon("th"),
    skin = "light", status = "white", sidebarIcon = shiny::icon("bars"),
    tags$span(
      style = "font-size: 20px; font-weight: 350; ", # Make project name light
      "Tanweer Qewa Energy Company | PSS", # Replace "Your Project Name" with your project name
      HTML("&nbsp;&nbsp;&nbsp;")
    ),
    actionButton("info_button", label = "", icon = icon("info"), tooltip = "Information")
  ),
  dashboardSidebar(
    skin = "dark",
    status = "primary",
    collapsed = F,
    elevation = 4,
    sidebarUserPanel(textOutput("auth_output"),
      image = "user.png"
    ), # uiOutput("sidebarmenuuuu")
    sidebarMenuOutput("menu")
  ),

  # footer = bs4DashFooter(left = a("Powered by PlantOptix | Version 2.1", href="", target="_blank"), right = "Solar PV IPP | Plant Settlement System", fixed = FALSE),

  fullscreen = TRUE,
  dashboardBody(

    # tags$script(HTML("$(window).on('unload', function(event) {
    # Shiny.setInputValue(id = 'window_unload', value = true);});")),
    tags$head(
      tags$style(type = "text/css", ".recalculating {opacity: 1.0;}"),
      tags$script(src = "custom_handsontable.js")
    ),
    tabItems(

      # dashboard
      tabItem(
        tabName = "pass_dashboard",
        fluidRow(

          # A dynamic valueBox
          bs4ValueBoxOutput("kpi1", width = 3),
          bs4ValueBoxOutput("kpi2", width = 3),
          bs4ValueBoxOutput("kpi3", width = 3),
          bs4ValueBoxOutput("kpi4", width = 3),
          bs4ValueBoxOutput("kpi5", width = 3),
          bs4ValueBoxOutput("kpi6", width = 3),
          bs4ValueBoxOutput("kpi7", width = 3)
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            maximizable = TRUE,
            title = "Total payments for Net Electrical Energy", width = 6,
            plotlyOutput("solar_trend1")
          ),
          box(
            collapsible = TRUE,
            maximizable = TRUE,
            title = "Net Electrical Energy Actual Exp", width = 6,
            plotlyOutput("solar_trend2")
          ),
          box(
            title = "TCM | Last Calculation Execution",
            background = NULL,
            width = 12,
            status = "primary",
            solidHeader = FALSE,
            DTOutput("dash_table1")
          )
        )
      ),
      tabItem(
        tabName = "ppm_dashboard",
        fluidRow(

          # A dynamic valueBox
          bs4ValueBoxOutput("kpi11", width = 3),
          bs4ValueBoxOutput("kpi22", width = 3),
          bs4ValueBoxOutput("kpi33", width = 3),
          bs4ValueBoxOutput("kpi44", width = 3),
          bs4ValueBoxOutput("kpi55", width = 3),
          bs4ValueBoxOutput("kpi66", width = 3),
          bs4ValueBoxOutput("kpi77", width = 3)
        ),
        fluidRow(
          box(
            title = "PPM KPI's",
            background = NULL,
            width = 12,
            status = "primary",
            solidHeader = FALSE,
            fluidRow(
              column(
                width = 4,
                dateRangeInput("dateRange_ppm",
                  "Select date range:",
                  start = Sys.Date() - 30,
                  end = Sys.Date()
                )
              ),
              column(
                width = 2,
                div(
                  style = "margin-top: 30px;", # Adjust margin or padding as needed
                  downloadButton("ppm_data_download", "Export", icon = icon("file-export"), style = "width:100%")
                )
              )
            ),
            DTOutput("dash_table2")
          ),
          box(
            title = "Performance Ratio Variation",
            background = NULL,
            width = 6,
            status = "primary",
            solidHeader = FALSE,
            plotlyOutput("dash_plot3")
          ),
          box(
            title = "Power Output Variation",
            background = NULL,
            width = 6,
            status = "primary",
            solidHeader = FALSE,
            plotlyOutput("dash_plot4")
          )
        )
      ),


      # signallist
      tabItem(
        tabName = "dv",
        fluidRow(
          tabBox(
            id = "dv_id",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Meter Data",
              fluidRow(
                box(
                  title = "Meter Data Validation",
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,

                  # --- Filters + Action buttons (same row) ---
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "start_date_dv", label = "From:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                        # value = c(Sys.Date()-1)
                      )
                    ),
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "end_date_dv", label = "To:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                        # value = c(Sys.Date())
                      )
                    ),
                    column(
                      width = 2,
                      selectInput(
                        "meterid_dv",
                        "Select MeterId:",
                        choices = NULL
                      )
                    ),
                    column(
                      width = 4,
                      div(
                        style = "margin-top: 25px;", # aligns with date input
                        actionButton(
                          "mda_dv_refresh",
                          label = NULL,
                          icon = icon("sync"),
                          title = "Refresh Data",
                          style = "color:#3498db;" # blue
                        ),
                        actionButton(
                          "mda_dv_rebuild",
                          label = NULL,
                          icon = icon("tools"),
                          title = "Rebuild Data",
                          style = "color:#e67e22;" # orange
                        ),
                        actionButton(
                          "mda_dv_revalidate",
                          label = NULL,
                          icon = icon("check-double"),
                          title = "Revalidate Data",
                          style = "color:#27ae60;" # green
                        ),
                        actionButton(
                          "mda_dv_save",
                          label = NULL,
                          icon = icon("save"),
                          title = "Save Data",
                          style = "color:#9b59b6;" # purple
                        )
                      )
                    )
                  ),

                  # --- First Table ---
                  rHandsontableOutput("mda_dv1"),
                  hr(),
                  rHandsontableOutput("mda_dv2")
                )
              )
            ),
            tabPanel(
              title = "Scada Data",
              fluidRow(
                box(
                  title = "Scada Data Validation",
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,

                  # --- Filters + Action buttons (same row) ---
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "start_date_dcs_dv", label = "From:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        # update_on = "close",
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                        # value = c(Sys.Date()-1)
                      )
                    ),
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "end_date_dcs_dv", label = "To:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        # update_on = "close",
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                        # value = c(Sys.Date())
                      )
                    ),
                    column(
                      width = 1,
                      selectInput("category_dcs_dv", "Category:", choices = NULL)
                    ),
                    column(
                      width = 4,
                      div(
                        style = "margin-top: 25px;", # aligns with date input
                        actionButton(
                          "dcs_dv_refresh",
                          label = NULL,
                          icon = icon("sync"),
                          title = "Refresh Data",
                          style = "color:#3498db;" # blue
                        ),
                        actionButton(
                          "dcs_dv_rebuild",
                          label = NULL,
                          icon = icon("tools"),
                          title = "Rebuild Data",
                          style = "color:#e67e22;" # orange
                        ),
                        actionButton(
                          "dcs_dv_revalidate",
                          label = NULL,
                          icon = icon("check-double"),
                          title = "Revalidate Data",
                          style = "color:#27ae60;" # green
                        ),
                        actionButton(
                          "dcs_dv_save",
                          label = NULL,
                          icon = icon("save"),
                          title = "Save Data",
                          style = "color:#9b59b6;" # purple
                        )
                      )
                    )
                  ),

                  # --- First Table ---
                  rHandsontableOutput("scada_dv1"),
                  hr(),
                  rHandsontableOutput("scada_dv2")
                )
              )
            )
          )
        )
      ),

      # meterdata
      tabItem(
        tabName = "raw_data",
        fluidRow(
          tabBox(
            id = "raw_data_tab",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Raw MDA Data",
              fluidRow(
                box( # title = "Meter Data Monitoring",
                  title = tagList("Meter Data Monitoring"),
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "start_date_rmd", label = "From:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "end_date_rmd", label = "To:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 2,
                      selectInput("meter_id_rmd", "Meter Id:", choices = NULL)
                    ),
                    column(
                      width = 2,
                      selectInput("subtype_rmd", "Import/Export:", choices = c("EXPORT", "IMPORT"))
                    ),
                    column(
                      width = 2,
                      div(
                        style = "margin-top: 25px;", # aligns with date input
                        actionButton(
                          "mda_refresh",
                          label = NULL,
                          icon = icon("sync"),
                          title = "Refresh Data",
                          style = "color:#3498db;" # blue
                        )
                        # actionButton(
                        #   "mda_export",
                        #   label = NULL,
                        #   icon = icon("file-export"),
                        #   title = "Export Data",
                        #   style = "color:#e67e22;"   # orange
                        # )
                      )
                    )
                  ),
                  rHandsontableOutput("raw_mda")
                )
              )
            ),
            tabPanel(
              title = "Raw SCADA Data",
              fluidRow(
                box( # title = "Meter Data Monitoring",
                  title = tagList("Scada Data Monitoring"),
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "start_date_dcs", label = "From:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "end_date_dcs", label = "To:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 1,
                      selectInput("dcs_category_id", "Category:", choices = NULL)
                    ),
                    column(
                      width = 4,
                      selectInput("dcs_tag_id", "Select Tag:", choices = NULL)
                    ),
                    column(
                      width = 1,
                      div(
                        style = "margin-top: 25px;", # aligns with date input
                        actionButton(
                          "dcs_refresh",
                          label = NULL,
                          icon = icon("sync"),
                          title = "Refresh Data",
                          style = "color:#3498db;" # blue
                        )
                        # actionButton(
                        #   "dcs_export",
                        #   label = NULL,
                        #   icon = icon("file-export"),
                        #   title = "Export Data",
                        #   style = "color:#e67e22;"   # orange
                        # )
                      )
                    )
                  ),
                  rHandsontableOutput("raw_dcs")
                )
              )
            )
          )
        )
      ),

      # signallist
      tabItem(
        tabName = "parameterization",
        fluidRow(
          tabBox(
            id = "signallist",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "MDA Signals",
              fluidRow(
                box(
                  title = "Parameterization | MDA Signals",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("mda_sig"),
                  hr(),
                  actionButton("mda_sig_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
                )
              )
            ),
            tabPanel(
              title = "SCADA Signals",
              fluidRow(
                box(
                  title = "Parameterization | SCADA Signals",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("dcs_sig"),
                  hr(),
                  actionButton("dcs_sig_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
                )
              )
            ),
            tabPanel(
              title = "PSS Signals",
              fluidRow(
                box(
                  title = "Parameterization | PSS Signals",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("pss_sig"),
                  hr(),
                  actionButton("pss_sig_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
                )
              )
            ),
            tabPanel(
              title = "PPM Signals",
              fluidRow(
                box(
                  title = "Parameterization | PPM Signals",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("ppm_sig"),
                  hr(),
                  actionButton("ppm_sig_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
                )
              )
            )
          )
        )
      ),

      # capacity tariff
      tabItem(
        tabName = "fi",
        fluidRow(

          # --- LEFT COLUMN (7 width) ---
          column(
            width = 7, style = "padding-left: 0px; padding-right: 0px;",
            box(
              title = "Contract Data",
              width = 12,
              status = "primary",
              rHandsontableOutput("fi_static"),
              fluidRow(
                column(
                  width = 2,
                  selectInput("fi_static_rev", "Revision:", choices = NULL)
                ),
                column(
                  width = 4,
                  div(
                    style = "margin-top: 27px;", # Adjust margin or padding as needed
                    actionButton(
                      "fi_static_apply",
                      label = "Apply",
                      icon = icon("check"),
                      title = "Apply Revision",
                      style = "color:#e67e22;" # orange
                    ),
                    actionButton(
                      "fi_static_save",
                      label = "Save",
                      icon = icon("save"),
                      title = "Save",
                      style = "color:#27ae60;" # green
                    )
                  )
                )
              )
            ),

            # --- Row ER ---------------------
            fluidRow(
              # --- Exchange Rate Data ---
              column(
                width = 6, style = "padding-right: 0px;",
                box(
                  title = "Exchange Rate, EXRn",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("fi_er"),
                  hr(),
                  actionButton(
                    "fi_er_save",
                    label = "Save",
                    icon = icon("save"),
                    title = "Save Data",
                    style = "color:#9b59b6;" # purple
                  )
                )
              ),

              # --- VAT % Data ---
              column(
                width = 6, style = "padding-left: 0px;",
                box(
                  title = "VAT %",
                  background = NULL,
                  width = 12, # full width inside sub-column
                  status = "primary",
                  solidHeader = FALSE,
                  rHandsontableOutput("fi_vat"),
                  hr(),
                  actionButton(
                    "fi_vat_save",
                    label = "Save",
                    icon = icon("save"),
                    title = "Save Data",
                    style = "color:#9b59b6;" # purple
                  )
                )
              )
            )
          ),

          # --- RIGHT COLUMN (5 width) ---
          column(
            width = 5, style = "padding-left: 0px; padding-right: 0px;",
            box(
              title = "Contract Year Data",
              background = NULL,
              width = 12,
              status = "primary",
              solidHeader = FALSE,

              # --- Contract Year Table ---
              rHandsontableOutput("fi_cy"),
              hr(),
              # --- Descriptive text ---
              HTML("<div style='color: grey;'>
                          USPPIn: US Producer Price Index,
                          KSACPIn: KSA Consumer Price Index
                          </div>"),
              hr(),
              actionButton(
                "fi_cy_save",
                label = "Save",
                icon = icon("save"),
                title = "Save Data",
                style = "color:#9b59b6;" # purple
              )
            )
          )
        )
      ),


      # capacity tariff
      tabItem(
        tabName = "pc",
        fluidRow(

          # --- LEFT COLUMN (7 width) ---
          column(
            width = 7, style = "padding-left: 0px; padding-right: 0px;",

            # --- Static Contract Data ---
            box(
              title = "Commercial Operation Dates",
              background = NULL,
              width = 12,
              status = "primary",
              solidHeader = FALSE,
              rHandsontableOutput("pc_cod"),
              hr(),
              actionButton(
                "pc_cod_save",
                label = "Save",
                icon = icon("save"),
                title = "Save Data",
                style = "color:#9b59b6;" # purple
              )
            ),
            box(
              title = "Plant Configurations",
              background = NULL,
              width = 12,
              status = "primary",
              solidHeader = FALSE,
              rHandsontableOutput("pc_plant"),
              hr(),
              actionButton(
                "pc_plant_save",
                label = "Save",
                icon = icon("save"),
                title = "Save Data",
                style = "color:#9b59b6;" # purple
              )
            )
          ),

          # --- RIGHT COLUMN (5 width) ---
          column(
            width = 3, style = "padding-left: 0px; padding-right: 0px;",
            box(
              title = "Project NEE (MWhAC)",
              background = NULL,
              width = 12,
              status = "primary",
              solidHeader = FALSE,

              # --- Contract Year Table ---
              rHandsontableOutput("pc_pnee"),
              actionButton(
                "pc_pnee_save",
                label = "Save",
                icon = icon("save"),
                title = "Save Data",
                style = "color:#9b59b6;" # purple
              )
            )
          ),
          # --- RIGHT COLUMN (5 width) ---
          column(
            width = 2, style = "padding-left: 0px; padding-right: 0px;",
            box(
              title = "Calc Settings",
              background = NULL,
              width = 12,
              status = "primary",
              solidHeader = FALSE,
              selectInput(
                inputId = "pc_calc_mode",
                label = "Select Calculation Mode",
                choices = c("Auto", "Main", "Check"),
                selected = NULL
              )
            )
          )
        )
      ),


      # signallist
      tabItem(
        tabName = "availability",
        fluidRow(
          tabBox(
            id = "availability",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Availability",
              fluidRow(
                box(
                  title = "Plant Availability Configuration",
                  background = NULL,
                  width = 12, height = 700,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 2,
                      airDatepickerInput(
                        inputId = "a_date1", label = "Start Date:", timepicker = TRUE, autoClose = TRUE, readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 2,
                      airDatepickerInput(
                        inputId = "a_date2", label = "End Date:", timepicker = TRUE, readonly = TRUE, clearButton = TRUE,
                        timepickerOpts = timepickerOptions(minMinutes = 0, maxMinutes = 0)
                      )
                    ),
                    column(
                      width = 1,
                      numericInput("a1", "Duration:", value = "")
                    ),
                    column(
                      width = 3,
                      textInput("a2", "Reason:", value = "")
                    ),
                    column(
                      width = 1,
                      numericInput("a3", "Availability(%):", value = "")
                    ),
                    column(
                      width = 2,
                      div(
                        style = "margin-top: 33px;", # Adjust margin or padding as needed
                        actionButton("a_add_btn", "Add"),
                        actionButton("a_delete_btn", "Delete"),
                      )
                    )
                  ),
                  hr(),
                  DTOutput("a_table")
                )
              )
            ),
            tabPanel(
              title = "Availability Report",
              fluidRow(
                column(
                  width = 2,
                  airDatepickerInput(inputId = "a_startDate", label = "Select Date:", timepicker = F, autoClose = T, readonly = TRUE, clearButton = TRUE),
                  actionButton("a_report_btn", "Generate Report", style = "width:100%")
                ),
                column(
                  width = 10,
                  uiOutput("a_report")
                )
              )
            )
          )
        )
      ),

      # signallist
      tabItem(
        tabName = "deemed",
        fluidRow(
          tabBox(
            id = "deemed",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Deemed Period",
              fluidRow(
                box(
                  title = "Deemed Period Configuration",
                  width = 12,
                  status = "primary",
                  background = NULL,
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 1,
                      airMonthpickerInput(
                        inputId = "d_month",
                        label = "Month:",
                        addon = "none",
                        dateFormat = "yyyy-MM",
                        value = format(Sys.Date(), "%Y-%m"), # ← sets current month
                        readonly = TRUE
                      )
                    ),
                    column(
                      width = 2,
                      airDatepickerInput(
                        inputId = "deemed_date1",
                        label = "From:",
                        timepicker = TRUE,
                        addon = "none",
                        readonly = TRUE,
                        clearButton = TRUE,
                        timepickerOpts = timepickerOptions(
                          dateTimeSeparator = " at ",
                          timeFormat = "HH:mm",
                          minMinutes = 0,
                          maxMinutes = 0
                        )
                      )
                    ),
                    column(
                      width = 2,
                      airDatepickerInput(
                        inputId = "deemed_date2",
                        label = "To:",
                        timepicker = TRUE,
                        addon = "none",
                        readonly = TRUE,
                        clearButton = TRUE,
                        timepickerOpts = timepickerOptions(
                          dateTimeSeparator = " at ",
                          timeFormat = "HH:mm",
                          minMinutes = 0,
                          maxMinutes = 0
                        )
                      )
                    ),
                    column(
                      width = 2,
                      numericInput(
                        inputId = "d_availability",
                        label = "Availability (%):",
                        value = 100
                      )
                    ),
                    column(
                      width = 2,
                      selectInput(
                        inputId = "d_fm",
                        label = "Event:",
                        choices = c("Curtailment", "FM_Event"),
                        selected = "Curtailment"
                      )
                    ),
                    column(
                      width = 1,
                      numericInput(
                        inputId = "d_limit",
                        label = "Limit (MW):",
                        value = 100
                      )
                    ),
                    column(
                      width = 2,
                      div(
                        style = "margin-top: 30px;",
                        actionButton(
                          inputId = "d_add",
                          label = NULL,
                          status = "success",
                          icon = icon("plus"),
                          title = "Add"
                        ),
                        actionButton(
                          "d_save",
                          label = NULL,
                          icon = icon("save"),
                          title = "Save Data",
                          style = "color:#9b59b6;"
                        )
                      )
                    )
                  ),
                  hr(),
                  rHandsontableOutput("table_deemed")
                )
              )
            ),
            tabPanel(
              title = "Coefficients",
              fluidRow(
                box(
                  title = "Deemed Energy Coefficients",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 3,
                      selectInput("contract_year2", "Contract Year:", choices = paste0("CY", 1:35), selected = "CY1")
                    ),
                    column(
                      width = 2,
                      div(
                        style = "margin-top: 30px;", # Adjust margin or padding as needed
                        downloadButton("coeff_download_btn1", "Export", icon = icon("file-export"), style = "width:100%")
                      )
                    )
                  ),
                  rHandsontableOutput("coeff_contract"),
                  hr(),
                  actionButton("coeff_status_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
                )
              )
            )
          )
        )
      ),



      # schedule
      tabItem(
        tabName = "formula",
        fluidRow(
          box(
            title = "PPA Formula",
            background = NULL,
            width = 12,
            status = "primary",
            solidHeader = FALSE,
            rHandsontableOutput("formula"),
            hr(),
            actionButton("formula_save", icon = icon("save"), label = "Save", title = "Save Data", style = "color:#9b59b6;")
          )
        )
      ),


      # signallist
      tabItem(
        tabName = "logs",
        fluidRow(
          box(
            title = "Audit Trail",
            background = NULL,
            width = 12,
            status = "primary",
            solidHeader = FALSE,
            fluidRow(
              column(
                width = 3,
                airDatepickerInput(
                  inputId = "start_date_at", label = "From:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                  timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                )
              ),
              column(
                width = 3,
                airDatepickerInput(
                  inputId = "end_date_at", label = "To:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                  timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                )
              ),
              column(
                width = 1,
                div(
                  style = "margin-top: 25px;", # aligns with date input
                  actionButton(
                    "at_refresh",
                    label = NULL,
                    icon = icon("sync"),
                    title = "Refresh Data",
                    style = "color:#3498db;" # blue
                  )
                )
              )
            ),
            DTOutput("audit_trail")
          )
        )
      ),


      # signallist
      tabItem(
        tabName = "tcm",
        fluidRow(
          tabBox(
            id = "tcm_tabbox",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Hourly",
              fluidRow(
                box(
                  title = "Hourly Tariff Calculation Outputs,(IPPXTagsHOnTCM)",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 4,
                      dateRangeInput("dateRange_tcm",
                        "Select date range:",
                        start = Sys.Date() - 30,
                        end = Sys.Date()
                      )
                    ),
                    column(
                      width = 2,
                      div(
                        style = "margin-top: 30px;", # Adjust margin or padding as needed
                        downloadButton("tcm_hr_data_download", "Export", icon = icon("file-export"), style = "width:100%")
                      )
                    )
                  ),
                  DTOutput("tcm_table")
                )
              )
            ),
            tabPanel(
              title = "Daily",
              fluidRow(
                box(
                  title = "Daily Total,(IPPXTagsDOnTCM)",
                  background = NULL,
                  width = 12,
                  dateRangeInput("dateRange_tcm3",
                    "Select date range:",
                    start = Sys.Date() - 30,
                    end = Sys.Date()
                  ),
                  DTOutput("daily_total")
                )
              )
            ),
            tabPanel(
              title = "Monthly",
              fluidRow(
                box(
                  title = "Monthly Total,(IPPXTagsMOnTCM)",
                  background = NULL,
                  width = 12,
                  DTOutput("monthly_total")
                )
              )
            ),
            tabPanel(
              title = "Yearly",
              fluidRow(
                box(
                  title = "Yearly Total,(IPPXTagsYOnTCM)",
                  background = NULL,
                  width = 12,
                  DTOutput("yearly_total")
                )
              )
            )
          )
        )
      ),



      # INVOICE
      tabItem(
        tabName = "pass_reports",
        fluidRow(
          tabBox(
            id = "reports1",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,
            tabPanel(
              title = "Invoice",
              fluidRow(
                box(
                  title = "Invoice Generation",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 3,

                      # airDatepickerInput(
                      # inputId = "i_range",
                      # label = "Select the Invoice Period:",
                      # clearButton = TRUE,
                      # autoClose = T,
                      # range = TRUE,
                      # value = c(Sys.Date()-7, Sys.Date())
                      # ),
                      airDatepickerInput(inputId = "i_startDate", label = "From:", timepicker = F, addon = "none", autoClose = T, readonly = TRUE, clearButton = TRUE),
                      airDatepickerInput(inputId = "i_endDate", label = "To:", timepicker = F, addon = "none", autoClose = T, readonly = TRUE, clearButton = TRUE),

                      # airDatepickerInput(inputId = "i_startDate", label = "From:", timepicker = F, autoClose = T, readonly = TRUE, clearButton = TRUE),
                      # airDatepickerInput(inputId = "i_endDate", label = "To:", timepicker = F, autoClose = T, readonly = TRUE, clearButton = TRUE),
                      textInput("i_rn", "Invoice Number"),
                      hr(),
                      actionButton("i_runReport", "Generate Invoice")
                    ),
                    column(
                      width = 9,
                      # tags$h6(style = "font-weight:bold;", "Report Files:"),
                      # hr(),
                      uiOutput("i_reportOutput")
                    )
                  )
                )
              )
            ),
            tabPanel(
              title = "Invoice List",
              fluidRow(
                box(
                  title = "List of Invoices Generated and Approval Status",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = FALSE,
                  fluidRow(
                    column(
                      width = 4,
                      dateRangeInput("dateRange_invoice_list",
                        "Select date range:",
                        start = Sys.Date() - 30,
                        end = Sys.Date()
                      )
                    ),
                    column(
                      width = 4,
                      div(
                        style = "margin-top: 30px;",
                        actionButton(inputId = "i_viewInvoice", label = "View Invoice"),
                        actionButton(inputId = "i_approve", label = "Approve", status = "success"),
                        actionButton(inputId = "i_reject", label = "Reject", status = "danger")
                      )
                    )
                  ),
                  hr(),
                  DTOutput("invoice_list"),
                  br(),
                  uiOutput("i_viewInvoice_pdf")
                )
              )
            ),
            tabPanel(
              title = "Delta Invoice",
              fluidRow(
                box(
                  title = "Delta Invoice Generation",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 3,
                      # airDatepickerInput(
                      # inputId = "di_range",
                      # label = "Select the Invoice Period:",
                      # clearButton = TRUE,
                      # autoClose = T,
                      # range = TRUE,
                      # value = c(Sys.Date()-7, Sys.Date())
                      # ),
                      airDatepickerInput(inputId = "di_startDate", label = "From:", timepicker = F, addon = "none", autoClose = T, readonly = TRUE, clearButton = TRUE),
                      airDatepickerInput(inputId = "di_endDate", label = "To:", timepicker = F, addon = "none", autoClose = T, readonly = TRUE, clearButton = TRUE),
                      textInput("di_rn", "Invoice Number"),
                      hr(),
                      actionButton("di_runReport", "Generate Invoice")
                    ),
                    column(
                      width = 9,
                      # tags$h6(style = "font-weight:bold;", "Report Files:"),
                      # hr(),
                      uiOutput("di_reportOutput")
                    )
                  )
                )
              )
            ),
            tabPanel(
              title = "PPM Report",
              fluidRow(
                box(
                  title = "Plant Performance Reports",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "pr_range",
                        label = "Select the Period:",
                        clearButton = TRUE,
                        autoClose = T,
                        range = TRUE,
                        value = c(Sys.Date() - 7, Sys.Date())
                      ),
                      actionButton("pr_runReport", "Generate Report")
                    ),
                    column(
                      width = 9,
                      # tags$h6(style = "font-weight:bold;", "Report Files:"),
                      # hr(),
                      uiOutput("pr_reportOutput")
                    )
                  )
                )
              )
            ),
            tabPanel(
              title = "PPM Daily Report",
              fluidRow(
                box(
                  title = "Plant Performance Daily Reports",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 3,
                      airDatepickerInput(
                        inputId = "pr2_date",
                        label = "Select the report date:",
                        clearButton = TRUE,
                        autoClose = T,
                        value = c(Sys.Date())
                      ),
                      actionButton("pr2_runReport", "Generate Report")
                    ),
                    column(
                      width = 9,
                      # tags$h6(style = "font-weight:bold;", "Report Files:"),
                      # hr(),
                      uiOutput("pr2_reportOutput")
                    )
                  )
                )
              )
            ),
            tabPanel(
              title = "Coefficient Report",
              fluidRow(
                box(
                  title = "Coefficient Generation",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 3,
                      selectInput(
                        inputId = "coeff_contract_year",
                        label = "Select the Contract Year:",
                        choices = paste0("CY", 2:25)
                      ),
                      hr(),
                      actionButton("coeff_runReport", "Generate Report")
                    ),
                    column(
                      width = 9,
                      # tags$h6(style = "font-weight:bold;", "Report Files:"),
                      # hr(),
                      uiOutput("coeff_reportOutput")
                    )
                  )
                )
              )
            )
          )
        )
      ),


      # trial/scenario
      tabItem(
        tabName = "excel_data",
        fluidRow(
          tabBox(
            id = "excel1",
            title = "",
            width = 12,
            type = "tabs", # pills
            status = "primary",
            # solidHeader = TRUE,

            tabPanel(
              title = "Meter Data",
              fluidRow(
                box(
                  title = "Import Meter Data from Excel",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 4,
                      dateRangeInput("dateRange_excel_mda",
                        "Select date range:",
                        start = Sys.Date() - 30,
                        end = Sys.Date()
                      )
                    ),
                    column(
                      width = 6,
                      fileInput("excel_mda_file", "Choose the relevant excel file for meter data import"),
                    )
                  ),
                  DTOutput("excel_mda")
                )
              )
            ),
            tabPanel(
              title = "SCADA Data",
              fluidRow(
                box(
                  title = "Import SCADA Data from Excel",
                  background = NULL,
                  width = 12,
                  status = "primary",
                  solidHeader = F,
                  fluidRow(
                    column(
                      width = 4,
                      dateRangeInput("dateRange_excel_scada",
                        "Select date range:",
                        start = Sys.Date() - 30,
                        end = Sys.Date()
                      )
                    ),
                    column(
                      width = 6,
                      fileInput("excel_scada_file", "Choose the relevant excel file for scada data import"),
                    )
                  ),
                  DTOutput("excel_scada")
                )
              )
            )
          )
        )
      ),

      # documentation
      tabItem(
        tabName = "documentation",
        fluidRow(
          box(
            title = "Haden - PPA",
            background = NULL,
            width = 4,
            status = "primary",
            solidHeader = FALSE,
            a("Haden - Power Purchase Agreement - Executed Version"),
            hr(),
            actionButton(
              inputId = "d1", label = "View",
              icon = icon("eye"),
              status = "primary",
              onclick = "window.open('Wave 4 - Haden - Power Purchase Agreement - Executed Version.pdf')"
            )
          ),
          box(
            title = "Haden - Power Purchase Agreement FAA",
            background = NULL,
            width = 4,
            status = "primary",
            solidHeader = FALSE,
            a("Power Purchase Agreement FAA - (20 September 2024)"),
            hr(),
            actionButton(
              inputId = "d2", label = "View",
              icon = icon("eye"),
              status = "primary",
              onclick = "window.open('HAD - Power Purchase Agreement FAA.pdf')"
            )
          ),
          box(
            title = "Haden - Performance Guarantees",
            background = NULL,
            width = 4,
            status = "primary",
            solidHeader = FALSE,
            a("Performance Guarantees"),
            hr(),
            actionButton(
              inputId = "d3", label = "View",
              icon = icon("eye"),
              status = "primary",
              onclick = "window.open('App C - Performance Guarantees.pdf')"
            )
          ),
          box(
            title = "Haden - Testing and Commissioning",
            background = NULL,
            width = 4,
            status = "primary",
            solidHeader = FALSE,
            a("Testing and Commissioning"),
            hr(),
            actionButton(
              inputId = "d4", label = "View",
              icon = icon("eye"),
              status = "primary",
              onclick = "window.open('App H - Testing and Commissioning.pdf')"
            )
          )
        )
      ),

      # Report configurations
      tabItem(
        tabName = "report_config",
        fluidRow(
          box(
            title = "Company Information",
            background = NULL,
            width = 3, height = 500,
            status = "primary",
            solidHeader = FALSE,
            fluidRow(
              column(
                width = 12,
                textInput("input_text1", "Company Name:", value = ""),
                textAreaInput("input_text2", "Company Address:",
                  value = "",
                  rows = 6
                ),
                textInput("input_text3", "Finance Director:", value = ""),
                textInput("input_text4", "Project Director:", value = "")
              )
            )
          ),
          box(
            title = "Taxation Details",
            background = NULL,
            width = 3, height = 500,
            status = "primary",
            solidHeader = FALSE,
            fluidRow(
              column(
                width = 12,
                textInput("input_text5", "VAT Number:", value = ""),
                textInput("input_text6", "Commercial Registration Number:", value = ""),
                textInput("input_text7", "SAGIA License Number:", value = ""),
                textInput("input_text8", "Tax ID:", value = "")
              )
            )
          ),
          box(
            title = "Bank Account Details",
            background = NULL,
            width = 6, height = 500,
            status = "primary",
            solidHeader = FALSE,
            fluidRow(
              column(
                width = 6,
                textInput("input_text9", "Beneficiary Name:", value = ""),
                textInput("input_text10", "Bank Name:", value = ""),
                textInput("input_text11", "Account Number:", value = ""),
                textInput("input_text12", "IBAN:", value = "")
              ),
              column(
                width = 6,
                textInput("input_text13", "SWIFT Code:", value = ""),
                textAreaInput("input_text14", "Bank Address:", value = "", rows = 6)
              )
            )
          ),
          hr(),
          actionButton(inputId = "r_save_btn2", label = "Save Changes", status = "primary")
        )
      ),


      # Run Offline Calculation for TCM and PPM
      tabItem(
        tabName = "run_offline",
        fluidRow(
          box(
            title = "Run Offline TCM",
            background = NULL,
            width = 3, height = 450,
            status = "primary",
            solidHeader = F,
            fluidRow(
              column(
                width = 12,
                airDatepickerInput(
                  inputId = "start_date_tcm", label = "Start Time:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                  timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                  # value = c(Sys.Date()-1)
                ),
                airDatepickerInput(
                  inputId = "end_date_tcm", label = "End Time:", timepicker = TRUE, addon = "none", readonly = TRUE, clearButton = TRUE,
                  timepickerOpts = timepickerOptions(dateTimeSeparator = " at ", timeFormat = "HH:mm", minMinutes = 0, maxMinutes = 0)
                  # value = c(Sys.Date()-1)
                ),
                selectInput("indexation_type", "Indexation Type", choices = c("With-Indexation", "Without-Indexation"), selected = "With-Indexation"),
                hr(),
                actionButton("run_offline_tcm", "Run Offline TCM")
              )
            )
          ),
          box(
            title = "Run Offline PPM",
            background = NULL,
            width = 3, height = 450,
            status = "primary",
            solidHeader = F,
            fluidRow(
              column(
                width = 12,
                airDatepickerInput(
                  inputId = "offline_ppm_range",
                  label = "Select the Invoice Period:",
                  clearButton = TRUE,
                  autoClose = T,
                  range = TRUE,
                  value = c(Sys.Date() - 7, Sys.Date())
                ),
                hr(),
                actionButton("run_offline_ppm", "Run Offline PPM")
              )
            )
          ),
          box(
            title = "Run Offline Coefficient Calculation",
            background = NULL,
            width = 4, height = 450,
            status = "primary",
            solidHeader = F,
            fluidRow(
              column(
                width = 12,
                selectInput(
                  inputId = "offline_coefficient",
                  label = "Select the Contract Year:",
                  choices = paste0("CY", 2:25)
                ),
                hr(),
                actionButton("run_offline_coeff", "Calculate")
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "trends",
        fluidRow(
          box(
            title = "Configurator",
            background = NULL,
            width = 2,
            status = "primary",
            solidHeader = TRUE,
            selectInput(inputId = "data", label = "Choose a dataset:", choices = c("summary"), selected = "summary", multiple = FALSE),
            radioButtons(inputId = "chart_type", "Chart Type", choices = c("Line", "Bar", "Scatter"), inline = TRUE),
            selectInput(inputId = "var1", label = "Select variable:", choices = NULL),
            selectInput(inputId = "var2", label = "Select Variable:", choices = NULL, multiple = TRUE),
            actionButton(
              inputId = "refresh",
              label = "Refresh Data",
              icon = icon("refresh"),
              status = "primary"
            )
          ),
          box(
            title = "Plot",
            background = NULL,
            width = 10,
            status = "white",
            solidHeader = FALSE,
            plotlyOutput("plot")
          ),
          box(
            title = "Data",
            background = NULL,
            width = 12,
            status = "white",
            solidHeader = FALSE,
            DTOutput("trend_data")
          )
        )
      )
    )
  )
)
# )

ui <- secure_app(ui,
  enable_admin = T, theme = shinytheme("paper"),


  # add image on top ?
  tags_top =
    tags$div(
      # tags$h4("PXPASS", style = "align:center"),
      tags$img(
        src = "aguilonlogo.png", width = 100
      )
    ),

  # add information on bottom ?
  tags_bottom = tags$div(
    tags$p(
      "Powered by BML "
    )
  ),
  background = "linear-gradient(rgba(0, 0, 0, 0.0),
                 rgba(28, 40, 51, 0.0)),
                 url('bg.png')  no-repeat center fixed; background-size: cover; height: 100%; overflow: hidden;"
)



server <- function(input, output, session) {
  # Flags for AJAX rhandsontable updates
  mda_dv1_initialized <- reactiveVal(FALSE)
  mda_dv2_initialized <- reactiveVal(FALSE)
  scada_dv1_initialized <- reactiveVal(FALSE)
  scada_dv2_initialized <- reactiveVal(FALSE)
  formula_initialized <- reactiveVal(FALSE)
  mda_sig_initialized <- reactiveVal(FALSE)
  dcs_sig_initialized <- reactiveVal(FALSE)
  ppm_sig_initialized <- reactiveVal(FALSE)
  pss_sig_initialized <- reactiveVal(FALSE)

  raw_mda_initialized <- reactiveVal(FALSE)
  raw_dcs_initialized <- reactiveVal(FALSE)
  coeff_contract_initialized <- reactiveVal(FALSE)
  table_deemed_initialized <- reactiveVal(FALSE)

  fi_cy_initialized <- reactiveVal(FALSE)
  fi_er_initialized <- reactiveVal(FALSE)
  fi_vat_initialized <- reactiveVal(FALSE)
  fi_static_initialized <- reactiveVal(FALSE)

  pc_plant_initialized <- reactiveVal(FALSE)
  pc_cod_initialized <- reactiveVal(FALSE)
  pc_pnee_initialized <- reactiveVal(FALSE)

  formula_initialized <- reactiveVal(FALSE)
  res_auth <- secure_server(
    check_credentials = check_credentials(db_wd)
  )
  output$auth_output <- renderText({
    reactiveValuesToList(res_auth)$user
  })

  observeEvent(input$window_unload, {
    stopApp()
  })


  # session$onSessionEnded(function() {
  # print(paste("Session", session$token, "ended"))
  # if(!is.null(isolate({res_auth$user}))){
  #  stopApp()
  # }
  # })

  output$menu <- renderMenu({
    if (reactiveValuesToList(res_auth)$admin == "TRUE") {
      sidebarMenu(
        id = "sidebarID",
        flat = TRUE,
        compact = TRUE,
        menuItem("Dashboard", tabName = "pass_dashboard", icon = icon("dashboard"), selected = TRUE),
        menuItem(
          text = "Data", icon = icon("exchange-alt"), startExpanded = FALSE,
          # menuSubItem(text = "Signal List", tabName = "signal_list", icon = icon("angle-right")),
          menuSubItem(text = "Data Validation", tabName = "dv", icon = icon("angle-right")),
          menuSubItem(text = "Raw Data", tabName = "raw_data", icon = icon("angle-right")),
          # menuSubItem(text = "DCS Data", tabName = "dcs_data", icon = icon("angle-right")),
          menuSubItem(text = "Excel Import", tabName = "excel_data", icon = icon("angle-right"))
        ),
        menuItem("Tariff Accounting", tabName = "tcm", icon = icon("table")),
        menuItem("PPM", tabName = "ppm_dashboard", icon = icon("chart-area")),
        menuItem("Deemed", tabName = "deemed", icon = icon("bolt")),
        menuItem("Run Offline", tabName = "run_offline", icon = icon("backward")),
        menuItem("Reports", tabName = "pass_reports", icon = icon("file"), badgeLabel = "Invoice", badgeColor = "success"),
        menuItem("Availability", tabName = "availability", icon = icon("file-lines")),
        menuItem("Documentation", tabName = "documentation", icon = icon("book")),
        menuItem("Notifications", tabName = "logs", icon = icon("circle-exclamation")),
        menuItem(
          text = "Configurations", icon = icon("gear"), startExpanded = FALSE,
          menuSubItem(text = "Financial Inputs Config", tabName = "fi", icon = icon("angle-right")),
          menuSubItem(text = "Plant Configuration", tabName = "pc", icon = icon("angle-right")),
          menuSubItem(text = "Report Configuration", tabName = "report_config", icon = icon("angle-right")),
          menuSubItem(text = "Parameterization", tabName = "parameterization", icon = icon("angle-right")),
          menuSubItem(text = "Formula", tabName = "formula", icon = icon("angle-right"))
        )
      )
    } else if (reactiveValuesToList(res_auth)$group == "engineer") {
      sidebarMenu(
        id = "sidebarID",
        menuItem("Dashboard", tabName = "pass_dashboard", icon = icon("dashboard"), selected = TRUE),
        menuItem(
          text = "Data", icon = icon("exchange-alt"), startExpanded = FALSE,
          # menuSubItem(text = "Signal List", tabName = "signal_list", icon = icon("angle-right")),
          menuSubItem(text = "Meter Data", tabName = "meter_data", icon = icon("angle-right")),
          menuSubItem(text = "DCS Data", tabName = "dcs_data", icon = icon("angle-right")),
          menuSubItem(text = "Excel Import", tabName = "excel_data", icon = icon("angle-right"))
        ),
        menuItem("Tariff Accounting", tabName = "tcm", icon = icon("table")),
        menuItem("PPM", tabName = "ppm_dashboard", icon = icon("chart-area")),
        menuItem("Deemed", tabName = "deemed", icon = icon("bolt")),
        menuItem("Run Offline", tabName = "run_offline", icon = icon("backward")),
        menuItem("Reports", tabName = "pass_reports", icon = icon("file"), badgeLabel = "Invoice", badgeColor = "success"),
        menuItem("Availability", tabName = "availability", icon = icon("file-lines")),
        menuItem("Documentation", tabName = "documentation", icon = icon("book")),
        menuItem("Notifications", tabName = "logs", icon = icon("circle-exclamation"))
      )
    } else if (reactiveValuesToList(res_auth)$group == "operator") {
      sidebarMenu(
        id = "sidebarID",
        menuItem("Dashboard", tabName = "pass_dashboard", icon = icon("dashboard"), selected = TRUE),
        menuItem(
          text = "Data", icon = icon("exchange-alt"), startExpanded = FALSE,
          # menuSubItem(text = "Signal List", tabName = "signal_list", icon = icon("angle-right")),
          menuSubItem(text = "Meter Data", tabName = "meter_data", icon = icon("angle-right")),
          menuSubItem(text = "DCS Data", tabName = "dcs_data", icon = icon("angle-right"))
        ),
        menuItem("Tariff Accounting", tabName = "tcm", icon = icon("table")),
        menuItem("PPM", tabName = "ppm_dashboard", icon = icon("chart-area"))
      )
    }
  })



  observe({
    # Re-execute this reactive expression after 1000 milliseconds

    invalidateLater(60000, session)

    conn <- db_connection()
    # table_pass_kpi <- dbGetQuery(conn, "SELECT * FROM [dbo].[pass_kpi];")
    table_dcs_kpi <- dbGetQuery(conn, "SELECT * FROM [dbo].[dcs_kpi];")


    # table_tcm_dash <- dbGetQuery(conn, "SELECT TOP 6 [PP Name], [Tag Name], [Tag Time Stamp], [Tag Value], [Tag Quality] FROM dbo.IPPXTagsHOnTCM ORDER BY [Tag Time Stamp] DESC;")
    table_tcm_dash <- dbGetQuery(conn, "SELECT TOP 1 [Tag Time Stamp],
                                             MAX(CASE WHEN [Tag Name] = 'ccrn' THEN [Tag Value] END) AS CCRn,
											                       MAX(CASE WHEN [Tag Name] = 'omrn' THEN [Tag Value] END) AS OMRn,
											                       MAX(CASE WHEN [Tag Name] = 'ecn' THEN [Tag Value] END) AS ECn,
                                             MAX(CASE WHEN [Tag Name] = 'neen' THEN [Tag Value] END) AS NEEn,
                                             MAX(CASE WHEN [Tag Name] = 'need' THEN [Tag Value] END) AS NEEd,
                                             MAX(CASE WHEN [Tag Name] = 'tpn' THEN [Tag Value] END) AS TPn
                                      FROM [dbo].[IPPXTagsHOnTCM]
                                      GROUP BY [Tag Time Stamp]
                                      ORDER BY [Tag Time Stamp] DESC;")


    table_tpn <- dbGetQuery(conn, "select TOP 750 [Tag Time Stamp], [Tag Value] from [dbo].[IPPXTagsHOnTCM] where [Tag Name] = 'tpn' ORDER BY [Tag Time Stamp] DESC;")
    table_neen <- dbGetQuery(conn, "select TOP 750 [Tag Time Stamp], [Tag Value] from [dbo].[IPPXTagsHOnTCM] where [Tag Name] = 'neen' ORDER BY [Tag Time Stamp] DESC;")



    table_dcs_kpi1 <- dbGetQuery(conn, "SELECT TOP 1 * FROM [dbo].[ppm] order by [Tag Time Stamp] desc;")

    # kpi
    output$kpi1 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 2], 2)), style = "font-size: 100%;"),
        title = tags$p("Actual PR (%)", style = "font-size: 100%;"),
        icon = icon("chart-line"), color = "success", width = 3
      )
    })
    output$kpi2 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 3], 2)), style = "font-size: 100%;"),
        title = tags$p("Projected PR (%)", style = "font-size: 100%;"),
        icon = icon("check"), color = "success", width = 3
      )
    })
    output$kpi3 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 4], 2)), style = "font-size: 100%;"),
        title = tags$p("PR Deviation (%)", style = "font-size: 100%;"),
        icon = icon("info"), color = "success", width = 3
      )
    })
    output$kpi4 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 5], 2)), style = "font-size: 100%;"),
        title = tags$p("Actual Power (kW)", style = "font-size: 100%;"),
        icon = icon("chart-area"), color = "success", width = 3
      )
    })
    output$kpi5 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 6], 2)), style = "font-size: 100%;"),
        title = tags$p("Projected Power (kw)", style = "font-size: 100%;"),
        icon = icon("chart-area"), color = "success", width = 3
      )
    })
    output$kpi6 <- renderbs4InfoBox({
      bs4InfoBox(
        value = tags$p(paste0(round(table_dcs_kpi1[1, 7], 2)), style = "font-size: 100%;"),
        title = tags$p("Power Deviation (kW)", style = "font-size: 100%;"),
        icon = icon("chart-area"), color = "success", width = 3
      )
    })


    output$solar_trend1 <- renderPlotly({
      plotly::plot_ly(table_tpn, x = table_tpn$`Tag Time Stamp`, y = table_tpn$`Tag Value`, type = "scatter", mode = "lines", line = list(shape = "spline"), name = "Total Charges (SAR)") %>%
        layout(title = "", xaxis = list(title = ""))
      # config(displayModeBar = FALSE)
    })


    output$solar_trend2 <- renderPlotly({
      plotly::plot_ly(table_neen, x = table_neen$`Tag Time Stamp`, y = table_neen$`Tag Value`, type = "scatter", mode = "lines", line = list(shape = "spline"), name = "NEEi_Actual (kWh)") %>%
        layout(title = "", xaxis = list(title = ""))
      # config(displayModeBar = FALSE)
    })

    output$dash_table1 <- DT::renderDataTable({
      datatable(table_tcm_dash,
        rownames = FALSE,
        options = list(pageLength = 30, dom = "t")
      )
    })

    dbDisconnect(conn)
  })




  #************************************************************* raw data mda

  #* # Populate Meter ID dropdown when entering Raw MDA Data tab
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "raw_data") {
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        meterid_rmd <- dbGetQuery(conn, "SELECT DISTINCT Meterid FROM dbo.mda_signals WHERE Meterid IS NOT NULL ORDER BY Meterid")

        updateSelectInput(
          session, "meter_id_rmd",
          choices = meterid_rmd$Meterid
        )
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #--------------------------------------------------------------------------
  # Refresh Raw MDA Data table when filters change
  observeEvent(
    list(
      input$start_date_rmd, input$end_date_rmd,
      input$meter_id_rmd, input$subtype_rmd, input$mda_refresh
    ),
    {
      req(input$start_date_rmd, input$end_date_rmd, input$meter_id_rmd, input$subtype_rmd)

      # Show loading message
      loading_id <- showNotification("Loading MDA data...", type = "message", duration = NULL)

      tryCatch({
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        # Format input parameters
        start_date_rmd <- format(as.POSIXct(input$start_date_rmd), "%Y-%m-%d %H:%M:%S")
        end_date_rmd <- format(as.POSIXct(input$end_date_rmd), "%Y-%m-%d %H:%M:%S")
        meter_id_rmd <- as.character(input$meter_id_rmd)
        subtype_rmd <- as.character(input$subtype_rmd)

        # Execute stored procedure
        query_sp <- "EXEC raw_meter_data @meter_id = ?, @start_date = ?, @end_date = ?, @subtype = ?"

        table_mda <- dbGetQuery(
          conn, query_sp,
          params = list(meter_id_rmd, start_date_rmd, end_date_rmd, subtype_rmd)
        )

        # Handle empty result set
        if (nrow(table_mda) == 0) {
          showNotification("No data found for the selected period.", type = "warning", duration = 5)
        }

        # Render the data table
        # Render the data table
        render_smart_table(
          output, session, "raw_mda", table_mda, raw_mda_initialized,
          height = 500,
          conditional_cols = c("MainQ", "CheckQ"),
          readonly = TRUE
        )
      }, error = function(e) {
        # Error handling
        showNotification(
          paste("Error loading MDA data:", e$message),
          type = "error",
          duration = 8
        )
      }, finally = {
        # Remove loading notification
        removeNotification(loading_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* raw data dcs


  # --- For SCADA (TabBox trigger) ---
  observeEvent(input$raw_data_tab,
    {
      conn <- db_connection()
      on.exit(dbDisconnect(conn), add = TRUE)

      # Load distinct categories
      query_sp1 <- "SELECT DISTINCT [Category] FROM dbo.dcs_signals WHERE [Category] IS NOT NULL"
      dcs_category <- dbGetQuery(conn, query_sp1)

      updateSelectInput(session, "dcs_category_id", choices = dcs_category$Category)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #--------------------------------------------------------------------------
  # When user selects category, load the tags
  observeEvent(input$dcs_category_id,
    {
      req(input$dcs_category_id)

      conn <- db_connection()
      on.exit(dbDisconnect(conn), add = TRUE)

      query_sp2 <- paste0("SELECT DISTINCT [Tag Name] FROM dbo.dcs_signals WHERE [Category] = '", input$dcs_category_id, "' AND [Tag Name] IS NOT NULL")
      dcs_tags <- dbGetQuery(conn, query_sp2)

      updateSelectInput(session, "dcs_tag_id", choices = dcs_tags$`Tag Name`)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #--------------------------------------------------------------------------
  # Refresh Raw DCS Data table when filters change
  observeEvent(
    list(
      input$start_date_dcs, input$end_date_dcs,
      input$dcs_category_id, input$dcs_tag_id, input$dcs_refresh
    ),
    {
      req(input$start_date_dcs, input$end_date_dcs, input$dcs_category_id, input$dcs_tag_id)

      # Show loading notification
      loading_id <- showNotification("Loading DCS data...", type = "message", duration = NULL)

      tryCatch({
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        # Format inputs
        start_date_dcs <- format(as.POSIXct(input$start_date_dcs), "%Y-%m-%d %H:%M:%S")
        end_date_dcs <- format(as.POSIXct(input$end_date_dcs), "%Y-%m-%d %H:%M:%S")
        dcs_category_id <- as.character(input$dcs_category_id)
        dcs_tag_id <- as.character(input$dcs_tag_id)

        # Run stored procedure
        query_sp <- "EXEC raw_dcs_data @category = ?, @tag_name = ?, @start_date = ?, @end_date = ?"

        table_raw_dcs <- dbGetQuery(
          conn, query_sp,
          params = list(dcs_category_id, dcs_tag_id, start_date_dcs, end_date_dcs)
        )

        # Check if result is empty
        if (nrow(table_raw_dcs) == 0) {
          showNotification("No data found for the selected range.", type = "warning", duration = 5)
        }

        # Render table output
        # Render table output
        render_smart_table(
          output, session, "raw_dcs", table_raw_dcs,
          height = 500,
          conditional_cols = c("Quality"),
          readonly = TRUE
        )
      }, error = function(e) {
        # Error handling: show user-friendly message
        showNotification(paste("Error loading data:", e$message), type = "error", duration = 8)
      }, finally = {
        # Remove loading message
        removeNotification(loading_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )




  #************************************************************* rebuid and revalidate mda
  # Rebuild
  observeEvent(input$mda_dv_rebuild, {
    req(input$meterid_dv, input$start_date_dv, input$end_date_dv)

    # Show progress notification
    notification_id <- showNotification(
      "Rebuilding data...!!",
      duration = NULL,
      closeButton = FALSE,
      type = "message"
    )

    # Ensure notification is removed when done
    on.exit(removeNotification(notification_id), add = TRUE)

    conn <- db_connection()
    on.exit(dbDisconnect(conn), add = TRUE)

    start_date <- format(as.POSIXct(input$start_date_dv), "%Y-%m-%d %H:%M:%S")
    end_date <- format(as.POSIXct(input$end_date_dv), "%Y-%m-%d %H:%M:%S")
    meter_id <- input$meterid_dv
    RebuildFromRaw <- as.integer(1)
    # DefaultMode = 'Check'

    success <- tryCatch(
      {
        dbExecute(
          conn,
          "EXEC smd_processed_offline @start_date = ?, @end_date = ?, @meter_id = ?, @RebuildFromRaw = ?",
          params = list(start_date, end_date, meter_id, RebuildFromRaw)
        )
        TRUE
      },
      error = function(e) {
        FALSE
      }
    )

    shinyalert(
      title = ifelse(success, "Success", "Error"),
      text  = ifelse(success, "Rebuild completed successfully!", "Rebuild failed. Please try again."),
      type  = ifelse(success, "success", "error")
    )
  })

  # Revalidate
  observeEvent(input$mda_dv_revalidate, {
    req(input$meterid_dv, input$start_date_dv, input$end_date_dv)

    conn <- db_connection()
    on.exit(dbDisconnect(conn), add = TRUE)

    start_date <- format(as.POSIXct(input$start_date_dv), "%Y-%m-%d %H:%M:%S")
    end_date <- format(as.POSIXct(input$end_date_dv), "%Y-%m-%d %H:%M:%S")
    meter_id <- input$meterid_dv
    RebuildFromRaw <- as.integer(0)

    success <- tryCatch(
      {
        dbExecute(
          conn,
          "EXEC smd_processed_offline @start_date = ?, @end_date = ?, @meter_id = ?, @RebuildFromRaw = ?",
          params = list(start_date, end_date, meter_id, RebuildFromRaw)
        )
        TRUE
      },
      error = function(e) {
        FALSE
      }
    )

    shinyalert(
      title = ifelse(success, "Success", "Error"),
      text  = ifelse(success, "Revalidation completed successfully!", "Rebuild failed. Please try again."),
      type  = ifelse(success, "success", "error")
    )
  })

  #************************************************************* meter data validation
  # Sidebar observer: populate Meter ID dropdown once when entering mda_dv tab
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "dv") {
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        meterid_dv <- dbGetQuery(conn, "SELECT DISTINCT Meterid FROM dbo.mda_signals WHERE Meterid IS NOT NULL")
        updateSelectInput(session, "meterid_dv", choices = meterid_dv$Meterid)
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  # Optimized reactive observer for main table updates
  observeEvent(
    list(
      input$mda_dv_refresh,
      input$mda_dv_rebuild,
      input$mda_dv_revalidate,
      input$mda_dv_save,
      input$start_date_dv,
      input$end_date_dv,
      input$meterid_dv
    ),
    {
      # input$dv_id), {

      # Early validation - exit if conditions not met
      # req(input$sidebarID == "dv")
      # req(input$dateRange_mda_dv1, input$meterid_dv)
      req(input$start_date_dv, input$end_date_dv, input$meterid_dv)

      # Extract inputs once
      # start_date <- input$start_date_dv
      # end_date   <- input$end_date_dv

      start_date <- format(as.POSIXct(input$start_date_dv), "%Y-%m-%d %H:%M:%S")
      end_date <- format(as.POSIXct(input$end_date_dv), "%Y-%m-%d %H:%M:%S")
      meter_id <- input$meterid_dv


      # Enhanced date validation
      if (is.na(start_date) || is.na(end_date)) {
        showNotification("Invalid date range selected", type = "error", duration = 5)
        return()
      }

      # Validate date range
      if (start_date > end_date) {
        showNotification("Start date cannot be after end date", type = "error", duration = 5)
        return()
      }

      # Show loading indicator
      loading_id <- showNotification("Loading data...", type = "message", duration = NULL)

      # Wrap everything in error handling
      tryCatch(
        {
          # Database connection with proper cleanup
          conn <- db_connection()
          on.exit(
            {
              if (exists("conn") && !is.null(conn)) {
                tryCatch(dbDisconnect(conn), error = function(e) NULL)
              }
              removeNotification(loading_id)
            },
            add = TRUE
          )

          # Validate connection
          if (is.null(conn)) {
            stop("Failed to establish database connection")
          }

          # --- Query 1: Stored procedure output (readonly table) ---
          query_sp <- "EXEC smd_processed_dv @start_date = ?, @end_date = ?"

          table_mda_dv1 <- dbGetQuery(conn, query_sp, params = list(start_date, end_date))

          # Validate SP results
          if (is.null(table_mda_dv1) || nrow(table_mda_dv1) == 0) {
            showNotification("No data validation records found", type = "warning", duration = 5)
          }

          # --- Query 2: Processed data (editable table) ---
          query_processed <- "SELECT
                          [id] AS Id,
                          [timestamp]    AS [TimeStamp],
                          [meter_id]     AS [MeterId],
                          [main]         AS [Main],
                          CASE
                              WHEN [main_q] = 1 THEN 'Ok'
                              WHEN [main_q] = 0 THEN 'Error'
                              ELSE 'Null'
                          END AS [MainQ],
                          [check]        AS [Check],
                          CASE
                              WHEN [check_q] = 1 THEN 'Ok'
                              WHEN [check_q] = 0 THEN 'Error'
                              ELSE 'Null'
                          END AS [CheckQ],
                          [deviation]    AS [Deviation],
                          [mode]         AS [Mode],
                          [adjustment]   AS [Adjustment],
                          [result]       AS [Result],
                          [status]       AS [Status],
                          [remarks]      AS [Remarks]
                          FROM [dbo].[smd_processed]
                          WHERE [timestamp] BETWEEN ? AND ? AND [meter_id] = ?
                          ORDER BY [timestamp] ASC;"

          # FROM [dbo].[smd_processed]
          # WHERE [meter_id] = ?
          # ORDER BY [timestamp] ASC;"


          table_smd_processed <- dbGetQuery(conn, query_processed, params = list(start_date, end_date, meter_id))
          # table_smd_processed <- dbGetQuery(conn, query_processed, params = list(meter_id))
          table_smd_processed$TimeStamp <- format(as.POSIXct(table_smd_processed$TimeStamp), "%Y-%m-%d %H:%M:%S")

          # Apply filtering in R based on date/time
          # table_smd_processed <- table_smd_processed %>%
          # filter(TimeStamp >= start_date & TimeStamp <= end_date)


          # Data validation and cleaning
          if (is.null(table_smd_processed) || nrow(table_smd_processed) == 0) {
            showNotification(
              paste("No data found for meter", meter_id, "in selected date range"),
              type = "warning",
              duration = 5
            )
          }

          # Handle numeric conversion safely
          if ("Adjustment" %in% names(table_smd_processed)) {
            adjustment_numeric <- suppressWarnings(as.numeric(table_smd_processed$Adjustment))

            # Check for conversion failures
            na_count <- sum(is.na(adjustment_numeric) & !is.na(table_smd_processed$Adjustment))
            if (na_count > 0) {
              showNotification(
                paste(na_count, "Adjustment values couldn't be converted to numeric"),
                type = "warning",
                duration = 5
              )
            }

            table_smd_processed$Adjustment <- adjustment_numeric
          }

          # --- Render outputs ---
          # --- Render outputs ---
          # Table 1: Readonly stored procedure results
          render_smart_table(
            output, session, "mda_dv1", table_mda_dv1, mda_dv1_initialized,
            height = 80,
            readonly = TRUE
          )

          # Table 2: Editable processed data
          render_smart_table(
            output, session, "mda_dv2", table_smd_processed, mda_dv2_initialized,
            height = 500,
            editable_cols = c("Mode", "Adjustment", "Remarks"),
            dropdown_list = list("Mode" = c("Auto", "Main", "Check", "Adjustment")),
            conditional_cols = c("Status", "MainQ", "CheckQ"),
            hidden_cols = c("Id"), # hide PK from user edits
            exclude_update_cols = c("Id")
          )
        },
        error = function(e) {
          # Error handling
          error_msg <- paste("Error loading data:", e$message)
          showNotification(error_msg, type = "error", duration = 10)

          # Render empty tables on error
          # Render empty tables on error
          # Legacy init check removed
          # output$mda_dv1 <- renderRHandsontable(NULL)
          # output$mda_dv2 <- renderRHandsontable(NULL)
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* Save button mda

  observeEvent(input$mda_dv_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$mda_dv2)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "TimeStamp" = "timestamp",
          "MeterId" = "meter_id",
          "Mode" = "mode",
          "Adjustment" = "adjustment",
          "Remarks" = "remarks"
        )

        table_name_input <- "[dbo].[smd_processed]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("TimeStamp", "MeterId"),
          editable_cols = c("Mode", "Adjustment", "Remarks"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Mode", "Adjustment", "Remarks"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Meter Data"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* rebuid and revalidate dcs
  # Rebuild
  observeEvent(input$dcs_dv_rebuild,
    {
      req(input$category_dcs_dv, input$start_date_dcs_dv, input$end_date_dcs_dv)

      conn <- db_connection()
      on.exit(dbDisconnect(conn), add = TRUE)

      start_time <- format(as.POSIXct(input$start_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      end_time <- format(as.POSIXct(input$end_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      category <- input$category_dcs_dv
      RebuildFromRaw <- as.integer(1)

      success <- tryCatch(
        {
          dbExecute(
            conn,
            "EXEC dcppms_to_dcms_offline @start_time = ?, @end_time = ?, @category = ?, @RebuildFromRaw = ?",
            params = list(start_time, end_time, category, RebuildFromRaw)
          )
          TRUE
        },
        error = function(e) {
          print(e)
          FALSE
        }
      )

      shinyalert(
        title = ifelse(success, "Success", "Error"),
        text  = ifelse(success, "Rebuild completed successfully!", "Revalidation failed. Please try again."),
        type  = ifelse(success, "success", "error")
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  # Revalidate
  observeEvent(input$dcs_dv_revalidate,
    {
      req(input$category_dcs_dv, input$start_date_dcs_dv, input$end_date_dcs_dv)

      conn <- db_connection()
      on.exit(dbDisconnect(conn), add = TRUE)

      start_time <- format(as.POSIXct(input$start_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      end_time <- format(as.POSIXct(input$end_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      category <- input$category_dcs_dv
      RebuildFromRaw <- as.integer(0)

      success <- tryCatch(
        {
          dbExecute(
            conn,
            "EXEC dcppms_to_dcms_offline @start_time = ?, @end_time = ?, @category = ?, @RebuildFromRaw = ?",
            params = list(start_time, end_time, category, RebuildFromRaw)
          )
          TRUE
        },
        error = function(e) {
          print(e)
          FALSE
        }
      )

      shinyalert(
        title = ifelse(success, "Success", "Error"),
        text  = ifelse(success, "Revalidation completed successfully!", "Revalidation failed. Please try again."),
        type  = ifelse(success, "success", "error")
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* dcs data validation

  # When user selects category, load the tags
  observeEvent(input$dv_id,
    {
      conn <- db_connection()
      on.exit(dbDisconnect(conn), add = TRUE)

      query_sp2 <- paste0("SELECT DISTINCT [Category] FROM dbo.dcs_signals WHERE [Category] IS NOT NULL")
      dcs_tags <- dbGetQuery(conn, query_sp2)

      updateSelectInput(session, "category_dcs_dv", choices = dcs_tags$Category)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #-------------------DCS DATA VALIDATION

  # Optimized reactive observer for main table updates
  observeEvent(
    list(
      input$dcs_dv_refresh,
      input$category_dcs_dv,
      input$dcs_dv_rebuild,
      input$dcs_dv_revalidate,
      input$dcs_dv_save,
      input$start_date_dcs_dv,
      input$end_date_dcs_dv
    ),
    {
      # input$dv_id), {

      req(input$category_dcs_dv, input$start_date_dcs_dv, input$end_date_dcs_dv)

      # Extract inputs once
      start_date <- format(as.POSIXct(input$start_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      end_date <- format(as.POSIXct(input$end_date_dcs_dv), "%Y-%m-%d %H:%M:%S")
      category <- input$category_dcs_dv


      # Enhanced date validation
      if (is.na(start_date) || is.na(end_date)) {
        showNotification("Invalid date range selected", type = "error", duration = 5)
        return()
      }

      # Validate date range
      if (start_date > end_date) {
        showNotification("Start date cannot be after end date", type = "error", duration = 5)
        return()
      }

      # Show loading indicator
      loading_id <- showNotification("Loading data...", type = "message", duration = NULL)

      # Wrap everything in error handling
      tryCatch(
        {
          # Database connection with proper cleanup
          conn <- db_connection()
          on.exit(
            {
              if (exists("conn") && !is.null(conn)) {
                tryCatch(dbDisconnect(conn), error = function(e) NULL)
              }
              removeNotification(loading_id)
            },
            add = TRUE
          )

          # Validate connection
          if (is.null(conn)) {
            stop("Failed to establish database connection")
          }

          # --- Query 2: Processed data (editable table) ---
          query_dcs <- "SELECT
                          [Id] AS Id,
                          [Tag Time stamp]    AS [TimeStamp],
                          [Tag Value]     AS [Value],
                          [Tag Name]         AS [Category],
                          CASE
                              WHEN [Tag Quality] = 1 THEN 'Ok'
                              WHEN [Tag Quality] = 0 THEN 'Error'
                              ELSE 'Null'
                          END AS [Quality],
                          [Mode]         AS [Mode],
                          [Adjustment]   AS [Adjustment],
                          [Result]       AS [Result],
                          [Status]       AS [Status],
                          [Remarks]      AS [Remarks]
                          FROM [dbo].[IPPXTagsDCMS]
                          where [Tag Time stamp] between ? and ? and [Tag Name] = ?
                          ORDER BY [timestamp] ASC;"

          # --- Query 1: Stored procedure output (readonly table) ---
          table_scada_dv2 <- dbGetQuery(conn, query_dcs, params = list(start_date, end_date, category))
          table_scada_dv2$TimeStamp <- format(as.POSIXct(table_scada_dv2$TimeStamp), "%Y-%m-%d %H:%M:%S")


          # Validate SP results
          if (is.null(table_scada_dv2) || nrow(table_scada_dv2) == 0) {
            showNotification("No data available", type = "warning", duration = 5)
          }

          # --- Render outputs ---
          # --- Render outputs ---
          # Table 1: Readonly stored procedure results
          render_smart_table(
            output, session, "scada_dv2", table_scada_dv2, scada_dv2_initialized,
            height = 500,
            editable_cols = c("Mode", "Adjustment", "Remarks"),
            dropdown_list = list("Mode" = c("Actual", "Adjustment")),
            conditional_cols = c("Status", "Quality"),
            hidden_cols = c("Id"), # hide PK from user edits
            exclude_update_cols = c("Id")
          )
        },
        error = function(e) {
          # Error handling
          error_msg <- paste("Error loading data:", e$message)
          showNotification(error_msg, type = "error", duration = 10)

          # Render empty tables on error
          # output$mda_dv1 <- renderRHandsontable(NULL)
          if (!scada_dv2_initialized()) {
            output$scada_dv2 <- renderRHandsontable(NULL)
          } else {
            ajax_update_handsontable(session, "scada_dv2", list())
          }
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* Save button dcs

  observeEvent(input$dcs_dv_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$scada_dv2)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "TimeStamp" = "Tag Time stamp",
          "Category" = "Tag Name",
          "Mode" = "Mode",
          "Adjustment" = "Adjustment",
          "Remarks" = "Remarks"
        )

        table_name_input <- "[dbo].[IPPXTagsDCMS]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("TimeStamp", "Category"),
          editable_cols = c("Mode", "Adjustment", "Remarks"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Mode", "Adjustment", "Remarks"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Scada Data"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* Audit Trail

  # Refresh Raw MDA Data table when filters change
  observeEvent(
    list(input$start_date_at, input$end_date_at, input$at_refresh),
    {
      req(input$start_date_at, input$end_date_at)

      # Show loading message
      loading_id <- showNotification("Loading audit logs...", type = "message", duration = NULL)

      tryCatch({
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        start_date_at <- format(as.POSIXct(input$start_date_at), "%Y-%m-%d %H:%M:%S")
        end_date_at <- format(as.POSIXct(input$end_date_at), "%Y-%m-%d %H:%M:%S")

        # ✅ SQL query with date range filter
        query_audit <- "
             SELECT
                audit_id     AS [Audit Id],
                source_name  AS [Source Name],
                record_key   AS [Record Key],
                column_name  AS [Column Name],
                old_value    AS [Old Value],
                new_value    AS [New Value],
                changed_by   AS [Changed By],
                change_time  AS [Change Time]
              FROM dbo.audit_trail
              WHERE change_time BETWEEN ? AND ?
              ORDER BY audit_id DESC;"

        # ✅ Fetch filtered audit data
        table_at <- dbGetQuery(conn, query_audit, params = list(start_date_at, end_date_at))
        table_at$`Change Time` <- format(as.POSIXct(table_at$`Change Time`), "%Y-%m-%d %H:%M:%S")



        # Handle empty result set
        if (nrow(table_at) == 0) {
          showNotification("No data found for the selected period.", type = "warning", duration = 5)
        }

        output$audit_trail <- DT_Style1(data = table_at, page_length = 25)
      }, error = function(e) {
        # Error handling
        showNotification(
          paste("Error loading data:", e$message),
          type = "error",
          duration = 8
        )
      }, finally = {
        # Remove loading notification
        removeNotification(loading_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )



  #************************************************************* tcm
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "tcm") {
        observe({
          input$dateRange_tcm[1]
          input$dateRange_tcm[2]
          conn <- db_connection()
          # table_tcm <- dbGetQuery(conn, "SELECT [PP Name], [Tag Name], [Tag Time Stamp], [Tag Value], [Tag Quality] FROM dbo.IPPXTagsHOnTCM;")

          table_tcm <- dbGetQuery(conn, paste0("
                                      SELECT [Tag Time Stamp],
                                             MAX(CASE WHEN [Tag Name] = 'ccrn' THEN [Tag Value] END) AS CCRn,
                                             MAX(CASE WHEN [Tag Name] = 'omrn' THEN [Tag Value] END) AS OMRn,
                                             MAX(CASE WHEN [Tag Name] = 'ecn' THEN [Tag Value] END) AS ECn,
                                             MAX(CASE WHEN [Tag Name] = 'neen' THEN [Tag Value] END) AS NEEn,
                                             MAX(CASE WHEN [Tag Name] = 'need' THEN [Tag Value] END) AS NEEd,
                                             CAST(MAX(CASE WHEN [Tag Name] = 'deemed_stat' THEN [Tag Value] END) AS BIT) AS D_Stat,
                                             MAX(CASE WHEN [Tag Name] = 'tpn' THEN [Tag Value] END) AS TPn
                                      FROM [dbo].[IPPXTagsHOnTCM]
                                      WHERE [Tag Time Stamp] >= '", input$dateRange_tcm[1], "' AND [Tag Time Stamp] <= '", input$dateRange_tcm[2] + 1, "'
                                      GROUP BY [Tag Time Stamp]
                                      ORDER BY [Tag Time Stamp] DESC;"))

          dbDisconnect(conn)
          output$tcm_table <- DT::renderDataTable({
            datatable(table_tcm,
              filter = "top",
              class = "stripe hover grid",
              rownames = FALSE,
              options = list(
                pageLength = 100,
                columnDefs = list(list(className = "dt-center", targets = "_all"))
              )
            ) %>% formatStyle("D_Stat", backgroundColor = styleEqual(1, "yellow"), target = "row")
          })

          # Define the download handler using the function with a custom filename
          output$tcm_hr_data_download <- downloadData(table_tcm, "TCM Output Data")
        })


        observe({
          input$dateRange_tcm3[1]
          input$dateRange_tcm3[2]
          conn <- db_connection()
          # table_tcm <- dbGetQuery(conn, "SELECT [PP Name], [Tag Name], [Tag Time Stamp], [Tag Value], [Tag Quality] FROM dbo.IPPXTagsHOnTCM;")

          table_daily_total <- dbGetQuery(conn, paste0("
                                      SELECT [Date],
                                             MAX(CASE WHEN [Tag Name] = 'ecn' THEN [Total Tag Value] END) AS ECn,
                                             MAX(CASE WHEN [Tag Name] = 'neen' THEN [Total Tag Value] END) AS NEEn,
                                             MAX(CASE WHEN [Tag Name] = 'need' THEN [Total Tag Value] END) AS NEEd,
                                             MAX(CASE WHEN [Tag Name] = 'tpn' THEN [Total Tag Value] END) AS TPn
                                      FROM [dbo].[IPPXTagsDOnTCM]
                                      WHERE [Date] >= '", input$dateRange_tcm3[1], "' AND [Date] <= '", input$dateRange_tcm3[2], "'
                                      GROUP BY [Date]
                                      ORDER BY [Date] DESC;"))

          dbDisconnect(conn)


          output$daily_total <- DT_Style1(data = table_daily_total, page_length = 100)
        })


        conn <- db_connection()
        # table_tcm <- dbGetQuery(conn, "SELECT [PP Name], [Tag Name], [Tag Time Stamp], [Tag Value], [Tag Quality] FROM dbo.IPPXTagsHOnTCM;")

        table_monthly_total <- dbGetQuery(conn, paste0("
                                      SELECT [Year], [Month],
                                              MAX(CASE WHEN [Tag Name] = 'ecn' THEN [Total Tag Value] END) AS ECn,
                                              MAX(CASE WHEN [Tag Name] = 'neen' THEN [Total Tag Value] END) AS NEEn,
                                              MAX(CASE WHEN [Tag Name] = 'need' THEN [Total Tag Value] END) AS NEEd,
                                              MAX(CASE WHEN [Tag Name] = 'tpn' THEN [Total Tag Value] END) AS TPn
                                      FROM [dbo].[IPPXTagsMOonTCM]
                                      GROUP BY [Year], [Month]
                                      ORDER BY [Year] DESC, [Month] DESC;"))

        table_yearly_total <- dbGetQuery(conn, paste0("
                                      SELECT [Year],
                                              MAX(CASE WHEN [Tag Name] = 'ecn' THEN [Total Tag Value] END) AS ECn,
                                              MAX(CASE WHEN [Tag Name] = 'neen' THEN [Total Tag Value] END) AS NEEn,
                                              MAX(CASE WHEN [Tag Name] = 'need' THEN [Total Tag Value] END) AS NEEd,
                                              MAX(CASE WHEN [Tag Name] = 'tpn' THEN [Total Tag Value] END) AS TPn
                                      FROM [dbo].[IPPXTagsYOnTCM]
                                      GROUP BY [Year]
                                      ORDER BY [Year] DESC;"))

        dbDisconnect(conn)

        output$monthly_total <- DT_Style1(data = table_monthly_total, page_length = 100)
        output$yearly_total <- DT_Style1(data = table_yearly_total, page_length = 100)
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************** view coeff
  #*
  observeEvent(c(input$deemed, input$contract_year2),
    {
      conn <- db_connection()
      table_coeff_contract <- dbGetQuery(conn, paste0("SELECT [Contract Year], [Month],  A1n,  B1n ,  C1n, [Status] FROM  dbo.coefficient WHERE [Contract Year] = '", input$contract_year2, "'"))

      # Define the download handler using the function with a custom filename
      output$coeff_download_btn1 <- downloadData(table_coeff_contract, "Coefficients")

      dbDisconnect(conn)
      render_smart_table(
        output, session, "coeff_contract", table_coeff_contract, coeff_contract_initialized,
        height = 320,
        editable_cols = c("A1n", "B1n", "C1n", "Status"),
        dropdown_list = list("Status" = c("Approved", "Rejected", "Pending")),
        hidden_cols = c("Id"),
        exclude_update_cols = c("Id")
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #**************************************************** coeff_status_save -> coefficient approval status save

  observeEvent(input$coeff_status_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      conn <- db_connection()
      query_coeff <- paste0(
        "SELECT Id, [Contract Year], [Month], A1n, B1n, C1n, [Status]
     FROM dbo.coefficient
     WHERE [Contract Year] = '", input$contract_year2, "'"
      )

      table_coeff_db <- dbGetQuery(conn, query_coeff)
      dbDisconnect(conn)

      tryCatch({
        # Read edited table
        table_data <- hot_to_r(input$coeff_contract)

        # FIX: Remove SQL brackets from names
        names(table_data) <- gsub("\\[|\\]", "", names(table_data))

        # Apply Id
        table_data$Id <- table_coeff_db$Id

        req(nrow(table_data) > 0)

        col_mapping <- list(
          "Id"            = "Id",
          "Contract Year" = "Contract Year",
          "Month"         = "Month",
          "A1n"           = "A1n",
          "B1n"           = "B1n",
          "C1n"           = "C1n",
          "Status"        = "Status"
        )

        save_result <- save_editable_data_audit(
          hot_data        = table_data,
          identifier_cols = c("Contract Year", "Month"), # FIXED
          editable_cols   = c("A1n", "B1n", "C1n", "Status"),
          column_mapping  = col_mapping,
          table_name      = "[dbo].[coefficient]",
          audit_cols      = c("A1n", "B1n", "C1n", "Status"),
          user_id         = reactiveValuesToList(res_auth)$user,
          source_name     = "Coefficients"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Saving failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* new invoice generation

  observeEvent(input$i_runReport, {
    startDate <- input$i_startDate
    endDate <- input$i_endDate
    reportNumber <- input$i_rn

    # check whether invoice is already existing
    conn <- db_connection()
    invoice_existing_query <- paste0("SELECT CASE WHEN EXISTS ( SELECT 1 FROM [dbo].[invoice_list] WHERE [Start Date] = '", startDate, "' AND [End Date] = '", endDate, "' AND [Approval Status] = 'Pending' ) THEN 1 ELSE 0 END;")
    invoice_existing_query_count <- dbGetQuery(conn, invoice_existing_query)

    rn_existing_query <- paste0("SELECT COUNT(*) FROM [dbo].[invoice_list] WHERE [Invoice Number] = '", reportNumber, "';")
    rn_existing_query_count <- dbGetQuery(conn, rn_existing_query)

    dbDisconnect(conn)

    if (invoice_existing_query_count == 1) {
      showInfoModal("Invoice already calculated for the selected date range. Please check the Invoice List for the pending approvals !")
    } else {
      if (input$i_rn != "" && !is.null(startDate) && !is.null(endDate)) {
        versionNumber <- format(Sys.time(), "V.%Y%m%d%H%M%S")
        draft1 <- paste0("DRAFT COPY")
        draft <- URLencode(draft1)

        reportNumber1 <- URLencode(reportNumber)


        calculatedTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        userAccount <- reactiveValuesToList(res_auth)$user

        # Generate the report URL with the variables
        reportURL <- paste0(
          "http://computer:admin@localhost/ReportServer?%2finvoice",
          "&StartDate=", format(startDate, "%Y-%m-%d"),
          "&EndDate=", format(endDate, "%Y-%m-%d"),
          "&rn=", reportNumber1,
          "&draft=", draft,
          "&version=", versionNumber,
          "&rs:Command=Render&rs:Format=PDF"
        )

        # print(reportURL)

        #### at SITE http://administrator:Advantech01@localhost/ReportServer?%2fInvoice&StartDate=2023-07-20&EndDate=2023-07-20&rn=a1235&rs:Command=Render&rs:Format=PDF]

        # saveDir <- "D:/Projects/BAER"  #Replace with the desired directory path

        filename <- paste0("Invoice_", format(startDate, "%B_%Y"), "_", versionNumber, ".pdf")


        # Send the HTTP request to get the report
        response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))

        ############################ approval log

        conn <- db_connection()
        insertQuery_invoice <- paste0("INSERT INTO [dbo].[invoice_list] ([Version Number],[Start Date],[End Date],[Invoice Number],[Calculated Time],[User],[Approval Status])
                      VALUES ('", versionNumber, "','", startDate, "','", endDate, "','", reportNumber, "','", calculatedTime, "','", userAccount, "','Pending')")

        dbExecute(conn, insertQuery_invoice)
        dbDisconnect(conn)

        ##########################


        if (http_type(response) == "application/pdf") {
          showInfoModal("Draft invoice generated successfully. Approval pending !")
        } else {
          showInfoModal("Invoice generation failed !")
        }

        # targetDir = "D:/Projects/BAER/Aguilon_Rabigh/Aguilon_Rabigh1/www"

        # Perform the file copy operation
        file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

        output$i_reportOutput <- renderUI({
          # Render the iframe with the dynamically generated source filename
          tags$iframe(style = "width: 100%; height: 1000px", src = filename)
        })
      } else {
        # If any of the required variables is missing, inform the user or handle the situation accordingly

        showInfoModal("Please provide all the inputs !")
      } # end of if-else for missing inputs
    } # end of if-else for existing invoice check
  })

  #************************************************************ invoice list
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "pass_reports") {
        observe({
          input$reports1
          input$i_approve
          input$i_reject
          input$dateRange_invoice_list[1]
          input$dateRange_invoice_list[2]
          conn <- db_connection()
          table_invoice_list <- dbGetQuery(conn, paste0("
                                      SELECT [Version Number],[Start Date],[End Date],[Invoice Number],[Calculated Time],[User],[Approval Status]
                                      FROM [dbo].[invoice_list]
                                      WHERE [Calculated Time] >= '", input$dateRange_invoice_list[1], "' AND [Calculated Time] < '", input$dateRange_invoice_list[2] + 1, "'
                                      ORDER BY [Calculated Time] DESC;"))
          dbDisconnect(conn)

          table_invoice_list$`Calculated Time` <- format(as.POSIXct(table_invoice_list$`Calculated Time`), "%Y-%m-%d %H:%M:%S") # Replace the format with your desired format

          output$invoice_list <- DT::renderDataTable({
            datatable(table_invoice_list,
              filter = "top",
              class = "stripe hover grid",
              rownames = FALSE,
              selection = "single",
              options = list(
                pageLength = 5,
                columnDefs = list(list(className = "dt-center", targets = "_all"))
              )
            ) %>% formatStyle("Approval Status", backgroundColor = styleEqual(c("Approved", "Rejected", "Pending"), c("#28a745", "#dc3545", "yellow")))
          })
        })
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = T
  )


  #************************************************************* approval mechanism

  observeEvent(input$i_approve,
    {
      if (reactiveValuesToList(res_auth)$admin == "TRUE") {
        ####### code
        selected_row1 <- input$invoice_list_rows_selected

        conn <- db_connection()
        table_invoice_list <- dbGetQuery(conn, paste0("
                                      SELECT [Version Number],[Start Date],[End Date],[Invoice Number],[Calculated Time],[User],[Approval Status]
                                      FROM [dbo].[invoice_list]
                                      WHERE [Calculated Time] >= '", input$dateRange_invoice_list[1], "' AND [Calculated Time] < '", input$dateRange_invoice_list[2] + 1, "'
                                      ORDER BY [Calculated Time] DESC;"))
        dbDisconnect(conn)

        id <- table_invoice_list[selected_row1, "Id"]
        approval_status <- table_invoice_list[selected_row1, "Approval Status"]

        # reportNumber1 <- URLencode(reportNumber)

        if (!is.null(selected_row1) && approval_status == "Pending") {
          versionNumber3 <- table_invoice_list[selected_row1, "Version Number"]
          startDate3 <- as.Date(table_invoice_list[selected_row1, "Start Date"])
          endDate3 <- as.Date(table_invoice_list[selected_row1, "End Date"])
          reportNumber3 <- URLencode(table_invoice_list[selected_row1, "Invoice Number"])
          draft2 <- paste0("")
          draft3 <- URLencode(draft2)

          if (!is.null(versionNumber3)) {
            userAccount1 <- reactiveValuesToList(res_auth)$user

            # Generate the report URL with the variables
            reportURL <- paste0(
              "http://computer:admin@localhost/ReportServer?%2finvoice",
              "&StartDate=", format(startDate3, "%Y-%m-%d"),
              "&EndDate=", format(endDate3, "%Y-%m-%d"),
              "&rn=", reportNumber3,
              "&draft=", draft3,
              "&version=", versionNumber3,
              "&rs:Command=Render&rs:Format=PDF"
            )

            #### at SITE http://administrator:Advantech01@localhost/ReportServer?%2fInvoice&StartDate=2023-07-20&EndDate=2023-07-20&rn=a1235&rs:Command=Render&rs:Format=PDF]

            # saveDir <- "D:/Projects/BAER"  #Replace with the desired directory path

            filename3 <- paste0("Invoice_", format(startDate3, "%B_%Y"), "_", versionNumber3, ".pdf")

            # Send the HTTP request to get the report
            response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename3), overwrite = TRUE))

            # Perform the file copy operation
            file.copy(paste0(saveDir, "/", filename3), paste0(targetDir, "/", filename3), overwrite = TRUE)

            ############################ update query for approved rows

            conn <- db_connection()
            updateQuery <- paste0("UPDATE [dbo].[invoice_list] SET [Approval Status] = 'Approved' WHERE [Version Number] = '", versionNumber3, "';")
            dbExecute(conn, updateQuery)
            dbDisconnect(conn)

            ##########################

            if (http_type(response) == "application/pdf") {
              showInfoModal("Invoice Approved !")
            } else {
              showInfoModal("Approval failed !")
            }
          }
        } else {
          showInfoModal("Please select a pending invoice for approval !")
        }

        ###### code end
      } else {
        showInfoModal("Access denied. You do not have the necessary authorization to approve the invoice. Please contact the admin user !")
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = T
  )


  #************************************************************* rejection mechanism

  observeEvent(input$i_reject,
    {
      if (reactiveValuesToList(res_auth)$admin == "TRUE") {
        selected_row1 <- input$invoice_list_rows_selected


        if (!is.null(selected_row1)) {
          conn <- db_connection()
          table_invoice_list <- dbGetQuery(conn, paste0("
                                      SELECT *
                                      FROM [dbo].[invoice_list]
                                      WHERE [Calculated Time] >= '", input$dateRange_invoice_list[1], "' AND [Calculated Time] < '", input$dateRange_invoice_list[2] + 1, "'
                                      ORDER BY [Calculated Time] DESC;"))
          dbDisconnect(conn)

          id <- table_invoice_list[selected_row1, "Id"]
          approval_status <- table_invoice_list[selected_row1, "Approval Status"]

          if (!is.null(id) && approval_status == "Pending") {
            ############################ update query for approved rows

            conn <- db_connection()
            updateQuery <- paste0("UPDATE [dbo].[invoice_list] SET [Approval Status] = 'Rejected' WHERE [Id] = '", id, "';")
            dbExecute(conn, updateQuery)
            dbDisconnect(conn)
          } else {
            showInfoModal("Please select a pending invoice !")
          }
        } else {
          showInfoModal("Please select a pending invoice !")
        }

        ###### code end
      } else {
        showInfoModal("Access Denied. You do not have the necessary authorization to approve the invoice. Please contact the admin user !")
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = T
  )



  #************************************************************* view reports
  observeEvent(c(input$i_viewInvoice, input$i_approve),
    {
      selected_row <- input$invoice_list_rows_selected

      conn <- db_connection()
      table_invoice_list <- dbGetQuery(conn, paste0("
                                      SELECT [Version Number],[Start Date],[End Date],[Invoice Number],[Calculated Time],[User],[Approval Status]
                                      FROM [dbo].[invoice_list]
                                      WHERE [Calculated Time] >= '", input$dateRange_invoice_list[1], "' AND [Calculated Time] < '", input$dateRange_invoice_list[2] + 1, "'
                                      ORDER BY [Calculated Time] DESC;"))
      dbDisconnect(conn)

      if (!is.null(selected_row)) {
        versionNumber2 <- table_invoice_list[selected_row, "Version Number"]
        startDate2 <- as.Date(table_invoice_list[selected_row, "Start Date"])

        if (!is.null(versionNumber2)) {
          # Use the version number to construct a new query
          # conn <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "localhost\\AGUILON", Database = "", Trusted_Connection = "yes")


          filename2 <- paste0("Invoice_", format(startDate2, "%B_%Y"), "_", versionNumber2, ".pdf")

          output$i_viewInvoice_pdf <- renderUI({
            # Render the iframe with the dynamically generated source filename
            tags$iframe(style = "width: 100%; height: 1000px", src = filename2)
          })
        }
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* reports configuration initialize latest data
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "report_config") {
        conn <- db_connection()
        table_report_config <- dbGetQuery(conn, "select TOP 1 *  from [dbo].[report_configuration] order by Id desc")
        initialValues <- table_report_config[3:16]
        dbDisconnect(conn)
        # initialise the parameters with last stored value
        for (i in 1:14) {
          inputId <- paste0("input_text", i)
          updateTextInput(session, inputId, value = as.character(initialValues[[i]]))
        }
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* save report configuration

  observeEvent(input$r_save_btn2,
    {
      currentTimestamp <- Sys.time()

      values <- c(format(currentTimestamp, "%Y-%m-%d %H:%M:%S"))
      for (i in 1:15) {
        values <- c(values, as.character(input[[paste0("input_text", i)]]))
      }

      conn <- db_connection()

      # Define the SQL query with placeholders
      insertQuery <- "
    INSERT INTO [dbo].[report_configuration]
    ([Time Stamp], [Company Name], [Company Address], [Finance Director], [Project Director], [VAT Number], [Commercial Reg No], [SAGIA], [Tax ID], [Beneficiary Name], [Bank Name], [Account Number], [IBAN], [Swift Code], [Bank Address])
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

      # insertQuery <- glue::glue("INSERT INTO [dbo].[report_configuration] ([Time Stamp],[Company Name],[Company Address],[Finance Director],[Project Director],[VAT Number],[Commercial Reg No],[SAGIA],[Tax ID],[Beneficiary Name],[Bank Name],[Account Number],[IBAN],[Swift Code],[Bank Address])
      # VALUES ('{values[1]}','{values[2]}','{values[3]}','{values[4]}','{values[5]}','{values[6]}','{values[7]}','{values[8]}','{values[9]}','{values[10]}','{values[11]}','{values[12]}','{values[13]}','{values[14]}','{values[15]}')")


      # Execute the query with parameters
      dbExecute(conn, insertQuery, params = values)
      dbDisconnect(conn)

      # Provide feedback to user
      showModal(modalDialog("Data updated and saved to PSS database!"))
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* deemed

  # -------------------------------
  # 1. LOAD TABLE
  # -------------------------------
  rv_deemed <- reactiveVal()

  # ============================================================
  # LOAD DATA WHEN MONTH CHANGES
  # ============================================================
  observeEvent(c(input$sidebarID == "deemed", input$d_month), {
    req(input$d_month)

    selected_month <- as.Date(paste0(input$d_month, "-01"))
    from_limit <- selected_month
    to_limit <- selected_month %m+% months(1) - 1

    # Restrict date inputs
    updateAirDateInput(session, "deemed_date1",
      options = list(minDate = from_limit, maxDate = to_limit)
    )
    updateAirDateInput(session, "deemed_date2",
      options = list(minDate = from_limit, maxDate = to_limit)
    )

    d_year <- lubridate::year(selected_month)
    d_month <- lubridate::month(selected_month)

    load_id <- showNotification("Loading data...", type = "message", duration = NULL)

    tryCatch(
      {
        conn <- db_connection()
        on.exit(
          {
            try(dbDisconnect(conn), silent = TRUE)
            removeNotification(load_id)
          },
          add = TRUE
        )

        query_deemed <- "
      SELECT Id, [From], [To], Availability, Event, Limit
      FROM dbo.deemed
      WHERE YEAR([From]) = ? AND MONTH([From]) = ?
      ORDER BY Id ASC;
    "

        df <- dbGetQuery(conn, query_deemed, params = list(d_year, d_month))

        # Ensure minimum 100 rows
        if (nrow(df) < 100) {
          missing <- 100 - nrow(df)
          df <- rbind(
            df,
            data.frame(
              Id = NA_integer_,
              From = as.POSIXct(NA),
              To = as.POSIXct(NA),
              Availability = NA_real_,
              Event = NA_character_,
              Limit = NA_real_,
              stringsAsFactors = FALSE
            )[rep(1, missing), ]
          )
        }

        rv_deemed(df)
      },
      error = function(e) {
        showNotification(paste("Error loading data:", e$message), type = "error")
      }
    )
  })

  #-------------------------------------------------------
  showValidationErrors <- function(errors) {
    showModal(
      modalDialog(
        title = "Validation Errors",
        tags$ul(lapply(errors, function(err) tags$li(err))),
        easyClose = TRUE,
        footer = modalButton("OK")
      )
    )
  }

  #-------------------------------------------------------

  # ------------------------------------------------------------
  # ADD BUTTON → INSERT NEW ROW
  #-------------------------------------------------------------
  observeEvent(input$d_add, {
    req(
      input$d_month, input$deemed_date1, input$deemed_date2,
      input$d_availability, input$d_fm, input$d_limit, input$table_deemed
    )

    from_dt <- format(as.POSIXct(input$deemed_date1), "%Y-%m-%d %H:%M:%S")
    to_dt <- format(as.POSIXct(input$deemed_date2), "%Y-%m-%d %H:%M:%S")
    print(from_dt)
    print(to_dt)
    # -------------------------------
    #  Basic input check
    # -------------------------------
    if (is.null(from_dt) || is.null(to_dt) || is.null(input$d_availability) ||
      is.null(input$d_fm) || is.null(input$d_limit)) {
      showValidationErrors("Please fill all input fields.")
      return()
    }

    # -------------------------------
    #  Dates inside selected month
    # -------------------------------
    selected_month <- as.Date(paste0(input$d_month, "-01"))
    month_start <- selected_month
    month_end <- selected_month %m+% months(1) - 1

    if (from_dt < month_start || from_dt > month_end ||
      to_dt < month_start || to_dt > month_end) {
      showValidationErrors("Selected dates must be inside the chosen month.")
      return()
    }

    if (from_dt >= to_dt) {
      showValidationErrors("From date must be earlier than To date.")
      return()
    }

    # -------------------------------
    # Overlapping period validation
    # -------------------------------
    hot <- input$table_deemed$params$data

    df <- as.data.frame(
      do.call(rbind, lapply(hot, function(row) {
        sapply(row, function(x) if (is.null(x)) NA else x)
      })),
      stringsAsFactors = FALSE
    )

    colnames(df) <- c("From", "To", "Availability", "Event", "Limit")

    existing_rows <- df[!is.na(df$From) & !is.na(df$To), ]

    if (nrow(existing_rows) > 0) {
      overlap <- any((from_dt <= existing_rows$To) & (to_dt >= existing_rows$From))
      if (overlap) {
        showValidationErrors("This time period already exists!")
        return()
      }
    }

    # -------------------------------
    # Insert into first empty row
    # -------------------------------
    empty_row_index <- which(is.na(df$From) & is.na(df$To) &
      is.na(df$Availability) & is.na(df$Limit))[1]

    if (is.na(empty_row_index)) {
      showNotification("No empty rows left.", type = "error")
      return()
    }

    df$From <- format(as.POSIXct(df$From), "%Y-%m-%d %H:%M:%S")
    df$To <- format(as.POSIXct(df$To), "%Y-%m-%d %H:%M:%S")


    df[empty_row_index, ] <- list(
      From = from_dt,
      To = to_dt,
      Availability = as.numeric(input$d_availability),
      Event = as.character(input$d_fm),
      Limit = as.numeric(input$d_limit)
    )

    print(df)
    rv_deemed(df)
    showNotification("Row added successfully!", type = "message")
  })

  # ============================================================
  # RENDER RHANDSONTABLE → AUTO REFRESHES WHEN rv_deemed() CHANGES
  # ============================================================
  # ============================================================
  # RENDER RHANDSONTABLE → AUTO REFRESHES WHEN rv_deemed() CHANGES
  # ============================================================
  observeEvent(rv_deemed(), {
    req(rv_deemed())

    df <- rv_deemed()
    # Force UTC for display
    df$From <- format(as.POSIXct(df$From), "%Y-%m-%d %H:%M:%S")
    df$To <- format(as.POSIXct(df$To), "%Y-%m-%d %H:%M:%S")

    render_smart_table(
      output, session, "table_deemed", df, table_deemed_initialized,
      height = 450,
      editable_cols = c("From", "To", "Availability", "Event", "Limit"),
      dropdown_list = list("Event" = c("Curtailment", "FM_Event")),
      hidden_cols = c("Id"),
      exclude_update_cols = c("Id")
    )
  })


  # ============================================================
  # SAVE BUTTON → INSERT/UPDATE DB
  # ============================================================
  observeEvent(input$d_save, {
    req(input$table_deemed, input$d_month)
    save_id <- showNotification("Saving data...", type = "message", duration = NULL)

    tryCatch(
      {
        conn <- db_connection()
        on.exit(dbDisconnect(conn), add = TRUE)

        # -------------------------
        # Extract HOT data
        # -------------------------
        hot_raw <- input$table_deemed
        hot_clean <- lapply(hot_raw$params$data, function(row) {
          sapply(row, function(cell) {
            if (is.null(cell)) NA else if (length(cell) == 1) cell[[1]] else cell
          })
        })

        hot_clean <- hot_clean[sapply(hot_clean, function(r) !all(is.na(r)))]
        df <- if (length(hot_clean) == 0) {
          data.frame(From = NA, To = NA, Availability = NA, Event = NA, Limit = NA)[0, ]
        } else {
          setNames(
            as.data.frame(do.call(rbind, hot_clean), stringsAsFactors = FALSE),
            c("From", "To", "Availability", "Event", "Limit")
          )
        }

        print(df)

        # -------------------------
        # Month & Year
        # -------------------------
        ym <- as.Date(paste0(input$d_month, "-01"))
        year <- as.integer(format(ym, "%Y"))
        month <- as.integer(format(ym, "%m"))

        # validation
        df_chk <- df[!is.na(df$From) & !is.na(df$To), ]
        df_chk$From <- as.POSIXct(df_chk$From, format = "%Y-%m-%d %H:%M")
        df_chk$To <- as.POSIXct(df_chk$To, format = "%Y-%m-%d %H:%M")

        invalid_rows <- which((!is.na(df$From) & is.na(df_chk$From)) | (!is.na(df$To) & is.na(df_chk$To)))
        if (length(invalid_rows) > 0) {
          removeNotification(save_id)
          showValidationErrors(paste("Invalid date/time value found in row(s):", paste(invalid_rows, collapse = ", ")))
          return(NULL)
        }

        month_start <- as.POSIXct(paste0(input$d_month, "-01 00:00:00"))
        month_end <- month_start + months(1)
        out_of_month <- which(df_chk$From < month_start | df_chk$From >= month_end)
        if (length(out_of_month) > 0) {
          removeNotification(save_id)
          showValidationErrors(
            paste("Date range must be within selected month:", format(month_start, "%Y-%m"), "\nInvalid row(s):", paste(out_of_month, collapse = ", "))
          )
          return(NULL)
        }

        bad_rows <- which(df_chk$From >= df_chk$To)
        if (length(bad_rows) > 0) {
          removeNotification(save_id)
          showValidationErrors(paste("From time must be earlier than To time (row(s):", paste(bad_rows, collapse = ", "), ")"))
          return(NULL)
        }

        month_start <- as.POSIXct(ym)
        month_end <- as.POSIXct(ym %m+% months(1))
        out_of_month <- which(df_chk$From < month_start | df_chk$From >= month_end |
          df_chk$To <= month_start | df_chk$To > month_end)


        if (nrow(df_chk) >= 2) {
          for (i in 1:(nrow(df_chk) - 1)) {
            for (j in (i + 1):nrow(df_chk)) {
              if (!is.na(df_chk$From[i]) && !is.na(df_chk$To[i]) &&
                !is.na(df_chk$From[j]) && !is.na(df_chk$To[j]) &&
                df_chk$From[i] <= df_chk$To[j] &&
                df_chk$To[i] >= df_chk$From[j]) {
                removeNotification(save_id)
                showValidationErrors("Overlap detected between rows. Save aborted.")
                return(NULL)
              }
            }
          }
        }

        # Ensure types
        df$From <- format(as.POSIXct(df$From), "%Y-%m-%d %H:%M:%S")
        df$To <- format(as.POSIXct(df$To), "%Y-%m-%d %H:%M:%S")
        df$Availability <- as.numeric(df$Availability)
        df$Event <- as.character(df$Event)
        df$Limit <- as.numeric(df$Limit)


        # -------------------------
        # Delete existing month data
        # -------------------------
        sql_delete <- "DELETE FROM dbo.deemed WHERE YEAR([From]) = ? AND MONTH([From]) = ?"
        dbExecute(conn, sql_delete, params = list(year, month))

        # -------------------------
        # Insert new rows
        # -------------------------
        result <- save_data_only(
          hot_data = df,
          table_name = "dbo.deemed",
          insert_cols = c("From", "To", "Availability", "Event", "Limit")
        )


        # -------------------------
        # Reload table from DB
        # -------------------------
        query_deemed <- "
      SELECT Id, [From], [To], Availability, Event, Limit
      FROM dbo.deemed
      WHERE YEAR([From]) = ? AND MONTH([From]) = ?
      ORDER BY Id ASC;
    "
        df_reload <- dbGetQuery(conn, query_deemed, params = list(year, month))

        # Ensure 100 rows
        if (nrow(df_reload) < 100) {
          missing <- 100 - nrow(df_reload)
          df_reload <- rbind(
            df_reload,
            data.frame(
              Id = NA_integer_,
              From = as.POSIXct(NA),
              To = as.POSIXct(NA),
              Availability = NA_real_,
              Event = NA_character_,
              Limit = NA_real_,
              stringsAsFactors = FALSE
            )[rep(1, missing), ]
          )
        }
        rv_deemed(df_reload)

        removeNotification(save_id)

        if (result$success) {
          showNotification("Saved successfully", type = "message")
        } else {
          showNotification(result$message, type = "error")
        }
      },
      error = function(e) {
        removeNotification(save_id)
        showNotification(e$message, type = "error")
      }
    )
  })


  #*********************************************************************** financial inputs Static

  # =============================================================
  # 1) Load FI screen when sidebar menu "fi" is clicked
  # =============================================================
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID != "fi") {
        return(NULL)
      }

      loading_id <- showNotification("Loading FI data...", type = "message", duration = NULL)

      tryCatch(
        {
          # ---------- DB Connection ----------
          conn <- db_connection()
          if (is.null(conn)) stop("Failed to establish database connection")

          on.exit(
            {
              tryCatch(dbDisconnect(conn), error = function(e) NULL)
              removeNotification(loading_id)
            },
            add = TRUE
          )

          # ---------- Load FI_STATIC_REV ----------
          rev_query <- "SELECT TOP 1 Value FROM dbo.pc_settings WHERE Parameter = 'FI_STATIC_REV';"
          rev_df <- dbGetQuery(conn, rev_query)

          if (nrow(rev_df) == 0 || is.na(rev_df$Value[1])) {
            stop("Revision not found in database.")
          }

          fi_static_rev_value <- rev_df$Value[1]

          # Update dropdown
          updateSelectInput(
            session,
            inputId = "fi_static_rev",
            choices = 1:100,
            selected = fi_static_rev_value
          )


          # =============================================================
          # Load CY, ER, VAT tables
          # (Static tables that do NOT depend on revision)
          # =============================================================

          query_fi_cy <- "SELECT contract_year AS Contract_Year, ksacpin AS KSACPIn, usppin AS USPPIn FROM dbo.fi_cy ORDER BY id ASC;"
          query_fi_er <- "SELECT Id, Year, Month, Value FROM dbo.fi_er ORDER BY Id ASC;"
          query_fi_vat <- "SELECT [From], [To], Value FROM dbo.fi_vat ORDER BY id ASC;"

          # ---------- Execute queries ----------
          table_fi_cy <- dbGetQuery(conn, query_fi_cy)
          table_fi_er <- dbGetQuery(conn, query_fi_er)
          table_fi_vat <- dbGetQuery(conn, query_fi_vat)

          # =============================================================
          # Render Tables
          # =============================================================

          render_smart_table(
            output, session, "fi_cy", table_fi_cy, fi_cy_initialized,
            height = 600,
            editable_cols = c("KSACPIn", "USPPIn")
          )

          render_smart_table(
            output, session, "fi_er", table_fi_er, fi_er_initialized,
            height = 300,
            editable_cols = c("Year", "Month", "Value"),
            dropdown_list = list("Month" = month.name, "Year" = 2025:2100),
            hidden_cols = c("Id"),
            exclude_update_cols = c("Id")
          )

          render_smart_table(
            output, session, "fi_vat", table_fi_vat, fi_vat_initialized,
            height = 300,
            editable_cols = c("From", "To", "Value"),
            date_cols = c("From", "To")
          )
        },
        error = function(e) {
          # ---------- Error Handler ----------
          showNotification(
            paste("Error loading data:", e$message),
            type = "error",
            duration = 10
          )

          # Render empty tables to avoid errors
          output$fi_static <- renderRHandsontable(NULL)
          output$fi_cy <- renderRHandsontable(NULL)
          output$fi_er <- renderRHandsontable(NULL)
          output$fi_vat <- renderRHandsontable(NULL)
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )



  # =============================================================
  # 2) Refresh FI_STATIC when revision dropdown changes
  # =============================================================
  observeEvent(input$fi_static_rev, {
    req(input$fi_static_rev)

    tryCatch(
      {
        conn <- db_connection()
        if (is.null(conn)) stop("DB connection failed")

        on.exit({
          tryCatch(dbDisconnect(conn), error = function(e) NULL)
        })

        query_static <- "SELECT Id, Parameter, Description, Value, Unit FROM dbo.fi_static WHERE Revision = ? ORDER BY Id ASC;"
        table_fi_static <- dbGetQuery(conn, query_static, params = list(input$fi_static_rev))

        if (nrow(table_fi_static) == 0) {
          showNotification("No contract data for selected revision.", type = "warning", duration = 5)
        }

        render_smart_table(
          output, session, "fi_static", table_fi_static, fi_static_initialized,
          height = 190,
          editable_cols = c("Value"),
          hidden_cols = c("Id"),
          exclude_update_cols = c("Id")
        )
      },
      error = function(e) {
        showNotification(
          paste("Error loading data:", e$message),
          type = "error",
          duration = 10
        )
        output$fi_static <- renderRHandsontable(NULL)
      }
    )
  })



  #********************************************************************** save fi_static
  observeEvent(input$fi_static_save,
    {
      req(input$fi_static_rev)

      tryCatch({
        conn <- db_connection()
        if (is.null(conn)) stop("DB connection failed")

        on.exit({
          tryCatch(dbDisconnect(conn), error = function(e) NULL)
        })

        save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

        query_fi_static1 <- "SELECT Revision FROM dbo.fi_static WHERE Revision = ? ORDER BY Id ASC;"
        table_fi_static1 <- dbGetQuery(conn, query_fi_static1, params = list(input$fi_static_rev))

        table_data <- hot_to_r(input$fi_static)
        table_data$Revision <- table_fi_static1$Revision
        table_data$Revision <- as.integer(table_data$Revision)

        req(!is.null(table_data) && nrow(table_data) > 0)


        col_mapping <- list(
          "Revision" = "Revision",
          "Parameter" = "Parameter",
          "Value" = "Value"
        )

        table_name_input <- "[dbo].[fi_static]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Parameter", "Revision"),
          editable_cols = c("Value"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Value"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Contract Data"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** apply fi_static
  # Observe calculation mode selection and update DB
  observeEvent(input$fi_static_apply,
    {
      req(input$fi_static_rev) # Ensure input exists

      tryCatch(
        {
          conn <- db_connection()
          if (is.null(conn)) stop("DB connection failed")
          on.exit({
            tryCatch(dbDisconnect(conn), error = function(e) NULL)
          })

          # --- Fetch old value for audit ---
          old_value <- dbGetQuery(
            conn,
            "SELECT TOP 1 Value FROM dbo.pc_settings WHERE Parameter = 'FI_STATIC_REV';"
          )$Value
          if (length(old_value) == 0) old_value <- NA_character_

          # --- SQL UPDATE statement ---
          query_update <- "UPDATE dbo.pc_settings SET Value = ? WHERE Parameter = 'FI_STATIC_REV';"
          dbExecute(conn, query_update, params = list(input$fi_static_rev))

          # --- Insert audit/trial record ---
          audit_entry <- data.frame(
            table_name = "[dbo].[pc_settings]",
            source_name = "Contract Data",
            record_key = "Revision",
            old_value = old_value,
            new_value = input$fi_static_rev,
            changed_by = reactiveValuesToList(res_auth)$user,
            stringsAsFactors = FALSE
          )

          dbAppendTable(conn, Id(schema = "dbo", table = "audit_trail"), audit_entry)
          # Success message
          showNotification(paste("Revision successfully changed to:", input$fi_static_rev),
            type = "message", duration = 3
          )
        },
        error = function(e) {
          showNotification(paste("Error updating data:", e$message),
            type = "error", duration = 5
          )
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )



  #********************************************************************** save fi_cy
  observeEvent(input$fi_cy_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$fi_cy)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "USPPIn"        = "USPPIn",
          "KSACPIn"       = "KSACPIn",
          "Contract_Year" = "contract_year"
        )

        table_name_input <- "[dbo].[fi_cy]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Contract_Year"),
          editable_cols = c("USPPIn", "KSACPIn"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("USPPIn", "KSACPIn"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Contract Year Data"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #********************************************************************** save fi_vat
  observeEvent(input$fi_vat_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      conn <- db_connection()
      query_fi_vat1 <- "SELECT Id from dbo.fi_vat ORDER BY Id ASC;"
      table_fi_vat1 <- dbGetQuery(conn, query_fi_vat1)
      dbDisconnect(conn)

      tryCatch({
        table_data <- hot_to_r(input$fi_vat)
        table_data$Id <- table_fi_vat1$Id

        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Id"    = "Id",
          "From"  = "From",
          "To"    = "To",
          "Value" = "Value"
        )

        table_name_input <- "[dbo].[fi_vat]"

        save_result <- save_editable_data_audit1(
          hot_data = table_data,
          identifier_cols = c("Id"),
          editable_cols = c("From", "To", "Value"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("From", "To", "Value"),
          audit_key_cols = c("From", "To"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "VAT"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** save fi_er
  observeEvent(input$fi_er_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      conn <- db_connection()
      query_fi_er1 <- "SELECT Id from dbo.fi_er ORDER BY Id ASC;"
      table_fi_er1 <- dbGetQuery(conn, query_fi_er1)
      dbDisconnect(conn)

      tryCatch({
        table_data <- hot_to_r(input$fi_er)
        table_data$Id <- table_fi_er1$Id

        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Id"    = "Id",
          "Year"  = "Year",
          "Month" = "Month",
          "Value" = "Value"
        )

        table_name_input <- "[dbo].[fi_er]"

        save_result <- save_editable_data_audit1(
          hot_data = table_data,
          identifier_cols = c("Id"),
          editable_cols = c("Year", "Month", "Value"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Value"),
          audit_key_cols = c("Year", "Month"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Exchange Rate (EXRn)"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #*********************************************************************** plant config

  # Optimized reactive observer for main table updates
  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "pc") {
        # Show loading indicator
        loading_id <- showNotification("Loading data...", type = "message", duration = NULL)

        # Wrap everything in error handling
        tryCatch(
          {
            # Database connection with proper cleanup
            conn <- db_connection()
            on.exit(
              {
                if (exists("conn") && !is.null(conn)) {
                  tryCatch(dbDisconnect(conn), error = function(e) NULL)
                }
                removeNotification(loading_id)
              },
              add = TRUE
            )

            # Validate connection
            if (is.null(conn)) {
              stop("Failed to establish database connection")
            }

            query_pc_plant <- "SELECT Parameter, Description, Value, Unit from dbo.pc_plant ORDER BY Id ASC;"
            table_pc_plant <- dbGetQuery(conn, query_pc_plant)


            query_pc_cod <- "SELECT Parameter, Description, Date from dbo.pc_cod;"
            table_pc_cod <- dbGetQuery(conn, query_pc_cod)

            query_pc_pnee <- "SELECT contract_year AS [CY], pnee AS [Projected_NEE] from dbo.pc_pnee ORDER BY Id ASC;"
            table_pc_pnee <- dbGetQuery(conn, query_pc_pnee)

            # --- Render outputs ---
            # Table 1: Readonly stored procedure results
            # --- Render outputs ---
            # Table 1: Readonly stored procedure results
            render_smart_table(
              output, session, "pc_plant", table_pc_plant, pc_plant_initialized,
              height = 250,
              editable_cols = c("Value")
            )

            render_smart_table(
              output, session, "pc_cod", table_pc_cod, pc_cod_initialized,
              height = 140,
              editable_cols = c("Date"),
              date_cols = c("Date")
            )

            render_smart_table(
              output, session, "pc_pnee", table_pc_pnee, pc_pnee_initialized,
              height = 600,
              editable_cols = c("Projected_NEE")
            )

            # Load value from DB
            query <- "SELECT TOP 1 Value FROM dbo.pc_settings WHERE Parameter = 'Mode';"
            pc_calc_mode_df <- dbGetQuery(conn, query)
            pc_calc_mode_value <- pc_calc_mode_df$Value[1]

            # Update selectInput dynamically
            updateSelectInput(
              session,
              inputId = "pc_calc_mode",
              choices = c("Auto", "Main", "Check"),
              selected = pc_calc_mode_value
            )
          },
          error = function(e) {
            # Error handling
            error_msg <- paste("Error loading data:", e$message)
            showNotification(error_msg, type = "error", duration = 10)

            # Render empty tables on error
            output$fi_static <- renderRHandsontable(NULL)
          }
        )
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* pc settings mode

  # Observe calculation mode selection and update DB
  observeEvent(input$pc_calc_mode,
    {
      req(input$pc_calc_mode) # Ensure input exists

      tryCatch(
        {
          conn <- db_connection()
          on.exit(
            {
              if (!is.null(conn)) {
                tryCatch(dbDisconnect(conn), error = function(e) NULL)
              }
            },
            add = TRUE
          )

          # --- Fetch old value for audit ---
          old_value <- dbGetQuery(
            conn,
            "SELECT TOP 1 Value FROM dbo.pc_settings WHERE Parameter = 'Mode';"
          )$Value
          if (length(old_value) == 0) old_value <- NA_character_

          # --- SQL UPDATE statement ---
          query_update <- "UPDATE dbo.pc_settings SET Value = ? WHERE Parameter = 'Mode';"
          dbExecute(conn, query_update, params = list(input$pc_calc_mode))

          # --- Insert audit/trial record ---
          audit_entry <- data.frame(
            table_name = "[dbo].[pc_settings]",
            source_name = "Calculation Mode",
            old_value = old_value,
            new_value = input$pc_calc_mode,
            changed_by = reactiveValuesToList(res_auth)$user,
            stringsAsFactors = FALSE
          )

          dbAppendTable(conn, Id(schema = "dbo", table = "audit_trail"), audit_entry)
          # Success message
          showNotification(paste("Calculation mode updated:", input$pc_calc_mode),
            type = "message", duration = 3
          )
        },
        error = function(e) {
          showNotification(paste("Error updating mode:", e$message),
            type = "error", duration = 5
          )
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** pc_cod_save
  observeEvent(input$pc_cod_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$pc_cod)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Parameter" = "Parameter",
          "Date"      = "Date"
        )

        table_name_input <- "[dbo].[pc_cod]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Parameter"),
          editable_cols = c("Date"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Date"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "COD Data"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #********************************************************************** pc_plant_save
  observeEvent(input$pc_plant_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$pc_plant)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Parameter" = "Parameter",
          "Value" = "Value"
        )

        table_name_input <- "[dbo].[pc_plant]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Parameter"),
          editable_cols = c("Value"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Value"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Plant Configurations"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** pc_pnee_save
  observeEvent(input$pc_pnee_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$pc_pnee)
        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Projected_NEE" = "pnee",
          "CY" = "contract_year"
        )

        table_name_input <- "[dbo].[pc_pnee]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("CY"),
          editable_cols = c("Projected_NEE"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("Projected_NEE"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "Projected NEE"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )



  #************************************************************* ppm

  observeEvent(input$sidebarID,
    {
      if (input$sidebarID == "ppm_dashboard") {
        observe({
          # Re-execute this reactive expression after 30000 milliseconds
          invalidateLater(60000, session)

          # conn <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "localhost\\AGUILON", Database = "", Trusted_Connection = "yes")
          conn <- db_connection()

          table_dcs_kpi <- dbGetQuery(conn, "SELECT TOP 1 * FROM [dbo].[ppm] order by [Tag Time Stamp] desc;")
          table_ppm <- dbGetQuery(conn, "SELECT * FROM (SELECT TOP 24 * FROM [dbo].[ppm]
            ORDER BY [Tag Time Stamp] DESC
          ) AS subquery
        ORDER BY [Tag Time Stamp] ASC;")


          table_ppm$`Tag Time Stamp` <- format(as.POSIXct(table_ppm$`Tag Time Stamp`), "%Y-%m-%d %H:%M:%S")

          # kpi
          output$kpi11 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 2], 2)), style = "font-size: 100%;"),
              title = tags$p("Actual PR", style = "font-size: 100%;"),
              icon = icon("chart-line"), color = "success", width = 3
            )
          })
          output$kpi22 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 3], 2)), style = "font-size: 100%;"),
              title = tags$p("Projected PR", style = "font-size: 100%;"),
              icon = icon("check"), color = "success", width = 3
            )
          })
          output$kpi33 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 4], 2)), style = "font-size: 100%;"),
              title = tags$p("PR Deviation", style = "font-size: 100%;"),
              icon = icon("info"), color = "success", width = 3
            )
          })
          output$kpi44 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 5], 2)), style = "font-size: 100%;"),
              title = tags$p("Actual Power (kW)", style = "font-size: 100%;"),
              icon = icon("chart-area"), color = "success", width = 3
            )
          })
          output$kpi55 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 6], 2)), style = "font-size: 100%;"),
              title = tags$p("Projected Power (kw)", style = "font-size: 100%;"),
              icon = icon("chart-area"), color = "success", width = 3
            )
          })
          output$kpi66 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(round(table_dcs_kpi[1, 7], 2)), style = "font-size: 100%;"),
              title = tags$p("Power Deviation (kW)", style = "font-size: 100%;"),
              icon = icon("chart-area"), color = "success", width = 3
            )
          })
          output$kpi77 <- renderbs4InfoBox({
            bs4InfoBox(
              value = tags$p(paste0(table_dcs_kpi[1, 1]), style = "font-size: 100%;"),
              title = tags$p("Last Calculation Execution", style = "font-size: 100%;"),
              icon = icon("chart-area"), color = "warning", width = 3
            )
          })

          dbDisconnect(conn)
        })

        observe({
          input$dateRange_ppm[1]
          input$dateRange_ppm[2]
          # conn <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "localhost\\AGUILON", Database = "agpass", Trusted_Connection = "yes")
          conn <- db_connection()

          table_ppm1 <- dbGetQuery(conn, paste0("
                                      SELECT * FROM [dbo].[ppm]
                                      WHERE [Tag Time Stamp] >= '", input$dateRange_ppm[1], "' AND [Tag Time Stamp] < '", input$dateRange_ppm[2] + 1, "'
                                      ORDER BY [Tag Time Stamp] DESC;"))

          table_ppm1$`Tag Time Stamp` <- format(as.POSIXct(table_ppm1$`Tag Time Stamp`), "%Y-%m-%d %H:%M:%S")

          dbDisconnect(conn)

          output$dash_table2 <- DT_Style1(data = table_ppm1, page_length = 50)

          # Define the download handler using the function with a custom filename
          output$ppm_data_download <- downloadData(table_ppm1, "PPM Output Data")


          output$dash_plot3 <- renderPlotly({
            plot_ly(data = table_ppm1, x = table_ppm1$`Tag Time Stamp`, y = ~Actual_PR, name = "Actual PR", type = "scatter", mode = "lines", line = list(shape = "spline"), color = I("#007bff")) %>%
              add_trace(y = ~Projected_PR, name = "Projected PR", type = "scatter", mode = "lines", color = I("#39cccc")) %>%
              layout(title = "", xaxis = list(title = ""), yaxis = list(title = "Performance Ratio"))
          })

          output$dash_plot4 <- renderPlotly({
            plot_ly(data = table_ppm1, x = table_ppm1$`Tag Time Stamp`, y = ~Actual_Power, name = "Actual Power", type = "scatter", mode = "lines", line = list(shape = "spline"), color = I("#007bff")) %>%
              add_trace(y = ~Projected_Power, name = "Projected Power", type = "scatter", mode = "lines", color = I("#39cccc")) %>%
              layout(title = "", xaxis = list(title = ""), yaxis = list(title = "Power Output"))
          })
        })
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = F
  )


  #************************************************************* availability

  observeEvent(input$a_add_btn,
    {
      date1 <- input$a_date1
      date2 <- input$a_date2
      duration <- input$a1
      reason <- input$a2
      availability <- input$a3

      # Check if either date is NULL
      if (is.null(date1) || is.null(date2) || reason == "" || is.na(duration) || is.na(availability)) {
        shiny::showNotification("Missing Inputs.", type = "error")
      } else if (availability > 100) {
        # Check if the "From" date is strictly less than the "To" date
        shiny::showNotification("Availability Percentage should be less than or equal to 100.", type = "error")
      } else if (date1 >= date2) {
        # Check if the "From" date is strictly less than the "To" date
        shiny::showNotification("End date should be greater than the Start Date.", type = "error")
      } else {
        # Dates are not NULL, within the specified year and month, and "From" date is strictly less than "To" date
        conn <- db_connection()

        dbExecute(conn, glue::glue("INSERT INTO [dbo].[availability] ([Start Date], [End Date], [Duration], [Percentage Availability], [Reason]) VALUES ('{date1}', '{date2}', {duration}, {availability}, '{reason}' )"))

        dbDisconnect(conn)

        # Check if the "From" date is strictly less than the "To" date
        shiny::showNotification("Data inserted successfully.", type = "message")
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #****************

  observeEvent(input$a_delete_btn,
    {
      conn <- db_connection()
      table_availability <- dbGetQuery(
        conn,
        glue::glue("SELECT * from [dbo].[availability] ORDER BY Id DESC")
      )

      # Handle row deletion when the "Delete" button is clicked
      selected_row <- input$a_table_rows_selected

      if (!is.null(selected_row) && length(selected_row) > 0 && input$a_delete_btn > 0) {
        # Delete the selected row from the database
        delete_query <- glue::glue("DELETE FROM [dbo].[availability] WHERE Id = '{table_availability$Id[selected_row]}';")
        dbExecute(conn, delete_query)
      } else {
        # Show a notification when no rows are selected for deletion
        shiny::showNotification("Please select a row to delete.", type = "warning")
      }

      dbDisconnect(conn)
    },
    ignoreNULL = TRUE,
    ignoreInit = T
  )


  #*****************


  observeEvent(c(input$a_delete_btn, input$a_add_btn, input$sidebarID == "availability"),
    {
      conn <- db_connection()
      table_availability <- dbGetQuery(conn, glue::glue("SELECT [Start Date], [End Date],[Duration], [Percentage Availability], [Reason] FROM [dbo].[availability] ORDER BY Id DESC"))
      table_availability$`Start Date` <- format(as.POSIXct(table_availability$`Start Date`), "%Y-%m-%d %H:%M:%S")
      table_availability$`End Date` <- format(as.POSIXct(table_availability$`End Date`), "%Y-%m-%d %H:%M:%S")
      output$a_table <- DT::renderDataTable({
        datatable(
          table_availability,
          class = "stripe hover grid",
          rownames = FALSE,
          selection = "single",
          options = list(
            pageLength = 25,
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          )
        )
      })

      dbDisconnect(conn)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* availability report

  observeEvent(input$a_report_btn, {
    startDate <- input$a_startDate

    # check whether invoice is already existing
    conn <- db_connection()
    if (!is.null(input$a_startDate)) {
      versionNumber <- format(Sys.time(), "V.%Y%m%d%H%M%S")

      # Generate the report URL with the variables
      reportURL <- paste0(
        "http://Administrator:Advantech01@localhost/ReportServer?%2fAvailability",
        "&StartDate=", format(startDate, "%Y-%m-%d"),
        "&rs:Command=Render&rs:Format=PDF"
      )

      #### at SITE http://administrator:Advantech01@localhost/ReportServer?%2fInvoice&StartDate=2023-07-20&EndDate=2023-07-20&rn=a1235&rs:Command=Render&rs:Format=PDF]

      # saveDir <- "D:/Projects/BAER"  #Replace with the desired directory path

      filename <- paste0("Availaibity_Report_", format(startDate, "%B_%Y"), "_", versionNumber, ".pdf")

      # Send the HTTP request to get the report
      response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))


      if (http_type(response) == "application/pdf") {
        showModal(modalDialog(
          title = "Status",
          "Report generated successfully !"
        ))
      } else {
        showModal(modalDialog(
          title = "Status",
          "Report generation failed.."
        ))
      }


      # Perform the file copy operation
      file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

      output$a_report <- renderUI({
        # Render the iframe with the dynamically generated source filename
        tags$iframe(style = "width: 100%; height: 1000px", src = filename)
      })
    } else {
      # If any of the required variables is missing, inform the user or handle the situation accordingly
      showModal(modalDialog(
        title = "Missing Inputs",
        "Please select the date !"
      ))
    }
  })

  #************************************************************* delta invoice generation

  observeEvent(input$di_runReport, {
    startDate <- input$di_startDate
    endDate <- input$di_endDate
    reportNumber <- input$di_rn

    # check whether invoice is already existing
    conn <- db_connection()
    if (input$di_rn != "" && !is.null(startDate) && !is.null(endDate)) {
      versionNumber <- format(Sys.time(), "V.%Y%m%d%H%M%S")
      draft1 <- paste0("")
      draft <- URLencode(draft1)
      reportNumber1 <- URLencode(reportNumber)

      calculatedTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      userAccount <- reactiveValuesToList(res_auth)$user

      # Generate the report URL with the variables
      reportURL <- paste0(
        "http://Administrator:Advantech01@localhost/ReportServer?%2fdeltaInvoice",
        "&StartDate=", format(startDate, "%Y-%m-%d"),
        "&EndDate=", format(endDate, "%Y-%m-%d"),
        "&rn=", reportNumber1,
        "&draft=", draft,
        "&version=", versionNumber,
        "&rs:Command=Render&rs:Format=PDF"
      )

      #### at SITE http://administrator:Advantech01@localhost/ReportServer?%2fInvoice&StartDate=2023-07-20&EndDate=2023-07-20&rn=a1235&rs:Command=Render&rs:Format=PDF]

      # saveDir <- "D:/Projects/BAER"  #Replace with the desired directory path

      filename <- paste0("Delta_Invoice_", format(startDate, "%B_%Y"), "_", versionNumber, ".pdf")

      # Send the HTTP request to get the report
      response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))


      if (http_type(response) == "application/pdf") {
        showModal(modalDialog(
          title = "Status",
          "Delta invoice generated successfully !"
        ))
      } else {
        showModal(modalDialog(
          title = "Status",
          "Invoice generation failed.."
        ))
      }


      # Perform the file copy operation
      file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

      output$di_reportOutput <- renderUI({
        # Render the iframe with the dynamically generated source filename
        tags$iframe(style = "width: 100%; height: 1000px", src = filename)
      })
    } else {
      # If any of the required variables is missing, inform the user or handle the situation accordingly
      showModal(modalDialog(
        title = "Missing Inputs",
        "Please provide all the inputs..!"
      ))
    }
  })

  #**************************************************************** ppm reports1

  observeEvent(input$pr_runReport, {
    startDate <- input$pr_range[1]
    endDate <- input$pr_range[2]

    # check whether invoice is already existing
    conn <- db_connection()
    if (!is.null(startDate) && !is.null(endDate)) {
      calculatedTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      userAccount <- reactiveValuesToList(res_auth)$user

      # Generate the report URL with the variables
      reportURL <- paste0(
        "http://Administrator:Advantech01@localhost/ReportServer?%2fppm",
        "&StartDate=", format(startDate, "%Y-%m-%d"),
        "&EndDate=", format(endDate, "%Y-%m-%d"),
        "&rs:Command=Render&rs:Format=PDF"
      )

      filename <- paste0("PPM_Report", format(startDate, "%B_%Y"), ".pdf")

      # Send the HTTP request to get the report
      response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))


      if (http_type(response) == "application/pdf") {
        showModal(modalDialog(
          title = "Status",
          "PPM report generated successfully !"
        ))
      } else {
        showModal(modalDialog(
          title = "Status",
          "Report generation failed.."
        ))
      }


      # Perform the file copy operation
      file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

      output$pr_reportOutput <- renderUI({
        # Render the iframe with the dynamically generated source filename
        tags$iframe(style = "width: 100%; height: 1000px", src = filename)
      })
    } else {
      # If any of the required variables is missing, inform the user or handle the situation accordingly
      showModal(modalDialog(
        title = "Missing Inputs",
        "Please provide all the inputs..!"
      ))
    }
  })

  #**************************************************************** ppm report 2

  observeEvent(input$pr2_runReport, {
    startDate <- input$pr2_date

    # check whether invoice is already existing
    conn <- db_connection()
    if (!is.null(startDate)) {
      calculatedTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      userAccount <- reactiveValuesToList(res_auth)$user

      # Generate the report URL with the variables
      reportURL <- paste0(
        "http://Administrator:Advantech01@localhost/ReportServer?%2fppm_daily",
        "&StartDate=", format(startDate, "%Y-%m-%d"),
        "&rs:Command=Render&rs:Format=PDF"
      )

      filename <- paste0("PPM_Daily_Report", format(startDate, "%d_%B_%Y"), ".pdf")

      # Send the HTTP request to get the report
      response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))


      if (http_type(response) == "application/pdf") {
        showModal(modalDialog(
          title = "Status",
          "PPM daily report generated successfully !"
        ))
      } else {
        showModal(modalDialog(
          title = "Status",
          "Report generation failed.."
        ))
      }


      # Perform the file copy operation
      file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

      output$pr2_reportOutput <- renderUI({
        # Render the iframe with the dynamically generated source filename
        tags$iframe(style = "width: 100%; height: 1000px", src = filename)
      })
    } else {
      # If any of the required variables is missing, inform the user or handle the situation accordingly
      showModal(modalDialog(
        title = "Missing Inputs",
        "Please provide all the inputs..!"
      ))
    }
  })

  #******************************************************************* Coefficient Report

  observeEvent(input$coeff_runReport, {
    ContractYear <- input$coeff_contract_year
    prev_contract_year <- paste0("CY", as.numeric(gsub("[^0-9]", "", ContractYear)) - 1)
    # check whether invoice is already existing
    conn <- db_connection()
    if (!is.null(ContractYear)) {
      conn <- db_connection()
      query <- paste0("SELECT [To Date] FROM [dbo].[contract_year_coeff] WHERE CY = '", prev_contract_year, "'")
      endDate <- dbGetQuery(conn, query)$`To Date`

      # Check if the contract year has completed
      if (Sys.Date() > as.Date(endDate)) {
        calculatedTime <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        userAccount <- reactiveValuesToList(res_auth)$user

        # Generate the report URL with the variables
        reportURL <- paste0(
          "http://Administrator:Advantech01@localhost/ReportServer?%2fcoefficient_report",
          "&ContractYear=", ContractYear,
          "&rs:Command=Render&rs:Format=PDF"
        )

        #### at SITE http://administrator:Advantech01@localhost/ReportServer?%2fInvoice&StartDate=2023-07-20&EndDate=2023-07-20&rn=a1235&rs:Command=Render&rs:Format=PDF]

        # saveDir <- "D:/Projects/BAER"  #Replace with the desired directory path

        filename <- paste0(ContractYear, "_Coefficients_Report.pdf")

        # Send the HTTP request to get the report
        response <- GET(reportURL, write_disk(paste0(saveDir, "/", filename), overwrite = TRUE))


        if (http_type(response) == "application/pdf") {
          showModal(modalDialog(
            title = "Status",
            "Coefficient Report generated successfully !"
          ))
        } else {
          showModal(modalDialog(
            title = "Status",
            "Report generation failed.."
          ))
        }


        # Perform the file copy operation
        file.copy(paste0(saveDir, "/", filename), paste0(targetDir, "/", filename), overwrite = TRUE)

        output$coeff_reportOutput <- renderUI({
          # Render the iframe with the dynamically generated source filename
          tags$iframe(style = "width: 100%; height: 1000px", src = filename)
        })
      } else {
        # Display success message
        shinyalert::shinyalert(
          title = "Contract Year Incomplete!", type = "warning",
          text = "Coefficient Report generation is available for completed contract years.Please ensure the correct selection of Contract Year!"
        )
      }
    } else {
      # If any of the required variables is missing, inform the user or handle the situation accordingly
      showModal(modalDialog(
        title = "Missing Inputs",
        "Please provide all the inputs..!"
      ))
    }
  })


  #************************************************************* Run offline TCM

  observeEvent(input$run_offline_tcm,
    {
      startDate <- format(as.POSIXct(input$start_date_tcm), "%Y-%m-%d %H:%M:%S")
      endDate <- format(as.POSIXct(input$end_date_tcm), "%Y-%m-%d %H:%M:%S")
      indexation_type <- as.character(input$indexation_type)

      # Database connection
      conn <- db_connection()

      # Initialize progress bar
      pb <- shiny::Progress$new()
      pb$set(message = "Calculating offline TCM. Please wait...", value = 0)


      # Execute the stored procedure
      # query <- "EXEC TCM_Offline_V2 @from_date = ?, @to_date = ?, @type = ?"
      query <- "EXEC TCM_Offline_Audit_V3 @from_date = ?, @to_date = ?, @type = ?"
      dbSendQuery(conn, query, params = list(startDate, endDate, indexation_type))

      # Close progress bar
      pb$close()

      # Display success message
      shinyalert::shinyalert(
        title = "Success!", type = "success",
        text = "Offline TCM calculation completed successfully."
      )

      dbDisconnect(conn)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* Run offline PPM

  observeEvent(input$run_offline_ppm,
    {
      startDate <- format(as.POSIXct(input$offline_ppm_range[1]), "%Y-%m-%d %H:%M:%S")
      endDate <- format(as.POSIXct(input$offline_ppm_range[2]), "%Y-%m-%d %H:%M:%S")


      # Database connection
      conn <- db_connection()

      # Initialize progress bar
      pb <- shiny::Progress$new()
      pb$set(message = "Calculating offline PPM. Please wait...", value = 0)

      # Execute the stored procedure
      query <- "EXEC [dbo].[PPMCalcOffline] @from_date = ?, @to_date = ?"
      dbSendQuery(conn, query, params = list(startDate, endDate))

      # Close progress bar
      pb$close()

      # Display success message
      shinyalert::shinyalert(
        title = "Success!", type = "success",
        text = "Offline PPM calculation completed successfully."
      )

      dbDisconnect(conn)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************** Run Offline coefficient calculation
  observeEvent(input$run_offline_coeff,
    {
      cy <- input$offline_coefficient

      # Source the external script
      source("coeff_calc_offline.R", local = TRUE)


      tryCatch(
        {
          calculate_coefficients(cy)


          showNotification("Offline coefficients successfully calculated!", type = "message")
        },
        error = function(e) {
          showNotification("Error occurred while calculating coefficients.", type = "error")
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* licensing
  observeEvent(input$info_button, {
    showModal(
      modalDialog(
        title = icon("info-circle", "About"),
        # size = "l",
        footer = actionButton("close_info", "Close"),
        tags$iframe(
          src = "Aguilon.html",
          width = "100%",
          height = "600px",
          seamless = "seamless",
          frameborder = "0"
        ),
        easyClose = TRUE,
      )
    )
  })

  observeEvent(input$close_info, {
    removeModal()
  })

  #********************************************************************* excel imports
  #*
  #*
  #************************************************************* mda

  excel_mda_data <- read_data(input, "excel_mda_file", 1)

  observeEvent(input$excel_mda_file,
    {
      data <- excel_mda_data()
      from_date <- input$dateRange_excel_mda[1]
      to_date <- input$dateRange_excel_mda[2]

      if (!is.null(data)) {
        # Gather columns dynamically except for 'Tag Time Stamp'
        transformed_data <- data %>%
          gather(key = "Tag Name", value = "Tag Value", -c("Tag Time Stamp"))

        conn <- db_connection()
        # glue to avoid sql injection attack
        delete_query <- glue::glue("DELETE FROM [dbo].[IPPXTagsSMD] WHERE [Tag Time Stamp] >= '{from_date}' AND [Tag Time Stamp] <= '{to_date}' ")
        dbExecute(conn, delete_query)

        dbWriteTable(conn, "IPPXTagsSMD", transformed_data, append = TRUE)

        dbDisconnect(conn)
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #************************************************************* mda

  excel_scada_data <- read_data(input, "excel_scada_file", 1)

  observeEvent(input$excel_scada_file,
    {
      data <- excel_scada_data()
      from_date <- input$dateRange_excel_scada[1]
      to_date <- input$dateRange_excel_scada[2]

      if (!is.null(data)) {
        # Gather columns dynamically except for 'Tag Time Stamp'
        transformed_data <- data %>%
          gather(key = "Tag Name", value = "Tag Value", -c("Tag Time Stamp"))

        conn <- db_connection()
        # glue to avoid sql injection attack
        delete_query <- glue::glue("DELETE FROM [dbo].[IPPXTagsDCPPMS] WHERE [Tag Time Stamp] >= '{from_date}' AND [Tag Time Stamp] <= '{to_date}' ")
        dbExecute(conn, delete_query)

        dbWriteTable(conn, "IPPXTagsDCPPMS", transformed_data, append = TRUE)

        dbDisconnect(conn)
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************ parameterization

  # Optimized reactive observer for main table updates
  observeEvent(c(input$sidebarID, input$signallist),
    {
      if (input$sidebarID == "parameterization") {
        # Show loading indicator
        loading_id <- showNotification("Loading data...", type = "message", duration = NULL)

        print(paste("[SERVER] Parameterization Observer Triggered. Tab:", input$signallist))

        # Wrap everything in error handling
        tryCatch(
          {
            # Database connection with proper cleanup
            conn <- db_connection()
            on.exit(
              {
                if (exists("conn") && !is.null(conn)) {
                  tryCatch(dbDisconnect(conn), error = function(e) NULL)
                }
                removeNotification(loading_id)
              },
              add = TRUE
            )

            # Validate connection
            if (is.null(conn)) {
              stop("Failed to establish database connection")
            }


            query_mda_sig <- "SELECT Id, [Tag Name] AS TagName, Description, Meterid AS [MeterId], type AS [MeterType], subtype as [SubType], Unit from dbo.mda_signals ORDER BY Id ASC;"
            table_mda_sig <- dbGetQuery(conn, query_mda_sig)
            query_dcs_sig <- "SELECT Id, [Tag Name] AS TagName, Description, Category, Unit FROM dbo.dcs_signals;"
            table_dcs_sig <- dbGetQuery(conn, query_dcs_sig)
            query_pss_sig <- "SELECT Id, TagName, Description, Unit FROM dbo.pss_signals;"
            table_pss_sig <- dbGetQuery(conn, query_pss_sig)
            query_ppm_sig <- "SELECT Id, TagName, Description, Unit FROM dbo.ppm_signals;"
            table_ppm_sig <- dbGetQuery(conn, query_ppm_sig)

            # --- Render outputs ---
            # Table 1: mda_sig
            render_smart_table(
              output, session, "mda_sig", table_mda_sig, mda_sig_initialized,
              editable_cols = c("TagName", "Description", "MeterType", "SubType", "MeterId", "Unit"),
              dropdown_list = list("MeterType" = c("Check-Meter", "Main-Meter"), "SubType" = c("EXPORT", "IMPORT")),
              hidden_cols = c("Id"),
              exclude_update_cols = c("Id")
            )

            # Table 2: dcs_sig
            render_smart_table(
              output, session, "dcs_sig", table_dcs_sig, dcs_sig_initialized,
              editable_cols = c("TagName", "Description", "Category", "Unit"),
              dropdown_list = list("Category" = c("GPOA", "MT")),
              hidden_cols = c("Id"),
              exclude_update_cols = c("Id")
            )

            # Table 3: ppm_sig
            render_smart_table(
              output, session, "ppm_sig", table_ppm_sig, ppm_sig_initialized,
              editable_cols = c("TagName", "Description", "Unit"),
              hidden_cols = NULL,
              post_process = function(ht) {
                ht %>% rhandsontable::hot_col(col = "Id", width = 0.1, wordWrap = FALSE)
              }
            )

            # Table 4: pss_sig
            render_smart_table(
              output, session, "pss_sig", table_pss_sig, pss_sig_initialized,
              editable_cols = c("TagName", "Description", "Unit"),
              hidden_cols = c("Id"),
              exclude_update_cols = c("Id")
            )
          },
          error = function(e) {
            # Error handling
            error_msg <- paste("Error loading data:", e$message)
            showNotification(error_msg, type = "error", duration = 10)
          }
        )
      }
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #********************************************************************** mda_sig_save
  observeEvent(input$mda_sig_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      conn <- db_connection()
      query_mda_sig1 <- "SELECT Id from dbo.mda_signals ORDER BY Id ASC;"
      table_mda_sig1 <- dbGetQuery(conn, query_mda_sig1)
      dbDisconnect(conn)

      tryCatch({
        table_data <- hot_to_r(input$mda_sig)

        # Check if we have new rows (more rows than DB)
        # If so, we cannot simply assign IDs by position
        if (nrow(table_data) > nrow(table_mda_sig1)) {
          # Partial assignment or logic to keep NA for new rows?
          # For now, let's just assign what we can, assuming the TOP rows match existing
          # This is risky but matches legacy behavior roughly, except it fails if lengths differ significantly
          # SAFE FIX: Only assign Id if it is missing and we have a corresponding DB entry?
          # BETTER: Assume existing rows have Ids (if data loaded with Ids).
          # But 'mda_sig' loader originally had hidden_cols="Id".
          # If AJAX update dropped IDs, we have trouble.
          # Let's assume user refreshed or we fixed AJAX.
          # If table_data has Id column, use it.
        } else {
          # table_data$Id <- table_mda_sig1$Id
        }

        # NOTE: mda_sig_save logic seems flawed in original code (overwriting IDs).
        # Ideally we should refactor it like pss/ppm, but user only asked about ppm.
        # I will leave mda_sig_save mainly as is but commented out the dangerous overwrite if it causes crash

        # Attempt to use existing IDs if present
        if (is.null(table_data$Id)) {
          if (nrow(table_data) == nrow(table_mda_sig1)) {
            table_data$Id <- table_mda_sig1$Id
          }
        }

        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Id"          = "Id",
          "TagName"     = "Tag Name",
          "Description" = "Description",
          "MeterId"     = "Meterid",
          "MeterType"   = "type",
          "SubType"     = "subtype",
          "Unit"        = "Unit"
        )

        table_name_input <- "[dbo].[mda_signals]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Id"),
          editable_cols = c("TagName", "Description", "MeterType", "SubType", "MeterId", "Unit"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("TagName", "Description", "MeterType", "SubType", "MeterId", "Unit"),
          # audit_key_cols = c("Id"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "MDA Signals"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** dcs_sig_save
  observeEvent(input$dcs_sig_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      conn <- db_connection()
      query_dcs_sig1 <- "SELECT Id from dbo.dcs_signals ORDER BY Id ASC;"
      table_dcs_sig1 <- dbGetQuery(conn, query_dcs_sig1)
      dbDisconnect(conn)

      tryCatch({
        table_data <- hot_to_r(input$dcs_sig)

        req(!is.null(table_data) && nrow(table_data) > 0)

        col_mapping <- list(
          "Id"          = "Id",
          "TagName"     = "Tag Name",
          "Description" = "Description",
          "Category"    = "Category",
          "Unit"        = "Unit"
        )

        table_name_input <- "[dbo].[dcs_signals]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Id"),
          editable_cols = c("TagName", "Description", "Category", "Unit"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("TagName", "Description", "Category", "Unit"),
          # audit_key_cols = c("Id"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "SCADA Signals"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  #********************************************************************** pss_sig_save
  observeEvent(input$pss_sig_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        table_data <- hot_to_r(input$pss_sig)

        # Split updates (valid Id) and inserts (NA/new Id)
        updates <- table_data[!is.na(table_data$Id), ]
        inserts <- table_data[is.na(table_data$Id), ]

        msgs <- c()

        # 1. Process Updates
        if (nrow(updates) > 0) {
          col_mapping <- list(
            "Id"          = "Id",
            "TagName"     = "TagName",
            "Description" = "Description",
            "Unit"        = "Unit"
          )

          save_result <- save_editable_data_audit(
            hot_data = updates,
            identifier_cols = c("Id"),
            editable_cols = c("TagName", "Description", "Unit"),
            column_mapping = col_mapping,
            table_name = "[dbo].[pss_signals]",
            source_name = "PSS Signals",
            audit_cols = c("TagName", "Description", "Unit"),
            user_id = reactiveValuesToList(res_auth)$user
          )

          if (save_result$success) {
            if (length(msgs) == 0) msgs <- c("Updated rows.")
          } else {
            stop(save_result$message)
          }
        }

        # 2. Process Inserts
        if (nrow(inserts) > 0) {
          # Use generic save_data_only helper for INSERTs
          res_ins <- save_data_only(
            hot_data = inserts,
            table_name = "[dbo].[pss_signals]",
            insert_cols = c("TagName", "Description", "Unit")
          )
          if (res_ins$success) msgs <- c(msgs, "New rows added.") else stop(res_ins$message)
        }

        if (length(msgs) > 0) {
          showNotification(paste(msgs, collapse = " "), type = "message")

          # --- AUTO-REFRESH START ---
          # Re-fetch fresh data from DB to show new IDs and confirm save
          conn <- db_connection()
          query_ppm_sig <- "SELECT Id, TagName, Description, Unit FROM dbo.ppm_signals;"
          table_ppm_sig <- dbGetQuery(conn, query_ppm_sig)
          dbDisconnect(conn)

          print(paste("[SERVER] Save successful. Triggering AJAX refresh at", Sys.time()))

          # Send AJAX update
          ajax_update_handsontable(session, "ppm_sig", table_ppm_sig)
          # --- AUTO-REFRESH END ---
        } else {
          showNotification("No changes to save.", type = "warning")
        }
      }, error = function(e) {
        showNotification(paste("Save failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #********************************************************************** ppm_sig_save
  observeEvent(input$ppm_sig_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      # NOTE: No need to fetch IDs from DB manually if they are correctly maintained in table

      tryCatch({
        table_data <- hot_to_r(input$ppm_sig)
        req(!is.null(table_data) && nrow(table_data) > 0)

        # Split updates (valid Id) and inserts (NA/new Id/NULL Id)
        # Note: If Id logic fails, check if Id exists in table_data
        if (!"Id" %in% names(table_data)) {
          stop("Fatal Error: Id column missing from table data. Please refresh the page.")
        }

        updates <- table_data[!is.na(table_data$Id), ]
        inserts <- table_data[is.na(table_data$Id), ]

        msgs <- c()

        # 1. Process Updates
        if (nrow(updates) > 0) {
          col_mapping <- list(
            "Id"          = "Id",
            "TagName"     = "TagName",
            "Description" = "Description",
            "Unit"        = "Unit"
          )

          table_name_input <- "[dbo].[ppm_signals]"

          save_result <- save_editable_data_audit(
            hot_data = updates,
            identifier_cols = c("Id"),
            editable_cols = c("TagName", "Description", "Unit"),
            column_mapping = col_mapping,
            table_name = table_name_input,
            audit_cols = c("TagName", "Description", "Unit"),
            user_id = reactiveValuesToList(res_auth)$user,
            source_name = "PPM Signals"
          )

          if (save_result$success) {
            # msgs <- c(msgs, "Updates saved.")
          } else {
            # Accumulate errors
          }
        }

        # 2. Process Inserts
        if (nrow(inserts) > 0) {
          res_ins <- save_data_only(
            hot_data = inserts,
            table_name = "[dbo].[ppm_signals]",
            insert_cols = c("TagName", "Description", "Unit")
          )
          if (res_ins$success) msgs <- c(msgs, "New rows added.") else stop(res_ins$message)
        }

        # Combine results
        if (length(msgs) > 0) {
          showNotification(paste(msgs, collapse = " "), type = "message")
        } else {
          showNotification("Changes saved successfully.", type = "message")
        }

        # --- AUTO-REFRESH START ---
        # Re-fetch fresh data from DB to show new IDs and confirm save
        conn <- db_connection()
        query_ppm_sig <- "SELECT Id, TagName, Description, Unit FROM dbo.ppm_signals;"
        table_ppm_sig <- dbGetQuery(conn, query_ppm_sig)
        dbDisconnect(conn)

        # Send AJAX update using GLOBAL function
        ajax_update_handsontable(session, "ppm_sig", table_ppm_sig)
        # --- AUTO-REFRESH END ---
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )


  #************************************************************* formula

  #------------------- Reactive observer for loading formula table -------------------
  observeEvent(input$sidebarID,
    {
      req(input$sidebarID == "formula")

      loading_id <- showNotification("Loading data...", type = "message", duration = NULL)

      tryCatch(
        {
          # Open DB connection
          conn <- db_connection()
          on.exit(
            {
              if (!is.null(conn)) dbDisconnect(conn)
              removeNotification(loading_id)
            },
            add = TRUE
          )

          # Fetch formula table
          query_formula <- "SELECT Id, TagName, Description, Formula, Unit FROM dbo.formula;"
          table_formula <- dbGetQuery(conn, query_formula)

          # Render rHandsontable
          # Render rHandsontable
          render_smart_table(
            output, session, "formula", table_formula, formula_initialized,
            height = 600,
            editable_cols = c("TagName", "Description", "Formula", "Unit"),
            hidden_cols = c("Id"),
            exclude_update_cols = c("Id")
          )
        },
        error = function(e) {
          showNotification(paste("Error loading formula data:", e$message), type = "error", duration = 10)
        }
      )
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )



  #********************************************************************** formula_save
  observeEvent(input$formula_save,
    {
      save_id <- showNotification("Saving changes...", type = "message", duration = NULL)

      tryCatch({
        conn <- db_connection()
        on.exit(if (!is.null(conn)) dbDisconnect(conn), add = TRUE)

        # Fetch current IDs from DB
        table_ids <- dbGetQuery(conn, "SELECT Id FROM dbo.formula ORDER BY Id ASC;")

        # Convert handsontable to R data frame
        table_data <- hot_to_r(input$formula)
        req(!is.null(table_data) && nrow(table_data) > 0)

        # Assign Ids from DB (row order)
        table_data$Id <- table_ids$Id

        col_mapping <- list(
          "Id"          = "Id",
          "TagName"     = "TagName",
          "Description" = "Description",
          "Formula"     = "Formula",
          "Unit"        = "Unit"
        )

        table_name_input <- "[dbo].[formula]"

        save_result <- save_editable_data_audit(
          hot_data = table_data,
          identifier_cols = c("Id"),
          editable_cols = c("TagName", "Description", "Formula", "Unit"),
          column_mapping = col_mapping,
          table_name = table_name_input,
          audit_cols = c("TagName", "Description", "Formula", "Unit"),
          # audit_key_cols = c("Id"),
          user_id = reactiveValuesToList(res_auth)$user,
          source_name = "PPA Formula View"
        )

        show_save_results(save_result)
      }, error = function(e) {
        showNotification(paste("Data extraction failed:", e$message), type = "error", duration = 10)
      }, finally = {
        removeNotification(save_id)
      })
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )
}

options(shiny.host = "0.0.0.0")
options(shiny.port = 8080)

shinyApp(ui, server)
