# Master Guide: Adding a New AJAX Table (End-to-End)

This guide provides a complete, copy-paste blueprint for adding a new table to your application. It covers the full lifecycle: **Event Trigger → Data Fetch → Smart Render → Save → AJAX Refresh**.

We will use a hypothetical table named **`fuel_logs`** as an example.

---

## 1. Database Prerequisite (SQL)
Ensure your table exists in the database.
```sql
CREATE TABLE dbo.fuel_logs (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Date DATETIME,
    Liters FLOAT,
    Cost FLOAT,
    Remarks NVARCHAR(255)
);
```

---

## 2. UI Definition (`app.R`)
Add the table output to your tab definition in the UI section.
```r
# In your dashboardBody or tabItem:
box(
  title = "Fuel Logs", 
  status = "primary", 
  solidHeader = TRUE, 
  width = 12,
  
  # The Table Output
  rHandsontableOutput("fuel_logs_table"),
  
  # The Save Button
  actionButton("save_fuel_logs", "Save Changes", icon = icon("save"), class = "btn-success")
)
```

---

## 3. Server Flags (`app.R`)
Initialize a reactive flag at the top of your `server` function. This tracks if the table has been loaded yet.
```r
server <- function(input, output, session) {
  # ... existing flags ...
  
  # NEW FLAG
  fuel_logs_initialized <- reactiveVal(FALSE)
  
  # ...
}
```

---

## 4. The "View" Logic (Event Trigger)
This handles **tab switching**. It fetches data and renders the table (or updates it via AJAX if already open).

```r
# Trigger when user clicks the "Fuel" tab
observeEvent(input$sidebarID, {
  if (input$sidebarID == "fuel_tab") {
    
    # A. Fetch Data
    conn <- db_connection()
    df_fuel <- dbGetQuery(conn, "SELECT Id, Date, Liters, Cost, Remarks FROM dbo.fuel_logs")
    dbDisconnect(conn)
    
    # B. Render Smart Table (Handles Init + AJAX Update automatically)
    render_smart_table(
      output, session, 
      id = "fuel_logs_table",         # Must match UI ID
      data = df_fuel,                 # Dataframe from DB
      initialized_var = fuel_logs_initialized, # Flag from Step 3
      
      # Configuration
      height = 500,
      editable_cols = c("Date", "Liters", "Cost", "Remarks"),
      hidden_cols = c("Id"),          # Hide ID from user
      exclude_update_cols = c("Id")   # Don't overwrite ID in R (AJAX optimization)
    )
  }
})
```

---

## 5. The "Save" Logic (Save + Auto-Refresh)
This handles the **Save Button**. It writes to the DB and then *immediately* pushes the new data back to the browser using AJAX.

```r
observeEvent(input$save_fuel_logs, {
  # 1. Show Loading
  save_id <- showNotification("Saving...", type = "message", duration = NULL)
  
  tryCatch({
    # 2. Get Data from UI
    hot_data <- hot_to_r(input$fuel_logs_table)
    
    # 3. Save to Database (Using your existing global save functions)
    #    (Assumes you split Insert/Update logic here, similar to other tables)
    conn <- db_connection()
    # ... perform DB Insert/Update logic ...
    dbDisconnect(conn)
    
    # 4. SUCCESS: Auto-Refresh Logic
    showNotification("Saved successfully!", type = "message")
    
    # --- AUTO-REFRESH START ---
    # A. Re-fetch fresh data (to get new IDs, formatting, etc.)
    conn <- db_connection()
    df_fresh <- dbGetQuery(conn, "SELECT Id, Date, Liters, Cost, Remarks FROM dbo.fuel_logs")
    dbDisconnect(conn)
    
    # B. Send AJAX Update (Global Function)
    #    This updates the table without refreshing the iframe/scroll
    ajax_update_handsontable(session, "fuel_logs_table", df_fresh)
    # --- AUTO-REFRESH END ---
    
  }, error = function(e) {
    showNotification(paste("Error:", e$message), type = "error")
  }, finally = {
    removeNotification(save_id)
  })
})
```

---

## Summary of Global Functions Used
*   **`render_smart_table`**: Handles the `if(!initialized) { render } else { ajax }` logic for you.
*   **`ajax_update_handsontable`**: Sends the new data to the browser via `session$sendCustomMessage`.
