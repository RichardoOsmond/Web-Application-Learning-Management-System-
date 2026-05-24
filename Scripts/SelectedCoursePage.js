function toggleSection(panelId, title) {
    var panel = document.querySelector('[id$="' + panelId + '"]');
    var arrow = title.querySelector('.arrow-icon');
    panel.classList.toggle('open');
    arrow.classList.toggle('arrow-rotate');
}

function moveLessonToLeft() {
    var leftCol = document.querySelector('.left-column');
    var middleCol = document.querySelector('.middle-column');
    var lessonList = document.querySelector('.lesson-list-big');

    leftCol.classList.remove('left-column-center');
    lessonList.classList.remove('lesson-list-big');
    lessonList.classList.add('lesson-list-small');

    var links = document.querySelectorAll('.lesson-link');
    links.forEach(function (link) {
        link.classList.remove('lesson-link-big');
    });

    middleCol.classList.remove('hidden');
}

window.addEventListener('DOMContentLoaded', function () {
    // check if active (highlighting) is not null
    var hasActive = document.querySelector('.lesson-link.active') !== null;
    if (hasActive) {
        moveLessonToLeft();
    } else {
        // nothing is active
        var links = document.querySelectorAll('.lesson-link');
        links.forEach(function (link) {
            link.classList.add('lesson-link-big');
        });
    }
});