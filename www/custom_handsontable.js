$(document).on('shiny:connected', function () {
  Shiny.addCustomMessageHandler('updateRHandsontable', function (message) {
    console.log("[AJAX] Received updateRHandsontable message for ID:", message.id);
    console.log("[AJAX] Data payload size:", message.data ? message.data.length : 0);

    var el = document.getElementById(message.id);
    if (el) {
      var hot = $(el).handsontable('getInstance');
      if (hot) {
        console.log("[AJAX] Found Handsontable instance and element. Proceeding with update.");

        // --- 1. Capture State (Scroll & Selection) ---
        var selection = hot.getSelected();
        var holder = hot.rootElement.querySelector('.wtHolder');
        var scrollTop = holder ? holder.scrollTop : 0;
        var scrollLeft = holder ? holder.scrollLeft : 0;

        console.log("[AJAX] State captured - ScrollTop:", scrollTop, "Selection:", selection);

        // --- 2. Update Data ---
        hot.loadData(message.data);
        console.log("[AJAX] Data loaded successfully.");

        // --- 3. Restore State ---
        if (selection && selection.length > 0) {
          // selectCell(row, col, endRow, endCol, scrollToCell, changeListener)
          hot.selectCell(selection[0][0], selection[0][1], selection[0][2], selection[0][3], false, false);
        }

        if (holder) {
          holder.scrollTop = scrollTop;
          holder.scrollLeft = scrollLeft;
        }
        console.log("[AJAX] State restored.");

        // --- 4. Visual Feedback (Flash Green Border) ---
        // This confirms to the user that the AJAX update executed
        var originalBorder = el.style.border;
        el.style.border = "3px solid #28a745"; // Green highlight
        setTimeout(function () {
          el.style.border = originalBorder;
        }, 500); // Remove after 500ms
      } else {
        console.warn("[AJAX] Element found but Handsontable instance missing for ID:", message.id);
      }
    } else {
      console.error("[AJAX] Element not found for ID:", message.id);
    }
  });
});
