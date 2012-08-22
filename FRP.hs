
{-# LANGUAGE NoImplicitPrelude #-}

module FRP where

import Language.Fay.Prelude
import Language.Fay.FFI

main :: Fay ()
main = do writeElem body

reactiveInput :: (Elem, Elem)
reactiveInput = makeInputNG "p" "foo"

rValue :: Elem
rValue = fst reactiveInput

rInput :: Elem
rInput = snd reactiveInput

body :: Elem
body = Elem "div" [] 
            [ Elem "input" [Attr "type" "text"] []
            , rInput
            , rValue
            , Elem "p" [] [CData "Static character data"] ]

writeRaw :: String -> Fay ()
writeRaw = ffi "document.write(%1)"

data Attr = Attr String String

data Elem = Elem String [Attr] [Elem]
          | CData String

writeElem :: Elem -> Fay ()
writeElem = writeRaw . buildElem

buildAttr :: Attr -> String
buildAttr (Attr k v) = " " ++ k ++ "=\"" ++ v ++ "\""

buildElem :: Elem -> String
buildElem (CData s) = s
buildElem (Elem tag attrs childs) = 
  "<" ++ tag ++ concat (map buildAttr attrs) ++ ">" ++
  concat (map buildElem childs) ++
  "</" ++ tag ++ ">"

makeInputNG :: String -> String -> (Elem, Elem)
makeInputNG tag modelId = 
  (Elem tag [] 
            [CData $ "{{" ++ modelId ++ "}}"],
   Elem "input" [Attr "type" "text", Attr "ng-model" modelId] [])