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

function enableSort() {
    var numbers = document.querySelectorAll('.item-number');
    numbers.forEach(function (n) {
        n.style.display = 'inline';
    });

    var list = document.querySelector('[id$="materialPanel"]');
    var sortable = new Sortable(list, {
        animation: 150,
        onEnd: function (evt) {
            var items = document.querySelectorAll('.material-item');
            var order = [];
            items.forEach(function (item) {
                order.push(item.getAttribute('data-id'));
            });
            document.querySelector('[id$="hdnOrder"]').value = order.join(',');
        }
    });
    document.querySelector('[id$="saveOrderBtn"]').style.display = 'block';
}

function cancelSort() {
    var numbers = document.querySelectorAll('.item-number');
    numbers.forEach(function (n) {
        n.style.display = 'none';
    });
    document.querySelector('[id$="saveOrderBtn"]').style.display = 'none';
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
    document.querySelector('[id$="confirmLessonBtn"]').value = 'DeleteL';
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