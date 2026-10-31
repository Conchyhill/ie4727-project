// Home page scripts: Trending list scroll buttons.
// The Today / This week highlight is set by index.php from ?period=.

// Scroll the trending list by roughly one visible width.
// direction: -1 = left, 1 = right
function scrollTrending(direction) {
    var list = document.getElementById("trendingList");
    list.scrollBy({ left: direction * list.clientWidth * 0.8, behavior: "smooth" });
}

// Disable the arrow button when the list is already at that end.
function updateScrollButtons() {
    var list = document.getElementById("trendingList");
    var prev = document.querySelector(".scrollPrev");
    var next = document.querySelector(".scrollNext");
    prev.disabled = list.scrollLeft <= 0;
    next.disabled = list.scrollLeft + list.clientWidth >= list.scrollWidth - 1;
}

document.addEventListener("DOMContentLoaded", function () {
    var list = document.getElementById("trendingList");

    document.querySelector(".scrollPrev").addEventListener("click", function () {
        scrollTrending(-1);
    });
    document.querySelector(".scrollNext").addEventListener("click", function () {
        scrollTrending(1);
    });
    list.addEventListener("scroll", updateScrollButtons);
    window.addEventListener("resize", updateScrollButtons);

    updateScrollButtons();
});
