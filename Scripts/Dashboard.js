function toggleNotificationPanel() {
    var panel = document.getElementById("notificationPanel");
    if (panel) {
        panel.classList.toggle("is-open");
    }
}

document.addEventListener("click", function (e) {
    var panel = document.getElementById("notificationPanel");
    if (!panel) { return; }

    var clickedBell = e.target.closest("[title='Notification']");
    var clickedInsidePanel = panel.contains(e.target);

    if (!clickedBell && !clickedInsidePanel) {
        panel.classList.remove("is-open");
    }
})