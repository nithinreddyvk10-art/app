## Copyright @EEL
#############################################
####### Title   : Aguilon Analytics    ######
####### Date    : Modified: 18/09/2025 ######
####### Creator : SM ########################
#############################################
#------------------------------------------GLOBAL FUNCTIONS ------------------------------------------------------

## Copyright @ Aguilon Global
#############################################
####### Title:  Aguilon Analytics    ########
####### Date:   Modified: 13/05/2024 ########
#############################################

suppressWarnings(suppressMessages({
  library(bs4Dash)
  library(shiny)
  library(dplyr)
  library(shinyWidgets)
  library(plotly)
  library(DT)
  library(shinythemes)
  library(shinymanager)
  library(waiter)
  library(DBI)
  library(odbc)
  library(writexl)
  library(readxl)
  library(httr)
  library(openxlsx)
  library(tidyr)
  library(shinyalert)
  library(rhandsontable)
  library(jsonlite)
  library(lubridate)
  # library(later)
}))


db_connection <- function() {
  conn <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "localhost\\PLANTOPTIX", Database = "tabarjal_1", Trusted_Connection = "yes")
  # conn <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "localhost", Database = "agpass", Trusted_Connection = "yes")

  return(conn)
}


##################### SET DIRECTORIES

db_wd <- "C:/Users/DELL/Downloads/Tabarjal App/Tabarjal App/db.sqlite"
setwd("C:/Users/DELL/Downloads/Tabarjal App/Tabarjal App")
saveDir <- "C:/Users/DELL/Downloads/Tabarjal App/Tabarjal App/Reports"
targetDir <- "C:/Users/DELL/Downloads/Tabarjal App/Tabarjal App/www"


# In global.R for example:
set_labels(
  language = "en",
  "Please authenticate" = "Welcome to Aguilon",
  "Username:" = "Username:",
  "Password:" = "Password:"
)


# Function to handle file input and return reactive data
read_data <- function(input, input_file, sheet) {
  reactive({
    inFile <- input[[input_file]]
    if (is.null(inFile)) {
      return(NULL)
    }
    read_excel(inFile$datapath, sheet = sheet)
  })
}

showInfoModal <- function(message) {
  showModal(
    modalDialog(
      title = icon("info-circle", "Alert"),
      message,
      footer = tagList(
        actionButton("close_info", "Close")
      ),
      easyClose = TRUE
    )
  )
}

downloadData <- function(filtered_data, filename) {
  downloadHandler(
    filename = function() {
      paste(filename, ".xlsx", sep = "")
    },
    content = function(file) {
      # Save the filtered data to a CSV file
      write.xlsx(filtered_data, file, rowNames = FALSE)
    }
  )
}

DT_Style1 <- function(data, page_length) {
  DT::renderDataTable({
    datatable(data,
      filter = "top",
      class = "stripe hover grid",
      rownames = FALSE,
      options = list(
        pageLength = page_length,
        columnDefs = list(list(className = "dt-center", targets = "_all"))
      )
    )
  })
}

#--------------------------- universal function readonly/col_edit/dropdown/bitcolumn/conditional ----------------
# ✅ Hiding columns
# ✅ Auto height scaling
# ✅ Editable vs read-only logic
# ✅ Dropddwn support
# ✅ Bit column rendering (✅ / ❌ / NULL)
# ✅ Numeric formatting (5 decimals)
# ✅ Conditional formatting (with color mapping)
# ✅ CDate Function

