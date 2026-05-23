var currentItem = 0;

function slideCourse(direction) {
    var list = document.getElementById("listCourses");
    if (!list) { return; }

    var items = list.getElementsByClassName("item");
    var totalItems = items.length;
    if (totalItems === 0) { return; }

    var visibleCount = 2;
    var itemWidth = 400;

    currentItem += direction;
    var maxIndex = totalItems - visibleCount;
    if (maxIndex < 0) { maxIndex = 0; }
    if (currentItem < 0) { currentItem = maxIndex; }
    if (currentItem > maxIndex) { currentItem = 0; }

    list.style.transform = "translateX(-" + (currentItem * itemWidth) + "px)";
}