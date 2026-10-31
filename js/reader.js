// Chapter reader: text size buttons, chapter drop-down and arrow-key navigation.

var MIN_FONT = 14;
var MAX_FONT = 26;

// Change the chapter text size by step pixels and remember it for the next chapter
function changeFontSize(step) {
    var text = document.querySelector(".chapterText");
    if (!text) {
        return;
    }
    var size = parseInt(window.getComputedStyle(text).fontSize, 10) + step * 2;
    size = Math.max(MIN_FONT, Math.min(MAX_FONT, size));
    text.style.fontSize = size + "px";
    try {
        localStorage.setItem("readerFontSize", size);
    } catch (e) {
        // storage blocked (e.g. private window); the size just won't be remembered
    }
}

function restoreFontSize() {
    var text = document.querySelector(".chapterText");
    var saved = null;
    try {
        saved = localStorage.getItem("readerFontSize");
    } catch (e) {
        saved = null;
    }
    if (text && saved) {
        text.style.fontSize = saved + "px";
    }
}

// Left / right arrow keys follow the Previous / Next links (ignored while typing in a field)
function handleArrowKeys(event) {
    var tag = event.target.tagName;
    if (tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT") {
        return;
    }
    var link = null;
    if (event.key === "ArrowLeft") {
        link = document.querySelector("a[data-nav=prev]");
    } else if (event.key === "ArrowRight") {
        link = document.querySelector("a[data-nav=next]");
    }
    if (link) {
        window.location.href = link.href;
    }
}

document.addEventListener("DOMContentLoaded", function () {
    restoreFontSize();

    var buttons = document.querySelectorAll("[data-font]");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].addEventListener("click", function () {
            changeFontSize(parseInt(this.dataset.font, 10));
        });
    }

    // picking a chapter from the drop-down opens it straight away
    var selects = document.querySelectorAll(".chapterSelect");
    for (var j = 0; j < selects.length; j++) {
        selects[j].addEventListener("change", function () {
            this.form.submit();
        });
    }

    document.addEventListener("keydown", handleArrowKeys);
});
