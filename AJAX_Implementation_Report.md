# AJAX Implementation for PPM Signals Table

This report documents the AJAX-style update mechanism implemented for the "PPM Signals" table (`ppm_sig`) in your Shiny application.

## 1. Overview
**Goal:** To update the data in the "PPM Signals" table dynamically without removing and re-drawing the entire table interface.
**Benefit:** prevents screen "flickering," maintains the user's scroll position, and keeps the current cell selection active when data refreshes.

---

## 2. Server-Side Logic (`app.R`)

The logic resides inside the `observeEvent(input$sidebarID, ...)` block for the "parameterization" tab.

### The Logic Flow
The code checks a "flag" (`ppm_sig_initialized`) to decide whether to draw the table from scratch or just send new data.

```r
# Check if this is the FIRST time we are loading the table
if (!ppm_sig_initialized()) {

  # --- METHOD A: INITIALIZATION (First Load) ---
  # This runs only once. It builds the full HTML/JS widget.
  output$ppm_sig <- renderRHandsontable({
    StyledHandsontableUniversal(
      table_ppm_sig, 
      height = 600,
      editable_cols = c("TagName", "Description", "Unit"),
      hidden_cols = NULL  # CRITICAL: We DO NOT hide 'Id' here, or it disappears from data model
    ) %>% 
    # We visually hide 'Id' by shrinking it to 0.1 width and disabling text wrap.
    # This prevents the "Tall Rows" visual bug.
    rhandsontable::hot_col(col = "Id", width = 0.1, wordWrap = FALSE)
  })
  
  # Set the flag to TRUE so this block never runs again for this session
  ppm_sig_initialized(TRUE)

} else { 

  # --- METHOD B: AJAX UPDATE (Subsequent Loads) ---
  # This runs every time the data needs refreshing after the first time.
  
  # We send the FULL table data (including the hidden 'Id') to the browser.
  # 'jsonlite::toJSON' converts the R dataframe into a JavaScript-compatible array of objects.
  session$sendCustomMessage(
    "updateRHandsontable",                                     # The name of our Custom Event
    list(id = "ppm_sig", data = jsonlite::toJSON(table_ppm_sig, dataframe = "rows", rownames = FALSE)) # The Payload
  )
}
```

---

## 3. Client-Side Logic (`custom_handsontable.js`)

This JavaScript file acts as the "Receiver." It listens for the message sent by R and performs the surgical data update.

```javascript
// Wait for Shiny to connect to the browser
$(document).on('shiny:connected', function() {

  // Register a handler for the "updateRHandsontable" message type we used in R
  Shiny.addCustomMessageHandler('updateRHandsontable', function(message) {
    
    // 1. Locate the HTML element for the table (e.g., div id="ppm_sig")
    var el = document.getElementById(message.id);

    if (el) {
      // Get the existing Handsontable instance attached to this element
      var hot = $(el).handsontable('getInstance');
      
      if (hot) {
        // --- STEP 1: CAPTURE STATE ---
        // Before updating, save where the user is looking and what they selected.
        var selection = hot.getSelected(); // Returns [row, col, endRow, endCol]
        var holder = hot.rootElement.querySelector('.wtHolder'); // The scrollable container
        var scrollTop = holder ? holder.scrollTop : 0;
        var scrollLeft = holder ? holder.scrollLeft : 0;

        // --- STEP 2: UPDATE DATA ---
        // This is the core AJAX action. 'loadData' swaps the underlying data array
        // and repaints the grid cells WITHOUT destroying the grid instance itself. 
        hot.loadData(message.data);

        // --- STEP 3: RESTORE STATE ---
        // Re-apply the selection if one existed
        if (selection && selection.length > 0) {
          hot.selectCell(selection[0][0], selection[0][1], selection[0][2], selection[0][3], false, false);
        }
        
        // Restore the scroll position so the user doesn't jump to the top
        if (holder) {
          holder.scrollTop = scrollTop;
          holder.scrollLeft = scrollLeft;
        }
      }
    }
  });
});
```

## 4. Summary Flow

1.  **R Server**: "Oh, the data changed! Is the table already updated? Yes? Okay, don't redraw it. Just take this Data Packet (JSON)." -> **`sendCustomMessage`**
2.  **Browser**: "I received a message type `updateRHandsontable`."
3.  **JavaScript**: 
    *   "Hold on, let me remember where the user scrolled."
    *   "Okay, swap the old data for this new Data Packet."
    *   "Now put the user's scroll position back exactly where it was."
4.  **Result**: The numbers on the screen change instantly, but the table structure stays rock solid.
