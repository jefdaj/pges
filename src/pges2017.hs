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
  -- TODO actually this one includes photos
  --      refactor it using getResourceFilePath
  --      see https://github.com/jaspervdj/hakyll/issues/263
  match "previous.md" markdownRules
  -- pages with pics + blurbs for people
  match "speakers.html"   $ peopleRules "speakers/*"
  match "organizers.html" $ peopleRules "organizers/*"
  -- things to load for use in the above pages
  match "speakers/*"   personRules
  match "organizers/*" personRules
  match "templates/*"  templateRules
  -- files to copy over unchanged
  match "css/*"              copyRules
  match "files/2016/*"       copyRules
  match "files/logos/*.png"  copyRules
  match "files/people/*.jpg" copyRules
  match "files/ui/*.png"     copyRules

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
