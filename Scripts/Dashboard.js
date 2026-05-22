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
    var clickedInsideNotificationsPanel = panel.contains(e.target);

    if (!clickedBell && !clickedInsideNotificationsPanel) {
        panel.classList.remove("is-open");
    }
})

function toggleChatPanel() {
    var panel = document.getElementById("chatPanel");
    if (panel) {
        panel.classList.toggle("is-open");
    }
}

document.addEventListener("click", function (e) {
    var panel = document.getElementById("chatPanel");
    if (!panel) { return; }

    var clickedChat = e.target.closest("[title='Chat']")
    var clickedInsideChatPanel = panel.contains(e.target);

    if (!clickedChat && !clickedInsideChatPanel) {
        panel.classList.remove("is-open");
    }
})