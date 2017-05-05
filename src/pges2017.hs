{-# LANGUAGE OverloadedStrings #-}

import Hakyll
import Data.Monoid ((<>))

main :: IO ()
main = hakyll $ do
  -- TODO default handler with 404 page?
  -- simple pages
  match "index.html"  htmlRules
  match "schedule.md" markdownRules
  match "venue.md"    markdownRules
  -- pages that need to load other files
  match "previous.md"     $ galleryRules "files/2016/*.jpg"
  match "speakers.html"   $ peopleRules  "speakers/*.md"
  match "organizers.html" $ peopleRules  "organizers/*.md"
  -- things to load for use in the above pages
  match "speakers/*"   personRules
  match "organizers/*" personRules
  match "templates/*"  templateRules
  match "files/2016/*.jpg" $ version "url" $ urlRules
  -- files to copy over unchanged
  match "css/*"              copyRules
  match "files/2016/*"       copyRules
  match "files/logos/*.png"  copyRules
  match "files/people/*.jpg" copyRules
  match "files/ui/*.png"     copyRules

---------- refactor this part! ----------

urlRules :: Rules ()
urlRules = compile $ do
  path <- fmap (\i -> '/': toFilePath i) getUnderlying
  makeItem path

urlList :: String -> String -> Pattern -> Compiler (Context a)
urlList s1 s2 ptn = do
  urls <- loadAll $ ptn .&&. hasVersion "url"
  return $ listField s1
              (field s2 (return . itemBody))
             (sequence $ map return urls)

galleryRules :: Pattern -> Rules ()
galleryRules ptn = do
  route $ setExtension "html"
  compile $ do
    photos <- urlList "photos" "src" "files/2016/*.jpg"
    let ctx = photos <> defaultContext
    getResourceBody
      >>= applyAsTemplate ctx
      >>= loadAndApplyTemplate "templates/default.html" ctx

-----------------------------------------

htmlRules :: Rules ()
htmlRules = do
  route idRoute
  compile $ do
    getResourceBody
      >>= applyAsTemplate defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

markdownRules :: Rules ()
markdownRules = do
  route $ setExtension "html"
  compile $ pandocCompiler
    >>= loadAndApplyTemplate "templates/default.html" defaultContext
    >>= relativizeUrls

templateRules :: Rules ()
templateRules = compile templateBodyCompiler

copyRules :: Rules ()
copyRules = do
  route   idRoute
  compile copyFileCompiler

peopleRules :: Pattern -> Rules ()
peopleRules ptn = do
  route idRoute
  compile $ do
    people <- loadAll ptn
    let ctx = listField "people" defaultContext (return people)
           <> defaultContext
    getResourceBody
      >>= applyAsTemplate ctx -- fills in the templates
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls

-- these are also used on the organizers page (we're people too!)
personRules :: Rules ()
personRules = do
  compile $ pandocCompiler
    -- TODO where is this duplicated?
    -- >>= loadAndApplyTemplate "templates/person.html" defaultContext
    >>= relativizeUrls
