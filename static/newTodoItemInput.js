/// <reference path="../hyperbole/client/src/index.ts" />
window.addEventListener("load", () => {
    let todoList = window.Hyperbole?.hyperView?.("TodoListView");

    if (todoList) console.log("Found TodoListView 'todoList'", todoList);
    else console.error("Not Found TodoListView 'todoList'", todoList);

});