StyledHandsontableUniversal <- function(
    data,
    editable_cols = NULL,
    dropdown_list = list(),
    bit_cols = NULL,
    conditional_cols = list(),
    date_cols = NULL,
    readonly = FALSE,
    height = NULL,
    hidden_cols = NULL,
    digits = 5) {
  # Remove hidden columns from display
  display_data <- data
  if (!is.null(hidden_cols)) {
    display_data <- display_data[, !names(display_data) %in% hidden_cols, drop = FALSE]
  }

  if (is.null(height)) height <- max(100, nrow(display_data) * 35 + 1)


  ht <- rhandsontable::rhandsontable(
    display_data,
    width = "100%",
    height = height,
    rowHeaders = TRUE,
    manualColumnResize = TRUE,
    manualColumnMove = TRUE,
    stretchH = "all",
    selectCallback = TRUE,
    highlightCol = TRUE,
    highlightRow = TRUE,
    readOnly = readonly,
    digits = digits,
    escape = FALSE
  ) %>% rhandsontable::hot_cols(columnSorting = TRUE, search = TRUE)


  # Editable columns
  if (!readonly && !is.null(editable_cols)) {
    ht <- ht %>%
      rhandsontable::hot_col(col = editable_cols, readOnly = FALSE) %>%
      rhandsontable::hot_col(col = setdiff(names(display_data), editable_cols), readOnly = TRUE)
  }

  # Dropdowns
  for (colname in names(dropdown_list)) {
    ht <- ht %>%
      rhandsontable::hot_col(
        col = colname,
        type = "dropdown",
        source = dropdown_list[[colname]],
        readOnly = FALSE
      )
  }


  # Bit columns
  if (!is.null(bit_cols)) {
    bit_renderer <- "
      function (instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        if (value == 1) { td.innerHTML = '✅'; td.style.color='green'; td.style.textAlign='center'; }
        else if (value == 0) { td.innerHTML = '❌'; td.style.color='red'; td.style.textAlign='center'; }
        else { td.innerHTML='NULL'; td.style.color='gray'; td.style.textAlign='center'; }
      }
    "
    for (col in bit_cols) {
      if (col %in% names(display_data)) ht <- ht %>% rhandsontable::hot_col(col = col, renderer = bit_renderer, readOnly = TRUE)
    }
  }


  # Numeric formatting (
  numeric_cols <- names(display_data)[sapply(display_data, is.numeric)]
  if (length(numeric_cols) > 0) {
    for (col in numeric_cols) {
      ht <- ht %>% hot_col(
        col = col,
        type = "numeric",
        format = "0.00000",
        readOnly = ifelse(!is.null(editable_cols), !(col %in% editable_cols), FALSE)
      )
    }
  }


  # Conditional formatting
  color_map <- list("Ok" = "#a7ff86", "Error" = "#ffb2b2", "Null" = "#ffb2b2")
  if (!is.null(conditional_cols)) {
    for (col in conditional_cols) {
      if (col %in% names(display_data)) {
        ht <- ht %>% rhandsontable::hot_col(
          col = col,
          renderer = sprintf("
            function (instance, td, row, col, prop, value, cellProperties) {
              Handsontable.renderers.TextRenderer.apply(this, arguments);
              var ruleColors = %s;
              td.style.background = ruleColors[value] || 'white';
            }
          ", jsonlite::toJSON(color_map, auto_unbox = TRUE)),
          readOnly = TRUE
        )
      }
    }
  }



  # --- NEW: Date columns ---
  if (!is.null(date_cols)) {
    for (col in date_cols) {
      if (col %in% names(display_data)) {
        ht <- ht %>%
          rhandsontable::hot_col(col = col, type = "date", dateFormat = "YYYY-MM-DD")
      }
    }
  }

  ht
}






## --------------------------- HOW to APPLY -------------------------------------------------------------------
# output$mda_dv1 <- renderRHandsontable({
#   StyledHandsontableUniversal(
#     table_smd_processed,
#     editable_cols = c("Mode", "Remarks"),
#     dropdown_list = list("Mode" = c("Auto", "Manual", "Bypass", "NA")),
#     bit_cols = c("MainQ", "CheckQ"),
#     conditional_cols = c("Status", "Result")  # no need to pass rules now
#   )
# })



#--------------------------- Optimized bulk save function ----------------------------------------------------
# -------------------------------
# Save editable data to DB
# -------------------------------
save_editable_data <- function(
    hot_data,
    identifier_cols,
    editable_cols,
    column_mapping,
    table_name) {
  if (is.null(hot_data) || nrow(hot_data) == 0) {
    return(list(success = FALSE, message = "No data to save"))
  }

  conn <- db_connection()
  on.exit(dbDisconnect(conn), add = TRUE)

  updated_rows <- 0
  errors <- list()

  id_cols_db <- sapply(identifier_cols, function(x) column_mapping[[x]])
  edit_cols_db <- sapply(editable_cols, function(x) column_mapping[[x]])

  for (i in seq_len(nrow(hot_data))) {
    row <- hot_data[i, , drop = FALSE]

    # SET clause
    set_values <- lapply(editable_cols, function(col) {
      val <- row[[col]]
      val <- trimws(as.character(val)) # Clean up whitespace and ensure string

      if (is.null(val) || is.na(val) || val == "" || val == "NULL") NA else val
    })
    set_clause <- paste0("[", edit_cols_db, "] = ?", collapse = ", ")

    # WHERE clause
    where_values <- lapply(identifier_cols, function(col) row[[col]])
    where_clause <- paste0("[", id_cols_db, "] = ?", collapse = " AND ")

    sql <- paste0("UPDATE ", table_name, " SET ", set_clause, " WHERE ", where_clause)

    tryCatch(
      {
        rows <- dbExecute(conn, sql, params = c(set_values, where_values))
        if (rows > 0) updated_rows <- updated_rows + 1
      },
      error = function(e) {
        errors[[length(errors) + 1]] <<- paste("Row", i, ":", e$message)
      }
    )
  }

  if (updated_rows > 0) {
    # msg <- paste("Successfully updated", updated_rows, "row(s)")
    msg <- paste("Successfully updated")
    if (length(errors) > 0) msg <- paste(msg, "with", length(errors), "errors")
    return(list(success = TRUE, message = msg, errors = errors))
  } else {
    return(list(success = FALSE, message = "No rows updated", errors = errors))
  }
}


# -------------------------------
# Show notifications for save results
# -------------------------------
show_save_results <- function(save_result, max_errors = 5) {
  if (save_result$success) {
    showNotification(save_result$message, type = "message", duration = 5)

    if (!is.null(save_result$errors) && length(save_result$errors) > 0) {
      failed_n <- length(save_result$errors)
      showNotification(
        paste0(
          "Some rows failed (", failed_n, "):\n",
          paste(head(save_result$errors, max_errors), collapse = "\n")
        ),
        type = "warning", duration = 8
      )
    }
  } else {
    showNotification(
      paste("Save failed:", save_result$message),
      type = "error", duration = 8
    )

    if (!is.null(save_result$errors) && length(save_result$errors) > 0) {
      showNotification(
        paste("Errors:\n", paste(head(save_result$errors, max_errors), collapse = "\n")),
        type = "error", duration = 10
      )
    }
  }
}



#-----------------------------------------------------------------------
# ✅ Save function with audit trail
#    → Now supports separate audit_key_cols for record_key
#-----------------------------------------------------------------------

save_editable_data_audit1 <- function(
    hot_data,
    identifier_cols,
    editable_cols,
    column_mapping,
    table_name,
    source_name,
    audit_table = "dbo.audit_trail",
    audit_cols = NULL,
    audit_key_cols = NULL, # ✅ NEW: Separate audit key columns
    user_id = NULL) {
  # ✅ Early exit if no data
  if (is.null(hot_data) || nrow(hot_data) == 0) {
    return(list(success = FALSE, message = "No data to save"))
  }

  # ✅ Open DB connection safely
  conn <- db_connection()
  on.exit(dbDisconnect(conn), add = TRUE)

  updated_rows <- 0
  errors <- list()
  audit_entries <- data.frame()

  id_cols_db <- sapply(identifier_cols, function(x) column_mapping[[x]])
  edit_cols_db <- sapply(editable_cols, function(x) column_mapping[[x]])

  # ✅ Default audit_key_cols to identifier_cols if not provided
  if (is.null(audit_key_cols)) {
    audit_key_cols <- identifier_cols
  }

  # 🧩 Process each row
  for (i in seq_len(nrow(hot_data))) {
    row <- hot_data[i, , drop = FALSE]

    # ✅ Build WHERE clause using identifier columns
    where_values <- lapply(identifier_cols, function(col) row[[col]])
    where_clause <- paste0("[", id_cols_db, "] = ?", collapse = " AND ")

    # 🔍 Fetch old record for audit comparison
    old_data <- tryCatch(
      {
        dbGetQuery(
          conn,
          paste0(
            "SELECT ", paste0("[", edit_cols_db, "]", collapse = ", "),
            " FROM ", table_name, " WHERE ", where_clause
          ),
          params = where_values
        )
      },
      error = function(e) NULL
    )

    # ✏️ Prepare SET clause for update
    set_values <- lapply(editable_cols, function(col) {
      val <- row[[col]]
      val <- trimws(as.character(val)) # Clean up whitespace and ensure string

      if (is.null(val) || is.na(val) || val == "" || val == "NULL") NA else val
    })
    set_clause <- paste0("[", edit_cols_db, "] = ?", collapse = ", ")

    sql <- paste0("UPDATE ", table_name, " SET ", set_clause, " WHERE ", where_clause)

    tryCatch(
      {
        rows <- dbExecute(conn, sql, params = c(set_values, where_values))
        if (rows > 0) {
          updated_rows <- updated_rows + 1

          # 🔒 AUDIT TRAIL LOGIC
          if (!is.null(audit_cols) && !is.null(old_data) && nrow(old_data) > 0) {
            # ✅ Use audit_key_cols for record_key (separate from identifier)
            record_key <- paste(paste0(audit_key_cols, "=", row[audit_key_cols]), collapse = ", ")

            for (col in audit_cols) {
              col_db <- column_mapping[[col]]
              old_val <- trimws(as.character(old_data[[col_db]][1]))
              new_val <- trimws(as.character(row[[col]]))

              # Normalize both values before comparing
              old_val_norm <- ifelse(is.null(old_val) || is.na(old_val) || old_val == "", NA, old_val)
              new_val_norm <- ifelse(is.null(new_val) || is.na(new_val) || new_val == "", NA, new_val)

              # Log only if the normalized values differ
              if (!identical(old_val_norm, new_val_norm)) {
                audit_entries <- rbind(
                  audit_entries,
                  data.frame(
                    table_name = table_name,
                    source_name = source_name,
                    record_key = record_key,
                    column_name = col_db,
                    old_value = old_val,
                    new_value = new_val,
                    action_type = "UPDATE",
                    changed_by = user_id,
                    # change_time = Sys.time(), GETDATE() set in the db table dbo.audit_trial
                    stringsAsFactors = FALSE
                  )
                )
              }
            }
          }
        }
      },
      error = function(e) {
        errors[[length(errors) + 1]] <<- paste("Row", i, ":", e$message)
      }
    )
  }

  # ✅ Insert collected audit records (if any)
  if (nrow(audit_entries) > 0) {
    tryCatch(
      {
        dbAppendTable(conn, Id(schema = "dbo", table = "audit_trail"), audit_entries)
      },
      error = function(e) {
        errors[[length(errors) + 1]] <<- paste("Audit insert failed:", e$message)
      }
    )
  }

  # ✅ Return result summary
  if (updated_rows > 0) {
    msg <- paste("Successfully updated")
    if (length(errors) > 0) msg <- paste(msg, "with", length(errors), "errors")
    return(list(success = TRUE, message = msg, errors = errors))
  } else {
    return(list(success = FALSE, message = "No rows updated", errors = errors))
  }
}




#-----------------------------------------------------------------------
# Save function with audit trial
#-----------------------------------------------------------------------

save_editable_data_audit <- function(
    hot_data,
    identifier_cols,
    editable_cols,
    column_mapping,
    table_name,
    source_name,
    audit_table = "dbo.audit_trail",
    audit_cols = NULL,
    user_id = NULL) {
  if (is.null(hot_data) || nrow(hot_data) == 0) {
    return(list(success = FALSE, message = "No data to save"))
  }

  conn <- db_connection()
  on.exit(dbDisconnect(conn), add = TRUE)

  updated_rows <- 0
  errors <- list()
  audit_entries <- data.frame()

  id_cols_db <- sapply(identifier_cols, function(x) column_mapping[[x]])
  edit_cols_db <- sapply(editable_cols, function(x) column_mapping[[x]])

  for (i in seq_len(nrow(hot_data))) {
    row <- hot_data[i, , drop = FALSE]

    # Build WHERE clause (identifiers)
    where_values <- lapply(identifier_cols, function(col) row[[col]])
    where_clause <- paste0("[", id_cols_db, "] = ?", collapse = " AND ")

    # Fetch old record for audit
    old_data <- tryCatch(
      {
        dbGetQuery(conn,
          paste0(
            "SELECT ", paste0("[", edit_cols_db, "]", collapse = ", "),
            " FROM ", table_name, " WHERE ", where_clause
          ),
          params = where_values
        )
      },
      error = function(e) NULL
    )

    # SET clause for update
    set_values <- lapply(editable_cols, function(col) {
      val <- row[[col]]

      val <- trimws(as.character(val)) # Clean up whitespace and ensure string

      if (is.null(val) || is.na(val) || val == "" || val == "NULL") NA else val
    })
    set_clause <- paste0("[", edit_cols_db, "] = ?", collapse = ", ")

    sql <- paste0("UPDATE ", table_name, " SET ", set_clause, " WHERE ", where_clause)

    tryCatch(
      {
        rows <- dbExecute(conn, sql, params = c(set_values, where_values))
        if (rows > 0) {
          updated_rows <- updated_rows + 1

          # --- 🔒 AUDIT TRAIL ---
          if (!is.null(audit_cols) && !is.null(old_data) && nrow(old_data) > 0) {
            record_key <- paste(paste0(identifier_cols, "=", row[identifier_cols]), collapse = ", ")

            for (col in audit_cols) {
              col_db <- column_mapping[[col]]
              old_val <- trimws(as.character(old_data[[col_db]][1]))
              new_val <- trimws(as.character(row[[col]]))

              # Normalize both values before comparing
              old_val_norm <- ifelse(is.null(old_val) || is.na(old_val) || old_val == "", NA, old_val)
              new_val_norm <- ifelse(is.null(new_val) || is.na(new_val) || new_val == "", NA, new_val)

              # Log only if the normalized values differ
              if (!identical(old_val_norm, new_val_norm)) {
                audit_entries <- rbind(
                  audit_entries,
                  data.frame(
                    table_name = table_name,
                    source_name = source_name,
                    record_key = record_key,
                    column_name = col_db,
                    old_value = old_val,
                    new_value = new_val,
                    action_type = "UPDATE",
                    changed_by = user_id,
                    change_time = Sys.time(),
                    stringsAsFactors = FALSE
                  )
                )
              }
            }
          }
        }
      },
      error = function(e) {
        errors[[length(errors) + 1]] <<- paste("Row", i, ":", e$message)
      }
    )
  }

  # Correct insertion of audit entries
  if (nrow(audit_entries) > 0) {
    tryCatch(
      {
        dbAppendTable(conn, Id(schema = "dbo", table = "audit_trail"), audit_entries)
      },
      error = function(e) {
        errors[[length(errors) + 1]] <<- paste("Audit insert failed:", e$message)
      }
    )
  }

  if (updated_rows > 0) {
    # msg <- paste("Successfully updated", updated_rows, "row(s)")
    msg <- paste("Successfully updated")
    if (length(errors) > 0) msg <- paste(msg, "with", length(errors), "errors")
    return(list(success = TRUE, message = msg, errors = errors))
  } else {
    return(list(success = FALSE, message = "No rows updated", errors = errors))
  }
}
#*************************************************************************************************
#*
#*
save_data_only <- function(
    hot_data,
    table_name,
    insert_cols) {
  if (is.null(hot_data) || nrow(hot_data) == 0) {
    return(list(success = TRUE, message = "No data"))
  }

  conn <- db_connection()
  on.exit(dbDisconnect(conn), add = TRUE)

  inserted_rows <- 0
  errors <- list()

  tryCatch(
    {
      dbBegin(conn)

      cols_db <- paste0("[", insert_cols, "]", collapse = ", ")
      placeholders <- paste(rep("?", length(insert_cols)), collapse = ", ")

      sql_insert <- paste0(
        "INSERT INTO ", table_name,
        " (", cols_db, ") VALUES (", placeholders, ")"
      )

      for (i in seq_len(nrow(hot_data))) {
        row <- hot_data[i, , drop = FALSE]

        tryCatch(
          {
            dbExecute(
              conn,
              sql_insert,
              params = as.list(row[insert_cols])
            )
            inserted_rows <- inserted_rows + 1
          },
          error = function(e) {
            errors[[length(errors) + 1]] <<-
              paste("Row", i, "failed (INSERT):", e$message)
          }
        )
      }

      if (length(errors) > 0) {
        stop("One or more rows failed during Save")
      }

      dbCommit(conn)

      list(
        success = TRUE,
        message = paste("Successfully updated")
      )
    },
    error = function(e) {
      dbRollback(conn)

      list(
        success = FALSE,
        message = e$message,
        errors = errors
      )
    }
  )
}




# save_data_only <- function(
#     hot_data,
#     old_data,                     # 👈 existing DB data for the month
#     table_name,
#     event,
#     identifier_cols,              # e.g. c("From","To")
#     insert_cols,
#     source_name = NULL,
#     audit_table = "dbo.audit_trail",
#     user_id = NULL,
#     enable_audit = TRUE
# ) {
#
#   if (is.null(hot_data)) hot_data <- data.frame()
#   if (is.null(old_data)) old_data <- data.frame()
#
#   conn <- db_connection()
#   on.exit(dbDisconnect(conn), add = TRUE)
#
#   audit_entries <- data.frame()
#   errors <- list()
#
#   # -------------------------------
#   # Helper to build business key
#   # -------------------------------
#   make_key <- function(df) {
#     if (nrow(df) == 0) return(character(0))
#     apply(df[identifier_cols], 1, function(x) paste(x, collapse = "|"))
#   }
#
#   tryCatch({
#     dbBegin(conn)
#
#     old_keys <- make_key(old_data)
#     new_keys <- make_key(hot_data)
#
#     # -------------------------------
#     # 1️⃣ DETECT INSERTS
#     # -------------------------------
#     insert_idx <- which(!(new_keys %in% old_keys))
#     insert_rows <- if (length(insert_idx) > 0)
#       hot_data[insert_idx, , drop = FALSE] else NULL
#
#     # -------------------------------
#     # 2️⃣ DETECT DELETES
#     # -------------------------------
#     delete_idx <- which(!(old_keys %in% new_keys))
#     delete_rows <- if (length(delete_idx) > 0)
#       old_data[delete_idx, , drop = FALSE] else NULL
#
#     # -------------------------------
#     # 3️⃣ DELETE AUDIT
#     # -------------------------------
#     if (enable_audit && !is.null(delete_rows) && nrow(delete_rows) > 0) {
#
#       for (i in seq_len(nrow(delete_rows))) {
#
#         record_key <- event
#
#         audit_entries <- rbind(
#           audit_entries,
#           data.frame(
#             table_name  = table_name,
#             source_name = source_name,
#             record_key  = record_key,
#             column_name = "Deemed Delete",
#             old_value   = paste(delete_rows[i, insert_cols], collapse = " | "),
#             new_value   = NA,
#             action_type = "DELETE",
#             changed_by  = user_id,
#             stringsAsFactors = FALSE
#           )
#         )
#       }
#     }
#
#     # -------------------------------
#     # 4️⃣ INSERT DATA + INSERT AUDIT
#     # -------------------------------
#     if (!is.null(insert_rows) && nrow(insert_rows) > 0) {
#
#       cols_db <- paste0("[", insert_cols, "]", collapse = ", ")
#       placeholders <- paste(rep("?", length(insert_cols)), collapse = ", ")
#
#       sql_insert <- paste0(
#         "INSERT INTO ", table_name,
#         " (", cols_db, ") VALUES (", placeholders, ")"
#       )
#
#       for (i in seq_len(nrow(insert_rows))) {
#
#         row <- insert_rows[i, , drop = FALSE]
#
#         dbExecute(conn, sql_insert, params = as.list(row[insert_cols]))
#
#         if (enable_audit && !is.null(source_name)) {
#
#           record_key <- event
#
#           audit_entries <- rbind(
#             audit_entries,
#             data.frame(
#               table_name  = table_name,
#               source_name = source_name,
#               record_key  = record_key,
#               column_name = "Deemed Insert",
#               old_value   = NA,
#               new_value   = paste(row[insert_cols], collapse = " | "),
#               action_type = "INSERT",
#               changed_by  = user_id,
#               stringsAsFactors = FALSE
#             )
#           )
#         }
#       }
#     }
#
#     # -------------------------------
#     # 5️⃣ WRITE AUDIT
#     # -------------------------------
#     if (enable_audit && nrow(audit_entries) > 0) {
#       dbAppendTable(
#         conn,
#         Id(schema = "dbo", table = "audit_trail"),
#         audit_entries
#       )
#     }
#
#     dbCommit(conn)
#
#     list(success = TRUE, message = "Saved with audit")
#
#   }, error = function(e) {
#
#     dbRollback(conn)
#
#     list(
#       success = FALSE,
#       message = e$message,
#       errors = errors
#     )
#   })






# save_data_only <- function(
#     hot_data,
#     old_data,                     # 👈 existing DB data for the month
#     table_name,
#     event,
#     identifier_cols,              # e.g. c("From","To")
#     insert_cols,
#     source_name = NULL,
#     audit_table = "dbo.audit_trail",
#     user_id = NULL,
#     enable_audit = TRUE
# ) {
#
#   if (is.null(hot_data)) hot_data <- data.frame()
#   if (is.null(old_data)) old_data <- data.frame()
#
#   conn <- db_connection()
#   on.exit(dbDisconnect(conn), add = TRUE)
#
#   audit_entries <- data.frame()
#   errors <- list()
#
#   # -------------------------------
#   # Helper to build business key
#   # -------------------------------
#   make_key <- function(df) {
#     if (nrow(df) == 0) return(character(0))
#     apply(df[identifier_cols], 1, function(x) paste(x, collapse = "|"))
#   }
#
#   tryCatch({
#     dbBegin(conn)
#
#     old_keys <- make_key(old_data)
#     new_keys <- make_key(hot_data)
#
#     # -------------------------------
#     # 1️⃣ DETECT INSERTS
#     # -------------------------------
#     insert_idx <- which(!(new_keys %in% old_keys))
#     insert_rows <- if (length(insert_idx) > 0)
#       hot_data[insert_idx, , drop = FALSE] else NULL
#
#     # -------------------------------
#     # 2️⃣ DETECT DELETES
#     # -------------------------------
#     delete_idx <- which(!(old_keys %in% new_keys))
#     delete_rows <- if (length(delete_idx) > 0)
#       old_data[delete_idx, , drop = FALSE] else NULL
#
#     # -------------------------------
#     # 3️⃣ DELETE AUDIT
#     # -------------------------------
#     if (enable_audit && !is.null(delete_rows) && nrow(delete_rows) > 0) {
#
#       for (i in seq_len(nrow(delete_rows))) {
#
#         record_key <- event
#
#         audit_entries <- rbind(
#           audit_entries,
#           data.frame(
#             table_name  = table_name,
#             source_name = source_name,
#             record_key  = record_key,
#             column_name = "Deemed Delete",
#             old_value   = paste(delete_rows[i, insert_cols], collapse = " | "),
#             new_value   = NA,
#             action_type = "DELETE",
#             changed_by  = user_id,
#             stringsAsFactors = FALSE
#           )
#         )
#       }
#     }
#
#     # -------------------------------
#     # 4️⃣ INSERT DATA + INSERT AUDIT
#     # -------------------------------
#     if (!is.null(insert_rows) && nrow(insert_rows) > 0) {
#
#       cols_db <- paste0("[", insert_cols, "]", collapse = ", ")
#       placeholders <- paste(rep("?", length(insert_cols)), collapse = ", ")
#
#       sql_insert <- paste0(
#         "INSERT INTO ", table_name,
#         " (", cols_db, ") VALUES (", placeholders, ")"
#       )
#
#       for (i in seq_len(nrow(insert_rows))) {
#
#         row <- insert_rows[i, , drop = FALSE]
#
#         dbExecute(conn, sql_insert, params = as.list(row[insert_cols]))
#
#         if (enable_audit && !is.null(source_name)) {
#
#           record_key <- event
#
#           audit_entries <- rbind(
#             audit_entries,
#             data.frame(
#               table_name  = table_name,
#               source_name = source_name,
#               record_key  = record_key,
#               column_name = "Deemed Insert",
#               old_value   = NA,
#               new_value   = paste(row[insert_cols], collapse = " | "),
#               action_type = "INSERT",
#               changed_by  = user_id,
#               stringsAsFactors = FALSE
#             )
#           )
#         }
#       }
#     }
#
#     # -------------------------------
#     # 5️⃣ WRITE AUDIT
#     # -------------------------------
#     if (enable_audit && nrow(audit_entries) > 0) {
#       dbAppendTable(
#         conn,
#         Id(schema = "dbo", table = "audit_trail"),
#         audit_entries
#       )
#     }
#
#     dbCommit(conn)
#
#     list(success = TRUE, message = "Saved with audit")
#
#   }, error = function(e) {
#
#     dbRollback(conn)
#
#     list(
#       success = FALSE,
#       message = e$message,
#       errors = errors
#     )
#   })
# }

# -------------------------------
# AJAX Update Handsontable Global Function
# -------------------------------
ajax_update_handsontable <- function(shiny_session, table_id, data) {
  # Log to console for visibility
  print(paste("[SERVER] AJAX Update Triggered for:", table_id, "at", Sys.time()))
  print(paste("[SERVER] Payload size (rows):", nrow(data)))

  # Send custom message to client
  shiny_session$sendCustomMessage(
    "updateRHandsontable",
    list(id = table_id, data = jsonlite::toJSON(data, dataframe = "rows", rownames = FALSE))
  )
}

# -------------------------------
# Smart Renderer for AJAX rhandsontable
# -------------------------------
render_smart_table <- function(
    output, shiny_session,
    id, # Element ID (e.g. 'mda_sig')
    data, # Full Data Frame
    initialized_var, # ReactiveVal for initialization state
    # Update options
    exclude_update_cols = NULL, # Columns to remove during AJAX update (e.g. 'Id')
    # Customization hook
    post_process = NULL, # Function to apply extra hot_col/hot_table calls
    # StyledHandsontableUniversal arguments passed via ...
    ...) {
  # Check if table is already initialized
  if (!initialized_var()) {
    # --- INITIALIZATION ---
    output[[id]] <- renderRHandsontable({
      # Base table configuration
      ht <- StyledHandsontableUniversal(data, ...)

      # Apply custom post-processing if provided (e.g. for ppm_sig visual hiding)
      if (!is.null(post_process)) {
        ht <- post_process(ht)
      }
      ht
    })

    # Mark as initialized
    initialized_var(TRUE)
  } else {
    # --- AJAX UPDATE ---
    data_to_send <- data

    # Remove columns if requested (for tables that hide Id completely)
    if (!is.null(exclude_update_cols)) {
      data_to_send <- data_to_send[, !names(data_to_send) %in% exclude_update_cols, drop = FALSE]
    }

    # Call the global AJAX function
    ajax_update_handsontable(shiny_session, id, data_to_send)
  }
}
