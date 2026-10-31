// Form helpers used across the site: client-side validation with inline messages,
// password strength meter, character counters, image previews, login/sign-up tabs
// and confirm dialogs. PHP repeats every check on the server.

// ---------- Validation ----------

// The <p class="fieldError"> that belongs to a field (the next one after it, or inside its fieldset)
function findErrorBox(field) {
    var start = field;
    if (field.type === "radio" || field.type === "checkbox") {
        start = field.closest("fieldset") || field.closest("label") || field;
        var inner = start.tagName === "FIELDSET" ? start.querySelector(":scope > .fieldError") : null;
        if (inner) {
            return inner;
        }
    }
    var el = start.nextElementSibling;
    while (el) {
        if (el.classList.contains("fieldError")) {
            return el;
        }
        if (/^(LABEL|INPUT|SELECT|TEXTAREA|FIELDSET|BUTTON)$/.test(el.tagName)) {
            break;
        }
        el = el.nextElementSibling;
    }
    // no box in the markup: add one after the field
    var box = document.createElement("p");
    box.className = "fieldError";
    start.parentNode.insertBefore(box, start.nextSibling);
    return box;
}

function showError(field, message) {
    findErrorBox(field).textContent = message;
    field.classList.toggle("invalid", message !== "");
    field.setAttribute("aria-invalid", message !== "" ? "true" : "false");
}

// Luhn checksum used by real card numbers
function luhnValid(number) {
    var sum = 0;
    var double = false;
    for (var i = number.length - 1; i >= 0; i--) {
        var digit = parseInt(number.charAt(i), 10);
        if (double) {
            digit *= 2;
            if (digit > 9) {
                digit -= 9;
            }
        }
        sum += digit;
        double = !double;
    }
    return sum % 10 === 0;
}

// Error message for one field, or "" if it is valid
function checkField(field) {
    var value = field.value.trim();
    var v = field.validity;

    if (v.valueMissing) {
        if (field.type === "radio") {
            return "Please choose an option.";
        }
        if (field.type === "checkbox") {
            return "Please tick this box to continue.";
        }
        if (field.type === "file") {
            return "Please choose a file.";
        }
        return field.tagName === "SELECT" ? "Please choose an option." : "This field is required.";
    }
    if (value === "" && field.type !== "file") {
        return "";  // optional and empty
    }
    if (v.typeMismatch && field.type === "email") {
        return "Enter a valid email address, e.g. name@example.com.";
    }
    if (field.minLength > 0 && value.length < field.minLength) {
        return "Must be at least " + field.minLength + " characters (currently " + value.length + ").";
    }
    if (v.patternMismatch) {
        return field.title || "Please use the format shown.";
    }
    if (v.rangeUnderflow || v.rangeOverflow) {
        return "Must be between " + field.min + " and " + field.max + ".";
    }
    if (v.stepMismatch || v.badInput) {
        return "Enter a number with at most 2 decimal places.";
    }

    // checks HTML5 attributes can't express
    if (field.dataset.match) {
        var other = document.getElementById(field.dataset.match);
        if (other && field.value !== other.value) {
            return "Passwords do not match.";
        }
    }
    if (field.id === "password" && !(/[A-Za-z]/.test(value) && /\d/.test(value))) {
        return "Include at least one letter and one number.";
    }
    if (field.id === "cardNumber") {
        var digits = value.replace(/[\s-]/g, "");
        if (!/^\d{13,19}$/.test(digits) || !luhnValid(digits)) {
            return "This card number is not valid.";
        }
    }
    if (field.id === "expiry") {
        var parts = value.split("/");
        var now = new Date();
        var expiry = (2000 + parseInt(parts[1], 10)) * 100 + parseInt(parts[0], 10);
        if (expiry < now.getFullYear() * 100 + now.getMonth() + 1) {
            return "This card has expired.";
        }
    }
    if (field.type === "file" && field.files.length > 0) {
        var file = field.files[0];
        if (["image/jpeg", "image/png", "image/gif", "image/webp"].indexOf(file.type) === -1) {
            return "Only JPG, PNG, GIF or WEBP images are allowed.";
        }
        if (field.dataset.maxSize && file.size > parseInt(field.dataset.maxSize, 10)) {
            return "Images must be 2 MB or smaller (this one is " + (file.size / 1048576).toFixed(1) + " MB).";
        }
    }
    return "";
}

