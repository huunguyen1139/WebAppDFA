function initMentionEditor(editorSelector, hiddenInputSelector) {
    var editor = $(editorSelector);
       

    editor.on('keyup1', function (e) {
        let selection = window.getSelection();
        if (!selection.rangeCount) return;
        let range = selection.getRangeAt(0);
        let container = range.startContainer;
        let text = container.nodeValue || '';
        let caretPos = range.startOffset;
        
        let atIndex = text.lastIndexOf('@', caretPos - 1);
        if (atIndex >= 0) {
            let search = text.substring(atIndex + 1, caretPos);
            if (search.length >= 2) {                
                $.ajax({
                    type: "POST",
                    url: "/Controls/MentionEditor/MentionEditorHandler.asmx/GetUserSuggestions",
                    data: JSON.stringify({ term: search }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        let suggestions = response.d;
                        $("#autocompleteDropdown").remove(); // Remove old dropdown

                        $('<ul id="autocompleteDropdown" class="dropdown-menu show"></ul>')
                            .css({
                                position: 'absolute',
                                top: editor.offset().top + editor.height(),
                                left: editor.offset().left,
                                width: editor.width()
                            })
                            .appendTo('body');

                        suggestions.forEach(item => {
                            $('<li class="dropdown-item"></li>')
                                .text(item.label)
                                .on('click', function () {                                   
                                    insertMention(item.value, item.userid, editor[0]);
                                    $("#autocompleteDropdown").remove();
                                })
                                .appendTo('#autocompleteDropdown');
                        });
                    }
                });
            }
        }
    });

    editor.on('input', function () {
        $(hiddenInputSelector).val(editor.html());      
       
    });

    function insertMention(userName, userId, editorEl) {
        
        // Build the mention HTML
        const mentionHtml = `<span class="mention" data-userid="${userId}" contenteditable="false">@${userName}</span>&nbsp;`;

        // Insert HTML at caret
        insertHtmlAtCaret(mentionHtml, editorEl);

        // Sync hidden field
        $(hiddenInputSelector).val(editorEl.innerHTML);
        
    }

    //get all Text Node include span
    function getAllNodes(parent) {
        let allNodes = [];

        function walk(node) {
            allNodes.push(node);
            node = node.firstChild;
            while (node) {
                walk(node);
                node = node.nextSibling;
            }
        }

        walk(parent);
        return allNodes;
    }


    //get only Text Node
    function getAllTextNodes(parent) {
        let textNodes = [];

        function walk(node) {
            if (node.nodeType === Node.TEXT_NODE) {
                textNodes.push(node);
            } else {
                node = node.firstChild;
                while (node) {
                    walk(node);
                    node = node.nextSibling;
                }
            }
        }

        walk(parent);
        return textNodes;
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



    function insertHtmlAtCaret(html, editorEl) {
        editorEl.focus(); // Ensure focus on editor
        debugger;
    let sel = window.getSelection();
    if (sel && sel.rangeCount > 0) {
        let range = sel.getRangeAt(0);
        
        debugger;
        // Work in a text node             
        // let AllNodes = getAllNodes(editorEl);

        //let textNode = range.startContainer;
        let textNode = getLastTextNode(editorEl);
        
        let offset = range.startOffset;

        if (textNode.nodeType === Node.TEXT_NODE) {
            let textContent = textNode.textContent;

            // Find last @ before caret
            let textBeforeCaret = textContent.substring(0, offset);
            let atIndex = textContent.lastIndexOf("@");
            

            if (atIndex !== -1) {
                // Split textNode at @term
                let beforeAt = textContent.substring(0, atIndex);
                let afterCaret = textContent.substring(offset); afterCaret = "";

                // Create new nodes
                let beforeNode = document.createTextNode(beforeAt);
                let afterNode = document.createTextNode(afterCaret);

                // Build mention node
                let el = document.createElement("div");
                el.innerHTML = html.trim();
                let mentionNode = el.firstChild;

                // Replace original textNode with: [beforeNode][mentionNode][afterNode]
                let parentNode = textNode.parentNode;
                let spaceNode = document.createTextNode(''); // new editable space node

                parentNode.insertBefore(beforeNode, textNode);
                parentNode.insertBefore(mentionNode, textNode);
                parentNode.insertBefore(afterNode, textNode);
                parentNode.removeChild(textNode);
                parentNode.insertBefore(spaceNode, mentionNode.nextSibling);

                // Move caret after mention, move to end
               
                let newRange = document.createRange();
                newRange.setStartAfter(spaceNode);
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

    function syncHiddenField(editorEl) {
        const hiddenInput = document.querySelector(editorEl.dataset.hiddenInputSelector);
        if (hiddenInput) {
            hiddenInput.value = editorEl.innerHTML;
        }
    }
   
}
