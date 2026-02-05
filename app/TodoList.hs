{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module TodoList where

import Data.Foldable
import Data.List.NonEmpty as NE
import Data.Text hiding (any)
import TodoList.Data
import Validation
import Web.Atomic.CSS (cls, (~))
import Web.Hyperbole
import Web.Hyperbole.HyperView

newtype TodoItemView = TodoItemView TodoItem deriving (Generic)

instance ViewId TodoItemView where
  type ViewState TodoItemView = Bool

instance HyperView TodoItemView es where
  data Action TodoItemView = TodoItemToggle
    deriving (Show, Generic)
    deriving anyclass (ViewAction)

  type Require TodoItemView = '[TodoListView]

  update TodoItemToggle = todoItemView <$ modify not

data TodoListView = TodoListView deriving (Generic)

instance ViewId TodoListView where
  type ViewState TodoListView = TodoListData

instance HyperView TodoListView es where
  data Action TodoListView = TodoItemCreate
    deriving (Generic, ViewAction, Show)

  type Require TodoListView = '[TodoItemView]

  update TodoItemCreate = do
    NewTodoItemForm @Identity inputTodoItem <- formData

    appendNewTodo inputTodoItem <$> get >>= \case
      Success (_, newTodoListData) -> todoListView Nothing <$ put newTodoListData
      Failure (err :| errs) -> pure $ todoListView $ Just (inputTodoItem, err : errs)

newtype NewTodoItemForm f = NewTodoItemForm {newItem :: Field f StrictText}
  deriving (Generic)
  deriving anyclass (FromFormF, GenFields FieldName)

todoItemView :: View TodoItemView ()
todoItemView = do
  (TodoItemView item, checked') <- context
  tag "input"
    @ att "type" "checkbox"
    . checked checked'
    . onChange (const TodoItemToggle)
    $ none
  text $ todoItemToText item

todoListView :: Maybe (StrictText, [StrictText]) -> View TodoListView ()
todoListView mErrs = el ~ cls "container mx-auto shadow" $ do
  todoListData <- viewState
  el ~ cls "p-4 mt-4" $
    if isTodoListEmpty todoListData
      then tag "p" ~ cls "text-lg" $ do
        text "Nothing "
        tag "span" ~ cls "font-semibold tracking-tighter" $ "TO DO"
        text ". Please add some items"
      else ol ~ cls "flex flex-row flex-wrap gap-4" $ do
        traverseTodoListData
          ( \item done ->
              li $
                hyperState
                  (TodoItemView item)
                  done
                  todoItemView
          )
          todoListData

  let f = fieldNames @NewTodoItemForm

  form TodoItemCreate ~ cls "p-4 mt-4 w-full flex flex-row flex-wrap gap-6 items-start" $ do
    el ~ cls "flex flex-col gap-2" $ do
      field f.newItem $ do
        let inputId = "new-todo-item"
            newItemInput = input TextInput @ att "id" inputId
        label ~ cls "sr-only" @ att "for" inputId $ "New todo item"
        case mErrs of
          Just (lastNewItemInputValue, errs@(_ : _)) -> do
            newItemInput @ autofocus . value lastNewItemInputValue ~ cls "shadow-inner px-2 py-1 outline-red-800"
            ol $ traverse_ (li . text ~ cls "text-xs text-red-800") errs
          Just (currentItemInput, []) -> newItemInput @ value currentItemInput ~ cls "border border-1 shadow-inner px-2 py-1"
          _ -> newItemInput @ value "" ~ cls "border border-1 shadow-inner px-2 py-1"
    submit ~ cls "shadow px-4 py-2 font-bold text-sm uppercase tracking-wide" $ "+ Todo"