// Validate every field in a form; returns true if the form can be submitted
function validateForm(form) {
    var fields = form.querySelectorAll("input:not([type=hidden]), select, textarea");
    var firstBad = null;
    var checkedGroups = {};

    for (var i = 0; i < fields.length; i++) {
        var field = fields[i];
        if (field.type === "radio") {
            if (checkedGroups[field.name]) {
                continue;  // one message per radio group
            }
            checkedGroups[field.name] = true;
        }
        var message = checkField(field);
        showError(field, message);
        if (message && !firstBad) {
            firstBad = field;
        }
    }

    // at most N tags on the create form
    var tagPicker = form.querySelector("#tagPicker");
    if (tagPicker) {
        var max = parseInt(tagPicker.dataset.max, 10);
        var chosen = tagPicker.querySelectorAll("input:checked").length;
        var tagBox = tagPicker.querySelector(".fieldError");
        tagBox.textContent = chosen > max ? "Choose at most " + max + " tags (" + chosen + " selected)." : "";
        if (chosen > max && !firstBad) {
            firstBad = tagPicker.querySelector("input");
        }
    }

    if (firstBad) {
        firstBad.focus();
        return false;
    }
    return true;
}

// ---------- Password strength ----------

function passwordScore(password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++;
    if (/\d/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;
    return Math.min(score, 4);
}

function updateStrength() {
    var bar = document.getElementById("strengthBar");
    var text = document.getElementById("strengthText");
    var labels = ["Too weak", "Weak", "Fair", "Good", "Strong"];
    var score = this.value === "" ? 0 : passwordScore(this.value);
    bar.style.width = (this.value === "" ? 0 : (score + 1) * 20) + "%";
    bar.className = "strength" + score;
    text.textContent = this.value === "" ? "At least 8 characters, with a letter and a number." : "Strength: " + labels[score];
}

// ---------- Character counters and image previews ----------

function updateCounter(counter, field) {
    var max = field.maxLength > 0 ? " / " + field.maxLength : "";
    counter.textContent = field.value.length + max + " characters";
}

function previewImage() {
    var img = document.getElementById(this.dataset.preview);
    if (img && this.files.length > 0 && checkField(this) === "") {
        var reader = new FileReader();
        reader.onload = function (event) {
            img.src = event.target.result;
        };
        reader.readAsDataURL(this.files[0]);
    }
}

// ---------- Login / sign-up tabs ----------

function showTab(panelId) {
    var panels = document.querySelectorAll(".tabPanel");
    var tabs = document.querySelectorAll(".tab");
    for (var i = 0; i < panels.length; i++) {
        panels[i].classList.toggle("active", panels[i].id === panelId);
    }
    for (var j = 0; j < tabs.length; j++) {
        tabs[j].classList.toggle("active", tabs[j].dataset.tab === panelId);
    }
}

// ---------- Set up ----------

document.addEventListener("DOMContentLoaded", function () {
    var i;

    // validate forms that opt out of the browser's own popups (novalidate)
    var forms = document.querySelectorAll("form[novalidate]");
    for (i = 0; i < forms.length; i++) {
        forms[i].addEventListener("submit", function (event) {
            if (!validateForm(this)) {
                event.preventDefault();
            } else if (this.id === "deleteForm" && !window.confirm("Delete your account permanently? This cannot be undone.")) {
                event.preventDefault();
            }
        });
        // clear a field's message once the user fixes it
        forms[i].addEventListener("change", function (event) {
            if (event.target.classList.contains("invalid")) {
                showError(event.target, checkField(event.target));
            }
        });
    }

    var strengthField = document.getElementById("password");
    if (strengthField && document.getElementById("strengthBar")) {
        strengthField.addEventListener("input", updateStrength);
    }

    var counters = document.querySelectorAll(".charCount[data-for]");
    for (i = 0; i < counters.length; i++) {
        (function (counter) {
            var field = document.getElementById(counter.dataset.for);
            updateCounter(counter, field);
            field.addEventListener("input", function () {
                updateCounter(counter, field);
            });
        })(counters[i]);
    }

    var fileInputs = document.querySelectorAll("input[type=file][data-preview]");
    for (i = 0; i < fileInputs.length; i++) {
        fileInputs[i].addEventListener("change", previewImage);
        fileInputs[i].addEventListener("change", function () {
            showError(this, checkField(this));
        });
    }

    // tab links switch panels without reloading; the URL still works without JS
    var tabLinks = document.querySelectorAll("[data-tab], [data-tab-link]");
    for (i = 0; i < tabLinks.length; i++) {
        tabLinks[i].addEventListener("click", function (event) {
            event.preventDefault();
            showTab(this.dataset.tab || this.dataset.tabLink);
            history.replaceState(null, "", this.href);
        });
    }

    // buttons that ask before doing something (e.g. remove from cart)
    var confirmButtons = document.querySelectorAll("[data-confirm]");
    for (i = 0; i < confirmButtons.length; i++) {
        confirmButtons[i].addEventListener("click", function (event) {
            if (!window.confirm(this.dataset.confirm)) {
                event.preventDefault();
            }
        });
    }

    // add a space every 4 digits as the card number is typed
    var card = document.getElementById("cardNumber");
    if (card) {
        card.addEventListener("input", function () {
            var digits = this.value.replace(/\D/g, "").substring(0, 19);
            this.value = digits.replace(/(\d{4})(?=\d)/g, "$1 ");
        });
    }
});
