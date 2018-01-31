{-# LANGUAGE OverloadedStrings #-}

import Hakyll
import Data.Monoid ((<>))

main :: IO ()
main = hakyll $ do
  -- TODO default handler with 404 page?
  -- simple pages
  match "index.md"    markdownRules
  match "schedule.md" markdownRules
  match "venue.md"    markdownRules
  -- pages that need to load other files
  match "previous.md"   $ galleryRules "files/201*/*.jpg"
  match "speakers.md"   $ peopleRules  "speakers/*.md"
  match "organizers.md" $ peopleRules  "organizers/*.md"
  -- things to load for use in the above pages
  match "speakers/*"   personRules
  match "organizers/*" personRules
  match "templates/*"  templateRules
  match "files/201*/*.jpg" $ version "url" $ urlRules
  -- files to copy over unchanged
  match "css/*"              copyRules
  match "files/201*/*"       copyRules
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
  compile $ pandocCompiler >> do
    photos2016 <- urlList "photos2016" "src" "files/2016/*.jpg"
    photos2017 <- urlList "photos2017" "src" "files/2017/*.jpg"
    let ctx = photos2016 <> photos2017 <> defaultContext
    getResourceBody
      >>= applyAsTemplate ctx
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls

-----------------------------------------

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
  route $ setExtension "html"
  compile $ pandocCompiler >> do
    people <- loadAll ptn
    let ctx = listField "people" defaultContext (return people)
           <> defaultContext
    getResourceBody
      >>= applyAsTemplate ctx -- fills in the templates
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls

personRules :: Rules ()
personRules = do
  compile $ pandocCompiler
    -- TODO where is this duplicated?
    -- >>= loadAndApplyTemplate "templates/person.html" defaultContext
    >>= relativizeUrls