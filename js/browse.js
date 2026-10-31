// Browse page: re-run the search as soon as a genre, status or sort option changes.
// This is a normal form submit (full page reload), not AJAX.

function submitFilters() {
    var form = document.getElementById("filterForm");
    // text fields that fail their pattern check (e.g. a bad serial number) block the auto-submit
    if (form.checkValidity()) {
        form.submit();
    } else {
        form.reportValidity();
    }
}

document.addEventListener("DOMContentLoaded", function () {
    var options = document.querySelectorAll("#filterForm input[type=checkbox], #filterForm input[type=radio], #filterForm select");
    for (var i = 0; i < options.length; i++) {
        options[i].addEventListener("change", submitFilters);
    }
});
