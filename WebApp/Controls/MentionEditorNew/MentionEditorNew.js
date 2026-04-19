(function () {

    /* ---------- helper: init single editor ---------- */
    function coreInit(editor, hidden) {
        if (editor.dataset.newInit === "1") return;
        editor.dataset.newInit = "1";

        /* popup creation */
        const pop = document.createElement('div');
        pop.className = 'mention-popup-new';
        pop.style.display = 'none';
        document.body.appendChild(pop);

        function showPopup(items, pos) {
            pop.innerHTML = '';
            items.forEach(it => {
                const div = document.createElement('div');
                div.className = 'mention-item-new';

                /* 1 — avatar wrapper (always exists) */
                const avatarBox = document.createElement('span');
                avatarBox.style.display = 'inline-flex';
                avatarBox.style.width = avatarBox.style.height = '28px';
                avatarBox.style.borderRadius = '50%';
                avatarBox.style.overflow = 'hidden';
                avatarBox.style.flexShrink = '0';

                //create custom template for popup
                if (it.avatar) {
                    const img = new Image();

                    /* fallback only fires if THIS image fails */
                    img.onerror = function () {
                        img.onerror = null;
                        img.src = '/images/users/erroruser.png';
                    };
                    img.onload = () => avatarBox.appendChild(img);
                    img.src = it.avatar;
                } else {
                    /* initials fallback (no avatar url provided) */
                    avatarBox.textContent = (it.value || '?')[0].toUpperCase();
                    avatarBox.style.background = '#c7d2fe';
                    avatarBox.style.color = '#374151';
                    avatarBox.style.alignItems = avatarBox.style.justifyContent = 'center';
                    avatarBox.style.display = 'inline-flex';
                    avatarBox.style.fontSize = '13px';
                }

                const name = document.createElement('span');
                name.className = 'name text-primary fs-3';
                name.textContent = it.label;
                name.style.marginLeft = '8px';
                name.style.fontWeight = '500';

                div.appendChild(avatarBox);
                div.appendChild(name);

                //d.textContent = it.label;
                //d.onclick = () => { insertMention(it); hide(); };
                div.onclick = () => { insertMention(it); hide(); };
                pop.appendChild(div)

            });
            pop.style.left = pos.x + 'px';
            pop.style.top = pos.y + 'px';
            pop.style.display = 'block';
        }
        function hide() { pop.style.display = 'none'; }

        /* fetch users */
        function fetchUsers(term, cb) {
            
            fetch('/Controls/MentionEditorNew/MentionEditorNewHandler.asmx/GetUserSuggestionsNew', {
                method: 'POST', headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ term: term })
            }).then(r => r.json()).then(d => cb(d.d || []));
        }

        /* sync hidden + placeholder */
        const sync = () => {
            hidden.value = editor.innerHTML;
            editor.classList.toggle('empty', editor.innerText.trim() === '');
        };
        sync();

        editor.addEventListener('input', sync);
        editor.addEventListener('blur', () => setTimeout(hide, 150));

        /* keyup detect @term */
        editor.addEventListener('keyup', function () {
            const sel = window.getSelection();
            if (!sel.rangeCount) return;
            const range = sel.getRangeAt(0).cloneRange();
            const pre = range.cloneRange();
            pre.selectNodeContents(editor);
            pre.setEnd(range.endContainer, range.endOffset);
            const lastWord = pre.toString().split(/\s/).pop();
            const m = lastWord.match(/^@(\S{1,30})$/i);
            if (m) {
                const kw = m[1];
                const rect = range.getBoundingClientRect();
                fetchUsers(kw, items => {
                    if (items.length) {
                        showPopup(items, { x: rect.left + window.scrollX, y: rect.bottom + window.scrollY });
                    } else hide();
                });
            } else hide();
        });

        /* insert mention */
        function insertMention(it) {
            const sel = window.getSelection();
            if (!sel.rangeCount) return;
            debugger;
            
            var h = editor;           
            const mentionHtml =
                `<span class="mention-new" data-userid="${it.userid}" contenteditable="false" ` +
                `style="pointer-events:none">@${it.value}</span>&nbsp;`;

            // Insert HTML at caret
            insertHtmlAtCaret(mentionHtml, h);

            /* Step 4: sync hidden field & placeholder */
            sync();
        }

        function parseMention(text) {
            const regex = /(.*?)(@\w+)(.*)/;
            const match = text.match(regex);

            if (match) {
                return {
                    before: match[1],  // includes space
                    tag: match[2],  // @username
                    after: match[3]   // includes space
                };
            }
            return null;
        }


        function insertHtmlAtCaret(html, editorEl) {
            editorEl.focus(); // Ensure focus on editor
            debugger;
            let sel = window.getSelection();
            if (sel && sel.rangeCount > 0) {
                let range = sel.getRangeAt(0);
                debugger;               
                let textNode = getLastTextNode(editorEl);
                let offset = range.startOffset;

                if (textNode.nodeType === Node.TEXT_NODE) {
                    let textContent = textNode.textContent;

                    // Find last @ before caret
                    let textBeforeCaret = textContent.substring(0, offset);
                    let atIndex = textContent.lastIndexOf("@");


                    if (atIndex !== -1) {
                        
                        // Split textNode at @term
                        //let beforeAt = textContent.substring(0, atIndex);
                        //let afterCaret = textContent.substring(offset); afterCaret = "";

                        var splitText = parseMention(textContent);
                        let beforeAt = splitText?.before?? "";
                        let afterCaret = splitText?.after?? "";

                        // Create new nodes
                        let beforeNode = document.createTextNode(beforeAt);
                        let afterNode = document.createTextNode(afterCaret);

                        // Build mention node
                        let el = document.createElement("div");
                        el.innerHTML = html.trim();
                        let mentionNode = el.firstChild;

                        // Replace original textNode with: [beforeNode][mentionNode][afterNode]
                        let parentNode = textNode.parentNode;
                        let spaceNode = document.createTextNode('\u00A0'); // new editable space node

                        parentNode.insertBefore(beforeNode, textNode);
                        parentNode.insertBefore(mentionNode, textNode);
                        parentNode.insertBefore(afterNode, textNode);
                        parentNode.removeChild(textNode);
                        parentNode.insertBefore(spaceNode, mentionNode.nextSibling);

                        // Move caret after mention

                        let newRange = document.createRange();
                        //newRange.setStartAfter(spaceNode);
                        newRange.setStart(spaceNode, 1); 
                        newRange.collapse(true);
                        sel.removeAllRanges();
                        sel.addRange(newRange);

                        return;
                    }
                }

                // Fallback: insert mention normally
                let el = document.createElement("div");
                el.innerHTML = html.trim();
                let frag = document.createDocumentFragment(), node, lastNode;
                while ((node = el.firstChild)) {
                    lastNode = frag.appendChild(node);
                }

                range.deleteContents();
                range.insertNode(frag);

                // Move caret after mention
                if (lastNode) {
                    range = range.cloneRange();
                    range.setStartAfter(lastNode);
                    range.collapse(true);
                    sel.removeAllRanges();
                    sel.addRange(range);
                }
            }
        }

        function getLastTextNode(element) {
            if (!element) return null;

            let walker = document.createTreeWalker(
                element,
                NodeFilter.SHOW_TEXT,
                {
                    acceptNode: function (node) {
                        return node.textContent.trim().length > 0
                            ? NodeFilter.FILTER_ACCEPT
                            : NodeFilter.FILTER_SKIP;
                    }
                },
                false
            );

            let lastTextNode = null;
            while (walker.nextNode()) {
                lastTextNode = walker.currentNode;
            }

            return lastTextNode;
        }

    }
    /* ---------- exported init (called from server) ---------- */
    window.initMentionEditorNew = function (edSel, hidSel) {
        const ed = document.querySelector(edSel);
        const hid = document.querySelector(hidSel);
        if (ed && hid) coreInit(ed, hid);
    };

    /* ---------- auto init after UpdatePanel loads ---------- */
    //Sys && Sys.Application.add_load(function () {
    //    document.querySelectorAll('.mention-editor-new').forEach(function (ed) {
    //        const hid = ed.nextElementSibling;
    //        if (hid) window.initMentionEditorNew('#' + ed.id, '#' + hid.id);
    //    });
    //});

})();
