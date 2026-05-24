var currentItem = 0;

function slideCourse(direction) {
    var listCourses = document.getElementById("listCourses");
    if (!listCourses) { return; }

    var items = listCourses.getElementsByClassName("item");
    var totalItems = items.length;
    if (totalItems === 0) { return; }

    var visibleCount = 2;
    var itemWidth = 400;

    currentItem += direction;
    var maxIndex = totalItems - visibleCount;
    if (maxIndex < 0) { maxIndex = 0; }
    if (currentItem < 0) { currentItem = maxIndex; }
    if (currentItem > maxIndex) { currentItem = 0; }

    listCourses.style.transform = "translateX(-" + (currentItem * itemWidth) + "px)";
}