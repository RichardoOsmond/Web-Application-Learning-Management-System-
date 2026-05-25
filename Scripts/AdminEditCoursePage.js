window.onload = function () {
    document.querySelector('[id$="aDeleteBtn"]').disabled = selectedLessonID <= 0;
}

function toggleSection(panelId, title) {
    var panel = document.querySelector('[id$="' + panelId + '"]');
    var arrow = title.querySelector('.arrow-icon');
    panel.classList.toggle('open');
    arrow.classList.toggle('arrow-rotate');
}

function showMaterialOnly() {
    document.getElementById('materialSection').classList.remove('hidden');
    document.getElementById('quizSection').classList.add('hidden');
}

function showQuizOnly() {
    document.getElementById('quizSection').classList.remove('hidden');
    document.getElementById('materialSection').classList.add('hidden');
}

function enableSort(panelSuffix) {
    var numbers = document.querySelectorAll('.item-number');
    numbers.forEach(function (n) {
        n.style.display = 'inline';
    });
    var list = document.querySelector('[id$="' + panelSuffix + '"]');
    var sortable = new Sortable(list, {
        animation: 150,
        onEnd: function (evt) {
            var items = list.querySelectorAll('[data-id]');
            var order = [];
            items.forEach(function (item) {
                order.push(item.getAttribute('data-id'));
            });
            document.querySelector('[id$="hdnOrder"]').value = order.join(',');
        }
    });
    var saveBtn = panelSuffix === 'materialPanel'
        ? document.querySelector('[id$="saveOrderBtn"]')
        : document.querySelector('[id$="qSaveOrderBtn"]');
    saveBtn.style.display = 'block';
}

function cancelSort() {
    var numbers = document.querySelectorAll('.item-number');
    numbers.forEach(function (n) {
        n.style.display = 'none';
    });
    var saveBtn = document.querySelector('[id$="saveOrderBtn"]');
    var qSaveBtn = document.querySelector('[id$="qSaveOrderBtn"]');
    if (saveBtn) saveBtn.style.display = 'none';
    if (qSaveBtn) qSaveBtn.style.display = 'none';
}

function openAddModal() {
    document.getElementById('modalTitle').innerText = 'Add Lesson';
    document.getElementById('addLessonContent').style.display = 'block';
    document.getElementById('deleteLessonContent').style.display = 'none';
    document.querySelector('[id$="hdnModalMode"]').value = 'Add';
    document.getElementById('addLessonModal').style.display = 'flex';
    document.querySelector('[id$="confirmLessonBtn"]').value = 'Add';
}
function closeModal() {
    document.getElementById('addLessonModal').style.display = 'none';
}
function openLessonDeleteModal() {
    document.getElementById('modalTitle').innerText = 'Delete Lesson';
    document.getElementById('addLessonContent').style.display = 'none';
    document.getElementById('deleteLessonContent').style.display = 'block';
    document.querySelector('[id$="hdnModalMode"]').value = 'DeleteL';
    document.getElementById('addLessonModal').style.display = 'flex';
    document.querySelector('[id$="confirmLessonBtn"]').value = 'Delete';
}

function openMaterialDeleteModal() {
    document.getElementById('modalTitle').innerText = 'Delete Material';
    document.getElementById('addLessonContent').style.display = 'none';
    document.getElementById('deleteMaterialContent').style.display = 'block';
    document.querySelector('[id$="hdnModalMode"]').value = 'DeleteM';
    document.getElementById('addLessonModal').style.display = 'flex';
    document.querySelector('[id$="confirmLessonBtn"]').value = 'Delete';
}

function openQuizDeleteModal() {
    document.getElementById('modalTitle').innerText = 'Delete Material';
    document.getElementById('addLessonContent').style.display = 'none';
    document.getElementById('deleteQuizContent').style.display = 'block';
    document.querySelector('[id$="hdnModalMode"]').value = 'DeleteQ';
    document.getElementById('addLessonModal').style.display = 'flex';
    document.querySelector('[id$="confirmLessonBtn"]').value = 'Delete';
}