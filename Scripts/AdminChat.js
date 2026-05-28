document.addEventListener("DOMContentLoaded", function () {
    var searchInput = document.getElementById("studentSearchBar");
    if (!searchInput) { return; }

    searchInput.addEventListener("input", function () {
        var student = searchInput.value.toLowerCase().trim();
        var students = document.getElementsByClassName("student_item");

        for (var i = 0; i < students.length; i++) {
            var studentName = students[i].getElementsByClassName("student_name")[0];
            var name = studentName ? studentName.textContent.toLowerCase() : "";
            students[i].style.display = (name.indexOf(student) !== -1) ? "" : "none";
        }
    });
});