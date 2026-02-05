{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module TodoList.Data
  ( TodoItem,
    TodoListData,
    todoItemToText,
    emptyTodoListData,
    isTodoListEmpty,
    appendNewTodo,
    todoToggle,
    todoRemove,
    traverseTodoListData,
    foldTodoListData,
  )
where

import Data.Aeson hiding (Success)
import Data.List as List
import Data.List.NonEmpty as NE
import Data.Map as Map
import Data.Maybe
import Data.Text hiding (any)
import Validation
import Web.Hyperbole
import Web.Hyperbole.Data.JSON

-- TEMP FIXME: upstream should have these simple instance
instance ToEncoded Bool

instance FromEncoded Bool

newtype TodoItem = TodoItem StrictText
  deriving stock (Generic)
  deriving newtype (Eq, Ord, Show)
  deriving anyclass (ToJSON, FromJSON, ToJSONKey, FromJSONKey, ToParam, FromParam, Session)
  deriving (ToEncoded) via (JSON StrictText)
  deriving (FromEncoded) via (JSON StrictText)

instance ViewId TodoItem where
  type ViewState TodoItem = Bool

todoItemToText :: TodoItem -> StrictText
todoItemToText (TodoItem txt) = txt

data TodoListData = TodoListData [TodoItem] (Map TodoItem Bool)
  deriving (Show, Generic)
  deriving anyclass (ToJSON, FromJSON, Session)
  deriving (ToEncoded) via (JSON TodoListData)
  deriving (FromEncoded) via (JSON TodoListData)

emptyTodoListData :: TodoListData
emptyTodoListData = TodoListData [] Map.empty

isTodoListEmpty :: TodoListData -> Bool
isTodoListEmpty (TodoListData [] _) = True
isTodoListEmpty _ = False

appendNewTodo :: StrictText -> TodoListData -> Validation (NonEmpty StrictText) (TodoItem, TodoListData)
appendNewTodo (TodoItem -> newTodo) (TodoListData list map'@(Map.lookup newTodo -> mTodoItem)) =
  (newTodo, TodoListData (newTodo : list) (Map.insert newTodo False map'))
    <$ ( if newTodo == TodoItem ""
           then failure "Todo item must not be empty"
           else failureIf (isJust mTodoItem) "Todo item must not be duplicate"
       )

todoToggle :: TodoItem -> TodoListData -> TodoListData
todoToggle item (TodoListData list map') = TodoListData list $ Map.adjust not item map'

todoRemove :: TodoItem -> TodoListData -> TodoListData
todoRemove item (TodoListData list map') = TodoListData (List.delete item list) (Map.delete item map')

foldTodoListData :: (acc -> TodoItem -> Bool -> acc) -> acc -> TodoListData -> acc
foldTodoListData f init' (TodoListData list map') =
  List.foldl'
    ( \acc item -> f acc item $ case Map.lookup item map' of
        Nothing -> error "impossible(foldTodoListData): inconsistent TodoListData"
        Just done -> done
    )
    init'
    list

traverseTodoListData :: (Applicative f) => (TodoItem -> Bool -> f ()) -> TodoListData -> f ()
traverseTodoListData f = foldTodoListData (\acc item done -> (acc *> f item done)) $ pure ()
