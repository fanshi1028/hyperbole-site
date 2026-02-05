{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai.Middleware.Static
import TodoList
import TodoList.Data
import Web.Hyperbole

data App = Home deriving (Eq, Generic)

instance Route App where
  baseRoute = Just Home

main :: IO ()
main =
  run 3000 $
    staticPolicy (addBase "static") $
      liveApp quickStartDocument . routeRequest $
        \case
          Home -> runPage page

page :: (Hyperbole :> es) => Page es '[TodoListView, TodoItemView]
page = pure $ do
  script "https://cdn.tailwindcss.com"
  script "newTodoItemInput.js"
  hyperState TodoListView emptyTodoListData $ todoListView Nothing
