var richeditor = {};
var editor = document.getElementById("editor");

richeditor.insertText = function(text) {
    editor.innerHTML = text;
    window.webkit.messageHandlers.heightDidChange.postMessage(document.body.offsetHeight);
}

editor.addEventListener("input", function() {
    window.webkit.messageHandlers.textDidChange.postMessage(editor.innerHTML);
}, false)

document.addEventListener("selectionchange", function() {
    window.webkit.messageHandlers.heightDidChange.postMessage(document.body.offsetHeight);
}, false);

//function restoreState() {
//  var editor = document.querySelector("trix-editor").editor
//  editor.loadJSON(JSON.parse('{"document":[{"text":[{"type":"string","attributes":{},"string":"test"},{"type":"string","attributes":{"blockBreak":true},"string":"\\n"}],"attributes":["heading1"]}],"selectedRange":[0,4]}'))
//}

function restoreEditor(state) {
  var editor = document.querySelector("trix-editor").editor
  console.log(state)
  editor.loadJSON(JSON.parse(state))
}
