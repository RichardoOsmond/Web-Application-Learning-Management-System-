window.onload = function () {
    var scrollPos = sessionStorage.getItem('scrollPos');
    if (scrollPos) {
        document.documentElement.scrollTop = parseInt(scrollPos);
        sessionStorage.removeItem('scrollPos');
    }
    document.body.style.opacity = '1';
}

document.addEventListener("DOMContentLoaded", function () {
    var uploadPath = document.querySelector('[id$="hdnUploadPath"]').value;
    tinymce.init({
        selector: '.tinymce-editor',
        height: 900,
        plugins: 'lists link image media table code wordcount',
        toolbar: 'undo redo | fontfamily fontsize | styles | bold italic | alignleft aligncenter alignright | image media | code',
        font_size_formats: '8pt 10pt 12pt 14pt 16pt 18pt 24pt 36pt 48pt',

        // --- IMAGE EMBEDDING CONFIGURATION ---
        relative_urls: false,
        remove_script_host: true,

        automatic_uploads: true,
        images_upload_url: 'UploadHandler.ashx?folder=' + uploadPath,

        content_style: 'body { font-family: Helvetica,Arial,sans-serif; font-size: 16px; } img { max-width: 100%; height: auto; }'
    });

    // Grab the HTML elements using their class names
    var nameInput = document.querySelector('.name-input');
    var saveButton = document.querySelector('[id$="btnSave"], [id$="btnExitNSave"]');
    var cardTextInput = document.querySelector('.card-text-input')
    var addCardButton = document.querySelector('[id$="btnAddCard"]')
    var cardImageUpload = document.querySelector('[id$="cardImageUpload"]');


    function toggleButtonState() {
        console.log("text:", cardTextInput.value, "files:", cardImageUpload.files.length, "cardEditMode:", cardEditMode);
        if (nameInput.value.trim() === "") {
            saveButton.disabled = true;  // Gray out if empty
        } else {
            saveButton.disabled = false; // Light it up if there is text
        }
        if (cardTextInput.value.trim() === "" || (cardImageUpload.files.length === 0 && cardEditMode !== true)) {
            addCardButton.disabled = true;
        } else {
            addCardButton.disabled = false;
        }
    }

    // Run it immediately on page load
    toggleButtonState();

    // Listen for typing events on the input field dynamically
    nameInput.addEventListener('input', toggleButtonState);
    cardTextInput.addEventListener('input', toggleButtonState);
    cardImageUpload.addEventListener('change', toggleButtonState);
});



function enableCardEdit() {
    document.querySelectorAll('.card-actions').forEach(function (a) {
        a.classList.add('visible');
    });
}

function disableCardEdit() {
    document.querySelectorAll('.card-actions').forEach(function (a) {
        a.classList.remove('visible');
    });
}

function saveScrollPosition() {
    sessionStorage.setItem('scrollPos', window.scrollY);
}

function highlightEditCard(flashcardID) {
    // hide all card actions first
    document.querySelectorAll('.card-actions').forEach(function (a) {
        a.style.display = 'none';
    });

    // find the selected card's actions and show only delete
    document.querySelectorAll('.flashcard-wrapper').forEach(function (wrapper) {
        var editBtn = wrapper.querySelector('[data-id="' + flashcardID + '"]');
        if (editBtn) {
            var actions = wrapper.querySelector('.card-actions');
            actions.style.display = 'flex';
            actions.querySelector('.edit-link').style.display = 'none';
        }
    });
}