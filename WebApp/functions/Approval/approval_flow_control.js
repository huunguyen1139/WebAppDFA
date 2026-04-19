
/* ---------- drop-down “Action” menu ----------------------------- */
document.querySelectorAll('ul.dropdown-menu a[data-cmd]').forEach(a=>{
        a.addEventListener('click', e => {
            const cmd = a.dataset.cmd;
            switch (cmd) {
                case 'send': confirmSend(); break;
                case 'cancel': confirmCancel(); break;
                case 'template': showTemplate(); break;
                case 'entry': showEntry(); break;
            }
        });
});

    /* ---------- Send / Cancel -------------------------------------- */
    function confirmSend(){
        Swal.fire({ title: 'Send for approval?', icon: 'question', showCancelButton: true })
            .then(r => {
                if (r.isConfirmed) {
                    __doPostBack('<%= UniqueID %>', 'send');
                }
            });
}
    function confirmCancel(){
        Swal.fire({ title: 'Cancel this approval?', icon: 'warning', showCancelButton: true })
            .then(r => {
                if (r.isConfirmed) {
                    __doPostBack('<%= UniqueID %>', 'cancel');
                }
            });
}

/* ---------- Approve / Reject buttons --------------------------- */
btnApprove.addEventListener('click', ()=> askComment('Approve?', 'approve'));
btnReject .addEventListener('click', ()=> askComment('Reject?',  'reject'));

    function askComment(title, cmd){
        Swal.fire({ title, input: 'textarea', showCancelButton: true, confirmButtonText: 'Submit' })
            .then(r => {
                if (r.isConfirmed) {
                    document.getElementById('<%= hfComment.ClientID %>').value = r.value || '';
                    __doPostBack('<%= UniqueID %>', cmd);
                }
            });
}

    /* ---------- Template wizard ------------------------------------ */
    function showTemplate(){
   // clone current rows into the modal list
   const tpl = document.getElementById('tplList');
    tpl.innerHTML = document.getElementById('flowBody').innerHTML
    .replaceAll('<tr','<div').replaceAll('</tr>','</div > ')   // quick convert → divs
        .replaceAll('<td', '<span').replaceAll('</td>', '');
new Sortable(tpl, { animation: 150 });

new bootstrap.Modal('#mdlTemplate').show();
}

/* ---------- Instance entry ------------------------------------- */
function showEntry() {
    fetch('FlowAjax.aspx?doc=<%= DocId %>')      // tiny handler returns JSON rows
        .then(r => r.json())
        .then(data => {
            const body = document.getElementById('entryBody');
            body.innerHTML = data.map((r, i) => `
            <tr><td>${i + 1}</td><td>${r.ApproverId}</td><td>${r.Status}</td>
                <td>${r.Comment || ''}</td><td>${r.ActionOn || ''}</td></tr>`).join('');
            new bootstrap.Modal('#mdlEntry').show();
        });
}

/* ---------- per-row actions (up / down / delete) --------------- */
document.getElementById('flowBody').addEventListener('click', e => {
    const btn = e.target.closest('button[data-cmd]');
    if (!btn) return;
    const tr = btn.closest('tr');
    const cmd = btn.dataset.cmd;
    if (cmd === 'del') tr.remove();
    if (cmd === 'up' && tr.previousElementSibling) tr.parentNode.insertBefore(tr, tr.previousElementSibling);
    if (cmd === 'down' && tr.nextElementSibling) tr.parentNode.insertBefore(tr.nextElementSibling, tr);
});

