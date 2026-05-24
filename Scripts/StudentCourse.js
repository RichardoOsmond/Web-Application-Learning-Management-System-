document.addEventListener("DOMContentLoaded", function() {
    var searchInput = document.getElementById("courseSearchBar");
    if (!searchInput) { return; }

    searchInput.addEventListener("input", function () {
        var courseNameSearch = searchInput.value.toLowerCase().trim();
        var listCourses = document.getElementsByClassName("course_container");

        for (var i = 0; i < listCourses.length; i++) {
            var coursesName = listCourses[i].getElementsByClassName("course_name")[0];
            var courseName = coursesName ? coursesName.textContent.toLowerCase() : "";

            if (courseName.indexOf(courseNameSearch) !== -1) {
                listCourses[i].style.display = "";
            } else {
                listCourses[i].style.display = "none";
            }
        }
    })
})